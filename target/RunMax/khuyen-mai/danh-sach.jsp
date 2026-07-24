<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Phiếu Giảm Giá - RunMax Admin</title>
        <meta name="description" content="Quản lý phiếu giảm giá khuyến mãi RunMax">

        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    </head>

    <body>
        <div class="admin-wrapper">
            <!-- Sidebar -->
            <jsp:include page="/includes/sidebar.jsp">
                <jsp:param name="activePage" value="khuyen-mai" />
                <jsp:param name="activeSubmenu" value="pgg" />
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="/includes/header.jsp" />

                <!-- Page Content -->
                <div class="page-content">
                    <h1 class="page-title">Phiếu Giảm Giá</h1>

                    <!-- Search & Actions Bar -->
                    <div class="content-card">
                        <div class="search-bar">
                            <input type="text" class="search-input" placeholder="Tìm kiếm" id="searchVoucher">
                            <button class="btn-primary-blue" type="button">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                            <button class="btn-primary-red btn-reset" type="button">
                                <i class="bi bi-arrow-clockwise"></i> Làm mới
                            </button>
                            <a href="${pageContext.request.contextPath}/khuyen-mai/them-moi.jsp?activePage=khuyen-mai&activeSubmenu=pgg"
                                class="btn-add ms-auto">
                                <i class="bi bi-plus-lg"></i> Thêm Phiếu Giảm Giá
                            </a>
                        </div>

                        <!-- Filters -->
                        <div class="filter-bar">
                            <span class="filter-icon"><i class="bi bi-funnel-fill"></i></span>
                            <select class="filter-select" id="filterLoai">
                                <option value="">Loại giảm giá</option>
                                <option value="phan-tram">Giảm theo %</option>
                                <option value="tien">Giảm theo VNĐ</option>
                            </select>
                            <select class="filter-select" id="filterTrangThai">
                                <option value="">Trạng thái</option>
                                <option value="dang-dien-ra">Đang diễn ra</option>
                                <option value="sap-dien-ra">Sắp diễn ra</option>
                                <option value="ket-thuc">Kết thúc</option>
                            </select>
                        </div>
                    </div>

                    <!-- Voucher Table -->
                    <div class="content-card" style="padding: 0; overflow: hidden;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 50px;">STT</th>
                                    <th>Mã</th>
                                    <th>Loại giảm giá</th>
                                    <th>Giá trị giảm</th>
                                    <th>Giảm tối đa</th>
                                    <th>Số lượng</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Điều kiện</th>
                                    <th>Trạng thái</th>
                                    <th style="width: 80px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>KM001</td>
                                    <td>Giảm theo %</td>
                                    <td>10%</td>
                                    <td>500.000đ</td>
                                    <td>100</td>
                                    <td>01/12/2025</td>
                                    <td>31/12/2025</td>
                                    <td>Đơn tối thiểu 2.000.000đ</td>
                                    <td><span class="badge-ongoing">Đang diễn ra</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/khuyen-mai/chi-tiet.jsp?activePage=khuyen-mai&activeSubmenu=pgg&id=1"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>KM002</td>
                                    <td>Giảm theo VNĐ</td>
                                    <td>500.000đ</td>
                                    <td>2.000.000đ</td>
                                    <td>50</td>
                                    <td>15/12/2025</td>
                                    <td>15/01/2026</td>
                                    <td>Đơn tối thiểu 5.000.000đ</td>
                                    <td><span class="badge-ongoing">Đang diễn ra</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/khuyen-mai/chi-tiet.jsp?activePage=khuyen-mai&activeSubmenu=pgg&id=2"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>KM003</td>
                                    <td>Giảm theo %</td>
                                    <td>20%</td>
                                    <td>1.000.000đ</td>
                                    <td>200</td>
                                    <td>01/01/2026</td>
                                    <td>28/02/2026</td>
                                    <td>Đơn tối thiểu 3.000.000đ</td>
                                    <td><span class="badge-upcoming">Sắp diễn ra</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/khuyen-mai/chi-tiet.jsp?activePage=khuyen-mai&activeSubmenu=pgg&id=3"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>KM004</td>
                                    <td>Giảm theo VNĐ</td>
                                    <td>200.000đ</td>
                                    <td>200.000đ</td>
                                    <td>0</td>
                                    <td>01/10/2025</td>
                                    <td>30/11/2025</td>
                                    <td>Không có</td>
                                    <td><span class="badge-ended">Kết thúc</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/khuyen-mai/chi-tiet.jsp?activePage=khuyen-mai&activeSubmenu=pgg&id=4"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination-wrapper">
                        <button class="page-btn" title="Trang trước">
                            <i class="bi bi-chevron-left"></i>
                        </button>
                        <input type="text" class="page-number" value="1" readonly>
                        <button class="page-btn" title="Trang sau">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    </body>

    </html>
