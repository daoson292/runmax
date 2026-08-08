package com.runmax.controller;

import com.runmax.service.ThongKeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@WebServlet("/thong-ke")
public class ThongKeServlet extends HttpServlet {

    private final ThongKeService tkService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tnStr  = req.getParameter("tuNgay");
        String dnStr  = req.getParameter("denNgay");

        LocalDate today = LocalDate.now();
        LocalDateTime tuNgay  = (tnStr != null && !tnStr.isEmpty())
            ? LocalDate.parse(tnStr).atStartOfDay()
            : today.withDayOfMonth(1).atStartOfDay();
        LocalDateTime denNgay = (dnStr != null && !dnStr.isEmpty())
            ? LocalDate.parse(dnStr).atTime(23, 59, 59)
            : today.atTime(23, 59, 59);

        req.setAttribute("tongDonHang",     tkService.tongDonHang(tuNgay, denNgay));
        req.setAttribute("tongDoanhThu",    tkService.tongDoanhThu(tuNgay, denNgay));
        req.setAttribute("doanhThuHomNay",  tkService.doanhThuHomNay());
        req.setAttribute("doanhThuTuanNay", tkService.doanhThuTuanNay());
        req.setAttribute("doanhThuThangNay",tkService.doanhThuThangNay());
        req.setAttribute("doanhThuNamNay",  tkService.doanhThuNamNay());
        req.setAttribute("chartData",       tkService.doanhThuTheoNgay(tuNgay, denNgay));
        req.setAttribute("topSanPham",      tkService.topSanPham(5, tuNgay, denNgay));
        req.setAttribute("tuNgay", tnStr != null ? tnStr : today.withDayOfMonth(1).toString());
        req.setAttribute("denNgay", dnStr != null ? dnStr : today.toString());
        req.getRequestDispatcher("/WEB-INF/thongKe/index.jsp").forward(req, resp);
    }
}
