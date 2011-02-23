package tryNoTwo;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

public class Zulu {

	private HashMap<String,String> xys;
	private String[] words;
	private HashMap<Integer,ArrayList<String>> windowFeatures;

	public Zulu(File file) {

		xys=new HashMap<String,String>();
		windowFeatures=new HashMap<Integer,ArrayList<String>>();


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
			int syllableCount=0;
			int syllableIndice=1;
			String tempInteger="";
			for(int i=0;i<tempString.length()-1;i++){
				if(tempArray[syllableCount].length()==syllableIndice){
					tempInteger+="1";
					syllableCount++;
					syllableIndice=1;
				}
				else{
					tempInteger+="0";
					syllableIndice++;
				}
			}
			tempInteger+="0";
			xys.put(tempString,tempInteger);
		}
		words=xys.keySet().toArray(new String[xys.size()]);
		scanner.close();
	}

	public String[] getWords() {
		return words;
	}
	public void setWords(String[] words) {
		this.words = words;
	}

	public void generateWindowFeatures() {
		String featureWord;
		String featureY;

		String tempWord;
		String tempY;

		ArrayList<String> tempList;

		for (int i=3;i<20;i++){
			windowFeatures.put(i,new ArrayList<String>());
		}

		for(String word : xys.keySet()){

			for(int i=3;i<20;i++){
				tempWord=word;
				tempY=xys.get(word);
				while(tempWord.length()>=i){
					featureWord=tempWord.substring(0,i);
					featureY=tempY.substring(0,i);
					tempList=windowFeatures.get(i);
					if(!tempList.contains(featureWord+" "+featureY))
						tempList.add(featureWord+" "+featureY);
					windowFeatures.put(i,tempList);
					tempWord=tempWord.substring(i);
				}
			}
		}
	}

	public static boolean evaluate(String featureXspaceY,String xbar,int pos,String labelIminus1, String labelI){
		String[] XY=featureXspaceY.split(" ");
		String featureX=XY[0];
		String featureY=XY[1];

		xbar=xbar.substring(0,featureX.length());
		if(!xbar.equals(featureX))
			return false;

		if(pos==0){
			if(labelI.equals(featureY.substring(0,1)))
				return true;
			else 
				return false;
		}

		return(featureY.charAt(pos)==labelI.charAt(0)&&featureY.charAt(pos-1)==labelIminus1.charAt(0));
	}

	public void evaluateWordsAndWriteToFile() {
		for(String word : words){
			String labels=xys.get(word);
			for(int i:windowFeatures.keySet()){
				for(String featureXspaceY:windowFeatures.get(i)){
					int pos=0;
					int sum=0;
					while(pos<=i){
						if(evaluate(
								featureXspaceY,
								word.substring(0,i),
								pos,
								labels.substring(pos-1,pos)
								,labels.substring(pos,pos+1)
								))
							sum++;
					}
					//print wordindex,pos,feature,fvalue(==sum)
				}
			}
		}
	}
}
