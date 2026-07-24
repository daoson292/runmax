package com.runmax.controller;

import com.runmax.entity.NhanVien;
import com.runmax.service.NhanVienService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final NhanVienService nvService = new NhanVienService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Nếu đã login, redirect về dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("nhanVien") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tenDangNhap = req.getParameter("tenDangNhap");
        String matKhau     = req.getParameter("matKhau");

        NhanVien nv = nvService.authenticate(tenDangNhap, matKhau);
        if (nv != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("nhanVien", nv);
            session.setAttribute("tenNhanVien", nv.getHoTen());
            session.setAttribute("vaiTro", nv.getVaiTro().getMaVaiTro());
            session.setAttribute("toastSuccess", "Đăng nhập thành công! Chào mừng " + nv.getHoTen() + " quay trở lại hệ thống RunMax POS.");
            session.setMaxInactiveInterval(60 * 60); // 1 giờ
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác! Vui lòng kiểm tra lại tài khoản thành viên.");
            req.setAttribute("tenDangNhapCu", tenDangNhap);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
