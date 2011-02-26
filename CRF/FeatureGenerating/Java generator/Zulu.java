package tryNoTwo;

import java.io.Console;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

public class Zulu {

	private HashMap<String,String> xys;
	private String[] words;
	private HashMap<Integer,ArrayList<String>> windowFeatures;
	private final int numberOfFeatures=7;

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

	public void generateWindowFeatures() {
		String featureWord;
		String featureY;

		String tempWord;
		String tempY;

		ArrayList<String> tempList;

		for (int i=3;i<numberOfFeatures+1;i++){
			windowFeatures.put(i,new ArrayList<String>());
		}

		for(String word : xys.keySet()){
			for(int i=3;i<numberOfFeatures+1;i++){
				tempWord=word;
				tempY=xys.get(word);
				while(tempWord.length()>=i){
					featureWord=tempWord.substring(0,i);
					featureY=tempY.substring(0,i);
					tempList=windowFeatures.get(i);
					if(!tempList.contains(featureWord+" "+featureY))
						tempList.add(featureWord+" "+featureY);
					windowFeatures.put(i,tempList);
					tempWord=tempWord.substring(1);
					tempY=tempY.substring(1);
				}
			}
		}
	}

	public static boolean evaluate(String featureXspaceY,String xbar,String labelIminus1, String labelI){
		String[] XY=featureXspaceY.split(" ");
		String featureX=XY[0];
		String featureY=XY[1];
		if(!featureX.equals(xbar)){
			return false;
		}
		
		char featureLabel=featureY.charAt(featureY.length()-1);
		char featureMinusOneLabel=featureY.charAt(featureY.length()-2);
		
		return(featureLabel==labelI.charAt(0)&&featureMinusOneLabel==labelIminus1.charAt(0));
	}

	public void evaluateWordsAndWriteToFile() {
		int wordCount=0;
		int featureCount=0;
		try
		{
			FileWriter writer = new FileWriter("c:\\temp\\zulu250lines.csv");

			for(String word : words){
				String labels=xys.get(word);
				for(int lengthOfFeature:windowFeatures.keySet()){
					for(String featureXspaceY:windowFeatures.get(lengthOfFeature)){
						for (int wordpos=0;wordpos+lengthOfFeature<word.length()+1;wordpos++){
							String xbar=word.substring(wordpos,wordpos+lengthOfFeature);
							if(featureXspaceY.split(" ")[0].equals("lwa")&&xbar.equals("lwa")){
								int a=0;
								a++;
							}
							String labelMinus1=labels.substring(lengthOfFeature+wordpos-2,lengthOfFeature+wordpos-1);
							String label=labels.substring(lengthOfFeature+wordpos-1,lengthOfFeature+wordpos);
								if(evaluate(
										featureXspaceY,
										xbar,
										labelMinus1,
										label
								))
									writer.append(wordCount +" "+" "+featureCount+" "+wordpos+" "+labelMinus1+" "+label+"\n");

							}
						}
					featureCount++;
					}
				wordCount++;
				}
			FileWriter writer2=new FileWriter("c:\\temp\\features.txt");
			System.out.println("laise");
			for(int lengthOfFeature:windowFeatures.keySet()){
				for(String featureXspaceY:windowFeatures.get(lengthOfFeature)){
					writer2.append(featureXspaceY.split(" ")[0]+"\n");
				}
			}
			writer.close();
			writer2.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
}
