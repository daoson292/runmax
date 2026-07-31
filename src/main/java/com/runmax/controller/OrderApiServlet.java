package com.runmax.controller;

import com.google.gson.Gson;
import com.runmax.repository.HoaDonRepository;
import com.runmax.repository.LichSuThanhToanRepository;
import com.runmax.entity.HoaDon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/order/check-status")
public class OrderApiServlet extends HttpServlet {

    private HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private LichSuThanhToanRepository lsttRepo = new LichSuThanhToanRepository();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String orderCode = request.getParameter("orderCode");
        System.out.println("[OrderApiServlet] Frontend đang kiểm tra trạng thái thanh toán. OrderCode: " + orderCode);
        Map<String, Object> result = new HashMap<>();
        
        if (orderCode != null && !orderCode.isEmpty()) {
            HoaDon hd = hoaDonRepo.findByMaHd(orderCode);
            if (hd != null) {
                BigDecimal tongDaTra = lsttRepo.tinhTongTienDaTra(hd.getId());
                if (tongDaTra == null) {
                    tongDaTra = BigDecimal.ZERO;
                }
                BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;
                if (tongTien.compareTo(BigDecimal.ZERO) == 0 && hd.getTrangThai() == 0) {
                    java.util.List<com.runmax.entity.HoaDonChiTiet> chiTiets = hoaDonRepo.findChiTietByHoaDonId(hd.getId());
                    if (chiTiets != null) {
                        for (com.runmax.entity.HoaDonChiTiet ct : chiTiets) {
                            tongTien = tongTien.add(ct.getThanhTien() != null ? ct.getThanhTien() : BigDecimal.ZERO);
                        }
                    }
                    if (hd.getPhieuGiamGia() != null) {
                        BigDecimal giam = hd.getPhieuGiamGia().getGiaTrigiam();
                        if (hd.getPhieuGiamGia().getLoaiGiam() != null && hd.getPhieuGiamGia().getLoaiGiam() == 1) {
                            giam = tongTien.multiply(giam).divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
                            if (hd.getPhieuGiamGia().getGiamToiDa() != null && giam.compareTo(hd.getPhieuGiamGia().getGiamToiDa()) > 0) {
                                giam = hd.getPhieuGiamGia().getGiamToiDa();
                            }
                        }
                        tongTien = tongTien.subtract(giam);
                    }
                    if (tongTien.compareTo(BigDecimal.ZERO) < 0) tongTien = BigDecimal.ZERO;
                }
                BigDecimal conNo = tongTien.subtract(tongDaTra);
                if (conNo.compareTo(BigDecimal.ZERO) < 0) {
                    conNo = BigDecimal.ZERO;
                }
                
                result.put("da_tra", tongDaTra);
                result.put("con_no", conNo);

                if (hd.getTrangThai() == 1 || conNo.compareTo(BigDecimal.ZERO) == 0) {
                    result.put("status", "PAID");
                } else if (hd.getTrangThai() == 3 || tongDaTra.compareTo(BigDecimal.ZERO) > 0) {
                    result.put("status", "THIEU");
                } else {
                    result.put("status", "PENDING");
                }
            } else {
                result.put("status", "ERROR");
            }
        } else {
            result.put("status", "ERROR");
            System.out.println("[OrderApiServlet] Lỗi: orderCode trống hoặc null");
        }
        
        System.out.println("API Polling - HD: " + orderCode + " | Da tra: " + result.get("da_tra") + " | Con no: " + result.get("con_no"));
        
        response.getWriter().write(gson.toJson(result));
    }
}
