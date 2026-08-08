<%-- 
  TRANG CHỦ DASHBOARD (/dashboard)
  - Keyword search GG: "JSTL fmt:formatNumber currency", "Chart.js Line & Doughnut Chart CDN"
  - Nhiệm vụ & Bố cục:
    1. 4 Thẻ KPI trên cùng: Nhận dữ liệu (${doanhThuHomNay}, ${tongDonHomNay}) từ DashboardServlet.
    2. Biểu đồ Đường Doanh Thu: Lấy chuỗi JSON (${chartLabels}, ${chartValues}) từ Servlet để render bằng Chart.js.
    3. Biểu đồ Tròn Trạng Thái Đơn Hàng: Lấy số lượng (${pieHoanTat}, ${pieCho}, ${pieHuy}) render tỷ lệ đơn hàng.
    4. Bảng Top Giày Bán Chạy: Duyệt danh sách ${topSanPham} hiển thị 5 mẫu giày hot nhất.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tổng quan Cửa hàng Giày Chạy Bộ Nam RunMax" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .quick-action-card {
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid transparent;
            background: #ffffff;
        }
        .quick-action-card:hover {
            transform: translateY(-5px);
            border-color: #fecaca;
            box-shadow: 0 10px 15px -3px rgba(220, 38, 38, 0.1), 0 4px 6px -2px rgba(220, 38, 38, 0.05) !important;
        }
        .quick-action-card:hover .icon-wrapper {
            background-color: #dc2626 !important;
            color: #ffffff !important;
            transform: scale(1.1);
        }
        .icon-wrapper {
            transition: all 0.3s ease;
        }
        /* Style cho bộ lọc và thẻ thống kê động */
        .filter-card {
            background-color: #ffffff;
            border: 0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .filter-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        .filter-title {
            font-weight: bold;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #333;
        }
        .quick-filters .btn {
            border-radius: 50rem;
            padding: 5px 15px;
            font-size: 0.85rem;
            margin-left: 5px;
            color: #6c757d;
            border-color: #dee2e6;
        }
        .quick-filters .btn.active, .quick-filters .btn:hover {
            background-color: #dc2626;
            color: #fff;
            border-color: #dc2626;
        }
        .stats-container {
            display: flex;
            background-color: #fff;
            border: 0;
            border-radius: 8px;
            margin-bottom: 24px;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .stat-box {
            flex: 1;
            padding: 20px;
            text-align: center;
            border-right: 1px solid #e2e8f0;
        }
        .stat-box:last-child {
            border-right: none;
        }
        .stat-title-sm {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 8px;
            text-transform: uppercase;
            font-weight: bold;
        }
        .stat-val {
            font-size: 1.8rem;
            font-weight: bold;
            color: #212529;
        }
        .stat-subtext {
            font-size: 0.75rem;
            color: #adb5bd;
            margin-top: 5px;
        }
        .progress-thin {
            height: 4px;
            margin-top: 10px;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <!-- Welcome Banner -->
                <div class="mb-4">
                    <div class="runmax-card p-4 mb-4 border-0 shadow-sm" style="background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%); border-left: 5px solid #dc2626 !important;">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <div>
                                <h4 class="fw-bold text-dark mb-1">Hệ Thống Quản Lý & POS Giày Chạy Bộ Nam RunMax 🏃‍♂️</h4>
                                <p class="text-muted mb-0">Chào mừng <b>${sessionScope.nhanVien != null ? sessionScope.nhanVien.hoTen : 'Quản trị viên'}</b>. Chuyên các dòng Marathon Pro, Ultra Boost & AeroGlide.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BỘ LỌC THỜI GIAN -->
                <div class="filter-card">
                    <div class="filter-header">
                        <div class="filter-title">
                            <i class="bi bi-funnel-fill text-danger"></i> Bộ lọc thống kê
                            <span class="fs-6 fw-normal text-muted ms-2" style="font-size: 0.8rem !important;">Dữ liệu bảng và biểu đồ bên dưới được tính toán theo bộ lọc này</span>
                        </div>
                        <div class="quick-filters">
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('today', this)">Hôm nay</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('week', this)">Tuần này</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('month', this)">Tháng này</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('year', this)">Năm nay</button>
                        </div>
                    </div>
                    <form id="filterForm" action="${pageContext.request.contextPath}/dashboard" method="get">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold small text-secondary mb-1">Từ ngày</label>
                                <input type="date" id="tuNgay" name="tuNgay" class="form-control" value="${tuNgay}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold small text-secondary mb-1">Đến ngày</label>
                                <input type="date" id="denNgay" name="denNgay" class="form-control" value="${denNgay}">
                            </div>
                            <div class="col-md-4 d-flex justify-content-end gap-2">
                                <button type="submit" class="btn btn-danger px-4">
                                    <i class="bi bi-search me-1"></i> Áp dụng
                                </button>
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i> Đặt lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Thẻ thống kê KPI (Động theo bộ lọc) -->
                <div class="stats-container">
                    <div class="stat-box">
                        <div class="stat-title-sm">Doanh thu</div>
                        <div class="stat-val text-danger">
                            <fmt:formatNumber value="${not empty doanhThuKy ? doanhThuKy : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </div>
                        <div class="stat-subtext">Đã ghi nhận trong kỳ</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-title-sm">Đơn hàng</div>
                        <div class="stat-val">${not empty tongDonHang ? tongDonHang : 0}</div>
                        <div class="stat-subtext">Đã thanh toán ${not empty pieHoanTat ? pieHoanTat : 0} - Hủy ${not empty pieHuy ? pieHuy : 0} - Chờ ${not empty pieCho ? pieCho : 0}</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-title-sm">Sản phẩm đã bán</div>
                        <div class="stat-val">${not empty tongSanPhamBan ? tongSanPhamBan : 0}</div>
                        <div class="stat-subtext">Items sold</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-title-sm">Tỷ lệ hoàn thành</div>
                        <div class="stat-val">${not empty tyLeHoanThanh ? tyLeHoanThanh : 0}%</div>
                        <div class="progress progress-thin">
                            <div class="progress-bar bg-danger" role="progressbar" style="width: ${not empty tyLeHoanThanh ? tyLeHoanThanh : 0}%" aria-valuenow="${not empty tyLeHoanThanh ? tyLeHoanThanh : 0}" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    </div>
                </div>

                <!-- BIỂU ĐỒ DOANH THU & BỘ LỌC THỜI GIAN -->
                <div class="runmax-card p-4 mb-4 border-0 shadow-sm" style="background: #ffffff;">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 pb-2 border-bottom">
                        <div>
                            <h6 class="fw-bold text-dark mb-1">
                                <i class="bi bi-bar-chart-line-fill text-danger me-1"></i> BIỂU ĐỒ DOANH THU BÁN GIÀY TRONG KỲ
                            </h6>
                            <span class="text-muted small">Phân tích xu hướng doanh số bán hàng tự động từ cơ sở dữ liệu</span>
                        </div>
                    </div>
                    <div style="position: relative; height: 320px; width: 100%;">
                        <canvas id="runmaxRevenueChart"></canvas>
                    </div>
                </div>

                <!-- Hai bảng: Top Giày & Đã Bán Tồn Kho -->
                <div class="row g-4 mb-4">
                    <!-- Bảng Giày Chạy Bộ Bán Chạy -->
                    <div class="col-lg-6">
                        <div class="runmax-card mb-0 border-0 shadow-sm overflow-hidden h-100" style="background: #ffffff;">
                            <div class="px-4 py-3 d-flex justify-content-between align-items-center bg-danger">
                                <h6 class="mb-0 fw-bold text-white"><i class="bi bi-trophy me-2"></i> Top Giày Bán Chạy Nhất</h6>
                                <a href="${pageContext.request.contextPath}/san-pham" class="badge bg-white text-danger text-decoration-none rounded-pill px-3 py-1">Xem tất cả</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="px-4 py-3 border-bottom-0" style="width: 50px;">#</th>
                                            <th class="py-3 border-bottom-0">Dòng Giày Chạy Bộ</th>
                                            <th class="text-end py-3 px-4 border-bottom-0">Số lượng thực tế đã bán</th>
                                        </tr>
                                    </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topSanPham}">
                                            <c:forEach var="item" items="${topSanPham}" varStatus="stt">
                                                <tr>
                                                    <td class="px-4">
                                                        <span class="badge ${stt.index == 0 ? 'bg-danger' : (stt.index == 1 ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                            ${stt.count}
                                                        </span>
                                                    </td>
                                                    <td class="fw-bold text-dark">${item[0]}</td>
                                                    <td class="text-end px-4">
                                                        <span class="badge bg-danger fs-6 px-3 py-2">
                                                            <i class="bi bi-cart-check me-1"></i> ${item[1]} đôi
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center py-4 text-muted">
                                                    Chưa có sản phẩm nào được bán ra
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                        </div>
                    </div>

                    <!-- Kho Sản Phẩm -->
                    <div class="col-lg-6">
                        <div class="runmax-card mb-0 border-0 shadow-sm overflow-hidden h-100" style="background: #ffffff;">
                            <div class="px-4 py-3 d-flex justify-content-between align-items-center bg-danger">
                                <h6 class="mb-0 fw-bold text-white"><i class="bi bi-box-seam me-2"></i> Kho sản phẩm</h6>
                                <span class="badge bg-white text-danger rounded-pill px-3 py-1">Số liệu trực tiếp</span>
                            </div>
                            <div class="table-responsive" style="max-height: 350px;">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                                        <tr>
                                            <th class="px-4 py-3 border-bottom-0">Sản phẩm</th>
                                            <th class="text-center py-3 border-bottom-0" style="width: 150px;">Kích cỡ</th>
                                            <th class="text-center py-3 border-bottom-0" style="width: 150px;">Tồn</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty banChamVaTonKho}">
                                                <c:forEach var="item" items="${banChamVaTonKho}">
                                                    <tr>
                                                        <td class="px-4 text-dark fw-medium">${item[0]}</td>
                                                        <td class="text-center">
                                                            <span class="badge border text-dark px-3 py-2" style="background-color: #f8fafc; border-color: #e2e8f0 !important;">${item[1]}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${item[2] < 10}">
                                                                    <span class="fw-bold text-danger">${item[2]}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-dark fw-medium">${item[2]}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="3" class="text-center py-4 text-muted">Chưa có dữ liệu thống kê sản phẩm</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tỷ Lệ Trạng Thái Đơn Hàng & Sản Phẩm Đã Bán -->
                <div class="row g-4 mb-4">
                    <!-- Sản Phẩm Đã Bán -->
                    <div class="col-lg-6">
                        <div class="runmax-card mb-0 border-0 shadow-sm overflow-hidden h-100" style="background: #ffffff;">
                            <div class="px-4 py-3 d-flex justify-content-between align-items-center bg-danger">
                                <h6 class="mb-0 fw-bold text-white"><i class="bi bi-cart-check me-2"></i> Sản Phẩm Đã Bán Trong Kỳ</h6>
                            </div>
                            <div class="table-responsive" style="max-height: 350px;">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                                        <tr>
                                            <th class="px-4 py-3 border-bottom-0">Sản phẩm</th>
                                            <th class="text-center py-3 border-bottom-0">Số lượng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty sanPhamDaBanHnay}">
                                                <c:forEach var="item" items="${sanPhamDaBanHnay}">
                                                    <tr>
                                                        <td class="px-4 fw-medium text-dark">${item[0]}</td>
                                                        <td class="text-center">
                                                            <span class="badge bg-success bg-opacity-10 text-success px-3 py-2" style="font-size: 0.9rem;">${item[1]}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="2" class="text-center py-4 text-muted">Chưa có sản phẩm nào được bán hôm nay</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Tỷ Lệ Trạng Thái Đơn Hàng -->
                    <div class="col-lg-6">
                        <div class="runmax-card p-4 h-100 d-flex flex-column justify-content-between border-0 shadow-sm" style="background: #ffffff;">
                            <div>
                                <h6 class="fw-bold text-dark mb-1">
                                    <i class="bi bi-pie-chart-fill text-danger me-1"></i> TỶ LỆ PHÂN BỔ TRẠNG THÁI ĐƠN HÀNG
                                </h6>
                                <p class="text-muted small mb-3">Tỷ trọng đơn hoàn tất, đang chờ thanh toán và hủy bỏ</p>
                            </div>
                            <div style="position: relative; height: 250px; width: 100%;">
                                <canvas id="runmaxOrderStatusChart"></canvas>
                            </div>
                            <!-- Chú thích trạng thái dưới biểu đồ -->
                            <div class="row text-center mt-3 pt-2 border-top g-2">
                                <div class="col-4">
                                    <div class="d-flex align-items-center justify-content-center gap-1 small fw-semibold text-dark">
                                        <span class="d-inline-block rounded-circle" style="width: 10px; height: 10px; background: #10b981;"></span>
                                        Hoàn tất
                                    </div>
                                    <div class="fw-bold text-success fs-6">${pieHoanTat != null ? pieHoanTat : 0} đơn</div>
                                </div>
                                <div class="col-4">
                                    <div class="d-flex align-items-center justify-content-center gap-1 small fw-semibold text-dark">
                                        <span class="d-inline-block rounded-circle" style="width: 10px; height: 10px; background: #f59e0b;"></span>
                                        Đang chờ
                                    </div>
                                    <div class="fw-bold text-warning fs-6">${pieCho != null ? pieCho : 0} đơn</div>
                                </div>
                                <div class="col-4">
                                    <div class="d-flex align-items-center justify-content-center gap-1 small fw-semibold text-dark">
                                        <span class="d-inline-block rounded-circle" style="width: 10px; height: 10px; background: #ef4444;"></span>
                                        Đã hủy
                                    </div>
                                    <div class="fw-bold text-danger fs-6">${pieHuy != null ? pieHuy : 0} đơn</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Dữ liệu ẩn an toàn cho biểu đồ -->
    <input type="hidden" id="chartLabelsData" value='${not empty chartLabels ? chartLabels : "[\"Hôm nay\"]"}' />
    <input type="hidden" id="chartValuesData" value='${not empty chartValues ? chartValues : "[0]"}' />
    <input type="hidden" id="pieHoanTatData" value="${pieHoanTat != null ? pieHoanTat : 0}" />
    <input type="hidden" id="pieChoData" value="${pieCho != null ? pieCho : 0}" />
    <input type="hidden" id="pieHuyData" value="${pieHuy != null ? pieHuy : 0}" />

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Date Adapter for Chart.js Time Scale -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            if (typeof Chart === 'undefined') {
                console.error("Chart.js library chưa được tải.");
                return;
            }

            // 1. BIỂU ĐỒ DOANH THU THEO NGÀY
            try {
                const canvasEl = document.getElementById('runmaxRevenueChart');
                if (canvasEl) {
                    const ctx = canvasEl.getContext('2d');
                    let labels = ['Hôm nay'];
                    let dataValues = [0];

                    const elLabels = document.getElementById('chartLabelsData');
                    const elValues = document.getElementById('chartValuesData');
                    if (elLabels && elLabels.value) {
                        try {
                            const parsedL = JSON.parse(elLabels.value);
                            if (Array.isArray(parsedL) && parsedL.length > 0) labels = parsedL;
                        } catch (e) { console.warn("Lỗi parse chartLabelsData:", e); }
                    }
                    if (elValues && elValues.value) {
                        try {
                            const parsedV = JSON.parse(elValues.value);
                            if (Array.isArray(parsedV) && parsedV.length > 0) dataValues = parsedV;
                        } catch (e) { console.warn("Lỗi parse chartValuesData:", e); }
                    }

                    const gradientFill = ctx.createLinearGradient(0, 0, 0, 300);
                    gradientFill.addColorStop(0, 'rgba(220, 38, 38, 0.35)');
                    gradientFill.addColorStop(1, 'rgba(220, 38, 38, 0.02)');

                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Doanh thu giày chạy bộ (VNĐ)',
                                data: dataValues,
                                borderColor: '#dc2626',
                                borderWidth: 3,
                                pointBackgroundColor: '#dc2626',
                                pointBorderColor: '#ffffff',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                pointHoverRadius: 7,
                                backgroundColor: gradientFill,
                                fill: true,
                                tension: 0.35
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: true,
                                    position: 'top',
                                    labels: {
                                        font: { family: 'Inter', size: 13, weight: 'bold' },
                                        color: '#0f172a'
                                    }
                                },
                                tooltip: {
                                    backgroundColor: '#0f172a',
                                    padding: 12,
                                    titleFont: { size: 14, weight: 'bold' },
                                    bodyFont: { size: 13 },
                                    callbacks: {
                                        label: function(context) {
                                            let val = context.raw || 0;
                                            return ' Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(val) + ' đ';
                                        }
                                    }
                                }
                            },
                            scales: {
                                x: {
                                    type: 'time',
                                    time: {
                                        unit: 'day',
                                        displayFormats: { day: 'dd/MM/yyyy' },
                                        tooltipFormat: 'dd/MM/yyyy'
                                    },
                                    grid: { display: false },
                                    ticks: { 
                                        font: { family: 'Inter', size: 12 }, 
                                        color: '#64748b',
                                        maxTicksLimit: 7
                                    }
                                },
                                y: {
                                    beginAtZero: true,
                                    grid: { color: '#f1f5f9' },
                                    ticks: {
                                        font: { family: 'Inter', size: 12 },
                                        color: '#64748b',
                                        callback: function(value) {
                                            if (value >= 1000000) return (value / 1000000) + ' Tr đ';
                                            if (value >= 1000) return (value / 1000) + ' K đ';
                                            return value + ' đ';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            } catch (err1) {
                console.error("Lỗi khởi tạo biểu đồ doanh thu:", err1);
            }

            // 2. BIỂU ĐỒ TRÒN PHÂN BỔ TRẠNG THÁI
            try {
                const ctxPie = document.getElementById('runmaxOrderStatusChart');
                if (ctxPie) {
                    const pieHoanTat = Number(document.getElementById('pieHoanTatData')?.value || 0);
                    const pieCho = Number(document.getElementById('pieChoData')?.value || 0);
                    const pieHuy = Number(document.getElementById('pieHuyData')?.value || 0);
                    const totalPie = pieHoanTat + pieCho + pieHuy;

                    new Chart(ctxPie.getContext('2d'), {
                        type: 'doughnut',
                        data: {
                            labels: totalPie > 0 ? ['Đã hoàn tất', 'Đang chờ thanh toán', 'Đã hủy đơn'] : ['Chưa có đơn hàng'],
                            datasets: [{
                                data: totalPie > 0 ? [pieHoanTat, pieCho, pieHuy] : [1],
                                backgroundColor: totalPie > 0 ? [
                                    '#10b981', // Xanh lá
                                    '#f59e0b', // Vàng cam
                                    '#ef4444'  // Đỏ
                                ] : ['#e2e8f0'],
                                borderColor: '#ffffff',
                                borderWidth: 3,
                                hoverOffset: 6
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '68%',
                            plugins: {
                                legend: { display: false },
                                tooltip: {
                                    backgroundColor: '#0f172a',
                                    padding: 10,
                                    titleFont: { size: 13, weight: 'bold' },
                                    bodyFont: { size: 13 },
                                    callbacks: {
                                        label: function(context) {
                                            return ' ' + context.label + ': ' + context.raw + ' đơn hàng';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            } catch (err2) {
                console.error("Lỗi khởi tạo biểu đồ tròn:", err2);
            }
        });

        // Hàm hỗ trợ lọc nhanh ngày tháng
        function setQuickFilter(type, btnElement) {
            document.querySelectorAll('.quick-filters .btn').forEach(btn => btn.classList.remove('active'));
            if (btnElement) btnElement.classList.add('active');

            const tuNgay = document.getElementById('tuNgay');
            const denNgay = document.getElementById('denNgay');
            const today = new Date();
            
            let startDate = new Date();
            let endDate = new Date();

            if (type === 'today') {
                // Today (already set to today)
            } else if (type === 'week') {
                const day = today.getDay();
                const diff = today.getDate() - day + (day === 0 ? -6 : 1); 
                startDate = new Date(today.setDate(diff));
            } else if (type === 'month') {
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
            } else if (type === 'year') {
                startDate = new Date(today.getFullYear(), 0, 1);
            }

            const formatDate = (date) => {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `\${year}-\${month}-\${day}`;
            };

            tuNgay.value = formatDate(startDate);
            denNgay.value = formatDate(endDate);

            document.getElementById('filterForm').submit();
        }

        // Kích hoạt trạng thái button tương ứng với url
        window.addEventListener('DOMContentLoaded', (event) => {
            const tuNgay = document.getElementById('tuNgay')?.value;
            const denNgay = document.getElementById('denNgay')?.value;
            const todayStr = new Date().toISOString().split('T')[0];
            const buttons = document.querySelectorAll('.quick-filters .btn');
            
            if (tuNgay === denNgay && tuNgay === todayStr) {
                if(buttons[0]) buttons[0].classList.add('active');
            }
        });
    </script>
</body>
</html>
