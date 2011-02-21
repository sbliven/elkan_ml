import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class ThreeFeature implements FeatureGenerator {

	public ThreeFeature(){
	}

	public void evaluate(String word, String[] syllables, Map<String,ArrayList<String>> wordFeatures){
		
		String fullWord=word;
		int syllableNumber=0;
		int syllableIndice=0;
		int nextSplitLocation;
		String feature;
		ArrayList<String> tempList;
		
		while (word.length()>=3){
			nextSplitLocation=syllables[syllableNumber].length()-syllableIndice;
				
			if(nextSplitLocation>=3){
				syllableIndice++;
			}
			else if(nextSplitLocation<=0){
				if(word.length()==3) break;
				if(syllableNumber<syllables.length-1)syllableNumber++;
			}
			else{
				feature=word.substring(0,3)+String.valueOf(nextSplitLocation);
				
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
