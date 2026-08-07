package com.runmax.controller;

import com.runmax.entity.*;
import com.runmax.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/khach-hang")
public class KhachHangServlet extends HttpServlet {

    private final KhachHangService khService = new KhachHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add"  -> showForm(req, resp, null);
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                showForm(req, resp, khService.findById(id));
            }
            case "delete" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                khService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/khach-hang");
            }
            default -> showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action != null ? action : "") {
            case "save"              -> handleSave(req, resp);
            case "toggle"            -> handleToggle(req, resp);
            case "saveAddress"       -> handleSaveAddress(req, resp);
            case "deleteAddress"     -> handleDeleteAddress(req, resp);
            case "setDefaultAddress" -> handleSetDefaultAddress(req, resp);
            case "delete" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                khService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/khach-hang");
            }
            default -> resp.sendRedirect(req.getContextPath() + "/khach-hang");
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
        String ttStr   = req.getParameter("trangThai");
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

        Long totalRecords = khService.countAll(keyword, tt);
        int totalPages = (int) Math.ceil((double) totalRecords / size);

        req.setAttribute("khachHangs", khService.findAll(keyword, tt, offset, size));
        req.setAttribute("keyword", keyword);
        req.setAttribute("trangThai", tt);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        req.getRequestDispatcher("/WEB-INF/QL_Tai_Khoan/khach-hang.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, KhachHang kh)
            throws ServletException, IOException {
        if (req.getAttribute("diaChi") == null && kh != null && kh.getId() != null) {
            req.setAttribute("diaChi", khService.findDiaChi(kh.getId()));
        }
        req.setAttribute("khachHang", kh);
        req.setAttribute("nextMaKh", khService.getNextMaKh());
        req.getRequestDispatcher("/WEB-INF/QL_Tai_Khoan/form-khach-hang.jsp").forward(req, resp);
    }

    private List<DiaChiKhachHang> extractAddressesFromRequest(HttpServletRequest req, KhachHang kh) {
        List<DiaChiKhachHang> list = new java.util.ArrayList<>();
        String[] tinhThanhs   = req.getParameterValues("dc_tinhThanhPho");
        String[] quanHuyens   = req.getParameterValues("dc_quanHuyen");
        String[] phuongXas    = req.getParameterValues("dc_phuongXa");
        String[] chiTiets     = req.getParameterValues("dc_diaChiChiTiet");
        String[] dcTrangThais = req.getParameterValues("dc_trangThai");
        if (chiTiets != null) {
            for (int i = 0; i < chiTiets.length; i++) {
                String ct = chiTiets[i];
                if (ct == null || ct.trim().isEmpty()) continue;
                String px  = (phuongXas != null && i < phuongXas.length) ? phuongXas[i] : "";
                String qh  = (quanHuyens != null && i < quanHuyens.length) ? quanHuyens[i] : "";
                String ttP = (tinhThanhs != null && i < tinhThanhs.length) ? tinhThanhs[i] : "";
                int dcTt   = (dcTrangThais != null && i < dcTrangThais.length) ? Integer.parseInt(dcTrangThais[i]) : (i == 0 ? 1 : 0);
                list.add(DiaChiKhachHang.builder()
                    .khachHang(kh)
                    .diaChiChiTiet(ct.trim())
                    .phuongXa(px.trim())
                    .quanHuyen(qh.trim())
                    .tinhThanhPho(ttP.trim())
                    .trangThai(dcTt)
                    .build());
            }
        }
        return list;
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr       = req.getParameter("id");
        String hoTen       = req.getParameter("hoTen");
        String maKh        = req.getParameter("maKh");
        String sdt         = req.getParameter("sdt");
        String email       = req.getParameter("email");
        String ngaySinhStr = req.getParameter("ngaySinh");
        String gioiTinhStr = req.getParameter("gioiTinh");
        String ttStr       = req.getParameter("trangThai");

        boolean isEdit = (idStr != null && !idStr.isEmpty());
        Long id = isEdit ? Long.parseLong(idStr) : null;

        java.time.LocalDate ngaySinh = null;
        if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
            try {
                ngaySinh = java.time.LocalDate.parse(ngaySinhStr.trim());
            } catch (Exception ignored) {}
        }
        int gioiTinh = (gioiTinhStr != null && !gioiTinhStr.isEmpty()) ? Integer.parseInt(gioiTinhStr) : 1;
        int tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : 1;

        if (hoTen == null || hoTen.trim().isEmpty() || hoTen.trim().length() < 2) {
            req.setAttribute("errorMessage", "Họ và tên khách hàng không hợp lệ (tối thiểu 2 ký tự, không được chỉ chứa khoảng trắng)!");
            KhachHang khTmp = KhachHang.builder().id(id).maKh(maKh).hoTen(hoTen != null ? hoTen.trim() : "").sdt(sdt).email(email).ngaySinh(ngaySinh).gioiTinh(gioiTinh).trangThai(tt).build();
            req.setAttribute("diaChi", extractAddressesFromRequest(req, khTmp));
            showForm(req, resp, khTmp);
            return;
        }

        if (maKh == null || maKh.trim().isEmpty()) {
            maKh = khService.getNextMaKh();
        } else {
            maKh = maKh.trim().toUpperCase();
        }

        // Check duplicate maKh, sdt, email
        List<KhachHang> list = khService.findAll(null, null);
        for (KhachHang item : list) {
            if (isEdit && id != null && id.equals(item.getId())) continue;
            if (item.getMaKh() != null && item.getMaKh().equalsIgnoreCase(maKh)) {
                req.setAttribute("errorMessage", "Mã khách hàng '" + maKh + "' đã tồn tại, không được trùng!");
                KhachHang khTmp = KhachHang.builder().id(id).maKh(maKh).hoTen(hoTen).sdt(sdt).email(email).ngaySinh(ngaySinh).gioiTinh(gioiTinh).trangThai(tt).build();
                req.setAttribute("diaChi", extractAddressesFromRequest(req, khTmp));
                showForm(req, resp, khTmp);
                return;
            }
            if (sdt != null && !sdt.trim().isEmpty() && item.getSdt() != null && item.getSdt().trim().equals(sdt.trim())) {
                req.setAttribute("errorMessage", "Số điện thoại '" + sdt.trim() + "' đã được sử dụng cho khách hàng khác!");
                KhachHang khTmp = KhachHang.builder().id(id).maKh(maKh).hoTen(hoTen).sdt(sdt).email(email).ngaySinh(ngaySinh).gioiTinh(gioiTinh).trangThai(tt).build();
                req.setAttribute("diaChi", extractAddressesFromRequest(req, khTmp));
                showForm(req, resp, khTmp);
                return;
            }
            if (email != null && !email.trim().isEmpty() && item.getEmail() != null && item.getEmail().trim().equalsIgnoreCase(email.trim())) {
                req.setAttribute("errorMessage", "Email '" + email.trim() + "' đã được sử dụng cho khách hàng khác!");
                KhachHang khTmp = KhachHang.builder().id(id).maKh(maKh).hoTen(hoTen).sdt(sdt).email(email).ngaySinh(ngaySinh).gioiTinh(gioiTinh).trangThai(tt).build();
                req.setAttribute("diaChi", extractAddressesFromRequest(req, khTmp));
                showForm(req, resp, khTmp);
                return;
            }
        }

        KhachHang khSaved;
        if (isEdit && id != null) {
            khSaved = khService.findById(id);
            khSaved.setMaKh(maKh);
            khSaved.setHoTen(hoTen.trim());
            khSaved.setSdt(sdt != null ? sdt.trim() : null);
            khSaved.setEmail(email != null ? email.trim() : null);
            khSaved.setNgaySinh(ngaySinh);
            khSaved.setGioiTinh(gioiTinh);
            khSaved.setTrangThai(tt);
            khService.update(khSaved);
        } else {
            khSaved = KhachHang.builder()
                .maKh(maKh)
                .hoTen(hoTen.trim())
                .sdt(sdt != null ? sdt.trim() : null)
                .email(email != null ? email.trim() : null)
                .ngaySinh(ngaySinh)
                .gioiTinh(gioiTinh)
                .trangThai(tt)
                .build();
            khService.save(khSaved);
            if (sdt != null && !sdt.trim().isEmpty()) {
                khSaved = khService.findBySdt(sdt.trim());
            }
            if (khSaved == null || khSaved.getId() == null) {
                List<KhachHang> all = khService.findAll(maKh, null);
                if (!all.isEmpty()) khSaved = all.get(0);
            }
        }

        // Đồng bộ danh sách địa chỉ gửi lên từ form
        if (khSaved != null && khSaved.getId() != null) {
            String[] tinhThanhs   = req.getParameterValues("dc_tinhThanhPho");
            String[] quanHuyens   = req.getParameterValues("dc_quanHuyen");
            String[] phuongXas    = req.getParameterValues("dc_phuongXa");
            String[] chiTiets     = req.getParameterValues("dc_diaChiChiTiet");
            String[] dcTrangThais = req.getParameterValues("dc_trangThai");

            khService.deleteDiaChiByKhachHangId(khSaved.getId());
            if (chiTiets != null) {
                for (int i = 0; i < chiTiets.length; i++) {
                    String ct = chiTiets[i];
                    if (ct == null || ct.trim().isEmpty()) continue;
                    String px  = (phuongXas != null && i < phuongXas.length) ? phuongXas[i] : "";
                    String qh  = (quanHuyens != null && i < quanHuyens.length) ? quanHuyens[i] : "";
                    String ttP = (tinhThanhs != null && i < tinhThanhs.length) ? tinhThanhs[i] : "";
                    int dcTt   = (dcTrangThais != null && i < dcTrangThais.length) ? Integer.parseInt(dcTrangThais[i]) : (i == 0 ? 1 : 0);

                    DiaChiKhachHang dc = DiaChiKhachHang.builder()
                        .khachHang(khSaved)
                        .diaChiChiTiet(ct.trim())
                        .phuongXa(px.trim())
                        .quanHuyen(qh.trim())
                        .tinhThanhPho(ttP.trim())
                        .trangThai(dcTt)
                        .build();
                    khService.saveDiaChi(dc);
                }
            }
        }

        req.getSession().setAttribute("successMessage", isEdit ? "Cập nhật thông tin khách hàng thành công!" : "Thêm mới khách hàng thành công!");
        resp.sendRedirect(req.getContextPath() + "/khach-hang");
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        khService.toggleStatus(id);
        resp.sendRedirect(req.getContextPath() + "/khach-hang");
    }

    private void handleSaveAddress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long khId = Long.parseLong(req.getParameter("khachHangId"));
        KhachHang kh = khService.findById(khId);
        if (kh != null) {
            String tinhThanh = req.getParameter("tinhThanhPho");
            String quanHuyen = req.getParameter("quanHuyen");
            String phuongXa  = req.getParameter("phuongXa");
            String chiTiet   = req.getParameter("diaChiChiTiet");
            int isDefault    = "1".equals(req.getParameter("trangThai")) ? 1 : 0;

            if (isDefault == 1) {
                List<DiaChiKhachHang> list = khService.findDiaChi(khId);
                for (DiaChiKhachHang item : list) {
                    if (item.getTrangThai() == 1) {
                        item.setTrangThai(0);
                        khService.updateDiaChi(item);
                    }
                }
            } else {
                List<DiaChiKhachHang> list = khService.findDiaChi(khId);
                if (list.isEmpty()) isDefault = 1;
            }

            DiaChiKhachHang dc = DiaChiKhachHang.builder()
                .khachHang(kh)
                .diaChiChiTiet(chiTiet)
                .phuongXa(phuongXa)
                .quanHuyen(quanHuyen)
                .tinhThanhPho(tinhThanh)
                .trangThai(isDefault)
                .build();
            khService.saveDiaChi(dc);
        }
        resp.sendRedirect(req.getContextPath() + "/khach-hang?action=edit&id=" + khId);
    }

    private void handleDeleteAddress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id   = Long.parseLong(req.getParameter("id"));
        Long khId = Long.parseLong(req.getParameter("khId"));
        khService.deleteDiaChi(id);
        resp.sendRedirect(req.getContextPath() + "/khach-hang?action=edit&id=" + khId);
    }

    private void handleSetDefaultAddress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id   = Long.parseLong(req.getParameter("id"));
        Long khId = Long.parseLong(req.getParameter("khId"));
        List<DiaChiKhachHang> list = khService.findDiaChi(khId);
        for (DiaChiKhachHang item : list) {
            if (item.getId().equals(id)) {
                item.setTrangThai(1);
            } else if (item.getTrangThai() == 1) {
                item.setTrangThai(0);
            }
            khService.updateDiaChi(item);
        }
        if (!"true".equals(req.getParameter("ajax"))) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang?action=edit&id=" + khId);
        } else {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("OK");
        }
    }
}
