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
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/san-pham-chi-tiet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class SanPhamChiTietServlet extends HttpServlet {

    private final SanPhamChiTietService spctService       = new SanPhamChiTietService();
    private final SanPhamService        spService         = new SanPhamService();
    private final MauSacService         msService         = new MauSacService();
    private final KichCoService         kcService         = new KichCoService();
    private final DeGiayService         dgService         = new DeGiayService();
    private final CloudinaryService     cloudinaryService = new CloudinaryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add"  -> showForm(req, resp, null);
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                showForm(req, resp, spctService.findById(id));
            }
            case "toggleStatus", "delete" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                spctService.toggleStatus(id);
                String spIdStr = req.getParameter("sanPhamId");
                if (spIdStr != null && !spIdStr.isEmpty() && !"null".equals(spIdStr)) {
                    resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet?sanPhamId=" + spIdStr);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet");
                }
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
            default       -> resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet");
        }
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String success = (String) req.getSession().getAttribute("successMessage");
        if (success != null) {
            req.setAttribute("successMessage", success);
            req.getSession().removeAttribute("successMessage");
        }
        String keyword  = req.getParameter("keyword");
        String msIdStr  = req.getParameter("mauSacId");
        String kcIdStr  = req.getParameter("kichCoId");
        String dgIdStr  = req.getParameter("deGiayId");
        String ttStr    = req.getParameter("trangThai");
        String gMinStr  = req.getParameter("giaMin");
        String gMaxStr  = req.getParameter("giaMax");

        String spIdStr  = req.getParameter("sanPhamId");
        Long sanPhamId  = parseId(spIdStr);

        Long mauSacId  = parseId(msIdStr);
        Long kichCoId  = parseId(kcIdStr);
        Long deGiayId  = parseId(dgIdStr);
        Integer tt     = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : null;
        BigDecimal gMin = (gMinStr != null && !gMinStr.isEmpty()) ? new BigDecimal(gMinStr) : null;
        BigDecimal gMax = (gMaxStr != null && !gMaxStr.isEmpty()) ? new BigDecimal(gMaxStr) : null;

        List<SanPhamChiTiet> list = spctService.findAll(keyword, mauSacId, kichCoId, deGiayId, tt, gMin, gMax, sanPhamId);
        if (sanPhamId != null) {
            req.setAttribute("filterSanPham", spService.findById(sanPhamId));
        }
        BigDecimal maxPriceInDb = spctService.findMaxPrice(sanPhamId);
        long maxVal = maxPriceInDb != null ? maxPriceInDb.longValue() : 10000000L;
        if (maxVal <= 0) {
            maxVal = 10000000L;
        } else if (maxVal % 100000 != 0) {
            maxVal = ((maxVal / 100000) + 1) * 100000;
        }
        if (maxVal < 1000000L) {
            maxVal = Math.max(maxVal, 1000000L);
        }
        req.setAttribute("sliderMax", maxVal);

        req.setAttribute("spctList", list);
        req.setAttribute("mauSacs", msService.findAll(null));
        req.setAttribute("kichCos", kcService.findAll(null));
        req.setAttribute("deGiays", dgService.findAll(null));
        req.setAttribute("keyword", keyword);
        req.setAttribute("mauSacId", mauSacId);
        req.setAttribute("kichCoId", kichCoId);
        req.setAttribute("deGiayId", deGiayId);
        req.setAttribute("trangThai", tt);
        req.setAttribute("sanPhamId", sanPhamId);
        req.setAttribute("giaMin", gMinStr);
        req.setAttribute("giaMax", gMaxStr);
        req.getRequestDispatcher("/WEB-INF/QL_SanPham/chi-tiet.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, SanPhamChiTiet spct)
            throws ServletException, IOException {
        req.setAttribute("spct", spct);
        req.setAttribute("sanPhams", spService.findAll(null, null, null, 1));
        req.setAttribute("mauSacs", msService.findAll(null));
        req.setAttribute("kichCos", kcService.findAll(null));
        req.setAttribute("deGiays", dgService.findAll(null));
        req.getRequestDispatcher("/WEB-INF/QL_SanPham/form-chi-tiet.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr    = req.getParameter("id");
        Long sanPhamId  = Long.parseLong(req.getParameter("sanPhamId"));
        Long mauSacId   = Long.parseLong(req.getParameter("mauSacId"));
        Long kichCoId   = Long.parseLong(req.getParameter("kichCoId"));
        Long deGiayId   = Long.parseLong(req.getParameter("deGiayId"));
        BigDecimal giaGoc = new BigDecimal(req.getParameter("giaGoc"));
        BigDecimal giaBan = new BigDecimal(req.getParameter("giaBan"));
        int soLuongTon  = Integer.parseInt(req.getParameter("soLuongTon"));
        int trangThai   = Integer.parseInt(req.getParameter("trangThai") != null
                            ? req.getParameter("trangThai") : "1");

        SanPham sp = spService.findById(sanPhamId);
        MauSac  ms = msService.findById(mauSacId);
        KichCo  kc = kcService.findById(kichCoId);
        DeGiay  dg = dgService.findById(deGiayId);

        boolean isEdit = (idStr != null && !idStr.isEmpty());
        Long id = isEdit ? Long.parseLong(idStr) : null;

        Part fileAnh = null;
        try {
            fileAnh = req.getPart("fileAnh");
        } catch (Exception ignored) {}
        String uploadedUrl = cloudinaryService.uploadImage(fileAnh, "runmax/san-pham", req);
        String anhFromForm = req.getParameter("anhDaiDien");
        String currentAnh  = (uploadedUrl != null) ? uploadedUrl : (anhFromForm != null && !anhFromForm.trim().isEmpty() ? anhFromForm.trim() : null);

        if (giaGoc.compareTo(BigDecimal.ZERO) < 0 || giaBan.compareTo(BigDecimal.ZERO) < 0) {
            req.setAttribute("errorMessage", "Giá gốc và giá bán không được là số âm!");
            SanPhamChiTiet spctTmp = SanPhamChiTiet.builder().anhDaiDien(currentAnh).id(id).sanPham(sp).mauSac(ms).kichCo(kc).deGiay(dg).giaGoc(giaGoc).giaBan(giaBan).soLuongTon(soLuongTon).trangThai(trangThai).build();
            showForm(req, resp, spctTmp);
            return;
        }

        if (soLuongTon < 0) {
            req.setAttribute("errorMessage", "Số lượng tồn kho không được là số âm!");
            SanPhamChiTiet spctTmp = SanPhamChiTiet.builder().anhDaiDien(currentAnh).id(id).sanPham(sp).mauSac(ms).kichCo(kc).deGiay(dg).giaGoc(giaGoc).giaBan(giaBan).soLuongTon(soLuongTon).trangThai(trangThai).build();
            showForm(req, resp, spctTmp);
            return;
        }

        // Check duplicate variant combination
        List<SanPhamChiTiet> list = spctService.findAll(null, null, null, null, null, null, null);
        for (SanPhamChiTiet item : list) {
            if (isEdit && id != null && id.equals(item.getId())) continue;
            if (item.getSanPham() != null && item.getSanPham().getId().equals(sanPhamId) &&
                item.getMauSac() != null && item.getMauSac().getId().equals(mauSacId) &&
                item.getKichCo() != null && item.getKichCo().getId().equals(kichCoId) &&
                item.getDeGiay() != null && item.getDeGiay().getId().equals(deGiayId)) {
                req.setAttribute("errorMessage", "Biến thể (Sản phẩm + Màu sắc + Kích cỡ + Đế giày) này đã tồn tại, không được tạo trùng!");
                SanPhamChiTiet spctTmp = SanPhamChiTiet.builder().anhDaiDien(currentAnh).id(id).sanPham(sp).mauSac(ms).kichCo(kc).deGiay(dg).giaGoc(giaGoc).giaBan(giaBan).soLuongTon(soLuongTon).trangThai(trangThai).build();
                showForm(req, resp, spctTmp);
                return;
            }
        }

        if (isEdit && id != null) {
            SanPhamChiTiet spct = spctService.findById(id);
            if (currentAnh != null) {
                spct.setAnhDaiDien(currentAnh);
            }
            spct.setSanPham(sp); spct.setMauSac(ms); spct.setKichCo(kc); spct.setDeGiay(dg);
            spct.setGiaGoc(giaGoc); spct.setGiaBan(giaBan);
            spct.setSoLuongTon(soLuongTon); spct.setTrangThai(trangThai);
            spctService.update(spct);
        } else {
            SanPhamChiTiet spct = SanPhamChiTiet.builder()
                .anhDaiDien(currentAnh)
                .sanPham(sp).mauSac(ms).kichCo(kc).deGiay(dg)
                .giaGoc(giaGoc).giaBan(giaBan)
                .soLuongTon(soLuongTon).trangThai(trangThai).build();
            spctService.save(spct);
        }
        req.getSession().setAttribute("successMessage", isEdit ? "Cập nhật biến thể thành công!" : "Thêm mới biến thể thành công!");
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet");
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        spctService.toggleStatus(id);
        String spIdStr = req.getParameter("sanPhamId");
        if (spIdStr != null && !spIdStr.isEmpty() && !"null".equals(spIdStr)) {
            resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet?sanPhamId=" + spIdStr);
        } else {
            resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet");
        }
    }

    private Long parseId(String s) {
        return (s != null && !s.isEmpty()) ? Long.parseLong(s) : null;
    }
}
