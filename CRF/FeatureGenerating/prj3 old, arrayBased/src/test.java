

import java.util.HashMap;
import java.util.Map;

public class test {
	public static void testMe() {
		evaluate("abcdefghijklmnop",new String[]{"abcde","fg","h"});
	}
	public static void evaluate(String word, String[] syllables){
		Map<String,String> indicesOfSpaces=new HashMap<String,String>();
		String syllableIntegers="";

		for(int i=0;i< syllables.length;i++){
			syllableIntegers+=syllables[i].length();
		}

		while(word.length()>3){
			if(syllableIntegers.charAt(0)>='3'){
				indicesOfSpaces.put(word.substring(0,3), "");
				syllableIntegers=syllableIntegers.charAt(0)-'1'+syllableIntegers.substring(1);
			}
			else if(syllableIntegers.charAt(0)<'3'){
				indicesOfSpaces.put(word.substring(0,3), String.valueOf((syllableIntegers.charAt(0))));
				int int0=Integer.parseInt(String.valueOf(syllableIntegers.charAt(0)));
				int int1=Integer.parseInt(String.valueOf(syllableIntegers.charAt(1)));
				syllableIntegers=String.valueOf(int0+int1)+syllableIntegers.substring(2);
				
			}
			word=word.substring(1);
		}
	}
}
