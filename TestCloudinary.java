import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;

public class TestCloudinary {
    public static void main(String[] args) {
        String CLOUD_NAME = "hq5yd481";
        String API_KEY = "381417382149126";
        String API_SECRET = "UFrk5-6GEYKWYAygq7nP2rlrXjg";
        
        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
        ));
        
        try {
            System.out.println("Testing API key and secret by fetching account details...");
            Map result = cloudinary.api().ping(ObjectUtils.emptyMap());
            System.out.println("Success! " + result);
        } catch (Exception e) {
            System.out.println("Failed: " + e.getMessage());
        }
    }
}
