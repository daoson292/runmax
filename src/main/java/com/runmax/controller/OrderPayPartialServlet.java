package com.runmax.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.runmax.repository.HoaDonRepository;
import com.runmax.repository.LichSuThanhToanRepository;
import com.runmax.entity.HoaDon;
import com.runmax.entity.LichSuThanhToan;
import com.runmax.entity.PhuongThucThanhToan;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/order/pay-partial")
public class OrderPayPartialServlet extends HttpServlet {

    private HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private LichSuThanhToanRepository lsttRepo = new LichSuThanhToanRepository();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        
        try {
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            String hdId = json.has("hdId") ? json.get("hdId").getAsString() : "";
            BigDecimal soTien = json.has("soTien") ? json.get("soTien").getAsBigDecimal() : BigDecimal.ZERO;
            Long phuongThuc = json.has("phuongThuc") ? json.get("phuongThuc").getAsLong() : 1L; // 1: Tiền mặt
            
            HoaDon hd = hoaDonRepo.findByMaHd(hdId);
            if (hd != null && soTien.compareTo(BigDecimal.ZERO) > 0) {
                LichSuThanhToan ls = new LichSuThanhToan();
                ls.setHoaDon(hd);
                
                PhuongThucThanhToan pt = new PhuongThucThanhToan();
                pt.setId(phuongThuc);
                ls.setPhuongThucThanhToan(pt);
                
                ls.setSoTien(soTien);
                ls.setNoiDungCk(phuongThuc == 1L ? "Thanh toan tien mat" : "Thanh toan khac");
                ls.setNgayThanhToan(LocalDateTime.now());
                ls.setTrangThai(1);
                
                lsttRepo.save(ls);
                
                BigDecimal tongDaTra = lsttRepo.tinhTongTienDaTra(hd.getId());
                BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;
                
                if (tongDaTra.compareTo(tongTien) >= 0) {
                    hd.setTrangThai(1); // 1: Đã hoàn thành
                } else {
                    hd.setTrangThai(3); // 3: Thanh toán thiếu
                }
                hoaDonRepo.update(hd);
                
                BigDecimal conNo = tongTien.subtract(tongDaTra);
                if (conNo.compareTo(BigDecimal.ZERO) < 0) {
                    conNo = BigDecimal.ZERO;
                }
                
                result.put("da_tra", tongDaTra);
                result.put("con_no", conNo);
                result.put("success", true);
            } else {
                result.put("success", false);
                result.put("message", "Invalid invoice or amount");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
}
