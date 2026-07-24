package com.runmax.controller;

import com.runmax.service.ThongKeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

// Dashboard Controller / Servlet (Xử lý dữ liệu Trang chủ & Biểu đồ).
// Keyword search GG: "Jakarta HttpServlet request.setAttribute", "Servlet forward to JSP"
// Nhiệm vụ: Lấy số liệu từ ThongKeService đóng gói thành JSON & biến để đẩy sang trang index.jsp vẽ Biểu đồ Chart.js và KPI Cards.
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ThongKeService thongKeService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Bộ lọc thời gian cho biểu đồ: 7days, 30days, all
            String filter = req.getParameter("filter");
            if (filter == null || filter.isEmpty()) {
                filter = "all"; // Mặc định hiển thị toàn bộ để biểu đồ phong phú
            }

            java.time.LocalDateTime tuNgay = null;
            java.time.LocalDateTime denNgay = java.time.LocalDateTime.now();

            if ("7days".equals(filter)) {
                tuNgay = java.time.LocalDate.now().minusDays(6).atStartOfDay();
            } else if ("30days".equals(filter)) {
                tuNgay = java.time.LocalDate.now().minusDays(29).atStartOfDay();
            }

            // Tổng doanh thu toàn bộ / hôm nay
            BigDecimal dtHnay = thongKeService.doanhThuHomNay();
            BigDecimal dtThang = thongKeService.doanhThuThangNay();
            long tongDonHoanTat = thongKeService.tongDonHang(null, null);

            // Dữ liệu biểu đồ doanh thu theo ngày
            java.util.Map<String, BigDecimal> chartMap = thongKeService.doanhThuTheoNgay(tuNgay, denNgay);
            if (chartMap == null || chartMap.isEmpty()) {
                chartMap = new java.util.LinkedHashMap<>();
                chartMap.put(java.time.LocalDate.now().toString(), dtHnay != null ? dtHnay : BigDecimal.ZERO);
            }
            StringBuilder labelsJson = new StringBuilder("[");
            StringBuilder valuesJson = new StringBuilder("[");
            int i = 0;
            for (java.util.Map.Entry<String, BigDecimal> entry : chartMap.entrySet()) {
                if (i++ > 0) {
                    labelsJson.append(",");
                    valuesJson.append(",");
                }
                labelsJson.append("\"").append(entry.getKey()).append("\"");
                valuesJson.append(entry.getValue() != null ? entry.getValue() : BigDecimal.ZERO);
            }
            labelsJson.append("]");
            valuesJson.append("]");

            // Đặt các attribute khớp 100% với JSP
            req.setAttribute("doanhThuHomNay", dtHnay);
            req.setAttribute("doanhThuHnay", dtHnay);
            req.setAttribute("doanhThuThangNay", dtThang);
            req.setAttribute("tongDonHomNay", tongDonHoanTat);
            req.setAttribute("soDonHnay", tongDonHoanTat);
            req.setAttribute("chartLabels", labelsJson.toString());
            req.setAttribute("chartValues", valuesJson.toString());
            req.setAttribute("currentFilter", filter);

            // Thống kê phân bổ trạng thái đơn hàng cho biểu đồ tròn
            long pieHoanTat = thongKeService.demDonTheoTrangThai(1);
            long pieCho = thongKeService.demDonTheoTrangThai(0);
            long pieHuy = thongKeService.demDonTheoTrangThai(2);
            req.setAttribute("pieHoanTat", pieHoanTat);
            req.setAttribute("pieCho", pieCho);
            req.setAttribute("pieHuy", pieHuy);

            // Lấy Top 5 giày chạy bộ bán chạy thật từ DB
            req.setAttribute("topSanPham", thongKeService.topSanPham(5));
        } catch (Exception e) {
            e.printStackTrace();
            String todayStr = java.time.LocalDate.now().toString();
            req.setAttribute("doanhThuHomNay", BigDecimal.ZERO);
            req.setAttribute("doanhThuHnay", BigDecimal.ZERO);
            req.setAttribute("doanhThuThangNay", BigDecimal.ZERO);
            req.setAttribute("tongDonHomNay", 0L);
            req.setAttribute("soDonHnay", 0L);
            req.setAttribute("chartLabels", "[\"" + todayStr + "\"]");
            req.setAttribute("chartValues", "[0]");
            req.setAttribute("pieHoanTat", 0L);
            req.setAttribute("pieCho", 0L);
            req.setAttribute("pieHuy", 0L);
        }
        req.getRequestDispatcher("/WEB-INF/trangChu/index.jsp").forward(req, resp);
    }
}
