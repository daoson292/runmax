package com.runmax.controller;

import com.google.gson.Gson;
import com.runmax.entity.KhachHang;
import com.runmax.service.KhachHangService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet({"/api/customers/search", "/api/customers/add"})
public class CustomerApiServlet extends HttpServlet {
    private KhachHangService khachHangService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        khachHangService = new KhachHangService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (uri.endsWith("/api/customers/search")) {
            String term = req.getParameter("term");
            if (term == null) term = req.getParameter("kw");
            if (term == null) term = "";
            
            // Search active customers
            List<KhachHang> list = khachHangService.findAll(term, 1);
            
            // Format for Select2 and Custom Autosuggest
            List<Map<String, String>> results = list.stream().map(kh -> {
                Map<String, String> map = new HashMap<>();
                map.put("id", String.valueOf(kh.getId()));
                map.put("text", kh.getHoTen() + " - " + kh.getSdt());
                map.put("hoTen", kh.getHoTen());
                map.put("sdt", kh.getSdt());
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("results", results);
            out.print(gson.toJson(responseMap));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (uri.endsWith("/api/customers/add")) {
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");

            Map<String, Object> responseMap = new HashMap<>();

            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                responseMap.put("success", false);
                responseMap.put("message", "Vui lòng nhập đầy đủ tên và số điện thoại");
                out.print(gson.toJson(responseMap));
                return;
            }

            KhachHang existing = khachHangService.findBySdt(phone.trim());
            if (existing != null) {
                responseMap.put("success", false);
                responseMap.put("message", "Số điện thoại đã tồn tại!");
                out.print(gson.toJson(responseMap));
                return;
            }

            KhachHang kh = new KhachHang();
            kh.setHoTen(name.trim());
            kh.setSdt(phone.trim());
            kh.setMaKh(khachHangService.getNextMaKh());
            kh.setTrangThai(1); // Active

            boolean success = khachHangService.save(kh);
            if (success) {
                // Fetch again to get ID
                KhachHang savedKh = khachHangService.findBySdt(phone.trim());
                responseMap.put("success", true);
                responseMap.put("id", savedKh.getId());
                responseMap.put("text", savedKh.getHoTen() + " - " + savedKh.getSdt());
            } else {
                responseMap.put("success", false);
                responseMap.put("message", "Không thể lưu khách hàng");
            }
            out.print(gson.toJson(responseMap));
        }
    }
}
