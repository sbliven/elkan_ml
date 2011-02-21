import java.io.File;
import java.io.FileWriter;
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

		HashMap<String,ArrayList<String>> wordsAndFeatures=(HashMap<String, ArrayList<String>>) zulu.getFeaturesAndWords();
		//write features to file;

		int i=0;
		int j=0;
		String[] words=zulu.getWords();
		//int[][] featureValues =featureValues=new int[words.length][wordsAndFeatures.keySet().size()];
		HashMap<int[],Integer> featureValues=new HashMap<int[],Integer>();
		
		for(String word : words){
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator();
			j=0;
			while(iterator.hasNext()){
				String featureWord=iterator.next();
				while(wordsAndFeatures.get(featureWord).remove(word)){
					int[] tempints={i,j};
					int value=featureValues.containsKey(tempints)?((Integer)featureValues.get(tempints)):0;
					value++;
					featureValues.put(tempints, value);
				}
				j=j+(iterator.hasNext()?1:0);
			}
			i++;
		}

		try
		{
			FileWriter writer = new FileWriter("c:\\temp\\AllFeatureValues.csv");
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator();

			writer.append("0,0,words\\features,\n");
			int count=1;
			while(iterator.hasNext()){
				writer.append("0,"+ ++count+","+iterator.next()+"\n");
			}
			
			for(int i1=0;i1<words.length;i1++){
				writer.append(i1+" "+i1+1+"\t"+words[i1]+"\n");
			}
			for(int[] ints : featureValues.keySet()){
				writer.append(ints[0]+","+ints[1]+","+featureValues.get(ints)+".0000000000000000e+00");
				writer.append('\n');
			}
			writer.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}

	}

}
