package tryNoTwo;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class CVfeature {

	private final static String CONSONANT="BCDFGHJKLMNPQRSTVWXYZ";
	
	public static boolean evaluate(String xbar,int pos,String y,String CVpattern){
		
		if(!(y.charAt(0)==CVpattern.charAt(2)))
			return false;
		if(!(y.charAt(1)==CVpattern.charAt(3)))
			return false;
		
		if(CVpattern.charAt(0)=='C'){
			if(!CONSONANT.contains((String.valueOf(xbar.charAt(pos-1)).toUpperCase())))
				return false;
		}
		
		if(CVpattern.charAt(1)=='C'){
			if(!CONSONANT.contains(String.valueOf(xbar.charAt(pos)).toUpperCase()))
				return false;
		}

		return true;
	}
	
	public static void main(String[] args) throws IOException{
		FileWriter writer=new FileWriter(new File("c:\\temp\\CV.txt"));
		
		ArrayList<String[]> xys=new ArrayList<String[]>();
		File file = new File("src/data/full.txt");
		
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

		////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		for(int i=0;i<xys.size();i++){
			String word=xys.get(i)[0];
			String y=xys.get(i)[1];
			for (int wordPos=1;wordPos<word.length();wordPos++){
				if(evaluate(word,wordPos,y,"CC00")){
					writer.append((i+1)+" 01 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1 \n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CC01")){
					writer.append((i+1)+" 02 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CC10")){
					writer.append((i+1)+" 03 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CC11")){
					writer.append((i+1)+" 04 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CV00")){
					writer.append((i+1)+" 05 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CV01")){
					writer.append((i+1)+" 06 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CV10")){
					writer.append((i+1)+" 07 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"CV11")){
					writer.append((i+1)+" 08 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VC00")){
					writer.append((i+1)+" 09 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VC01")){
					writer.append((i+1)+" 010 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VC10")){
					writer.append((i+1)+" 011 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VC11")){
					writer.append((i+1)+" 012 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VV00")){
					writer.append((i+1)+" 013 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VV01")){
					writer.append((i+1)+" 014 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VV10")){
					writer.append((i+1)+" 015 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
				if(evaluate(word,wordPos,y,"VV11")){
					writer.append((i+1)+" 016 "+wordPos+" "+y.charAt(wordPos-1)+" "+y.charAt(wordPos)+" 1\n");
					continue;
				}
			}
		}
	}
}
