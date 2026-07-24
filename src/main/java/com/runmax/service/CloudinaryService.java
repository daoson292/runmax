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

    private static final String CLOUD_NAME = "hq5yd481";
    private static final String API_KEY    = "793213759265169";
    // API Secret do người dùng cung cấp
    private static String API_SECRET = System.getenv("CLOUDINARY_API_SECRET") != null
            ? System.getenv("CLOUDINARY_API_SECRET") : "UFrk5-6GEYKWYAyGq7nP2rlrXjg";

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
        Map<String, String> config = ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
        );
        this.cloudinary = new Cloudinary(config);
    }

    public String uploadImage(Part filePart, String folder) {
        return uploadImage(filePart, folder, null);
    }

    public String uploadImage(Part filePart, String folder, HttpServletRequest req) {
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
            System.err.println("[CloudinaryService] Lỗi Cloudinary API/Network: " + e.getMessage() + ". Đang chuyển sang lưu tại máy chủ (local disk)...");
            if (req != null) {
                return saveToLocal(filePart, folder, req);
            }
        }
        return null;
    }

    private String saveToLocal(Part filePart, String folder, HttpServletRequest req) {
        try {
            String originalName = filePart.getSubmittedFileName();
            String cleanName = System.currentTimeMillis() + "_" + originalName.replaceAll("[^a-zA-Z0-9.-]", "_");
            String relPath = "assets/uploads/" + (folder != null ? folder.replace("runmax/", "") + "/" : "");
            String realDirPath = req.getServletContext().getRealPath("/") + relPath;
            File dir = new File(realDirPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            File destFile = new File(dir, cleanName);
            try (InputStream in = filePart.getInputStream();
                 FileOutputStream out = new FileOutputStream(destFile)) {
                in.transferTo(out);
            }
            String url = req.getContextPath() + "/" + relPath + cleanName;
            System.out.println("[CloudinaryService] Đã lưu ảnh tại local: " + url);
            return url;
        } catch (Exception ex) {
            System.err.println("[CloudinaryService] Lỗi khi lưu ảnh local: " + ex.getMessage());
            ex.printStackTrace();
            return null;
        }
    }
}
