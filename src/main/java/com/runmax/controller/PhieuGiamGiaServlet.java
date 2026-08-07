package com.runmax.controller;

import com.runmax.entity.PhieuGiamGia;
import com.runmax.service.PhieuGiamGiaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/phieu-giam-gia")
public class PhieuGiamGiaServlet extends HttpServlet {

    private final PhieuGiamGiaService pggService = new PhieuGiamGiaService();
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add"  -> showForm(req, resp, null);
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                showForm(req, resp, pggService.findById(id));
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
            default       -> resp.sendRedirect(req.getContextPath() + "/phieu-giam-gia");
        }
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String success = (String) req.getSession().getAttribute("successMessage");
        if (success != null) {
            req.setAttribute("successMessage", success);
            req.getSession().removeAttribute("successMessage");
        }
        String keyword    = req.getParameter("keyword");
        String ttStr      = req.getParameter("trangThai");
        String loaiGiam   = req.getParameter("loaiGiam");
        String loaiPhieu  = req.getParameter("loaiPhieu");
        String denNgayStr = req.getParameter("denNgay");
        Integer tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : null;
        java.time.LocalDateTime denNgay = (denNgayStr != null && !denNgayStr.isEmpty())
            ? java.time.LocalDate.parse(denNgayStr).atTime(23, 59, 59) : null;

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

        Long totalRecords = pggService.countAll(keyword, tt, null, denNgay);
        int totalPages = (int) Math.ceil((double) totalRecords / size);

        req.setAttribute("phieuList", pggService.findAll(keyword, tt, null, denNgay, offset, size));
        req.setAttribute("keyword", keyword);
        req.setAttribute("trangThai", ttStr);
        req.setAttribute("loaiGiam", loaiGiam);
        req.setAttribute("loaiPhieu", loaiPhieu);
        req.setAttribute("denNgay", denNgayStr);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);
        req.getRequestDispatcher("/WEB-INF/giamGia/phieu-giam-gia.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, PhieuGiamGia pgg)
            throws ServletException, IOException {
        req.setAttribute("phieu", pgg);
        req.setAttribute("nextMa", pggService.getNextMaPhieu());
        req.setAttribute("isEdit", pgg != null && pgg.getId() != null);
        req.getRequestDispatcher("/WEB-INF/giamGia/form-phieu.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr      = req.getParameter("id");
        String tenPhieu   = req.getParameter("tenPhieu");
        int loaiPhieu     = parseIntDefault(req.getParameter("loaiPhieu"), 1);
        int loaiGiam      = parseIntDefault(req.getParameter("loaiGiam"), 1);
        BigDecimal giaTriGiam  = new BigDecimal(req.getParameter("giaTrigiam"));
        String giamTDStr       = req.getParameter("giamToiDa");
        BigDecimal giamToiDa   = (giamTDStr != null && !giamTDStr.trim().isEmpty()) ? new BigDecimal(giamTDStr.trim()) : null;
        BigDecimal dieuKienGiam = new BigDecimal(req.getParameter("dieuKienGiam") != null && !req.getParameter("dieuKienGiam").trim().isEmpty() ? req.getParameter("dieuKienGiam").trim() : "0");
        int soLuong             = parseIntDefault(req.getParameter("soLuong"), 1);
        String moTa             = req.getParameter("moTa");
        LocalDateTime batDau    = LocalDateTime.parse(req.getParameter("ngayBatDau") + "T00:00:00");
        LocalDateTime ketThuc   = LocalDateTime.parse(req.getParameter("ngayKetThuc") + "T23:59:59");

        boolean isEdit = (idStr != null && !idStr.trim().isEmpty());
        Long id = isEdit ? Long.parseLong(idStr.trim()) : null;

        if (tenPhieu == null || tenPhieu.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Tên phiếu giảm giá không được để trống!");
            PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
            showForm(req, resp, pTmp);
            return;
        }

        if (ketThuc.isBefore(batDau)) {
            req.setAttribute("errorMessage", "Ngày kết thúc không được nhỏ hơn ngày bắt đầu!");
            PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
            showForm(req, resp, pTmp);
            return;
        }

        if (soLuong <= 0) {
            req.setAttribute("errorMessage", "Số lượng phiếu giảm giá phải lớn hơn 0!");
            PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
            showForm(req, resp, pTmp);
            return;
        }

        if (dieuKienGiam.compareTo(BigDecimal.ZERO) < 0 || (giamToiDa != null && giamToiDa.compareTo(BigDecimal.ZERO) < 0)) {
            req.setAttribute("errorMessage", "Điều kiện đơn hàng tối thiểu và Giảm tối đa không được là số âm!");
            PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
            showForm(req, resp, pTmp);
            return;
        }

        if (loaiGiam == 1) {
            if (giaTriGiam.compareTo(BigDecimal.ONE) < 0 || giaTriGiam.compareTo(new BigDecimal("100")) > 0) {
                req.setAttribute("errorMessage", "Lỗi logic: Nếu giảm theo phần trăm (%), giá trị giảm phải từ 1% đến 100% (không được giảm > 100% hay giá trị âm)!");
                PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
                showForm(req, resp, pTmp);
                return;
            }
        } else {
            if (giaTriGiam.compareTo(BigDecimal.ZERO) <= 0) {
                req.setAttribute("errorMessage", "Lỗi logic: Nếu giảm theo số tiền cố định, giá trị giảm phải lớn hơn 0 VNĐ!");
                PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
                showForm(req, resp, pTmp);
                return;
            }
        }

        // Check duplicate name
        var list = pggService.findAll(null, null, null, null);
        for (PhieuGiamGia item : list) {
            if (isEdit && id != null && id.equals(item.getId())) continue;
            if (item.getTenPhieu() != null && item.getTenPhieu().trim().equalsIgnoreCase(tenPhieu.trim())) {
                req.setAttribute("errorMessage", "Tên phiếu giảm giá '" + tenPhieu.trim() + "' đã tồn tại, không được trùng!");
                PhieuGiamGia pTmp = PhieuGiamGia.builder().id(id).tenPhieu(tenPhieu).loaiPhieu(loaiPhieu).loaiGiam(loaiGiam).giaTrigiam(giaTriGiam).giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong).moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).build();
                showForm(req, resp, pTmp);
                return;
            }
        }

        if (isEdit && id != null) {
            PhieuGiamGia p = pggService.findById(id);
            p.setTenPhieu(tenPhieu.trim()); p.setLoaiPhieu(loaiPhieu);
            p.setLoaiGiam(loaiGiam); p.setGiaTrigiam(giaTriGiam); p.setGiamToiDa(giamToiDa);
            p.setDieuKienGiam(dieuKienGiam); p.setSoLuong(soLuong); p.setMoTa(moTa);
            p.setNgayBatDau(batDau); p.setNgayKetThuc(ketThuc);
            String trangThaiStr = req.getParameter("trangThai");
            if (trangThaiStr != null && !trangThaiStr.trim().isEmpty()) {
                p.setTrangThai(parseIntDefault(trangThaiStr.trim(), p.getTrangThai()));
            }
            pggService.update(p);
        } else {
            String maPhieu = pggService.getNextMaPhieu();
            PhieuGiamGia p = PhieuGiamGia.builder()
                .maPhieu(maPhieu).tenPhieu(tenPhieu.trim()).loaiPhieu(loaiPhieu)
                .loaiGiam(loaiGiam).giaTrigiam(giaTriGiam)
                .giamToiDa(giamToiDa).dieuKienGiam(dieuKienGiam).soLuong(soLuong)
                .moTa(moTa).ngayBatDau(batDau).ngayKetThuc(ketThuc).trangThai(1).build();
            pggService.save(p);
        }
        req.getSession().setAttribute("successMessage", isEdit ? "Cập nhật phiếu giảm giá thành công!" : "Thêm phiếu giảm giá thành công!");
        resp.sendRedirect(req.getContextPath() + "/phieu-giam-gia");
    }

    private int parseIntDefault(String s, int def) {
        try { return (s != null && !s.isEmpty()) ? Integer.parseInt(s) : def; } catch (Exception e) { return def; }
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        pggService.toggleStatus(Long.parseLong(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/phieu-giam-gia");
    }
}
