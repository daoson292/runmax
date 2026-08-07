package com.runmax.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

// Cloudinary Upload Service (Tiện ích tải ảnh lên đám mây Cloudinary + Fallback Local Disk).
public class CloudinaryService {

    private static final String CLOUD_NAME = "hq5yd481".trim();
    private static final String API_KEY    = "381417382149126".trim();
    // API Secret do người dùng cung cấp
    private static String API_SECRET = "UFrk5-6GEYKWYAyGq7nP2rlrXjg".trim();

    private Cloudinary cloudinary;

    public CloudinaryService() {
        initCloudinary();
    }

    public static void setApiSecret(String secret) {
        if (secret != null && !secret.trim().isEmpty()) {
            API_SECRET = secret.trim();
        }
    }

    private void initCloudinary() {
        Map<String, Object> config = ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME.trim(),
                "api_key", API_KEY.trim(),
                "api_secret", API_SECRET.trim(),
                "secure", true
        );
        this.cloudinary = new Cloudinary(config);
    }

    public String uploadImage(Part filePart, String folder) throws Exception {
        return uploadImage(filePart, folder, null);
    }

    public String uploadImage(Part filePart, String folder, HttpServletRequest req) throws Exception {
        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        // Kiểm tra định dạng ảnh
        String contentType = filePart.getContentType();
        if (contentType != null && !contentType.startsWith("image/")) {
            System.err.println("[CloudinaryService] Lỗi: File tải lên không phải là định dạng hình ảnh (" + contentType + ")");
            return null;
        }

        try (InputStream inputStream = filePart.getInputStream()) {
            byte[] fileBytes = inputStream.readAllBytes();
            if (fileBytes.length == 0) {
                return null;
            }

            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "folder", folder != null && !folder.trim().isEmpty() ? folder.trim() : "runmax/general",
                    "resource_type", "image",
                    "use_filename", true,
                    "unique_filename", true
            );

            // Re-init nếu API Secret vừa được cập nhật động
            initCloudinary();

            Map uploadResult = cloudinary.uploader().upload(fileBytes, uploadParams);
            if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                String secureUrl = (String) uploadResult.get("secure_url");
                System.out.println("[CloudinaryService] Tải ảnh lên thành công: " + secureUrl);
                return secureUrl;
            }
        } catch (Exception e) {
            System.err.println("[CloudinaryService] Lỗi Cloudinary API/Network: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Lỗi kết nối tới Cloudinary API: " + e.getMessage(), e);
        }
        return null;
    }
}
