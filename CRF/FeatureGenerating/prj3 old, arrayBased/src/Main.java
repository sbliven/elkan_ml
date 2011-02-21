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
		features.add(new SixFeature());
		features.add(new SevenFeature());
		features.add(new EightFeature());
		features.add(new NineFeature());
		
		FeatureGenerator[] generatorArray=features.toArray(new FeatureGenerator[features.size()]);
		Zulu zulu=new Zulu(file,generatorArray);

		zulu.generateFeatures();

		HashMap<String,ArrayList<String>> wordsAndFeatures=(HashMap<String, ArrayList<String>>) zulu.getFeaturesAndWords();
		//write features to file;

		int[][] featureValues;
		int i=0;
		int j=0;
		String[] words=zulu.getWords();
		featureValues=new int[words.length][wordsAndFeatures.keySet().size()];
		
		for(String word : words){
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator();
			j=0;
			while(iterator.hasNext()){
				String featureWord=iterator.next();
				while(wordsAndFeatures.get(featureWord).remove(word)){
					featureValues[i][j]++;
				}
				j=j+(iterator.hasNext()?1:0);
			}
			i++;
		}

		try
		{
			FileWriter writer = new FileWriter("c:\\temp\\AllFeatureValues.csv");
			Iterator<String> iterator=wordsAndFeatures.keySet().iterator();

			writer.append("words\\features,");
			while(iterator.hasNext()){
				writer.append(iterator.next()+",");
			}
			writer.append('\n');
			for(int i1=0;i1<featureValues.length;i1++){
				writer.append(words[i1]+",");
				for(int j1=0;j1<featureValues[0].length;j1++){
					writer.append(featureValues[i1][j1]+((j1==featureValues[0].length-1)?"":","));
				}
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
