package com.runmax.controller;

import com.runmax.service.HoaDonService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalDate;

@WebServlet("/hoa-don")
public class HoaDonServlet extends HttpServlet {

    private final HoaDonService hdService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            showDetail(req, resp);
        } else if ("find-by-qr".equals(action)) {
            String code = req.getParameter("code");
            if (code != null && !code.trim().isEmpty()) {
                String cleanCode = code.replace("RUNMAX-HD:", "").replace("HD:", "").trim();
                com.runmax.entity.HoaDon hd = hdService.findByMaHd(cleanCode);
                if (hd == null) {
                    try {
                        hd = hdService.findById(Long.parseLong(cleanCode));
                    } catch (NumberFormatException ignored) {}
                }
                if (hd == null && !cleanCode.equals(code.trim())) {
                    hd = hdService.findByMaHd(code.trim());
                }
                if (hd != null) {
                    resp.sendRedirect(req.getContextPath() + "/hoa-don?action=detail&id=" + hd.getId());
                    return;
                }
                resp.sendRedirect(req.getContextPath() + "/hoa-don?error=qr-not-found&code=" + java.net.URLEncoder.encode(code, "UTF-8"));
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/hoa-don");
        } else {
            showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("huy".equals(action)) {
            Long hdId   = Long.parseLong(req.getParameter("id"));
            String lyDo = req.getParameter("lyDo");
            var nv = req.getSession().getAttribute("nhanVien");
            String nguoiThaoTac = nv != null
                ? ((com.runmax.entity.NhanVien) nv).getTenDangNhap()
                : "Quản lý";
            hdService.huyHoaDon(hdId, nguoiThaoTac, lyDo != null ? lyDo : "Hủy từ quản lý");
            resp.sendRedirect(req.getContextPath() + "/hoa-don?action=detail&id=" + hdId);
            return;
        } else if ("updateStatus".equals(action)) {
            Long hdId   = Long.parseLong(req.getParameter("id"));
            Integer status = Integer.parseInt(req.getParameter("status"));
            String ghiChu = req.getParameter("ghiChu");
            var nv = req.getSession().getAttribute("nhanVien");
            String nguoiThaoTac = nv != null
                ? ((com.runmax.entity.NhanVien) nv).getTenDangNhap()
                : "Quản lý";
            hdService.updateStatus(hdId, status, nguoiThaoTac, ghiChu);
            resp.sendRedirect(req.getContextPath() + "/hoa-don?action=detail&id=" + hdId);
            return;
        } else if ("them-sp".equals(action)) {
            Long hdId   = Long.parseLong(req.getParameter("hdId"));
            Long spctId = Long.parseLong(req.getParameter("spctId"));
            int soLuong = Integer.parseInt(req.getParameter("soLuong") != null ? req.getParameter("soLuong") : "1");
            hdService.themSanPham(hdId, spctId, soLuong);
            resp.sendRedirect(req.getContextPath() + "/hoa-don?action=detail&id=" + hdId);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/hoa-don");
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String maHd   = req.getParameter("maHd");
        String ttStr  = req.getParameter("trangThai");
        String tnStr  = req.getParameter("tuNgay");
        String dnStr  = req.getParameter("denNgay");

        // isFiltered = true khi người dùng đã chủ động gửi form bộ lọc
        boolean isFiltered = (maHd != null || ttStr != null || tnStr != null || dnStr != null);

        // Giá trị hiển thị trên input "Từ ngày" – luôn pre-fill ngày hôm nay nếu chưa nhập
        String tuNgayDisplay = (tnStr != null && !tnStr.isEmpty())
            ? tnStr
            : java.time.LocalDate.now().toString();

        // Chỉ truyền ngày vào query khi người dùng đã chủ động lọc
        Integer tt = (ttStr != null && !ttStr.isEmpty()) ? Integer.parseInt(ttStr) : null;
        LocalDateTime tuNgay  = (isFiltered && tnStr != null && !tnStr.isEmpty())
            ? LocalDate.parse(tnStr).atStartOfDay() : null;
        LocalDateTime denNgay = (dnStr != null && !dnStr.isEmpty())
            ? LocalDate.parse(dnStr).atTime(23, 59, 59) : null;

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

        Long totalRecords = hdService.countAll(maHd, tt, tuNgay, denNgay);
        int totalPages = (int) Math.ceil((double) totalRecords / size);

        var list = hdService.findAll(maHd, tt, tuNgay, denNgay, offset, size);
        
        req.setAttribute("hoaDons", list);
        req.setAttribute("danhSachHoaDon", list);
        req.setAttribute("maHd", maHd);
        req.setAttribute("trangThai", tt);
        req.setAttribute("tuNgay", tuNgayDisplay);   // pre-fill input luôn = hôm nay
        req.setAttribute("denNgay", dnStr);
        req.setAttribute("error", req.getParameter("error"));
        req.setAttribute("errorCode", req.getParameter("code"));
        
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        req.getRequestDispatcher("/WEB-INF/hoa-don/danh-sach.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        req.setAttribute("hoaDon", hdService.findById(id));
        req.setAttribute("chiTiets", hdService.findChiTiet(id));
        req.setAttribute("lichSuTT", hdService.findLichSuTT(id));
        req.setAttribute("lichSuHD", hdService.findLichSuHD(id));
        req.setAttribute("allSpct", new com.runmax.service.SanPhamChiTietService().findAll(null, null, null, null, null, null, null));
        req.getRequestDispatcher("/WEB-INF/hoa-don/chi-tiet.jsp").forward(req, resp);
    }
}
