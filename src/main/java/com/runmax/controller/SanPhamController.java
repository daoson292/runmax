package com.runmax.controller;

import com.runmax.entity.*;
import com.runmax.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/san-pham")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 5242880,
        maxRequestSize    = 20971520
)
public class SanPhamController extends HttpServlet {

    private final SanPhamService    spService  = new SanPhamService();
    private final ThuongHieuService thService  = new ThuongHieuService();
    private final ChatLieuService   clService  = new ChatLieuService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggleStatus" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                spService.toggleStatus(id);
                req.getSession().setAttribute("toastSuccess", "Đổi trạng thái sản phẩm thành công!");
                resp.sendRedirect(req.getContextPath() + "/san-pham");
            }
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                SanPham sp = spService.findById(id);
                showForm(req, resp, sp);
            }
            case "addForm" -> {
                showForm(req, resp, new SanPham());
            }
            default -> showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action != null ? action : "") {
            case "add"    -> handleAdd(req, resp);
            case "save"   -> handleSave(req, resp);
            case "toggle" -> handleToggle(req, resp);
            default       -> resp.sendRedirect(req.getContextPath() + "/san-pham");
        }
    }

    private Long parseId(String str) {
        if (str == null || str.trim().isEmpty()) return null;
        try { return Long.parseLong(str.trim()); } catch (Exception e) { return null; }
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        Long thId = parseId(req.getParameter("thuongHieuId"));
        Long clId = parseId(req.getParameter("chatLieuId"));
        String ttStr = req.getParameter("trangThai");
        Integer tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : null;

        List<SanPham> sanPhams = spService.findAll(keyword, thId, clId, tt);
        req.setAttribute("danhSachSanPham", sanPhams);
        req.setAttribute("thuongHieus", thService.findAll(null, null));
        req.setAttribute("chatLieus", clService.findAll(null));
        req.setAttribute("keyword", keyword);
        req.setAttribute("thuongHieuId", thId);
        req.setAttribute("chatLieuId", clId);
        req.setAttribute("trangThai", tt);
        req.getRequestDispatcher("/WEB-INF/QL_SanPham/san-pham.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, SanPham sp)
            throws ServletException, IOException {
        req.setAttribute("sanPham", sp);
        req.setAttribute("thuongHieus", thService.findAll(null, null));
        req.setAttribute("chatLieus", clService.findAll(null));
        req.setAttribute("mauSacs", new MauSacService().findAll(null));
        req.setAttribute("kichCos", new KichCoService().findAll(null));
        req.setAttribute("deGiays", new DeGiayService().findAll(null));
        if (sp != null && sp.getId() != null) {
            req.setAttribute("existingVariants", new SanPhamChiTietService().findAll(null, null, null, null, null, null, null, sp.getId()));
        }
        req.getRequestDispatcher("/WEB-INF/QL_SanPham/form.jsp").forward(req, resp);
    }

    /** Xử lý thêm mới từ modal (POST action=add) */
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tenSp = req.getParameter("tenSp");
        String maSp  = req.getParameter("maSp");
        String moTa  = req.getParameter("moTa");
        String thIdStr = req.getParameter("thuongHieuId");
        String clIdStr = req.getParameter("chatLieuId");

        // Validate
        String errorMsg = null;
        if (maSp == null || maSp.trim().isEmpty()) {
            maSp = spService.getNextMaSp();
        } else {
            maSp = maSp.trim().toUpperCase();
        }

        if (tenSp == null || tenSp.trim().isEmpty()) {
            errorMsg = "Tên sản phẩm không được để trống.";
        } else if (thIdStr == null || thIdStr.isEmpty()) {
            errorMsg = "Vui lòng chọn thương hiệu.";
        } else if (clIdStr == null || clIdStr.isEmpty()) {
            errorMsg = "Vui lòng chọn chất liệu.";
        } else if (spService.isMaSPExists(maSp)) {
            errorMsg = "Mã sản phẩm '" + maSp + "' đã tồn tại trong hệ thống.";
        } else if (spService.isTenSPExists(tenSp.trim())) {
            errorMsg = "Tên sản phẩm '" + tenSp + "' đã tồn tại trong hệ thống.";
        }

        if (errorMsg != null) {
            List<SanPham> sanPhams = spService.findAll(null, null, null, null);
            req.setAttribute("danhSachSanPham", sanPhams);
            req.setAttribute("thuongHieus", thService.findAll(null, null));
            req.setAttribute("chatLieus", clService.findAll(null));
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/WEB-INF/QL_SanPham/san-pham.jsp").forward(req, resp);
            return;
        }

        Long thId = Long.parseLong(thIdStr);
        Long clId = Long.parseLong(clIdStr);
        ThuongHieu th = thService.findById(thId);
        ChatLieu   cl = clService.findById(clId);
        SanPham sp = SanPham.builder()
            .maSp(maSp).tenSp(tenSp.trim()).moTa(moTa)
            .thuongHieu(th).chatLieu(cl).trangThai(1).build();
        spService.save(sp);
        req.getSession().setAttribute("toastSuccess", "Thêm sản phẩm '" + tenSp.trim() + "' thành công!");
        resp.sendRedirect(req.getContextPath() + "/san-pham");
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr     = req.getParameter("id");
        String tenSp     = req.getParameter("tenSp");
        String maSp      = req.getParameter("maSp");
        String moTa      = req.getParameter("moTa");
        Long   thId      = Long.parseLong(req.getParameter("thuongHieuId"));
        Long   clId      = Long.parseLong(req.getParameter("chatLieuId"));
        int    trangThai = Integer.parseInt(req.getParameter("trangThai") != null
                            ? req.getParameter("trangThai") : "1");

        ThuongHieu th = thService.findById(thId);
        ChatLieu   cl = clService.findById(clId);

        boolean isEdit = (idStr != null && !idStr.isEmpty());
        Long id = isEdit ? Long.parseLong(idStr) : null;

        if (tenSp == null || tenSp.trim().isEmpty()) {
            req.setAttribute("error", "Tên sản phẩm không được để trống.");
            SanPham spTmp = SanPham.builder().id(id).maSp(maSp).tenSp(tenSp).moTa(moTa).thuongHieu(th).chatLieu(cl).trangThai(trangThai).build();
            showForm(req, resp, spTmp);
            return;
        }

        if (maSp == null || maSp.trim().isEmpty()) {
            maSp = spService.getNextMaSp();
        } else {
            maSp = maSp.trim().toUpperCase();
        }

        // Check duplicates
        List<SanPham> list = spService.findAll(null, null, null, null);
        for (SanPham item : list) {
            if (isEdit && id != null && id.equals(item.getId())) continue;
            if (item.getMaSp() != null && item.getMaSp().equalsIgnoreCase(maSp)) {
                req.setAttribute("error", "Mã sản phẩm '" + maSp + "' đã tồn tại trong hệ thống.");
                SanPham spTmp = SanPham.builder().id(id).maSp(maSp).tenSp(tenSp).moTa(moTa).thuongHieu(th).chatLieu(cl).trangThai(trangThai).build();
                showForm(req, resp, spTmp);
                return;
            }
            if (item.getTenSp() != null && item.getTenSp().equalsIgnoreCase(tenSp.trim())) {
                req.setAttribute("error", "Tên sản phẩm '" + tenSp.trim() + "' đã tồn tại trong hệ thống.");
                SanPham spTmp = SanPham.builder().id(id).maSp(maSp).tenSp(tenSp).moTa(moTa).thuongHieu(th).chatLieu(cl).trangThai(trangThai).build();
                showForm(req, resp, spTmp);
                return;
            }
        }

        SanPham savedSp;
        if (isEdit && id != null) {
            SanPham sp = spService.findById(id);
            sp.setTenSp(tenSp.trim()); sp.setMaSp(maSp); sp.setMoTa(moTa);
            sp.setThuongHieu(th); sp.setChatLieu(cl); sp.setTrangThai(trangThai);
            spService.update(sp);
            savedSp = sp;
        } else {
            SanPham sp = SanPham.builder()
                .maSp(maSp).tenSp(tenSp.trim()).moTa(moTa)
                .thuongHieu(th).chatLieu(cl).trangThai(1).build();
            spService.save(sp);
            savedSp = sp;
        }

        // Save generated variants if sent from form
        String[] variantMauSacIds = req.getParameterValues("variantMauSacId");
        String[] variantKichCoIds = req.getParameterValues("variantKichCoId");
        String[] variantDeGiayIds = req.getParameterValues("variantDeGiayId");
        String[] variantSoLuongs  = req.getParameterValues("variantSoLuong");
        String[] variantGiaBans   = req.getParameterValues("variantGiaBan");

        int variantSavedCount = 0;
        if (variantMauSacIds != null && variantMauSacIds.length > 0) {
            SanPhamChiTietService spctService = new SanPhamChiTietService();
            MauSacService msSvc = new MauSacService();
            KichCoService kcSvc = new KichCoService();
            DeGiayService dgSvc = new DeGiayService();
            com.runmax.service.CloudinaryService cloudinaryService = new com.runmax.service.CloudinaryService();

            java.util.Map<Long, String> uploadedColorUrls = new java.util.HashMap<>();
            // Pre-upload unique color images
            for (String msIdStr : variantMauSacIds) {
                if (msIdStr != null && !msIdStr.trim().isEmpty()) {
                    Long msId = null;
                    try {
                        msId = Long.parseLong(msIdStr.trim());
                    } catch (Exception ignored) {}
                    
                    if (msId != null && !uploadedColorUrls.containsKey(msId)) {
                        jakarta.servlet.http.Part filePart = null;
                        try {
                            filePart = req.getPart("fileAnh_color_" + msId);
                        } catch (Exception ignored) {}
                        
                        try {
                            String url = cloudinaryService.uploadImage(filePart, "runmax/san-pham", req);
                            if (url == null) {
                                String oldUrl = req.getParameter("oldAnh_color_" + msId);
                                if (oldUrl != null && !oldUrl.trim().isEmpty()) {
                                    url = oldUrl.trim();
                                }
                            }
                            if (url != null) {
                                uploadedColorUrls.put(msId, url);
                            }
                        } catch (Exception e) {
                            req.setAttribute("error", e.getMessage());
                            SanPham spTmp = SanPham.builder().id(id).maSp(maSp).tenSp(tenSp).moTa(moTa).thuongHieu(th).chatLieu(cl).trangThai(trangThai).build();
                            showForm(req, resp, spTmp);
                            return;
                        }
                    }
                }
            }

            for (int i = 0; i < variantMauSacIds.length; i++) {
                try {
                    String msIdStr = variantMauSacIds[i] != null ? variantMauSacIds[i].trim() : "";
                    String kcIdStr = variantKichCoIds[i] != null ? variantKichCoIds[i].trim() : "";
                    String dgIdStr = variantDeGiayIds[i] != null ? variantDeGiayIds[i].trim() : "";
                    String slStr   = (variantSoLuongs != null && i < variantSoLuongs.length && variantSoLuongs[i] != null) ? variantSoLuongs[i].trim().replaceAll("[^0-9]", "") : "0";
                    String giaStr  = (variantGiaBans != null && i < variantGiaBans.length && variantGiaBans[i] != null) ? variantGiaBans[i].trim().replaceAll("[^0-9.]", "") : "0";

                    if (msIdStr.isEmpty() || kcIdStr.isEmpty() || dgIdStr.isEmpty()) continue;

                    Long msId = Long.parseLong(msIdStr);
                    Long kcId = Long.parseLong(kcIdStr);
                    Long dgId = Long.parseLong(dgIdStr);
                    int sl    = slStr.isEmpty() ? 0 : Integer.parseInt(slStr);
                    BigDecimal gia = giaStr.isEmpty() ? BigDecimal.ZERO : new BigDecimal(giaStr);

                    String variantImgUrl = uploadedColorUrls.get(msId);

                    // Check if variant already exists for this product
                    boolean exists = false;
                    List<SanPhamChiTiet> existingList = spctService.findAll(null, msId, kcId, dgId, null, null, null, savedSp.getId());
                    if (existingList != null && !existingList.isEmpty()) {
                        for (SanPhamChiTiet ex : existingList) {
                            if (ex.getMauSac() != null && ex.getMauSac().getId().equals(msId) &&
                                ex.getKichCo() != null && ex.getKichCo().getId().equals(kcId) &&
                                ex.getDeGiay() != null && ex.getDeGiay().getId().equals(dgId)) {
                                exists = true;
                                ex.setSoLuongTon(sl);
                                ex.setGiaBan(gia);
                                ex.setGiaGoc(gia);
                                if (variantImgUrl != null) {
                                    ex.setAnhDaiDien(variantImgUrl);
                                }
                                if (spctService.update(ex)) {
                                    variantSavedCount++;
                                }
                                break;
                            }
                        }
                    }
                    if (!exists) {
                        SanPhamChiTiet newSpct = SanPhamChiTiet.builder()
                            .sanPham(savedSp)
                            .mauSac(msSvc.findById(msId))
                            .kichCo(kcSvc.findById(kcId))
                            .deGiay(dgSvc.findById(dgId))
                            .soLuongTon(sl)
                            .giaBan(gia)
                            .giaGoc(gia)
                            .anhDaiDien(variantImgUrl)
                            .trangThai(1)
                            .build();
                        if (spctService.save(newSpct)) {
                            variantSavedCount++;
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error saving variant index " + i + " for product ID " + savedSp.getId() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }

        String msg = (isEdit ? "Cập nhật" : "Thêm mới") + " sản phẩm thành công!";
        if (variantSavedCount > 0) {
            msg = (isEdit ? "Cập nhật" : "Thêm mới") + " sản phẩm & " + variantSavedCount + " biến thể thành công!";
        }
        req.getSession().setAttribute("toastSuccess", msg);
        resp.sendRedirect(req.getContextPath() + "/san-pham");
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        spService.toggleStatus(id);
        resp.sendRedirect(req.getContextPath() + "/san-pham");
    }
}
