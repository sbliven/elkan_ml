import java.util.ArrayList;
import java.util.Map;


public class SixFeature implements FeatureGenerator{
	public void evaluate(String word, String[] syllables, Map<String,ArrayList<String>> wordFeatures){

		String fullWord=word;
		int syllableNumber=0;
		int syllableIndice=0;
		int nextSplitLocation;
		String feature;
		ArrayList<String> tempList;

		while (word.length()>=6){
			nextSplitLocation=syllables[syllableNumber].length()-syllableIndice;

			if(nextSplitLocation>=6){
				syllableIndice++;
			}
			else if(nextSplitLocation<=0){
				if(word.length()==6) break;
				if(syllableNumber<syllables.length-1)syllableNumber++;
			}
			else{
				feature=word.substring(0,6)+String.valueOf(nextSplitLocation);

				if(wordFeatures.containsKey(feature)){
					tempList=wordFeatures.get(feature);
				} else tempList=new ArrayList<String>();
				tempList.add(fullWord); //In other words I add a new one every time. So for ab ab ab we will get two aba2's;
				wordFeatures.put(feature, tempList);

				syllableIndice++;
			}
			word=word.substring(1);
		}


	}
}
