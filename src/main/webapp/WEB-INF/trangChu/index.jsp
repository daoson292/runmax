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
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <!-- Welcome Banner -->
                <div class="runmax-card p-4 mb-4" style="background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%); border-left: 5px solid #dc2626;">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Hệ Thống Quản Lý & POS Giày Chạy Bộ Nam RunMax 🏃‍♂️</h4>
                            <p class="text-muted mb-0">Chào mừng <b>${sessionScope.nhanVien != null ? sessionScope.nhanVien.hoTen : 'Quản trị viên'}</b>. Chuyên các dòng Marathon Pro, Ultra Boost & AeroGlide.</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/ban-hang" class="btn btn-runmax">
                                <i class="bi bi-cart-plus-fill me-1"></i> MỞ QUẦY POS BÁN HÀNG
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet" class="btn btn-outline-danger fw-semibold">
                                <i class="bi bi-boxes me-1"></i> Xem Kho Giày Chi Tiết
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 4 Thẻ thống kê KPI -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="runmax-card p-4 h-100 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted small fw-bold text-uppercase">Doanh Thu Hôm Nay</span>
                                <div class="rounded-3 bg-danger bg-opacity-10 text-danger p-2"><i class="bi bi-currency-dollar fs-5"></i></div>
                            </div>
                            <h3 class="fw-bold text-dark mb-1">
                                <fmt:formatNumber value="${doanhThuHnay != null ? doanhThuHnay : 0}" type="number" /> đ
                            </h3>
                            <span class="badge bg-success bg-opacity-10 text-success small"><i class="bi bi-calendar-check"></i> Cập nhật trực tiếp từ DB</span>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card p-4 h-100 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted small fw-bold text-uppercase">Đơn Giày Đã Bán</span>
                                <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-2"><i class="bi bi-bag-check fs-5"></i></div>
                            </div>
                            <h3 class="fw-bold text-dark mb-1">${soDonHnay != null ? soDonHnay : 0} đơn</h3>
                            <span class="text-muted small">Tổng đơn đã hoàn tất</span>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card p-4 h-100 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted small fw-bold text-uppercase">Khách Hàng Runner</span>
                                <div class="rounded-3 bg-warning bg-opacity-10 text-warning p-2"><i class="bi bi-people fs-5"></i></div>
                            </div>
                            <h3 class="fw-bold text-dark mb-1">Khách Thành Viên</h3>
                            <span class="text-muted small">Thành viên câu lạc bộ chạy</span>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card p-4 h-100 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted small fw-bold text-uppercase">Tồn Kho Giày Nam</span>
                                <div class="rounded-3 bg-info bg-opacity-10 text-info p-2"><i class="bi bi-box-seam fs-5"></i></div>
                            </div>
                            <h3 class="fw-bold text-dark mb-1">Size 39 - 44</h3>
                            <span class="text-muted small">Chuyên chạy bộ nam</span>
                        </div>
                    </div>
                </div>

                <!-- BIỂU ĐỒ DOANH THU & BỘ LỌC THỜI GIAN -->
                <div class="runmax-card p-4 mb-4 border-0 shadow-sm" style="background: #ffffff;">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 pb-2 border-bottom">
                        <div>
                            <h6 class="fw-bold text-dark mb-1">
                                <i class="bi bi-bar-chart-line-fill text-danger me-1"></i> BIỂU ĐỒ DOANH THU BÁN GIÀY THEO THỜI GIAN
                            </h6>
                            <span class="text-muted small">Phân tích xu hướng doanh số bán hàng tự động từ cơ sở dữ liệu</span>
                        </div>
                        <div class="btn-group shadow-sm mt-2 mt-md-0" role="group">
                            <a href="${pageContext.request.contextPath}/dashboard?filter=7days"
                               class="btn btn-sm ${currentFilter == '7days' ? 'btn-danger' : 'btn-outline-secondary'}">
                                <i class="bi bi-calendar-range me-1"></i> 7 Ngày Qua
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard?filter=30days"
                               class="btn btn-sm ${currentFilter == '30days' ? 'btn-danger' : 'btn-outline-secondary'}">
                                <i class="bi bi-calendar-month me-1"></i> 30 Ngày Qua
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard?filter=all"
                               class="btn btn-sm ${currentFilter == 'all' ? 'btn-danger' : 'btn-outline-secondary'}">
                                <i class="bi bi-calendar-check me-1"></i> Toàn Bộ Thời Gian
                            </a>
                        </div>
                    </div>
                    <div style="position: relative; height: 320px; width: 100%;">
                        <canvas id="runmaxRevenueChart"></canvas>
                    </div>
                </div>

                <!-- Bảng Giày Chạy Bộ Bán Chạy & Đơn hàng gần đây -->
                <div class="row g-4">
                    <div class="col-lg-7">
                        <div class="runmax-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="fw-bold text-dark mb-0"><i class="bi bi-trophy text-danger me-1"></i> TOP GIÀY CHẠY BỘ NAM BÁN CHẠY NHẤT</h6>
                                <a href="${pageContext.request.contextPath}/san-pham" class="small text-danger text-decoration-none fw-semibold">Xem tất cả</a>
                            </div>
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 50px;">#</th>
                                        <th>Dòng Giày Chạy Bộ</th>
                                        <th class="text-end">Số lượng thực tế đã bán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topSanPham}">
                                            <c:forEach var="item" items="${topSanPham}" varStatus="stt">
                                                <tr>
                                                    <td>
                                                        <span class="badge ${stt.index == 0 ? 'bg-danger' : (stt.index == 1 ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                            ${stt.count}
                                                        </span>
                                                    </td>
                                                    <td class="fw-bold text-dark">${item[0]}</td>
                                                    <td class="text-end">
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

                    <div class="col-lg-5">
                        <div class="runmax-card p-4 h-100 d-flex flex-column justify-content-between">
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
                                    grid: { display: false },
                                    ticks: { font: { family: 'Inter', size: 12 }, color: '#64748b' }
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
    </script>
</body>
</html>
