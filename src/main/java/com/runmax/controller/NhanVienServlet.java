package com.runmax.controller;

import com.runmax.entity.*;
import com.runmax.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/nhan-vien")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class NhanVienServlet extends HttpServlet {

    private final NhanVienService   nvService         = new NhanVienService();
    private final VaiTroService     vtService         = new VaiTroService();
    private final CloudinaryService cloudinaryService = new CloudinaryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add"  -> showForm(req, resp, null);
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                showForm(req, resp, nvService.findById(id));
            }
            default -> showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action != null ? action : "") {
            case "save"   -> handleSave(req, resp);
            case "toggle" -> handleToggle(req, resp);
            default       -> resp.sendRedirect(req.getContextPath() + "/nhan-vien");
        }
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String success = (String) req.getSession().getAttribute("successMessage");
        if (success != null) {
            req.setAttribute("successMessage", success);
            req.getSession().removeAttribute("successMessage");
        }
        String keyword = req.getParameter("keyword");
        String vtIdStr = req.getParameter("vaiTroId");
        String ttStr   = req.getParameter("trangThai");
        Long vtId = (vtIdStr != null && !vtIdStr.isEmpty()) ? Long.parseLong(vtIdStr) : null;
        Integer tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : null;

        int page = 1;
        int size = 10;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        if (page < 1) page = 1;
        int offset = (page - 1) * size;

        Long totalRecords = nvService.countAll(keyword, vtId, tt);
        int totalPages = (int) Math.ceil((double) totalRecords / size);

        req.setAttribute("nhanViens", nvService.findAll(keyword, vtId, tt, offset, size));
        req.setAttribute("vaiTros", vtService.findAll());
        req.setAttribute("keyword", keyword);
        req.setAttribute("vaiTroId", vtId);
        req.setAttribute("trangThai", tt);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        req.getRequestDispatcher("/WEB-INF/QL_Tai_Khoan/nhan-vien.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, NhanVien nv)
            throws ServletException, IOException {
        req.setAttribute("nhanVienEdit", nv);
        req.setAttribute("vaiTros", vtService.findAll());
        req.setAttribute("nextMaNv", nvService.getNextMaNv());
        req.getRequestDispatcher("/WEB-INF/QL_Tai_Khoan/form-nhan-vien.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr       = req.getParameter("id");
        String hoTen       = req.getParameter("hoTen");
        String maNv        = req.getParameter("maNv");
        String sdt         = req.getParameter("sdt");
        String email       = req.getParameter("email");
        String tdnhap      = req.getParameter("tenDangNhap");
        String mkMoi       = req.getParameter("matKhau");
        String vtIdStr     = req.getParameter("vaiTroId");
        String gioiTinhStr = req.getParameter("gioiTinh");
        String ngaySinhStr = req.getParameter("ngaySinh");
        String tinhThanh   = req.getParameter("tinhThanhPho");
        String quanHuyen   = req.getParameter("quanHuyen");
        String phuongXa    = req.getParameter("phuongXa");
        String chiTiet     = req.getParameter("diaChiChiTiet");
        String ttStr       = req.getParameter("trangThai");

        Long vtId = (vtIdStr != null && !vtIdStr.isEmpty()) ? Long.parseLong(vtIdStr) : 1L;
        VaiTro vt = vtService.findById(vtId);
        int tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : 1;

        boolean isEdit = (idStr != null && !idStr.isEmpty());
        Long id = isEdit ? Long.parseLong(idStr) : null;

        boolean gioiTinh = (gioiTinhStr == null || "1".equals(gioiTinhStr) || "true".equalsIgnoreCase(gioiTinhStr));
        LocalDate ngaySinh = null;
        if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
            try {
                ngaySinh = LocalDate.parse(ngaySinhStr.trim());
            } catch (Exception ignored) {}
        }

        Part fileAnh = null;
        try {
            fileAnh = req.getPart("fileAnh");
        } catch (Exception ignored) {}
        
        String uploadedUrl = null;
        String anhFromForm = req.getParameter("anhDaiDien");
        try {
            uploadedUrl = cloudinaryService.uploadImage(fileAnh, "runmax/nhan-vien", req);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Lỗi tải ảnh lên Cloud: " + e.getMessage());
            NhanVien nvTmp = NhanVien.builder().anhDaiDien(anhFromForm).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
            showForm(req, resp, nvTmp);
            return;
        }
        
        String currentAnh  = (uploadedUrl != null) ? uploadedUrl : (anhFromForm != null && !anhFromForm.trim().isEmpty() ? anhFromForm.trim() : null);

        if (hoTen == null || hoTen.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Họ và tên nhân viên không được để trống!");
            NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
            showForm(req, resp, nvTmp);
            return;
        }

        if (sdt == null || !sdt.trim().matches("^0[0-9]{9}$")) {
            req.setAttribute("errorMessage", "Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0!");
            NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
            showForm(req, resp, nvTmp);
            return;
        }

        if (maNv == null || maNv.trim().isEmpty()) {
            maNv = nvService.getNextMaNv();
        } else {
            maNv = maNv.trim().toUpperCase();
        }

        if (!isEdit && (tdnhap == null || tdnhap.trim().isEmpty())) {
            if (email != null && !email.trim().isEmpty()) {
                tdnhap = email.trim();
            } else if (sdt != null && !sdt.trim().isEmpty()) {
                tdnhap = sdt.trim();
            } else {
                tdnhap = maNv;
            }
        }

        if (!isEdit && (mkMoi == null || mkMoi.trim().isEmpty())) {
            mkMoi = nvService.generatePassword();
        }

        // Check duplicates
        List<NhanVien> list = nvService.findAll(null, null, null);
        for (NhanVien item : list) {
            if (isEdit && id != null && id.equals(item.getId())) continue;
            if (item.getMaNv() != null && item.getMaNv().equalsIgnoreCase(maNv)) {
                req.setAttribute("errorMessage", "Mã nhân viên '" + maNv + "' đã tồn tại, không được trùng!");
                NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
                showForm(req, resp, nvTmp);
                return;
            }
            if (tdnhap != null && !tdnhap.trim().isEmpty() && item.getTenDangNhap() != null && item.getTenDangNhap().trim().equalsIgnoreCase(tdnhap.trim())) {
                req.setAttribute("errorMessage", "Tên đăng nhập '" + tdnhap.trim() + "' đã tồn tại, không được trùng!");
                NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
                showForm(req, resp, nvTmp);
                return;
            }
            if (sdt != null && !sdt.trim().isEmpty() && item.getSdt() != null && item.getSdt().trim().equals(sdt.trim())) {
                req.setAttribute("errorMessage", "Số điện thoại '" + sdt.trim() + "' đã được sử dụng cho nhân viên khác!");
                NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
                showForm(req, resp, nvTmp);
                return;
            }
            if (email != null && !email.trim().isEmpty() && item.getEmail() != null && item.getEmail().trim().equalsIgnoreCase(email.trim())) {
                req.setAttribute("errorMessage", "Email '" + email.trim() + "' đã được sử dụng cho nhân viên khác!");
                NhanVien nvTmp = NhanVien.builder().anhDaiDien(currentAnh).id(id).maNv(maNv).hoTen(hoTen).sdt(sdt).email(email).tenDangNhap(tdnhap).vaiTro(vt).gioiTinh(gioiTinh).ngaySinh(ngaySinh).tinhThanhPho(tinhThanh).quanHuyen(quanHuyen).phuongXa(phuongXa).diaChiChiTiet(chiTiet).trangThai(tt).build();
                showForm(req, resp, nvTmp);
                return;
            }
        }

        if (isEdit && id != null) {
            NhanVien nv = nvService.findById(id);
            if (currentAnh != null) {
                nv.setAnhDaiDien(currentAnh);
            }
            nv.setMaNv(maNv);
            nv.setHoTen(hoTen.trim());
            nv.setSdt(sdt != null ? sdt.trim() : null);
            nv.setEmail(email != null ? email.trim() : null);
            if (tdnhap != null && !tdnhap.trim().isEmpty()) nv.setTenDangNhap(tdnhap.trim());
            nv.setVaiTro(vt);
            nv.setGioiTinh(gioiTinh);
            nv.setNgaySinh(ngaySinh);
            nv.setTinhThanhPho(tinhThanh != null ? tinhThanh.trim() : null);
            nv.setQuanHuyen(quanHuyen != null ? quanHuyen.trim() : null);
            nv.setPhuongXa(phuongXa != null ? phuongXa.trim() : null);
            nv.setDiaChiChiTiet(chiTiet != null ? chiTiet.trim() : null);
            if (mkMoi != null && !mkMoi.trim().isEmpty()) nv.setMatKhau(mkMoi.trim());
            nv.setTrangThai(tt);
            nvService.update(nv);
            NhanVien loggedIn = (NhanVien) req.getSession().getAttribute("nhanVien");
            if (loggedIn != null && loggedIn.getId() != null && loggedIn.getId().equals(nv.getId())) {
                req.getSession().setAttribute("nhanVien", nv);
                req.getSession().setAttribute("tenNhanVien", nv.getHoTen());
            }
        } else {
            NhanVien nv = NhanVien.builder()
                .anhDaiDien(currentAnh)
                .maNv(maNv)
                .hoTen(hoTen.trim())
                .sdt(sdt != null ? sdt.trim() : null)
                .email(email != null ? email.trim() : null)
                .tenDangNhap(tdnhap.trim())
                .matKhau(mkMoi.trim())
                .vaiTro(vt)
                .gioiTinh(gioiTinh)
                .ngaySinh(ngaySinh)
                .tinhThanhPho(tinhThanh != null ? tinhThanh.trim() : null)
                .quanHuyen(quanHuyen != null ? quanHuyen.trim() : null)
                .phuongXa(phuongXa != null ? phuongXa.trim() : null)
                .diaChiChiTiet(chiTiet != null ? chiTiet.trim() : null)
                .trangThai(tt)
                .build();
            nvService.save(nv);
        }
        // Gửi email chào mừng và thông báo thành công
        if (!isEdit) {
            boolean emailSent = nvService.sendWelcomeEmailAsync(email, hoTen.trim(), tdnhap.trim(), mkMoi.trim());
            if (emailSent) {
                req.getSession().setAttribute("successMessage",
                    "Thêm nhân viên thành công! Thông tin tài khoản đã gửi qua email: " + email);
            } else {
                // Không có email – lưu mật khẩu tạm để hiển thị nổi bật trên màn hình
                req.getSession().setAttribute("successMessage", "Thêm nhân viên thành công!");
                req.getSession().setAttribute("tempPasswordAlert",
                    "Nhân viên <strong>" + hoTen.trim() + "</strong> chưa có email.<br>"
                    + "Tài khoản: <code>" + tdnhap.trim() + "</code> &nbsp;| "
                    + "Mật khẩu tạm: <code>" + mkMoi.trim() + "</code><br>"
                    + "<small class=\"text-muted\">Vui lòng bàn giao trực tiếp cho nhân viên và yêu cầu đổi mật khẩu ngay.</small>");
            }
        } else {
            req.getSession().setAttribute("successMessage", "Cập nhật nhân viên thành công!");
        }
        resp.sendRedirect(req.getContextPath() + "/nhan-vien");
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        nvService.toggleStatus(id);
        resp.sendRedirect(req.getContextPath() + "/nhan-vien");
    }
}
