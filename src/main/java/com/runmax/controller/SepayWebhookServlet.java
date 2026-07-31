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

@WebServlet("/api/webhook/sepay")
public class SepayWebhookServlet extends HttpServlet {

    private HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private LichSuThanhToanRepository lsttRepo = new LichSuThanhToanRepository();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        String VALID_API_KEY = "wertyghyjtrewrfhgje12345y6u";
        
        System.out.println("========== [SEPAY WEBHOOK] TÍN HIỆU MỚI ==========");
        System.out.println("[SepayWebhookServlet] Auth Header nhận được: " + authHeader);
        if (authHeader == null || !authHeader.contains(VALID_API_KEY)) {
            System.out.println("[SepayWebhookServlet] -> 401 Unauthorized (API Key KHÔNG KHỚP)");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }
        System.out.println("[SepayWebhookServlet] -> Xác thực API Key thành công");

        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        System.out.println("[SepayWebhookServlet] Payload JSON: " + sb.toString());
        try {
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            if (json == null) {
                System.out.println("[SepayWebhookServlet] -> Lỗi: Không parse được JSON từ body");
                return;
            }
            
            BigDecimal amount = json.has("transferAmount") && !json.get("transferAmount").isJsonNull() ? json.get("transferAmount").getAsBigDecimal() : BigDecimal.ZERO;
            String content = json.has("content") && !json.get("content").isJsonNull() ? json.get("content").getAsString() : "";
            
            System.out.println("[SepayWebhookServlet] Trích xuất: transferAmount = " + amount + " | content = '" + content + "'");
            
            String orderCode = "";
            java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("HD\\d+").matcher(content.toUpperCase());
            if (matcher.find()) {
                orderCode = matcher.group();
            }
            if (orderCode.isEmpty()) {
                orderCode = content.trim().toUpperCase();
            }
            
            System.out.println("[SepayWebhookServlet] Mã Hóa Đơn nhận diện được: " + orderCode);

            HoaDon hd = hoaDonRepo.findByMaHd(orderCode);
            if (hd == null) {
                System.out.println("[SepayWebhookServlet] -> Không tìm thấy hóa đơn mã: " + orderCode);
            } else {
                System.out.println("[SepayWebhookServlet] -> Tìm thấy hóa đơn ID " + hd.getId() + ". Trạng thái cũ: " + hd.getTrangThai());
            }
            
            if (hd != null && hd.getTrangThai() != 1 && hd.getTrangThai() != 2) {
                LichSuThanhToan ls = new LichSuThanhToan();
                ls.setHoaDon(hd);
                
                com.runmax.repository.PhuongThucThanhToanRepository ptRepo = new com.runmax.repository.PhuongThucThanhToanRepository();
                PhuongThucThanhToan pt = ptRepo.findById(2L);
                if (pt == null) {
                    pt = new PhuongThucThanhToan();
                    pt.setId(2L); // Fallback
                }
                ls.setPhuongThucThanhToan(pt);
                
                ls.setSoTien(amount);
                ls.setNoiDungCk(content);
                ls.setNgayThanhToan(LocalDateTime.now());
                ls.setTrangThai(1);
                
                lsttRepo.save(ls);
                
                BigDecimal tongDaTra = lsttRepo.tinhTongTienDaTra(hd.getId());
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
                    
                    // Cập nhật luôn vào DB để đồng bộ với Webhook
                    hd.setTongTien(tongTien);
                }
                if (tongDaTra.compareTo(tongTien) >= 0) {
                    hd.setTrangThai(1); // 1: Đã hoàn thành
                } else {
                    hd.setTrangThai(3); // 3: Thanh toán thiếu
                }
                hoaDonRepo.update(hd);
                
                System.out.println("[SepayWebhookServlet] -> CẬP NHẬT THÀNH CÔNG: Đã lưu LichSuThanhToan " + amount + ". Trạng thái HD mới: " + hd.getTrangThai());
            }
        } catch (Exception e) {
            System.err.println("[SepayWebhookServlet] -> LỖI NGOẠI LỆ TRONG WEBHOOK:");
            e.printStackTrace();
            System.err.println("Lỗi Webhook: " + e.getMessage());
        }
        
        response.setContentType("application/json");
        response.setStatus(200);
        response.getWriter().write("{\"success\":true}");
    }
}
