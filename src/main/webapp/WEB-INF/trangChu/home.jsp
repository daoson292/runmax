<%-- 
  TRANG CHỦ - Thao Tác Nhanh (/trang-chu)
  - Chỉ hiển thị Quick Actions, không cần dữ liệu từ DB.
  - Admin: Bán Hàng, Hóa Đơn, Sản Phẩm, Khách Hàng, Nhân Viên, Khuyến Mãi, Thống Kê
  - Nhân Viên: Bán Hàng, Hóa Đơn, Sản Phẩm (SKU), Khách Hàng
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Trang Chủ - RunMax" scope="request" />
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
            border-radius: 14px;
        }
        .quick-action-card:hover {
            transform: translateY(-6px);
            border-color: #fecaca;
            box-shadow: 0 12px 20px -4px rgba(220, 38, 38, 0.12), 0 4px 8px -2px rgba(220, 38, 38, 0.06) !important;
        }
        .quick-action-card:hover .icon-wrapper {
            background-color: #dc2626 !important;
            color: #ffffff !important;
            transform: scale(1.1);
        }
        .icon-wrapper {
            transition: all 0.3s ease;
        }
        .quick-action-label {
            font-size: 0.82rem;
            font-weight: 600;
            color: #374151;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">

                <%-- Welcome Banner --%>
                <div class="runmax-card p-4 mb-4 border-0 shadow-sm" style="background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%); border-left: 5px solid #dc2626 !important;">
                    <h4 class="fw-bold text-dark mb-1">
                        <i class="bi bi-house-door-fill text-danger me-2"></i>Trang Chủ RunMax
                    </h4>
                    <p class="text-muted mb-0">
                        Chào mừng <b>${sessionScope.nhanVien != null ? sessionScope.nhanVien.hoTen : 'Quản trị viên'}</b> quay trở lại. Chọn chức năng phía dưới để bắt đầu.
                    </p>
                </div>

                <%-- Thao Tác Nhanh --%>
                <h5 class="fw-bold text-dark mb-3">
                    <i class="bi bi-lightning-charge-fill text-danger me-2"></i>Thao Tác Nhanh
                </h5>

                <%-- === ADMIN SECTION === --%>
                <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
                    <div class="row g-3 mb-5">

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/ban-hang" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-cart-check-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Bán Hàng tại Quầy</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/hoa-don" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-receipt-cutoff fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Hóa Đơn</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/san-pham" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-box-seam-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Sản Phẩm</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/khach-hang" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-people-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Khách Hàng</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/nhan-vien" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-person-badge-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Nhân Viên</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/phieu-giam-gia" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-ticket-perforated-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Khuyến Mãi</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-2 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-bar-chart-line-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Thống Kê</p>
                                </div>
                            </a>
                        </div>

                    </div>
                </c:if>

                <%-- === NHÂN VIÊN SECTION === --%>
                <c:if test="${sessionScope.vaiTro != 'ROLE_ADMIN' && sessionScope.vaiTro != 'ADMIN'}">
                    <div class="row g-3 mb-5">

                        <div class="col-md-3 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/ban-hang" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-cart-check-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Bán Hàng tại Quầy</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/hoa-don" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-receipt-cutoff fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Hóa Đơn</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-upc-scan fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Xem Sản Phẩm (SKU)</p>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3 col-sm-4 col-6">
                            <a href="${pageContext.request.contextPath}/khach-hang" class="text-decoration-none">
                                <div class="runmax-card p-3 text-center h-100 quick-action-card shadow-sm">
                                    <div class="icon-wrapper bg-danger bg-opacity-10 text-danger mb-2 mx-auto rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        <i class="bi bi-people-fill fs-3"></i>
                                    </div>
                                    <p class="quick-action-label mb-0">Khách Hàng</p>
                                </div>
                            </a>
                        </div>

                    </div>
                </c:if>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
