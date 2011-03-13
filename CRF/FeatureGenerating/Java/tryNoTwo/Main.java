package tryNoTwo;

import java.io.File;

public class Main {

	/**
	 * @param args
	 */
	public static void Main(String[] args) {
		
		File file = new File("src/data/zulu250.txt");
		
		//constructor reads in words and syllables and
		//maps them together as "ababalabala,10010010"
		Zulu zulu= new Zulu(file);
		
		//makes all 'aba 101'-s, 'zululululu 10100101'-s etc
		zulu.generateWindowFeatures();
		
		
		zulu.evaluateWordsAndWriteToFile();
		
	}

}
