package com.runmax.controller;

import com.runmax.entity.ChatLieu;
import com.runmax.service.ChatLieuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ChatLieuServlet", urlPatterns = {
        "/admin/chat-lieu",
        "/admin/chat-lieu/store",
        "/admin/chat-lieu/update",
        "/admin/chat-lieu/toggle-status"
})
public class ChatLieuServlet extends HttpServlet {
    private final ChatLieuService service = new ChatLieuService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<ChatLieu> danhSach = service.getAll(keyword);

        req.setAttribute("danhSachChatLieu", danhSach);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/san-pham/chat-lieu.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getServletPath();

        switch (action) {
            case "/admin/chat-lieu/store": {
                String ten = req.getParameter("ten");
                service.create(ten);
                break;
            }
            case "/admin/chat-lieu/update": {
                Long id = Long.parseLong(req.getParameter("id"));
                String ten = req.getParameter("ten");
                Integer trangThai = Integer.parseInt(req.getParameter("trangThai"));
                service.update(id, ten, trangThai);
                break;
            }
            case "/admin/chat-lieu/toggle-status": {
                Long id = Long.parseLong(req.getParameter("id"));
                service.toggleStatus(id);
                break;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/chat-lieu");
    }
}
