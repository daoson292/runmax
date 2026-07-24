package com.runmax.service;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailService – Gửi email SMTP cho hệ thống RunMax.
 * Cấu hình tại: src/main/resources/email.properties
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private final Properties mailProps = new Properties();

    public EmailService() {
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("email.properties")) {
            if (in != null) {
                mailProps.load(in);
            } else {
                LOGGER.warning("Không tìm thấy email.properties – email sẽ không được gửi.");
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Lỗi đọc email.properties", e);
        }
    }

    /**
     * Gửi email chào mừng kèm thông tin tài khoản cho nhân viên mới.
     *
     * @param toEmail     Email nhận
     * @param hoTen       Họ tên nhân viên
     * @param tenDangNhap Tên đăng nhập
     * @param matKhau     Mật khẩu tạm thời (plain text)
     * @return true nếu gửi thành công
     */
    public boolean sendWelcomeEmail(String toEmail, String hoTen, String tenDangNhap, String matKhau) {
        if (toEmail == null || toEmail.trim().isEmpty()) return false;

        String smtpHost     = mailProps.getProperty("mail.smtp.host", "smtp.gmail.com");
        String smtpPort     = mailProps.getProperty("mail.smtp.port", "587");
        String smtpUser     = mailProps.getProperty("mail.smtp.username", "");
        String smtpPass     = mailProps.getProperty("mail.smtp.password", "");
        String fromName     = mailProps.getProperty("mail.from.name", "RunMax System");
        String fromAddress  = mailProps.getProperty("mail.from.address", smtpUser);
        boolean useStartTLS = Boolean.parseBoolean(mailProps.getProperty("mail.smtp.starttls", "true"));
        boolean useAuth     = Boolean.parseBoolean(mailProps.getProperty("mail.smtp.auth", "true"));

        if (smtpUser.isBlank() || smtpPass.isBlank() || smtpPass.startsWith("xxxx")) {
            LOGGER.warning("SMTP chưa cấu hình – bỏ qua gửi email cho: " + toEmail);
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", String.valueOf(useAuth));
        props.put("mail.smtp.starttls.enable", String.valueOf(useStartTLS));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromAddress, fromName, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail.trim()));
            message.setSubject("=?UTF-8?B?" + java.util.Base64.getEncoder()
                .encodeToString(("🎉 Chào mừng " + hoTen + " gia nhập RunMax!").getBytes("UTF-8")) + "?=");
            message.setContent(buildEmailBody(hoTen, tenDangNhap, matKhau), "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.info("Đã gửi email thành công đến: " + toEmail);
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi email đến " + toEmail, e);
            return false;
        }
    }

    /**
     * Gửi email bất đồng bộ (không block luồng chính).
     */
    public void sendWelcomeEmailAsync(String toEmail, String hoTen, String tenDangNhap, String matKhau) {
        new Thread(() -> sendWelcomeEmail(toEmail, hoTen, tenDangNhap, matKhau),
                   "email-sender").start();
    }

    // -------------------------------------------------------------------------
    // Nội dung email HTML
    // -------------------------------------------------------------------------
    private String buildEmailBody(String hoTen, String tenDangNhap, String matKhau) {
        return "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\">"
            + "<style>"
            + "body{font-family:Arial,sans-serif;background:#f4f4f4;margin:0;padding:0;}"
            + ".wrap{max-width:520px;margin:32px auto;background:#fff;border-radius:12px;"
            + "box-shadow:0 4px 16px rgba(0,0,0,.10);overflow:hidden;}"
            + ".header{background:#dc2626;padding:28px 32px;text-align:center;}"
            + ".header h1{color:#fff;margin:0;font-size:26px;letter-spacing:1px;}"
            + ".header p{color:#fecaca;margin:6px 0 0;font-size:14px;}"
            + ".body{padding:32px;color:#1e293b;}"
            + ".body h2{margin-top:0;font-size:18px;}"
            + ".info-box{background:#fef2f2;border:1px solid #fecaca;border-radius:8px;"
            + "padding:16px 20px;margin:20px 0;}"
            + ".info-box table{width:100%;border-collapse:collapse;}"
            + ".info-box td{padding:6px 0;font-size:14px;}"
            + ".info-box td:first-child{color:#6b7280;width:130px;}"
            + ".info-box td:last-child{font-weight:700;color:#dc2626;font-size:15px;}"
            + ".warning{background:#fffbeb;border:1px solid #fde68a;border-radius:8px;"
            + "padding:12px 16px;margin-top:16px;font-size:13px;color:#92400e;}"
            + ".footer{background:#f8fafc;padding:16px 32px;text-align:center;"
            + "font-size:12px;color:#94a3b8;border-top:1px solid #e2e8f0;}"
            + "</style></head><body>"
            + "<div class=\"wrap\">"
            + "  <div class=\"header\"><h1>RunMax</h1><p>Hệ thống quản lý cửa hàng giày</p></div>"
            + "  <div class=\"body\">"
            + "    <h2>Chào mừng <strong>" + escHtml(hoTen) + "</strong>! 🎉</h2>"
            + "    <p>Tài khoản hệ thống RunMax của bạn đã được tạo thành công.<br>"
            + "       Dưới đây là thông tin đăng nhập của bạn:</p>"
            + "    <div class=\"info-box\">"
            + "      <table>"
            + "        <tr><td>Tên đăng nhập:</td><td>" + escHtml(tenDangNhap) + "</td></tr>"
            + "        <tr><td>Mật khẩu tạm:</td><td>" + escHtml(matKhau) + "</td></tr>"
            + "      </table>"
            + "    </div>"
            + "    <div class=\"warning\">"
            + "      ⚠️ <strong>Lưu ý bảo mật:</strong> Vui lòng đổi mật khẩu ngay sau khi đăng nhập lần đầu."
            + "      Không chia sẻ thông tin này cho người khác."
            + "    </div>"
            + "  </div>"
            + "  <div class=\"footer\">© 2025 RunMax – Đền Lừ, Hoàng Mai, Hà Nội | Hotline: 0968038313</div>"
            + "</div>"
            + "</body></html>";
    }

    private String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
}
