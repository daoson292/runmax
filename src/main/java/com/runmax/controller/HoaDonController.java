package com.runmax.controller;

import com.runmax.entity.HoaDon;
import com.runmax.service.HoaDonService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "HoaDonController", urlPatterns = {
        "/admin/hoa-don",
        "/admin/hoa-don/create",
        "/admin/hoa-don/update-status",
        "/admin/hoa-don/delete"
})
public class HoaDonController extends HttpServlet {
    private final HoaDonService service = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String statusStr = req.getParameter("trangThai");
        Integer st = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try { st = Integer.parseInt(statusStr); } catch (Exception ignored) {}
        }

        List<HoaDon> danhSach = service.getAll(keyword, st);
        req.setAttribute("danhSachHoaDon", danhSach);
        req.setAttribute("keyword", keyword);
        req.setAttribute("trangThai", st);

        req.getRequestDispatcher("/hoa-don/danh-sach.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getServletPath();

        switch (action) {
            case "/admin/hoa-don/create": {
                String maHd = req.getParameter("maHd");
                if (maHd == null || maHd.trim().isEmpty()) {
                    maHd = new com.runmax.repository.HoaDonRepository().getNextMaHd();
                }
                String tenKhachHang = req.getParameter("tenKhachHang"); // giữ lại để ghi chú nếu cần
                BigDecimal tongTien = BigDecimal.ZERO;
                try {
                    tongTien = new BigDecimal(req.getParameter("tongTien"));
                } catch (Exception ignored) {}
                String ghiChu = req.getParameter("ghiChu");
                // Ghi chú thêm tên khách nếu có (vì không có field riêng nữa)
                if (tenKhachHang != null && !tenKhachHang.trim().isEmpty()) {
                    ghiChu = (ghiChu != null && !ghiChu.trim().isEmpty())
                        ? "Khách: " + tenKhachHang + " - " + ghiChu
                        : "Khách: " + tenKhachHang;
                }

                service.create(maHd, tongTien, ghiChu);
                break;
            }
            case "/admin/hoa-don/update-status": {
                Long id = Long.parseLong(req.getParameter("id"));
                Integer trangThai = Integer.parseInt(req.getParameter("trangThai"));
                service.updateStatus(id, trangThai);
                break;
            }
            case "/admin/hoa-don/delete": {
                Long id = Long.parseLong(req.getParameter("id"));
                service.deleteHoaDon(id);
                break;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/hoa-don");
    }
}
