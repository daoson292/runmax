package com.runmax.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Security Filter (Bộ lọc xác thực & phân quyền RBAC).
// Keyword search GG: "Jakarta WebFilter doFilter", "Role Based Access Control Servlet"
// Nhiệm vụ: Kiểm tra session đăng nhập trước mọi request. Chưa login -> chuyển hướng về /login. Staff truy cập URL Admin -> đẩy về Dashboard.
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo Filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();

        // 1. Danh sách các đường dẫn công khai (Whitelist) không cần đăng nhập
        boolean isPublicResource = path.startsWith("/assets/")
                || path.equals("/login")
                || path.equals("/login.jsp")
                || path.startsWith("/api/public");

        if (isPublicResource) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Kiểm tra trạng thái đăng nhập trong Session
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("nhanVien") != null);

        if (!isLoggedIn) {
            // Chưa đăng nhập -> Chuyển hướng ngay về trang Đăng nhập (/login)
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 3. Phân quyền theo Use Case: Kiểm tra các URL dành riêng cho Quản lý (Admin)
        String vaiTro = (String) session.getAttribute("vaiTro");
        boolean isAdmin = "ROLE_ADMIN".equals(vaiTro) || "ADMIN".equals(vaiTro);

        // Các đường dẫn chỉ Admin mới được phép truy cập
        boolean isAdminOnlyUrl = path.startsWith("/nhan-vien")
                || path.startsWith("/thuoc-tinh")
                || path.equals("/san-pham")
                || path.startsWith("/phieu-giam-gia")
                || path.equals("/dashboard")       // Thống kê Dashboard
                || path.startsWith("/thong-ke");   // Trang thống kê chi tiết

        if (isAdminOnlyUrl && !isAdmin) {
            // Nhân viên cố tình truy cập trang của Admin -> Chặn và chuyển về Trang Chủ kèm thông báo
            session.setAttribute("error", "Bạn đang đăng nhập với quyền Nhân viên, không có quyền truy cập chức năng Quản trị!");
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // 4. Hợp lệ -> Cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy Filter
    }
}
