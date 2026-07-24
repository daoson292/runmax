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
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <!-- Bộ lọc theo khoảng ngày -->
                <div class="runmax-card mb-4">
                    <form action="${pageContext.request.contextPath}/thong-ke" method="get" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-secondary">Từ ngày</label>
                            <input type="date" name="tuNgay" class="form-control" value="${tuNgay}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-secondary">Đến ngày</label>
                            <input type="date" name="denNgay" class="form-control" value="${denNgay}">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-runmax w-100">
                                <i class="bi bi-filter me-1"></i> Lọc thống kê
                            </button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/thong-ke" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Mặc định
                            </a>
                        </div>
                    </form>
                </div>

                <!-- 4 Thẻ tổng quan thời gian -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="runmax-card stat-card h-100">
                            <div class="stat-title">Doanh thu hôm nay</div>
                            <div class="stat-value text-danger">
                                <fmt:formatNumber value="${doanhThuHomNay}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card stat-card h-100">
                            <div class="stat-title">Doanh thu tuần này</div>
                            <div class="stat-value text-dark">
                                <fmt:formatNumber value="${doanhThuTuanNay}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card stat-card h-100">
                            <div class="stat-title">Doanh thu tháng này</div>
                            <div class="stat-value text-dark">
                                <fmt:formatNumber value="${doanhThuThangNay}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="runmax-card stat-card h-100">
                            <div class="stat-title">Doanh thu năm nay</div>
                            <div class="stat-value text-dark">
                                <fmt:formatNumber value="${doanhThuNamNay}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
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
</body>
</html>
