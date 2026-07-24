package com.runmax.controller;

import com.runmax.entity.ThuongHieu;
import com.runmax.service.ThuongHieuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet ThuongHieuServlet: Bộ điều khiển CRUD Thương hiệu
 * Dành cho người mới học:
 * - doGet(): Xử lý hiển thị danh sách và tìm kiếm (/admin/thuong-hieu)
 * - doPost(): Xử lý nhận form thêm mới, sửa, hoặc đổi trạng thái
 */
@WebServlet(name = "ThuongHieuServlet", urlPatterns = {
        "/admin/thuong-hieu",
        "/admin/thuong-hieu/store",
        "/admin/thuong-hieu/update",
        "/admin/thuong-hieu/toggle-status"
})
public class ThuongHieuServlet extends HttpServlet {
    private final ThuongHieuService service = new ThuongHieuService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<ThuongHieu> danhSach = service.getAll(keyword);

        req.setAttribute("danhSachThuongHieu", danhSach);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/san-pham/thuong-hieu/danh-sach.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getServletPath();

        switch (action) {
            case "/admin/thuong-hieu/store": {
                String ten = req.getParameter("ten");
                service.create(ten);
                break;
            }
            case "/admin/thuong-hieu/update": {
                Long id = Long.parseLong(req.getParameter("id"));
                String ten = req.getParameter("ten");
                Integer trangThai = Integer.parseInt(req.getParameter("trangThai"));
                service.update(id, ten, trangThai);
                break;
            }
            case "/admin/thuong-hieu/toggle-status": {
                Long id = Long.parseLong(req.getParameter("id"));
                service.toggleStatus(id);
                break;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/thuong-hieu");
    }
}
