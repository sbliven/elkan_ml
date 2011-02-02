import java.io.*;


public class Decoding {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		 try {
			BufferedReader in = new BufferedReader(new FileReader("C:/Users/Jonas/workspace/Decoding/src/HillstromDataCleaned.csv"));
			String begin = in.readLine();
			
			/*
			 * setup writer
			 */
			BufferedWriter womens = new BufferedWriter(new FileWriter("C:/Users/Jonas/workspace/Decoding/src/WomensEmail.csv"));
			BufferedWriter mens = new BufferedWriter(new FileWriter("C:/Users/Jonas/workspace/Decoding/src/MensEmail.csv"));
			BufferedWriter noemail = new BufferedWriter(new FileWriter("C:/Users/Jonas/workspace/Decoding/src/NoEmail.csv"));
			System.out.println(begin);
			
			
			for(int i=0;i<64000;++i){
			String[] s = in.readLine().split(",");
			
			double[] d = readLine(s);
			
			
			//now sort in depending on segment	
			writeLine(womens, mens, noemail, s, d);
			
			
			}
			womens.close();
			mens.close();
			noemail.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 

		

	}

	private static void writeLine(BufferedWriter womens, BufferedWriter mens,
			BufferedWriter noemail, String[] s, double[] d) throws IOException {
		String out = "";
		for(int j=0;j<d.length;++j){
			
			
			if(j<d.length-1){
				out = out+d[j]+",";
			}else{
				out = out+d[j];
			}
		}
		//System.out.print(out);
		//System.out.println(s[8]);
		
		
		
		
		if(s[8].equals("Womens E-Mail")){
			//write to Womens Email
			womens.write(out);
			womens.newLine();
			
		}else if(s[8].equals("Mens E-Mail")){
			//write to Mens Email
			mens.write(out);
			mens.newLine();
		}else{
			//write to no email
			noemail.write(out);
			noemail.newLine();
		}
		
		System.out.println();
	}

	private static double[] readLine(String[] s) {
		double[] d = new double[28];
		
		/*
		 * Bits 0 to 10
		 * Recency as bits from 0=Jan to 10 = Nov
		 * (December left out)
		 */
		int recency = Integer.parseInt(s[0]);
		if(recency<12){
			d[recency-1]=1;
		}
		/*
		 * Bit 11 to 16
		 * 
		 *  Decodes Segment 1 to 6
		 *  (Segement 7 left out)
		 */

		int history_segment = Integer.parseInt(""+s[1].charAt(0));

		if(history_segment < 7){
			d[10+history_segment] = 1;
		}
 
		/*
		 * Bit 17: Real value of history
		 */
		double history = Double.parseDouble(s[2]);
		d[17] = history;
		
		/*
		 * Bit 18 and 19: Mens and Womens Newsletter
		 */			
		int mens = Integer.parseInt(s[3]);
		d[18]=mens;
		int womens = Integer.parseInt(s[4]);
		d[19] = womens;
		
		/*
		 * Bits 20 +21: Urban and Rural
		 * Suburban left out
		 */
				
		if(s[5].equals("Urban")){
			d[20]=1;
		}else if(s[5].equals("Rural")){
			d[21]=1;
		}
		/*
		 * Bit 22: Newbie or not
		 */
		int newbie = Integer.parseInt(s[6]);
		d[22] = newbie;
				
		/*
		 * Bit 23+24 Web, Phone or both in case Multichannel
		 */
		if(s[7].equals("Phone")){
			d[23]=1;
			d[24]=0;
		}else if(s[7].equals("Web")){
			d[23]=0;
			d[24]=1;
		}else{
			d[23]=1;
			d[24]=1;
		}
		
		/*
		 * Bit 25,26,27 Visit, Conversion, Real value Money spend
		 */

		int visit = Integer.parseInt(s[9]);
		d[25] = visit;
		int conversion = Integer.parseInt(s[10]);
		d[26] = conversion;
		double spend = Double.parseDouble(s[11]);
		d[27] = spend;
		return d;
	}

}
