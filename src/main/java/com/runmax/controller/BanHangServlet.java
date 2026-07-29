package com.runmax.controller;

import com.runmax.entity.*;
import com.runmax.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

// POS Controller / Servlet (Xử lý bán hàng tại quầy).
// Keyword search GG: "Jakarta HttpServlet doGet doPost action parameter", "Session Management Servlet"
// Nhiệm vụ: Xử lý tạo đơn chờ, thêm giày vào giỏ POS, áp mã voucher giảm giá, và thanh toán trừ kho tự động.
@WebServlet("/ban-hang")
public class BanHangServlet extends HttpServlet {

    private final HoaDonService         hdService   = new HoaDonService();
    private final SanPhamChiTietService spctService = new SanPhamChiTietService();
    private final PhieuGiamGiaService   pggService  = new PhieuGiamGiaService();
    private final KhachHangService      khService   = new KhachHangService();
    private final PhuongThucThanhToanRepository ptttRepo = new PhuongThucThanhToanRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        NhanVien nv = (NhanVien) session.getAttribute("nhanVien");
        if (nv == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if ("find-kh".equals(action)) {
            String sdt = req.getParameter("sdt");
            resp.setContentType("application/json;charset=UTF-8");
            if (sdt != null && !sdt.trim().isEmpty()) {
                com.runmax.entity.KhachHang kh = new com.runmax.repository.KhachHangRepository().findBySdt(sdt.trim());
                if (kh != null) {
                    resp.getWriter().write("{\"found\":true,\"id\":" + kh.getId() + ",\"hoTen\":\"" + kh.getHoTen().replace("\"", "\\\"") + "\"}");
                    return;
                }
            }
            resp.getWriter().write("{\"found\":false}");
            return;
        }
        if ("save-kh-ajax".equals(action)) {
            String hdIdStr = req.getParameter("hdId");
            if (hdIdStr != null && !hdIdStr.isEmpty()) {
                try {
                    saveCustomerInfoIfPresent(Long.parseLong(hdIdStr), req);
                } catch (Exception ignored) {}
            }
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":true}");
            return;
        }
        if ("thanhtoan".equals(action)) {
            showThanhToan(req, resp, nv);
            return;
        }

        // 1. Danh sách Hóa đơn chờ – Quản lý thấy tất cả, Nhân viên chỉ thấy đơn của mình
        boolean isQuanLy = nv.getVaiTro() != null && "ADMIN".equalsIgnoreCase(nv.getVaiTro().getMaVaiTro());
        List<HoaDon> pendingOrders = isQuanLy
                ? hdService.findAllPending()
                : hdService.findPendingByNhanVien(nv.getId());
        req.setAttribute("pendingOrders", pendingOrders);
        req.setAttribute("isQuanLy", isQuanLy);

        // 2. Xác định Hóa đơn hiện tại đang chọn
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) {
            hdIdStr = req.getParameter("hoaDonId");
        }
        HoaDon currentHd = null;
        if (hdIdStr != null && !hdIdStr.isEmpty()) {
            currentHd = hdService.findById(Long.parseLong(hdIdStr));
        } else if (!pendingOrders.isEmpty()) {
            currentHd = pendingOrders.get(0);
        }

        if (currentHd != null) {
            req.setAttribute("currentHd", currentHd);
            req.setAttribute("chiTiets", hdService.findChiTiet(currentHd.getId()));
        }

        req.setAttribute("phieuGiamGias", pggService.findActive());

        // 3. Tìm kiếm SKU Giày Chạy Bộ
        String kw = req.getParameter("kw");
        req.setAttribute("allSpct", spctService.findAll(kw, null, null, null, 1, null, null));

        // Thông báo
        String success = req.getParameter("success");
        if ("thanh-toan-thanh-cong".equals(success)) {
            req.setAttribute("message", "Thanh toán thành công đơn hàng!");
        }
        String error = req.getParameter("error");
        if ("sl-vuot-ton".equals(error)) {
            req.setAttribute("errorMessage", "Số lượng bạn chọn vượt quá số lượng tồn khohiện tại của sản phẩm!");
        } else if ("thanh-toan-that-bai".equals(error)) {
            req.setAttribute("errorMessage", "Thanh toán thất bại, vui lòng kiểm tra lại đơn hàng (hoặc giỏ hàng đang trống)!");
        } else if ("chua-co-sp".equals(error)) {
            req.setAttribute("errorMessage", "Đơn hàng chưa có sản phẩm nào để thanh toán hoặc áp dụng giảm giá!");
        } else if ("chua-chon-hd".equals(error)) {
            req.setAttribute("errorMessage", "Vui lòng chọn hoặc tạo hóa đơn chờ trước khi thực hiện thao tác!");
        } else if ("khong-du-dieu-kien".equals(error)) {
            req.setAttribute("errorMessage", "Đơn hàng chưa đủ điều kiện (tổng tiền chưa đạt tối thiểu) để áp dụng mã giảm giá này!");
        }

        req.getRequestDispatcher("/WEB-INF/ban_hang_tai_quay/pos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        NhanVien nv = (NhanVien) session.getAttribute("nhanVien");
        if (nv == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "";

        // Tự động cập nhật SĐT và Tên Khách Hàng nếu có trong form post trước khi thực hiện thao tác
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        if (hdIdStr != null && !hdIdStr.isEmpty()) {
            try {
                saveCustomerInfoIfPresent(Long.parseLong(hdIdStr), req);
            } catch (Exception ignored) {}
        }

        switch (action) {
            case "tao-don", "taoHoaDon"       -> handleTaoDon(req, resp, nv);
            case "them-sp", "themSanPham"     -> handleThemSP(req, resp);
            case "them-nhieu-sp"              -> handleThemNhieuSP(req, resp);
            case "cap-nhat-sl", "capNhatSoLuong" -> handleCapNhatSL(req, resp);
            case "xoa-sp", "xoaSanPham"       -> handleXoaSP(req, resp);
            case "ap-voucher", "apVoucher"    -> handleApVoucher(req, resp);
            case "ap-voucher-ajax", "apVoucherAjax" -> handleApVoucherAjax(req, resp);
            case "xoa-voucher-ajax", "xoaVoucherAjax" -> handleXoaVoucherAjax(req, resp);
            case "thanh-toan", "thanhToan"    -> handleThanhToan(req, resp, nv);
            case "huy-don", "huyDon"          -> handleHuyDon(req, resp, nv);
            case "xoa-don", "xoaHoaDon"       -> handleXoaDon(req, resp);
            default                           -> resp.sendRedirect(req.getContextPath() + "/ban-hang");
        }
    }

    private void handleTaoDon(HttpServletRequest req, HttpServletResponse resp, NhanVien nv)
            throws IOException {
        boolean isQuanLy = nv.getVaiTro() != null && "ADMIN".equalsIgnoreCase(nv.getVaiTro().getMaVaiTro());
        List<HoaDon> currentPending = isQuanLy ? hdService.findAllPending() : hdService.findPendingByNhanVien(nv.getId());
        if (currentPending != null && currentPending.size() >= 10) {
            String redirectUrl = req.getContextPath() + "/ban-hang?error=max-pending";
            if (!currentPending.isEmpty() && currentPending.get(0) != null) {
                redirectUrl += "&hdId=" + currentPending.get(0).getId();
            }
            resp.sendRedirect(redirectUrl);
            return;
        }

        HoaDon hd = hdService.taoHoaDon(nv);
        if (hd != null) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hd.getId());
        } else {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?error=tao-don-that-bai");
        }
    }

    private void handleThemSP(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr   = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId        = Long.parseLong(hdIdStr);
        Long spctId      = Long.parseLong(req.getParameter("spctId"));
        int soLuong      = Integer.parseInt(req.getParameter("soLuong") != null ? req.getParameter("soLuong") : "1");

        boolean ok = hdService.themSanPham(hdId, spctId, soLuong);
        if (!ok) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId + "&error=sl-vuot-ton");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId);
    }

    private void handleThemNhieuSP(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId = Long.parseLong(hdIdStr);

        String[] spctIdsStr = req.getParameterValues("spctIds[]");
        String[] soLuongsStr = req.getParameterValues("soLuongs[]");

        if (spctIdsStr != null && soLuongsStr != null && spctIdsStr.length == soLuongsStr.length) {
            java.util.List<Long> spctIds = new java.util.ArrayList<>();
            java.util.List<Integer> soLuongs = new java.util.ArrayList<>();
            for (int i = 0; i < spctIdsStr.length; i++) {
                spctIds.add(Long.parseLong(spctIdsStr[i]));
                soLuongs.add(Integer.parseInt(soLuongsStr[i]));
            }
            hdService.themNhieuSanPham(hdId, spctIds, soLuongs);
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId);
    }

    private void handleCapNhatSL(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr   = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId        = (hdIdStr != null && !hdIdStr.isEmpty()) ? Long.parseLong(hdIdStr) : null;

        String chiTietIdStr = req.getParameter("chiTietId");
        if (chiTietIdStr == null || chiTietIdStr.isEmpty()) chiTietIdStr = req.getParameter("cthdId");
        Long chiTietId   = Long.parseLong(chiTietIdStr);

        int soLuong = 1;
        try { soLuong = Integer.parseInt(req.getParameter("soLuong")); } catch (Exception e) {}

        boolean ok = hdService.capNhatSoLuong(chiTietId, soLuong);
        String redirectUrl = req.getContextPath() + "/ban-hang" + (hdId != null ? "?hdId=" + hdId : "");
        if (!ok && soLuong > 0) {
            redirectUrl += (hdId != null ? "&" : "?") + "error=sl-vuot-ton";
        }
        resp.sendRedirect(redirectUrl);
    }

    private void handleXoaSP(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr   = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId        = Long.parseLong(hdIdStr);

        String chiTietIdStr = req.getParameter("chiTietId");
        if (chiTietIdStr == null || chiTietIdStr.isEmpty()) chiTietIdStr = req.getParameter("cthdId");
        Long chiTietId   = Long.parseLong(chiTietIdStr);

        hdService.xoaSanPham(chiTietId);
        resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId);
    }

    private void handleApVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId = (hdIdStr != null && !hdIdStr.isEmpty()) ? Long.parseLong(hdIdStr) : null;
        if (hdId == null) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?error=chua-chon-hd");
            return;
        }

        String pggIdStr = req.getParameter("phieuGiamGiaId");
        Long pggId = (pggIdStr != null && !pggIdStr.isEmpty()) ? Long.parseLong(pggIdStr) : null;

        List<HoaDonChiTiet> chiTiets = hdService.findChiTiet(hdId);
        if (chiTiets.isEmpty() && pggId != null) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId + "&error=chua-co-sp");
            return;
        }

        boolean ok = hdService.apDungPhieuGiamGia(hdId, pggId);
        if (!ok && pggId != null) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId + "&error=khong-du-dieu-kien");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId);
    }

    private void handleApVoucherAjax(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        JsonObject responseJson = new JsonObject();

        try {
            Long hdId = Long.parseLong(req.getParameter("hdId"));
            String pggIdStr = req.getParameter("phieuGiamGiaId");
            Long pggId = (pggIdStr != null && !pggIdStr.trim().isEmpty()) ? Long.parseLong(pggIdStr) : null;

            if (pggId == null) {
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Mã giảm giá không hợp lệ!");
                resp.getWriter().write(new Gson().toJson(responseJson));
                return;
            }

            List<HoaDonChiTiet> chiTiets = hdService.findChiTiet(hdId);
            if (chiTiets.isEmpty()) {
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Đơn hàng chưa có sản phẩm nào để áp dụng giảm giá!");
                resp.getWriter().write(new Gson().toJson(responseJson));
                return;
            }

            boolean ok = hdService.apDungPhieuGiamGia(hdId, pggId);
            if (!ok) {
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Hóa đơn không đủ điều kiện hoặc voucher đã hết lượt/hết hạn!");
                resp.getWriter().write(new Gson().toJson(responseJson));
                return;
            }

            HoaDon hd = hdService.findById(hdId);
            responseJson.addProperty("status", "success");
            responseJson.addProperty("message", "Áp dụng voucher thành công!");
            
            JsonObject data = new JsonObject();
            data.addProperty("tienHang", hd.getTienHang());
            data.addProperty("soTienGiam", hd.getSoTienGiam());
            data.addProperty("tongTien", hd.getTongTien());
            
            if (hd.getPhieuGiamGia() != null) {
                data.addProperty("pggId", hd.getPhieuGiamGia().getId());
                data.addProperty("pggMa", hd.getPhieuGiamGia().getMaPhieu());
                data.addProperty("pggLoaiGiam", hd.getPhieuGiamGia().getLoaiGiam());
                data.addProperty("pggGiaTri", hd.getPhieuGiamGia().getGiaTrigiam());
                data.addProperty("pggDieuKien", hd.getPhieuGiamGia().getDieuKienGiam());
                if (hd.getPhieuGiamGia().getGiamToiDa() != null) {
                    data.addProperty("pggGiamToiDa", hd.getPhieuGiamGia().getGiamToiDa());
                }
            }
            
            responseJson.add("data", data);
            resp.getWriter().write(new Gson().toJson(responseJson));
            
        } catch (Exception e) {
            e.printStackTrace();
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Lỗi dữ liệu: " + e.getMessage());
            resp.getWriter().write(new Gson().toJson(responseJson));
        }
    }

    private void handleXoaVoucherAjax(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        JsonObject responseJson = new JsonObject();
        
        try {
            Long hdId = Long.parseLong(req.getParameter("hdId"));
            
            hdService.apDungPhieuGiamGia(hdId, -1L); 
            
            HoaDon hd = hdService.findById(hdId);
            responseJson.addProperty("status", "success");
            responseJson.addProperty("message", "Đã gỡ mã giảm giá!");
            
            JsonObject data = new JsonObject();
            data.addProperty("tienHang", hd.getTienHang());
            data.addProperty("soTienGiam", hd.getSoTienGiam());
            data.addProperty("tongTien", hd.getTongTien());
            
            responseJson.add("data", data);
            resp.getWriter().write(new Gson().toJson(responseJson));
            
        } catch (Exception e) {
            e.printStackTrace();
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Lỗi khi gỡ mã: " + e.getMessage());
            resp.getWriter().write(new Gson().toJson(responseJson));
        }
    }

    private void showThanhToan(HttpServletRequest req, HttpServletResponse resp, NhanVien nv)
            throws ServletException, IOException {
        Long hdId = Long.parseLong(req.getParameter("hdId"));
        HoaDon hd = hdService.findById(hdId);
        req.setAttribute("currentHd", hd);
        req.setAttribute("chiTiets", hdService.findChiTiet(hdId));
        req.setAttribute("phieuGiamGias", pggService.findActive());
        req.setAttribute("ptttList", ptttRepo.findAll());
        req.setAttribute("khachHangs", khService.findAll(null, 1));
        req.getRequestDispatcher("/WEB-INF/ban_hang_tai_quay/thanh-toan.jsp").forward(req, resp);
    }

    private void handleThanhToan(HttpServletRequest req, HttpServletResponse resp, NhanVien nv)
            throws IOException {
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId      = (hdIdStr != null && !hdIdStr.isEmpty()) ? Long.parseLong(hdIdStr) : null;
        if (hdId == null) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?error=chua-chon-hd");
            return;
        }

        List<HoaDonChiTiet> chiTiets = hdService.findChiTiet(hdId);
        if (chiTiets.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId + "&error=chua-co-sp");
            return;
        }

        String ptttIdStr = req.getParameter("ptttId");
        Long ptttId    = (ptttIdStr != null && !ptttIdStr.isEmpty()) ? Long.parseLong(ptttIdStr) : 1L;

        String pggIdStr = req.getParameter("phieuGiamGiaId");
        Long pggId      = (pggIdStr != null && !pggIdStr.isEmpty()) ? Long.parseLong(pggIdStr) : null;

        // Lấy khachHangId từ form (null = khách lẻ)
        String khIdStr = req.getParameter("khachHangId");
        Long khachHangId = (khIdStr != null && !khIdStr.isEmpty()) ? Long.parseLong(khIdStr) : null;

        PhuongThucThanhToan pttt = new PhuongThucThanhToanRepository().findById(ptttId);
        PhieuGiamGia pgg = (pggId != null) ? pggService.findById(pggId) : null;

        boolean ok = hdService.thanhToan(hdId, ptttId, pggId, khachHangId, pttt, pgg, nv.getTenDangNhap());
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?success=thanh-toan-thanh-cong&printHdId=" + hdId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/ban-hang?hdId=" + hdId + "&error=thanh-toan-that-bai");
        }
    }

    private void handleHuyDon(HttpServletRequest req, HttpServletResponse resp, NhanVien nv)
            throws IOException {
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId = Long.parseLong(hdIdStr);

        String lyDo = req.getParameter("lyDo");
        hdService.huyHoaDon(hdId, nv.getTenDangNhap(), lyDo != null ? lyDo : "Hủy tại quầy POS");
        resp.sendRedirect(req.getContextPath() + "/ban-hang");
    }

    private void handleXoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hdIdStr = req.getParameter("hdId");
        if (hdIdStr == null || hdIdStr.isEmpty()) hdIdStr = req.getParameter("hoaDonId");
        Long hdId = Long.parseLong(hdIdStr);
        hdService.deleteHoaDon(hdId);
        resp.sendRedirect(req.getContextPath() + "/ban-hang");
    }

    /**
     * Lưu Khách Hàng vào Hóa đơn qua FK.
     * Tìm KhachHang theo SĐT, nếu có thì gán vào hd.setKhachHang().
     * Nếu không có SĐT (khách lẻ) thì set null.
     */
    private void saveCustomerInfoIfPresent(Long hdId, HttpServletRequest req) {
        if (hdId == null) return;
        String sdt = req.getParameter("sdt");
        String khIdStr = req.getParameter("khachHangId");
        if (sdt == null && khIdStr == null) return;

        HoaDon hd = hdService.findById(hdId);
        if (hd == null) return;

        boolean changed = false;

        // Ưu tiên: nếu có khachHangId trực tiếp
        if (khIdStr != null && !khIdStr.trim().isEmpty()) {
            try {
                Long khId = Long.parseLong(khIdStr);
                KhachHang kh = new com.runmax.repository.KhachHangRepository().findById(khId);
                if (kh != null && !java.util.Objects.equals(
                        hd.getKhachHang() != null ? hd.getKhachHang().getId() : null, khId)) {
                    hd.setKhachHang(kh);
                    changed = true;
                }
            } catch (NumberFormatException ignored) {}
        } else if (sdt != null) {
            // Tìm theo SĐT
            String sdtClean = sdt.trim().isEmpty() ? null : sdt.trim();
            if (sdtClean != null) {
                KhachHang kh = new com.runmax.repository.KhachHangRepository().findBySdt(sdtClean);
                if (kh != null) {
                    Long currentKhId = hd.getKhachHang() != null ? hd.getKhachHang().getId() : null;
                    if (!java.util.Objects.equals(currentKhId, kh.getId())) {
                        hd.setKhachHang(kh);
                        changed = true;
                    }
                }
            } else if (hd.getKhachHang() != null) {
                hd.setKhachHang(null);
                changed = true;
            }
        }

        if (changed) {
            new com.runmax.repository.HoaDonRepository().update(hd);
        }
    }

    private static class PhuongThucThanhToanRepository extends com.runmax.repository.PhuongThucThanhToanRepository {}
}
