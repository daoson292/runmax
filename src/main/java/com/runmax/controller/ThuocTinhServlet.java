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

/**
 * ThuocTinhServlet – quản lý tất cả thuộc tính sản phẩm:
 * Thương hiệu, Chất liệu, Màu sắc, Kích cỡ, Đế giày.
 * URL pattern: /thuoc-tinh?loai=thuong-hieu|chat-lieu|mau-sac|kich-co|de-giay
 */
@WebServlet("/thuoc-tinh")
public class ThuocTinhServlet extends HttpServlet {

    private final ThuongHieuService thService = new ThuongHieuService();
    private final ChatLieuService   clService = new ChatLieuService();
    private final MauSacService     msService = new MauSacService();
    private final KichCoService     kcService = new KichCoService();
    private final DeGiayService     dgService = new DeGiayService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String loai   = req.getParameter("loai");
        String action = req.getParameter("action");
        if (loai == null) loai = "thuong-hieu";
        if (action == null) action = "list";

        req.setAttribute("loaiHienTai", loai);
        req.setAttribute("tenLoai", getTenLoai(loai));

        String success = (String) req.getSession().getAttribute("successMessage");
        if (success != null) {
            req.setAttribute("successMessage", success);
            req.getSession().removeAttribute("successMessage");
        }

        switch (action) {
            case "edit" -> {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("editItem", findById(loai, id));
                req.setAttribute("action", "edit");
            }
            case "delete" -> {
                handleDelete(req, resp, loai);
                return;
            }
            case "toggle" -> {
                handleToggle(req, resp, loai);
                return;
            }
            default -> req.setAttribute("action", "list");
        }

        loadList(req, loai, req.getParameter("keyword"));
        req.getRequestDispatcher("/WEB-INF/thuocTinh/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String loai   = req.getParameter("loai");
        String action = req.getParameter("action");
        if (loai == null) loai = "thuong-hieu";

        switch (action != null ? action : "") {
            case "save"   -> handleSave(req, resp, loai);
            case "toggle" -> handleToggle(req, resp, loai);
            case "delete" -> handleDelete(req, resp, loai);
            default       -> resp.sendRedirect(req.getContextPath() + "/thuoc-tinh?loai=" + loai);
        }
    }

    private void loadList(HttpServletRequest req, String loai, String keyword) {
        switch (loai) {
            case "thuong-hieu" -> req.setAttribute("items", thService.findAll(keyword, null));
            case "chat-lieu"   -> req.setAttribute("items", clService.findAll(keyword));
            case "mau-sac"     -> req.setAttribute("items", msService.findAll(keyword));
            case "kich-co"     -> req.setAttribute("items", kcService.findAll(keyword));
            case "de-giay"     -> req.setAttribute("items", dgService.findAll(keyword));
        }
    }

    private Object findById(String loai, Long id) {
        return switch (loai) {
            case "thuong-hieu" -> thService.findById(id);
            case "chat-lieu"   -> clService.findById(id);
            case "mau-sac"     -> msService.findById(id);
            case "kich-co"     -> kcService.findById(id);
            case "de-giay"     -> dgService.findById(id);
            default            -> null;
        };
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp, String loai) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String ten   = req.getParameter("ten");
        String ma    = req.getParameter("ma");
        int tt = Integer.parseInt(req.getParameter("trangThai") != null ? req.getParameter("trangThai") : "1");

        boolean isEdit = (idStr != null && !idStr.isEmpty());
        Long id = isEdit ? Long.parseLong(idStr) : null;

        // Validate empty/blank
        if (ten == null || ten.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Tên thuộc tính không được để trống!");
            doGet(req, resp);
            return;
        }

        if ("kich-co".equals(loai)) {
            try {
                int sizeVal = Integer.parseInt(ten.trim());
                if (sizeVal < 15 || sizeVal > 60) {
                    if ("true".equals(req.getParameter("ajax"))) {
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.getWriter().write("{\"success\":false, \"message\": \"Kích cỡ giày không hợp lệ (vui lòng nhập số từ 15 đến 60)!\"}");
                        return;
                    }
                    req.setAttribute("errorMessage", "Kích cỡ giày không hợp lệ (vui lòng nhập số từ 15 đến 60)!");
                    doGet(req, resp);
                    return;
                }
            } catch (NumberFormatException ex) {
                if ("true".equals(req.getParameter("ajax"))) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"success\":false, \"message\": \"Kích cỡ giày phải là số nguyên thực tế (từ 15 đến 60)!\"}");
                    return;
                }
                req.setAttribute("errorMessage", "Kích cỡ giày phải là số nguyên thực tế (từ 15 đến 60)!");
                doGet(req, resp);
                return;
            }
        }

        String prefix = switch (loai) {
            case "thuong-hieu" -> "TH";
            case "chat-lieu"   -> "CL";
            case "mau-sac"     -> "MS";
            case "kich-co"     -> "KC";
            case "de-giay"     -> "DG";
            default            -> "TT";
        };
        if (ma == null || ma.trim().isEmpty()) {
            ma = prefix + String.format("%04d", (int)(System.currentTimeMillis() % 10000));
        } else {
            ma = ma.trim().toUpperCase();
        }

        // Check duplicate ten/ma across existing items
        List<?> list = switch (loai) {
            case "thuong-hieu" -> thService.findAll(null, null);
            case "chat-lieu"   -> clService.findAll(null);
            case "mau-sac"     -> msService.findAll(null);
            case "kich-co"     -> kcService.findAll(null);
            case "de-giay"     -> dgService.findAll(null);
            default -> List.of();
        };
        for (Object obj : list) {
            Long objId = null; String objTen = null; String objMa = null;
            if (obj instanceof ThuongHieu t) { objId = t.getId(); objTen = t.getTen(); objMa = t.getMa(); }
            else if (obj instanceof ChatLieu t) { objId = t.getId(); objTen = t.getTen(); objMa = t.getMa(); }
            else if (obj instanceof MauSac t) { objId = t.getId(); objTen = t.getTen(); objMa = t.getMa(); }
            else if (obj instanceof KichCo t) { objId = t.getId(); objTen = t.getTen(); objMa = t.getMa(); }
            else if (obj instanceof DeGiay t) { objId = t.getId(); objTen = t.getTen(); objMa = t.getMa(); }
            if (isEdit && id != null && id.equals(objId)) continue;
            if (objTen != null && objTen.equalsIgnoreCase(ten.trim())) {
                if ("true".equals(req.getParameter("ajax"))) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"success\":false, \"message\": \"Tên thuộc tính '" + ten.trim() + "' đã tồn tại, không được trùng!\"}");
                    return;
                }
                req.setAttribute("errorMessage", "Tên thuộc tính '" + ten.trim() + "' đã tồn tại, không được trùng!");
                doGet(req, resp);
                return;
            }
            if (objMa != null && objMa.equalsIgnoreCase(ma.trim())) {
                if ("true".equals(req.getParameter("ajax"))) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{\"success\":false, \"message\": \"Mã thuộc tính '" + ma.trim() + "' đã tồn tại, không được trùng!\"}");
                    return;
                }
                req.setAttribute("errorMessage", "Mã thuộc tính '" + ma.trim() + "' đã tồn tại, không được trùng!");
                doGet(req, resp);
                return;
            }
        }

        switch (loai) {
            case "thuong-hieu" -> {
                if (isEdit) {
                    ThuongHieu e = thService.findById(id);
                    e.setTen(ten.trim()); e.setTrangThai(tt); e.setMa(ma); thService.update(e);
                } else {
                    ThuongHieu e = ThuongHieu.builder().ten(ten.trim()).trangThai(tt).build();
                    e.setMa(ma);
                    thService.save(e);
                }
            }
            case "chat-lieu" -> {
                if (isEdit) {
                    ChatLieu e = clService.findById(id);
                    e.setTen(ten.trim()); e.setTrangThai(tt); e.setMa(ma); clService.update(e);
                } else {
                    ChatLieu e = ChatLieu.builder().ten(ten.trim()).trangThai(tt).build();
                    e.setMa(ma);
                    clService.save(e);
                }
            }
            case "mau-sac" -> {
                if (isEdit) {
                    MauSac e = msService.findById(id);
                    e.setTen(ten.trim()); e.setTrangThai(tt); e.setMa(ma); msService.update(e);
                } else {
                    MauSac e = MauSac.builder().ten(ten.trim()).trangThai(tt).build();
                    e.setMa(ma);
                    msService.save(e);
                }
            }
            case "kich-co" -> {
                if (isEdit) {
                    KichCo e = kcService.findById(id);
                    e.setTen(ten.trim()); e.setTrangThai(tt); e.setMa(ma); kcService.update(e);
                } else {
                    KichCo e = KichCo.builder().ten(ten.trim()).trangThai(tt).build();
                    e.setMa(ma);
                    kcService.save(e);
                }
            }
            case "de-giay" -> {
                if (isEdit) {
                    DeGiay e = dgService.findById(id);
                    e.setTen(ten.trim()); e.setTrangThai(tt); e.setMa(ma); dgService.update(e);
                } else {
                    DeGiay e = DeGiay.builder().ten(ten.trim()).trangThai(tt).ma(ma).build();
                    dgService.save(e);
                }
            }
        }
        if ("true".equals(req.getParameter("ajax")) || "XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            resp.setContentType("application/json;charset=UTF-8");
            Long savedId = null; String savedTen = ten.trim();
            List<?> listAfter = switch (loai) {
                case "thuong-hieu" -> thService.findAll(savedTen, null);
                case "chat-lieu"   -> clService.findAll(savedTen);
                case "mau-sac"     -> msService.findAll(savedTen);
                case "kich-co"     -> kcService.findAll(savedTen);
                case "de-giay"     -> dgService.findAll(savedTen);
                default -> List.of();
            };
            for (Object obj : listAfter) {
                if (obj instanceof ThuongHieu t && t.getTen().equalsIgnoreCase(savedTen)) { savedId = t.getId(); break; }
                else if (obj instanceof ChatLieu t && t.getTen().equalsIgnoreCase(savedTen)) { savedId = t.getId(); break; }
                else if (obj instanceof MauSac t && t.getTen().equalsIgnoreCase(savedTen)) { savedId = t.getId(); break; }
                else if (obj instanceof KichCo t && t.getTen().equalsIgnoreCase(savedTen)) { savedId = t.getId(); break; }
                else if (obj instanceof DeGiay t && t.getTen().equalsIgnoreCase(savedTen)) { savedId = t.getId(); break; }
            }
            resp.getWriter().write("{\"success\":true, \"id\": " + savedId + ", \"ten\": \"" + savedTen + "\", \"loai\": \"" + loai + "\"}");
            return;
        }
        req.getSession().setAttribute("successMessage", isEdit ? "Cập nhật thành công!" : "Thêm mới thành công!");
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh?loai=" + loai);
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp, String loai) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        switch (loai) {
            case "thuong-hieu" -> thService.toggleStatus(id);
            case "chat-lieu"   -> clService.toggleStatus(id);
            case "mau-sac"     -> msService.toggleStatus(id);
            case "kich-co"     -> kcService.toggleStatus(id);
            case "de-giay"     -> dgService.toggleStatus(id);
        }
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh?loai=" + loai);
    }

    private String getTenLoai(String loai) {
        return switch (loai) {
            case "thuong-hieu" -> "Thương hiệu";
            case "chat-lieu"   -> "Chất liệu";
            case "mau-sac"     -> "Màu sắc";
            case "kich-co"     -> "Kích cỡ";
            case "de-giay"     -> "Đế giày";
            default            -> loai;
        };
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, String loai) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        switch (loai) {
            case "thuong-hieu" -> thService.delete(id);
            case "chat-lieu"   -> clService.delete(id);
            case "mau-sac"     -> msService.delete(id);
            case "kich-co"     -> kcService.delete(id);
            case "de-giay"     -> dgService.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh?loai=" + loai);
    }
}
