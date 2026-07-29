package com.runmax.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// Trang Chủ Servlet - Hiển thị bảng Thao Tác Nhanh.
// Đây là trang mặc định sau khi đăng nhập (không có dữ liệu thống kê).
// Nhân viên (NHAN_VIEN) sẽ được redirect về /ban-hang bởi LoginServlet.
@WebServlet("/trang-chu")
public class TrangChuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Không cần truy vấn DB, chỉ render trang Quick Actions
        req.getRequestDispatcher("/WEB-INF/trangChu/home.jsp").forward(req, resp);
    }
}
