#!/usr/bin/python
"""
Creates Genome "Documents"

The vocabulary of genome consists of PFam-A families.

Running this module builds up two maps:
genomes     maps from NCBI TaxIDs to a Genome object, which contains a list of
            Pfam accessions
proteins    maps from a UniProt accession to the genome that protein came from

@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse
import gzip
import xml.dom.minidom
import xml.dom.pulldom
import re
from itertools import islice

class Genome:
    def __init__(self,n,taxID,species,domain):
        self.n = n
        self.taxID = taxID
        self.species = species
        self.domain = domain
        self.proteins = {}

    def add(self,accession):
        """Adds the PFam family referenced by accession to this genome
        """
        count = self.proteins.get(accession,0)
        self.proteins[accession] = count + 1

    def __str__(self):
        return "%d\t%s\t%s\t%s\t%d pfams" %( self.n, self.taxID, self.domain,
                self.species, len(self.proteins) )

class UniProtSAX (xml.sax.handler.ContentHandler):
    def __init__(self, genomes=None):
        self.proteins = {}
        self._locator = None

        if genomes is None:
            self.genomes = {}
            self.createGenomes = True
        else:
            self.genomes = genomes
            self.createGenomes = False

    def setDocumentLocator(self,locator):
        self._locator = locator

    def startDocument():
        """Receive notification of the beginning of a document.

        The SAX parser will invoke this method only once, before any other methods in this interface or in DTDHandler (except for setDocumentLocator()).
        """
        pass

    def endDocument():
        """Receive notification of the end of a document.

        The SAX parser will invoke this method only once, and it will be the last method invoked during the parse. The parser shall not invoke this method until it has either abandoned parsing (because of an unrecoverable error) or reached the end of input.
        """
        pass

    def startElement(self, name, attrs):
        """ Signals the start of an element in non-namespace mode.

        The name parameter contains the raw XML 1.0 name of the element type as a string and the attrs parameter holds an object of the Attributes interface (see The Attributes Interface) containing the attributes of the element. The object passed as attrs may be re-used by the parser; holding on to a reference to it is not a reliable way to keep a copy of the attributes. To keep a copy of the attributes, use the copy() method of the attrs object.
        """
        pass

    def endElement(name):
        """Signals the end of an element in non-namespace mode.

        The name parameter contains the name of the element type, just as with the startElement() event.
        """
        pass

class UniProt:
    def __init__(self, genomes=None):
        self.proteins = {}
        if genomes is None:
            self.genomes = {}
            self.createGenomes = True
        else:
            self.genomes = genomes
            self.createGenomes = False


    def parse(self, file):
        doc = xml.dom.pulldom.parse(file)
        self.handleUniprot(doc)

    def handleUniprot(self,doc):
        entryNum = 0
        for event, node in doc:
            if event == 'START_ELEMENT' and node.nodeName == "entry":
                doc.expandNode(node)
                self.handleEntry(node)
                entryNum += 1
                if entryNum % 100 == 0:
                    print("Parsed %d uniprot entries. %d saved."%(entryNum,len(self.proteins)))

        #for entry in doc.getElementsByTagName("entry"):
        #self.handleEntry(entry)


    def handleEntry(self,entry):
        """Handles one uniprot entry, adding it to the proteins and
        genomes variables.
        """
        organisms = entry.getElementsByTagName("organism")
        if len(organisms) != 1:
            sys.stderr.write("Parse Error! Wrong number of organisms (%d)\n" %\
                    len(organisms) )
            return False
        genome = self.handleOrganism(organisms[0])

        if genome is None:
            return False

        #Some proteins have several accession numbers
        for accession in entry.getElementsByTagName("accession"):
            accessionNr = accession.firstChild.data
            self.proteins[accessionNr] = genome
        return True

    def handleOrganism(self,organism):
        """Handles an organism entry, creating a genome for it if
        needed, adding the genome to the genomes variable, and returning
        the new genome
        """
        taxID = None
        for ref in organism.getElementsByTagName("dbReference"):
            if ref.attributes["type"].value == "NCBI Taxonomy":
                taxID = ref.attributes["id"].value
        if taxID is None:
            sys.stderr.write("Parse Error! No taxID.\n")
            return None

        # Check if this organism already was encountered
        if self.genomes.has_key(taxID):
            return self.genomes[taxID]

        if self.createGenomes:
            # Create a new genome for this organism

            name = None
            for aName in organism.getElementsByTagName("name"):
                if aName.attributes["type"].value == "scientific":
                    name = aName.firstChild.data
            if name is None:
                sys.stderr.write("Parse Error! No scientific name.\n")
                return None

            lineages = organism.getElementsByTagName("lineage")
            if len(lineages) != 1:
                sys.stderr.write("Parse Error! Wrong number of lineages (%d)\n" %\
                        len(lineages))
                return None
            lineage = lineages[0]

            domain = self.handleLineage(lineage)
            if domain is None:
                return None

            # Filter out viral genomes
            if domain != "Eukaryota" and \
                    domain != "Bacteria" and \
                    domain != "Archaea":
                return None

            genome = Genome(len(self.genomes)+1,taxID, name,domain)

            self.genomes[taxID] = genome
            return genome
        else:
            # Don't create a new genome
            return None

    def handleLineage(self,lineage):
        """Parses a lineage and extracts the domain of this organism
        """
        taxa = lineage.getElementsByTagName("taxon")
        if len(taxa) < 1:
            sys.stderr.write("Parse Error! No taxa found.\n")
            return None
        taxon = taxa[0]
 
        return taxon.firstChild.data





def getProteinListFromStockholm(file):
    """ Parses the stockholm file.

    Extracts the pfam excession number and a list of uniprot ids for that pfam.

    Returns an iterator of (pfam, [uniprot,]), eg ("PF05884.5", [ O45006.2, O45005.1, Q9XWW4.1, Q9XW39.1, Q22524.1, A8X9E1.1, A8XG77.1, O44551.1, A8PHE3.1, A8WUN3.1, Q20960.1, ] )
    """
    pfam = None #pfam accession
    proteins = [] # list of uniprot accessions

    ACregex = re.compile("#=GF AC +(PF[0-9]+(\.[0-9]+)?)")
    GSregex = re.compile("#=GS\s\S+\s+AC\s([A-Za-z0-9]+)(\.[0-9]+)?")

    for line in file:
        line = line.strip()
        match = ACregex.match(line)
        if match is not None:
            if pfam is not None:
                sys.stderr.write("Parse Error. Multiple Pfam accessions (%s,%s)\n" % (pfam, match.group(1) ) )
            else:
                pfam = match.group(1)
        else:
            match = GSregex.match(line)
            if match is not None:
                uniprot = match.group(1)
                proteins.append(uniprot)
            elif line == "//":
                # End of section
                pair = (pfam,proteins)
                pfam = None
                proteins = []
                if pair[0] is None:
                    sys.stderr.write("Parse Error. No pfam AC found.\n")
                elif len(pair[1]) == 0:
                    sys.stderr.write("Parse Error. No proteins found.\n")
                else:
                    yield pair
            else:
                # Other types of lines
                pass

    # End of file
    if pfam is not None or len(proteins) > 0:
        pair = (pfam,proteins)
        pfam = None
        proteins = []
        if pair[0] is None:
            sys.stderr.write("Parse Error. No pfam AC found.\n")
        elif pair[1] is None:
            sys.stderr.write("Parse Error. No pfam AC found.\n")
        else:
            yield pair

    #yield ("PF0",["Q721N6","Q3YR73","Q91G55"])

    

#class Protein
#    """Represents essential (to me) information about a uniprot protein"""
#    def __init__(self,ac,os,oc,ox=None):
#        """Store fields from the uniprot record
#
#        AC accession number
#        OS species name
#        OC taxonomy (array), starting with taxonomical domain & ending with genus
#        OX NCBI TaxID
#        """
#        self._ac = ac
#        self._os = os
#        self._oc = oc
#        self._ox = ox

def _getProteinsFromUniprot(file):
    """Parses a Uniprot file for information about the protein(s). Returns a list
    of tuples containing:

    AC accession number
    OS species name
    OC taxonomy (array), starting with taxonomical domain & ending with genus
    OX NCBI TaxID
    """
    pass #TODO

def readGenomes(genomeFile,headerLines=1):
    """Read genome info from a tab-delimeted file.

    Columns:
     1. Taxon Uniprot ID
     2. Mnemonic
     3. Scientific name
     4. Common name
     5. Synonym
     6. Other Names
     7. Reviewed
     8. Rank
     9. Lineage
    10. Parent
    """
    genomes = {}

    lineNum = headerLines
    for line in islice(genomeFile,headerLines,None): #ignore header
        lineNum += 1
        line = line.strip("\n")
        columns = line.split("\t")
        if len(columns) != 10:
            sys.stderr.write("Warning: error reading genome at line %d.\n"%lineNum)
        else:
            taxID = columns[0]
            name = columns[2]
            domain = columns[8].split("; ")[0]
            genomes[taxID] =  Genome(len(genomes)+1, taxID, name, domain) 

    return genomes


if __name__ == "__main__":
    parser = optparse.OptionParser( usage="usage: python %prog [options]" )
    parser.add_option("-v","--verbose", help="Long messages",
        dest="verbose",default=False, action="store_true")
    (options, args) = parser.parse_args()

    if len(args) != 0:
        parser.print_usage()
        parser.exit("Error: Expected 0 argument, but found %d"%len(args) )

    prefix = "uniprot"
    genomeFilename = "%s.documents.txt"%prefix
    valuesFilename = "%s.values.txt"%prefix
    wordsFilename  = "%s.words.txt"%prefix
    labelsFilename = "%s.labels.txt"%prefix

    labels = {
            "eukaryota": 1,
            "archaea":   2,
            "bacteria":  3,
            }
    sys.stdout.write("Reading Genomes...")
    genomeFile = open("all.txt","r")
    genomes = readGenomes(genomeFile)
    genomeFile.close()
    print("Read %d genomes." % len(genomes))

    print("Writing genomes to %s and %s"%(genomeFilename,labelsFilename))
    with open(genomeFilename,"w") as genomeFile:
        with open(labelsFilename,"w") as labelsFile:
            for genome in genomes.values():
                genomeFile.write("%s\n"% str(genome))
                labelsFile.write("%d\t%d\n"% (genome.n,labels.get(genome.domain.lower(),-1) ))

    sys.stdout.write("Reading Proteins...")
    uniprot = UniProt(genomes)
    uniprotFile = gzip.GzipFile("uniprot_sprot.xml.gz")
    #uniprotFile = open("uniprot_short.xml")
    uniprot.parse(uniprotFile)
    uniprotFile.close()
    print("Read %d Proteins." % len(uniprot.proteins))

    sys.stdout.write("Reading Pfam...")
    pfamA = gzip.GzipFile("Pfam-A.full.gz","r")
    #pfamA = open("Pfam-A.short.txt","r")
    pfams = {}
    for pfam, proteins in getProteinListFromStockholm(pfamA):
        for prot in proteins:
            genome = uniprot.proteins.get(prot)
            if genome is None:
                #sys.stderr.write("Warning: unknown UniProt accession: %s\n"%prot)
                pass
            else:
                genome.add(pfam)
        pfams[pfam] = len(pfams)+1
        if len(pfams)%1000 == 0:
            print("Read %d pfams.\n"%len(pfams))
    print("Read %d pfams." % len(pfams))

    #Now output genomes
    print("Writing Pfams to %s."%wordsFilename)
    with open(wordsFilename,"w") as pfamFile:
        for pfam,n in pfams.items():
            pfamFile.write("%d\t%s\n" % (n,pfam))

    print("Writing pfam species to %s."%valuesFilename)
    with open(valuesFilename,"w") as valuesFile:
        for genome in uniprot.genomes.values():
            for pfam,count in genome.proteins.items():
                #write genome, pfam, count
                valuesFile.write("%d\t%d\t%d\n" % (genome.n, pfams[pfam], count))




