import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;

public class Zulu {
	
	Map<String,String[]> wordSyllables;
	private FeatureGenerator[] features;
	Map<String,ArrayList<String>> wordFeatures;
	String[] words;
	
	// loads the data
	public Zulu(File file,FeatureGenerator[] features) {
        wordSyllables=new HashMap<String,String[]>();
		wordFeatures=new HashMap<String,ArrayList<String>>();
		
		this.features=features;
		
		Scanner scanner=null;
        try {
            scanner = new Scanner(file);
        } catch (Exception e) {
        System.out.println(e);
        }
        
        String tempString;
        ArrayList<String> tempAllArray=new ArrayList<String>();
        String[] tempArray;
        
        while(scanner.hasNext()){
        	tempAllArray.addAll(Arrays.asList(scanner.nextLine().split("\u0009")));
        	tempString=tempAllArray.remove(0);
        	tempArray=tempAllArray.remove(0).split(" ");
        	wordSyllables.put(tempString,tempArray);
        }
        words=wordSyllables.keySet().toArray(new String[wordSyllables.size()]);
        scanner.close();
	}

	public void generateFeatures() {
		String word;
		String[] syllables;
		
		Set<String> wordSet=wordSyllables.keySet();
		Iterator<String> iterator=wordSet.iterator();
		
		while (iterator.hasNext()){
			word=iterator.next();
			syllables=wordSyllables.get(word);
			for(FeatureGenerator fg : features){
				fg.evaluate(word, syllables,wordFeatures);
			}
		}
	}

	public String[] getWords() {
		return words;
	}

	public Map<String,ArrayList<String>> getFeaturesAndWords() {
		return wordFeatures;
	}
}
