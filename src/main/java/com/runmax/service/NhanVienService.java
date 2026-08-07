package com.runmax.service;

import com.runmax.entity.NhanVien;
import com.runmax.repository.NhanVienRepository;

import java.security.SecureRandom;
import java.util.List;

public class NhanVienService {
    private final NhanVienRepository repo = new NhanVienRepository();
    private final EmailService emailService = new EmailService();

    // -------------------------------------------------------------------------
    // Tìm kiếm
    // -------------------------------------------------------------------------
    public List<NhanVien> findAll(String keyword, Long vaiTroId, Integer trangThai, int offset, int limit) {
        return repo.findAll(keyword, vaiTroId, trangThai, offset, limit);
    }

    public Long countAll(String keyword, Long vaiTroId, Integer trangThai) {
        return repo.countAll(keyword, vaiTroId, trangThai);
    }

    public List<NhanVien> findAll(String keyword, Long vaiTroId, Integer trangThai) {
        return repo.findAll(keyword, vaiTroId, trangThai, 0, Integer.MAX_VALUE);
    }

    public NhanVien findById(Long id)   { return repo.findById(id); }
    public NhanVien getById(Long id)    { return repo.findById(id); }
    public NhanVien findByEmail(String email) { return repo.findByEmail(email); }

    // -------------------------------------------------------------------------
    // Xác thực đăng nhập (tenDangNhap HOẶC email)
    // -------------------------------------------------------------------------
    public NhanVien authenticate(String input, String matKhau) {
        NhanVien nv = repo.findByTenDangNhapOrEmail(input);
        if (nv != null && nv.getMatKhau() != null && nv.getMatKhau().equals(matKhau)) {
            return nv;
        }
        return null;
    }

    // -------------------------------------------------------------------------
    // Tạo mã nhân viên
    // -------------------------------------------------------------------------
    public String getNextMaNv() { return repo.getNextMaNv(); }

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------
    public boolean save(NhanVien e)           { return repo.save(e); }
    public boolean update(NhanVien e)         { return repo.update(e); }
    public boolean toggleStatus(Long id)      { return repo.toggleStatus(id); }

    // -------------------------------------------------------------------------
    // Tạo mật khẩu ngẫu nhiên an toàn
    // -------------------------------------------------------------------------
    private static final String UPPERCASE = "ABCDEFGHJKLMNPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghjkmnpqrstuvwxyz";
    private static final String DIGITS    = "23456789";
    private static final String SPECIAL   = "@#$!%&";
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Tạo mật khẩu ngẫu nhiên gồm 10 ký tự:
     * ít nhất 1 hoa, 1 thường, 1 số, 1 ký tự đặc biệt.
     */
    public String generatePassword() {
        StringBuilder sb = new StringBuilder();
        // Bảo đảm tối thiểu 1 ký tự mỗi loại
        sb.append(UPPERCASE.charAt(RANDOM.nextInt(UPPERCASE.length())));
        sb.append(LOWERCASE.charAt(RANDOM.nextInt(LOWERCASE.length())));
        sb.append(DIGITS.charAt(RANDOM.nextInt(DIGITS.length())));
        sb.append(SPECIAL.charAt(RANDOM.nextInt(SPECIAL.length())));

        // Điền thêm đủ 10 ký tự từ tất cả các loại
        String all = UPPERCASE + LOWERCASE + DIGITS + SPECIAL;
        for (int i = 4; i < 10; i++) {
            sb.append(all.charAt(RANDOM.nextInt(all.length())));
        }

        // Xáo trộn thứ tự
        char[] chars = sb.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = RANDOM.nextInt(i + 1);
            char tmp = chars[i]; chars[i] = chars[j]; chars[j] = tmp;
        }
        return new String(chars);
    }

    /**
     * Gửi email chào mừng bất đồng bộ.
     *
     * @return true nếu có email để gửi (dù chưa biết kết quả thực tế)
     */
    public boolean sendWelcomeEmailAsync(String toEmail, String hoTen,
                                         String tenDangNhap, String matKhau) {
        if (toEmail == null || toEmail.trim().isEmpty()) return false;
        emailService.sendWelcomeEmailAsync(toEmail, hoTen, tenDangNhap, matKhau);
        return true;
    }
}
