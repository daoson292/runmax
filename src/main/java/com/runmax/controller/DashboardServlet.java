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
    private final com.runmax.service.ThuongHieuService thuongHieuService = new com.runmax.service.ThuongHieuService();

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

            // Tổng doanh thu toàn bộ / hôm nay / tuần / tháng / năm
            BigDecimal dtHnay = thongKeService.doanhThuHomNay();
            BigDecimal dtTuan = thongKeService.doanhThuTuanNay();
            BigDecimal dtThang = thongKeService.doanhThuThangNay();
            BigDecimal dtNam = thongKeService.doanhThuNamNay();
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
            // Lấy doanh thu các kỳ
            BigDecimal doanhThuHnay = thongKeService.doanhThuHomNay();
            BigDecimal doanhThuHomQua = thongKeService.doanhThuHomQua();
            
            BigDecimal doanhThuTuanNay = thongKeService.doanhThuTuanNay();
            BigDecimal doanhThuTuanTruoc = thongKeService.doanhThuTuanTruoc();
            
            BigDecimal doanhThuThangNay = thongKeService.doanhThuThangNay();
            BigDecimal doanhThuThangTruoc = thongKeService.doanhThuThangTruoc();
            
            BigDecimal doanhThuNamNay = thongKeService.doanhThuNamNay();
            BigDecimal doanhThuNamTruoc = thongKeService.doanhThuNamTruoc();

            req.setAttribute("doanhThuHnay", doanhThuHnay);
            req.setAttribute("doanhThuTuanNay", doanhThuTuanNay);
            req.setAttribute("doanhThuThangNay", doanhThuThangNay);
            req.setAttribute("doanhThuNamNay", doanhThuNamNay);
            
            // Tính toán % tăng trưởng
            req.setAttribute("growthHnay", calculateGrowth(doanhThuHnay, doanhThuHomQua));
            req.setAttribute("growthTuan", calculateGrowth(doanhThuTuanNay, doanhThuTuanTruoc));
            req.setAttribute("growthThang", calculateGrowth(doanhThuThangNay, doanhThuThangTruoc));
            req.setAttribute("growthNam", calculateGrowth(doanhThuNamNay, doanhThuNamTruoc));
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

            // Tổng tồn kho
            long tongTonKho = thongKeService.tongSoLuongTonKho();
            req.setAttribute("tongTonKho", tongTonKho);

            // Lấy Top 5 giày chạy bộ bán chạy thật từ DB
            req.setAttribute("topSanPham", thongKeService.topSanPham(5));

            // Lấy danh sách hãng giày
            req.setAttribute("danhSachThuongHieu", thuongHieuService.findAll(null));

            // Sản phẩm đã bán hôm nay
            req.setAttribute("sanPhamDaBanHnay", thongKeService.sanPhamDaBanHomNay());

            // Thống kê Bán chậm & Tồn kho -> Kho sản phẩm
            req.setAttribute("banChamVaTonKho", thongKeService.thongKeBanChamVaTonKho());
        } catch (Exception e) {
            e.printStackTrace();
            String todayStr = java.time.LocalDate.now().toString();
            req.setAttribute("doanhThuHomNay", BigDecimal.ZERO);
            req.setAttribute("doanhThuHnay", BigDecimal.ZERO);
            req.setAttribute("doanhThuTuanNay", BigDecimal.ZERO);
            req.setAttribute("doanhThuThangNay", BigDecimal.ZERO);
            req.setAttribute("doanhThuNamNay", BigDecimal.ZERO);
            req.setAttribute("tongDonHomNay", 0L);
            req.setAttribute("soDonHnay", 0L);
            req.setAttribute("chartLabels", "[\"" + todayStr + "\"]");
            req.setAttribute("chartValues", "[0]");
            req.setAttribute("pieHoanTat", 0L);
            req.setAttribute("pieCho", 0L);
            req.setAttribute("pieHuy", 0L);
            req.setAttribute("tongTonKho", 0L);
        }
        req.getRequestDispatcher("/WEB-INF/trangChu/index.jsp").forward(req, resp);
    }

    private double calculateGrowth(BigDecimal current, BigDecimal previous) {
        if (previous == null || previous.compareTo(BigDecimal.ZERO) == 0) {
            if (current != null && current.compareTo(BigDecimal.ZERO) > 0) {
                return 100.0;
            }
            return 0.0;
        }
        if (current == null) {
            current = BigDecimal.ZERO;
        }
        
        double currDouble = current.doubleValue();
        double prevDouble = previous.doubleValue();
        
        return ((currDouble - prevDouble) / prevDouble) * 100.0;
    }
}
