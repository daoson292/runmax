<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Báo cáo Thống kê Doanh thu" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .filter-card {
            background-color: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
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
            background-color: #8c6b5d;
            color: #fff;
            border-color: #8c6b5d;
        }
        .filter-body {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
        }
        .date-inputs {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .date-group {
            display: flex;
            flex-direction: column;
        }
        .date-arrow {
            margin-top: 25px;
            color: #6c757d;
        }
        .btn-brown {
            background-color: #8c6b5d;
            color: #fff;
            border-color: #8c6b5d;
        }
        .btn-brown:hover {
            background-color: #7a5c4f;
            color: #fff;
        }
        .stats-container {
            display: flex;
            background-color: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
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
                <!-- Bộ lọc theo khoảng ngày -->
                <div class="filter-card">
                    <div class="filter-header">
                        <div class="filter-title">
                            <i class="bi bi-bar-chart-line-fill text-danger"></i> Bộ lọc thống kê
                            <span class="fs-6 fw-normal text-muted ms-2" style="font-size: 0.8rem !important;">Dữ liệu bên dưới được cập nhật theo bộ lọc này</span>
                        </div>
                        <div class="quick-filters">
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('today', this)">Hôm nay</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('week', this)">Tuần này</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('month', this)">Tháng này</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="setQuickFilter('year', this)">Năm nay</button>
                        </div>
                    </div>
                    <form id="filterForm" action="${pageContext.request.contextPath}/thong-ke" method="get">
                        <div class="filter-body row g-3">
                            <div class="col-md-7">
                                <div class="date-inputs">
                                    <div class="date-group flex-grow-1">
                                        <label class="form-label fw-semibold small text-secondary mb-1">Từ ngày</label>
                                        <input type="date" id="tuNgay" name="tuNgay" class="form-control" value="${tuNgay}">
                                    </div>
                                    <div class="date-arrow"><i class="bi bi-arrow-right"></i></div>
                                    <div class="date-group flex-grow-1">
                                        <label class="form-label fw-semibold small text-secondary mb-1">Đến ngày</label>
                                        <input type="date" id="denNgay" name="denNgay" class="form-control" value="${denNgay}">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5 d-flex justify-content-end align-items-end gap-2">
                                <button type="submit" class="btn btn-brown px-4">
                                    <i class="bi bi-funnel-fill me-1"></i> Lọc dữ liệu
                                </button>
                                <a href="${pageContext.request.contextPath}/thong-ke" class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i> Đặt lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- 4 Thẻ Chỉ Số Động -->
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
                        <div class="stat-subtext">Đã thanh toán ${not empty donThanhCong ? donThanhCong : 0} - Hủy ${not empty donHuy ? donHuy : 0} - Chờ ${not empty donCho ? donCho : 0}</div>
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

                <!-- Bảng chi tiết và Top 5 -->
                <div class="row g-4">
                    <div class="col-md-7">
                        <div class="runmax-card h-100">
                            <h6 class="fw-bold mb-3"><i class="bi bi-calendar-range me-2 text-danger"></i>Doanh thu theo ngày trong khoảng đã chọn</h6>
                            <div class="table-responsive">
                                <table class="table-runmax">
                                    <thead>
                                        <tr>
                                            <th>Ngày</th>
                                            <th class="text-end">Doanh thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty chartData}">
                                                <c:forEach var="entry" items="${chartData}">
                                                    <tr>
                                                        <td class="fw-semibold">${entry.key}</td>
                                                        <td class="text-end fw-bold text-danger">
                                                            <fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="2" class="text-center py-4 text-muted">Không có dữ liệu trong khoảng thời gian này</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-5">
                        <div class="runmax-card h-100">
                            <h6 class="fw-bold mb-3"><i class="bi bi-trophy-fill me-2 text-warning"></i>Top 5 Sản phẩm bán chạy nhất</h6>
                            <div class="table-responsive">
                                <table class="table-runmax">
                                    <thead>
                                        <tr>
                                            <th>Tên giày</th>
                                            <th class="text-end">Đã bán</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty topSanPham}">
                                                <c:forEach var="item" items="${topSanPham}">
                                                    <tr>
                                                        <td class="fw-semibold">${item[0]}</td>
                                                        <td class="text-end"><span class="badge bg-danger">${item[1]} đôi</span></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="2" class="text-center py-4 text-muted">Chưa có sản phẩm nào được bán ra</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function setQuickFilter(type, btnElement) {
            // Remove active class from all buttons
            document.querySelectorAll('.quick-filters .btn').forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            if (btnElement) btnElement.classList.add('active');

            const tuNgay = document.getElementById('tuNgay');
            const denNgay = document.getElementById('denNgay');
            const today = new Date();
            
            let startDate = new Date();
            let endDate = new Date();

            if (type === 'today') {
                // Today
            } else if (type === 'week') {
                // This week (start from Monday)
                const day = today.getDay();
                const diff = today.getDate() - day + (day === 0 ? -6 : 1); 
                startDate = new Date(today.setDate(diff));
            } else if (type === 'month') {
                // This month
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
            } else if (type === 'year') {
                // This year
                startDate = new Date(today.getFullYear(), 0, 1);
            }

            // Format YYYY-MM-DD
            const formatDate = (date) => {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `\${year}-\${month}-\${day}`;
            };

            tuNgay.value = formatDate(startDate);
            denNgay.value = formatDate(endDate);

            // Submit form automatically
            document.getElementById('filterForm').submit();
        }
        
        // Setup initial active state based on date range
        window.addEventListener('DOMContentLoaded', (event) => {
            const tuNgay = document.getElementById('tuNgay').value;
            const denNgay = document.getElementById('denNgay').value;
            const todayStr = new Date().toISOString().split('T')[0];
            const buttons = document.querySelectorAll('.quick-filters .btn');
            
            if (tuNgay === denNgay && tuNgay === todayStr) {
                buttons[0].classList.add('active');
            } else {
                // Logic to set other buttons active if needed based on URL params
                // This is a simple implementation, you might want to add more precise checks
            }
        });
    </script>
</body>
</html>
