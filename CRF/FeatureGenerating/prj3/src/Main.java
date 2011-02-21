import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;


public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		run();
		//test();
	}

	private static void test() {
		//test.testMe();
	}

	private static void run() {
		File file = new File("src/data/ZuluWordList.txt");

		ArrayList<FeatureGenerator> features=new ArrayList<FeatureGenerator>();
		features.add(new ThreeFeature());
		features.add(new FourFeature());
		features.add(new FiveFeature());
		//features.add(new SixFeature());
		//features.add(new SevenFeature());
		//features.add(new EightFeature());
		//features.add(new NineFeature());
		
		FeatureGenerator[] generatorArray=features.toArray(new FeatureGenerator[features.size()]);
		Zulu zulu=new Zulu(file,generatorArray);

		zulu.generateFeatures();

		// for each feature, contains all words which contain that feature
		HashMap<String,ArrayList<String>> wordsAndFeatures=(HashMap<String, ArrayList<String>>) zulu.getFeaturesAndWords();
		//write features to file;

		int i=0; //word number
		int j=0; //feature number
		String[] words=zulu.getWords();
		//int[][] featureValues =featureValues=new int[words.length][wordsAndFeatures.keySet().size()];
		HashMap<int[],Integer> featureValues=new HashMap<int[],Integer>();
		
		for(String word : words){
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator(); // feature->word[]
			j=0;
			while(iterator.hasNext()){ // for each feature
				String featureWord=iterator.next();
				// Pop a word off the stack for this feature, and add it's coordinates to featureValues
				while(wordsAndFeatures.get(featureWord).remove(word)){
					int[] tempints={i,j};
					
					// Update featureValues with the number of times {i,j} was present. Should never be more than 1?
					int value=featureValues.containsKey(tempints)?featureValues.get(tempints):0;
					value++;
					if(value>1)
						// Never prints. Should it?
						System.out.println("value = "+value);
					featureValues.put(tempints, value);
				}
				j=j+(iterator.hasNext()?1:0); //unnecessary check?
			}
			// j is now the total number of features.
			i++;
		}

		try
		{
			String dirName;
			
			dirName = "c:\\temp\\";
			//dirName = "./";
			
			Writer outFile = new BufferedWriter(new FileWriter(dirName+"AllFeatureValues.csv"));
			Writer wordFile = new BufferedWriter(new FileWriter(dirName+"AllWords.csv"));
			Writer featureFile = new BufferedWriter(new FileWriter(dirName+"AllFeatures.csv"));
			
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator(); 

			// Row 0 is feature headers
			//outFile.append("0,0,words\\features,\n");
			int count=0;
			while(iterator.hasNext()){ //for each feature
				//outFile.append("0,"+ ++count+","+iterator.next()+"\n");
				featureFile.append(String.format("%d,%s\n", ++count, iterator.next() ));
			}
			featureFile.close();
			
			for(int i1=0;i1<words.length;i1++){ //for each word
				//outFile.append(i1+" "+i1+1+"\t"+words[i1]+"\n");
				wordFile.append(String.format("%d,%s\n",i1+1,words[i1]));
			}
			wordFile.close();

			
			for(int[] ints : featureValues.keySet()){
				//outFile.append(ints[0]+","+ints[1]+","+featureValues.get(ints)+".0000000000000000e+00");
				//outFile.append('\n');
				outFile.append(String.format("%d,%d,%d\n", ints[0]+1, ints[1]+1, featureValues.get(ints)));
			}
			outFile.close();

			System.out.format("Wrote %d features for %d words. %d non-zero entries.",
					wordsAndFeatures.size(), words.length, featureValues.size());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}

	}

}
