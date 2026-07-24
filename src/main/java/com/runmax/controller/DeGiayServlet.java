package com.runmax.controller;

import com.runmax.entity.DeGiay;
import com.runmax.service.DeGiayService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DeGiayServlet", urlPatterns = {
        "/admin/de-giay",
        "/admin/de-giay/store",
        "/admin/de-giay/update",
        "/admin/de-giay/toggle-status"
})
public class DeGiayServlet extends HttpServlet {
    private final DeGiayService service = new DeGiayService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<DeGiay> danhSach = service.getAll(keyword);

        req.setAttribute("danhSachDeGiay", danhSach);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/san-pham/co-giay.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getServletPath();

        switch (action) {
            case "/admin/de-giay/store": {
                String ten = req.getParameter("ten");
                service.create(ten);
                break;
            }
            case "/admin/de-giay/update": {
                Long id = Long.parseLong(req.getParameter("id"));
                String ten = req.getParameter("ten");
                Integer trangThai = Integer.parseInt(req.getParameter("trangThai"));
                service.update(id, ten, trangThai);
                break;
            }
            case "/admin/de-giay/toggle-status": {
                Long id = Long.parseLong(req.getParameter("id"));
                service.toggleStatus(id);
                break;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/de-giay");
    }
}
