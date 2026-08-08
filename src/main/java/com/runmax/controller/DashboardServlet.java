package com.runmax.controller;

import com.runmax.service.ThongKeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

// Dashboard Controller / Servlet (Xử lý dữ liệu Trang chủ & Biểu đồ).
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ThongKeService thongKeService = new ThongKeService();
    private final com.runmax.service.ThuongHieuService thuongHieuService = new com.runmax.service.ThuongHieuService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String tnStr = req.getParameter("tuNgay");
            String dnStr = req.getParameter("denNgay");

            LocalDate today = LocalDate.now();
            LocalDateTime tuNgay = (tnStr != null && !tnStr.isEmpty())
                    ? LocalDate.parse(tnStr).atStartOfDay()
                    : today.withDayOfMonth(1).atStartOfDay();
            LocalDateTime denNgay = (dnStr != null && !dnStr.isEmpty())
                    ? LocalDate.parse(dnStr).atTime(23, 59, 59)
                    : today.atTime(23, 59, 59);

            // Dữ liệu biểu đồ doanh thu theo ngày
            Map<String, BigDecimal> chartMap = thongKeService.doanhThuTheoNgay(tuNgay, denNgay);
            if (chartMap == null || chartMap.isEmpty()) {
                chartMap = new java.util.LinkedHashMap<>();
                chartMap.put(today.toString(), BigDecimal.ZERO);
            }
            StringBuilder labelsJson = new StringBuilder("[");
            StringBuilder valuesJson = new StringBuilder("[");
            int i = 0;
            for (Map.Entry<String, BigDecimal> entry : chartMap.entrySet()) {
                if (i++ > 0) {
                    labelsJson.append(",");
                    valuesJson.append(",");
                }
                labelsJson.append("\"").append(entry.getKey()).append("\"");
                valuesJson.append(entry.getValue() != null ? entry.getValue() : BigDecimal.ZERO);
            }
            labelsJson.append("]");
            valuesJson.append("]");

            req.setAttribute("chartLabels", labelsJson.toString());
            req.setAttribute("chartValues", valuesJson.toString());

            // Các KPI động theo khoảng thời gian lọc
            BigDecimal tongDoanhThu = thongKeService.tongDoanhThu(tuNgay, denNgay);
            long tongDonHang = thongKeService.tongDonHang(tuNgay, denNgay);
            
            long pieHoanTat = thongKeService.demDonTheoTrangThai(1, tuNgay, denNgay);
            long pieCho = thongKeService.demDonTheoTrangThai(0, tuNgay, denNgay);
            long pieHuy = thongKeService.demDonTheoTrangThai(2, tuNgay, denNgay);
            
            long tongDon = pieHoanTat + pieCho + pieHuy;
            long tyLeHoanThanh = tongDon > 0 ? (pieHoanTat * 100 / tongDon) : 0;

            List<Object[]> sanPhamDaBan = thongKeService.sanPhamDaBanTrongKy(tuNgay, denNgay);
            long tongSanPhamBan = 0;
            for (Object[] row : sanPhamDaBan) {
                if (row[1] instanceof Number num) {
                    tongSanPhamBan += num.longValue();
                }
            }

            req.setAttribute("doanhThuKy", tongDoanhThu);
            req.setAttribute("tongDonHang", tongDonHang);
            req.setAttribute("tongSanPhamBan", tongSanPhamBan);
            req.setAttribute("tyLeHoanThanh", tyLeHoanThanh);

            req.setAttribute("pieHoanTat", pieHoanTat);
            req.setAttribute("pieCho", pieCho);
            req.setAttribute("pieHuy", pieHuy);

            // Tổng tồn kho (không phụ thuộc ngày)
            long tongTonKho = thongKeService.tongSoLuongTonKho();
            req.setAttribute("tongTonKho", tongTonKho);

            // Lấy Top 5 giày chạy bộ bán chạy theo kỳ
            req.setAttribute("topSanPham", thongKeService.topSanPham(5, tuNgay, denNgay));

            // Sản phẩm đã bán trong kỳ
            req.setAttribute("sanPhamDaBanHnay", sanPhamDaBan); // Giữ nguyên tên attribute để JSP không lỗi nếu chưa sửa hết

            // Thống kê Bán chậm & Tồn kho
            req.setAttribute("banChamVaTonKho", thongKeService.thongKeBanChamVaTonKho());

            req.setAttribute("tuNgay", tnStr != null ? tnStr : today.withDayOfMonth(1).toString());
            req.setAttribute("denNgay", dnStr != null ? dnStr : today.toString());

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("chartLabels", "[]");
            req.setAttribute("chartValues", "[]");
        }
        req.getRequestDispatcher("/WEB-INF/trangChu/index.jsp").forward(req, resp);
    }
}

