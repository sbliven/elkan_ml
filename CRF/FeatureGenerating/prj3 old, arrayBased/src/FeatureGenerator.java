import java.util.ArrayList;
import java.util.Map;


public interface FeatureGenerator {
	abstract void evaluate(String x, String[] y, Map<String, ArrayList<String>> wordFeatures);
}
