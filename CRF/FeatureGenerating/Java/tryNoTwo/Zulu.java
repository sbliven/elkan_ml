package tryNoTwo;

import java.io.Console;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

public class Zulu {

	private ArrayList<String[]> xys;
	private HashMap<Integer,ArrayList<String>> windowFeatures;
	private final int numberOfFeatures=7;

	public Zulu(File file) {

		xys=new ArrayList<String[]>();
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
			String word=scanner.nextLine();
			if (word.contains(","))
				continue;
			tempAllArray.addAll(Arrays.asList(word.split("\u0009")));
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
			xys.add(new String[]{tempString,tempInteger});
		}
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

		for(int i1=0;i1<xys.size();i1++){
			for(int i=3;i<numberOfFeatures+1;i++){
				tempWord=xys.get(i1)[0];
				tempY=xys.get(i1)[1];
				while(tempWord.length()>=i){
					featureWord=tempWord.substring(0,i);
					featureY=tempY.substring(i-2,i);
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

		char featureLabel=featureY.charAt(1);
		char featureMinusOneLabel=featureY.charAt(0);

		return(featureLabel==labelI.charAt(0)&&featureMinusOneLabel==labelIminus1.charAt(0));
	}

	public void evaluateWordsAndWriteToFile() {
		int wordCount=0;

		try
		{
			FileWriter writer = new FileWriter("c:\\temp\\zulu250.csv");
			for(int i=0;i<xys.size();i++){
				int featureCount=0;
				String word=xys.get(i)[0];
				String labels=xys.get(i)[1];
				for(int lengthOfFeature:windowFeatures.keySet()){
					for(String featureXspaceY:windowFeatures.get(lengthOfFeature)){
						for (int wordpos=0;wordpos+lengthOfFeature<word.length()+1;wordpos++){
							String xbar=word.substring(wordpos,wordpos+lengthOfFeature);

							String labelMinus1=labels.substring(lengthOfFeature+wordpos-2,lengthOfFeature+wordpos-1);
							String label=labels.substring(lengthOfFeature+wordpos-1,lengthOfFeature+wordpos);
							if(evaluate(
									featureXspaceY,
									xbar,
									labelMinus1,
									label
							))
								writer.append(wordCount+1 +" "+(featureCount+1)+" "+(wordpos+lengthOfFeature)+" "+labelMinus1+" "+label+" 1\n");

						}
						featureCount++;
					}
				}
				wordCount++;
				System.out.println(wordCount);
			}
			
			FileWriter writer2=new FileWriter("c:\\temp\\full features.txt");
			System.out.println("laise");
			for(int lengthOfFeature:windowFeatures.keySet()){
				for(String featureXspaceY:windowFeatures.get(lengthOfFeature)){
					writer2.append("win"+lengthOfFeature+" "+featureXspaceY+"\n");
					if(featureXspaceY.substring(featureXspaceY.indexOf(" ")).equals("aba"))
						System.out.println(featureXspaceY);
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
