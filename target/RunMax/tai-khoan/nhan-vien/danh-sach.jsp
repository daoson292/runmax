<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Nhân Viên - RunMax Admin</title>
        <meta name="description" content="Quản lý danh sách nhân viên hệ thống RunMax">

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
                <jsp:param name="activePage" value="tai-khoan" />
                <jsp:param name="activeSubmenu" value="nv" />
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="/includes/header.jsp" />

                <!-- Page Content -->
                <div class="page-content">
                    <h1 class="page-title">Quản Lý Nhân Viên</h1>

                    <!-- Search & Actions Bar -->
                    <div class="content-card">
                        <div class="search-bar">
                            <input type="text" class="search-input" placeholder="Tìm kiếm" id="searchNhanVien">
                            <button class="btn-primary-blue" type="button">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                            <button class="btn-primary-red btn-reset" type="button">
                                <i class="bi bi-arrow-clockwise"></i> Làm mới
                            </button>
                            <a href="${pageContext.request.contextPath}/tai-khoan/nhan-vien/them-moi.jsp?activePage=tai-khoan&activeSubmenu=nv"
                                class="btn-add ms-auto">
                                <i class="bi bi-plus-lg"></i> Thêm Nhân Viên
                            </a>
                        </div>

                        <!-- Filters -->
                        <div class="filter-bar">
                            <span class="filter-icon"><i class="bi bi-funnel-fill"></i></span>
                            <select class="filter-select" id="filterVaiTro">
                                <option value="">Vai trò</option>
                                <option value="admin">Admin</option>
                                <option value="nhan-vien">Nhân viên</option>
                            </select>
                            <select class="filter-select" id="filterTrangThai">
                                <option value="">Trạng thái</option>
                                <option value="hoat-dong">Hoạt động</option>
                                <option value="ngung">Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>

                    <!-- Staff Table -->
                    <div class="content-card" style="padding: 0; overflow: hidden;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 50px;">STT</th>
                                    <th>Mã NV</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th style="width: 80px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>NV001</td>
                                    <td>Nguyễn Văn An</td>
                                    <td>an.nv@runmax.vn</td>
                                    <td>0901234567</td>
                                    <td>Admin</td>
                                    <td><span class="badge-status badge-active">Hoạt động</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/tai-khoan/nhan-vien/chi-tiet.jsp?activePage=tai-khoan&activeSubmenu=nv&id=1"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>NV002</td>
                                    <td>Trần Thị Bích</td>
                                    <td>bich.tt@runmax.vn</td>
                                    <td>0912345678</td>
                                    <td>Nhân viên</td>
                                    <td><span class="badge-status badge-active">Hoạt động</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/tai-khoan/nhan-vien/chi-tiet.jsp?activePage=tai-khoan&activeSubmenu=nv&id=2"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>NV003</td>
                                    <td>Lê Hoàng Cường</td>
                                    <td>cuong.lh@runmax.vn</td>
                                    <td>0923456789</td>
                                    <td>Nhân viên</td>
                                    <td><span class="badge-ended">Ngừng hoạt động</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/tai-khoan/nhan-vien/chi-tiet.jsp?activePage=tai-khoan&activeSubmenu=nv&id=3"
                                            class="action-icon action-icon-view" title="Xem chi tiết">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>NV004</td>
                                    <td>Phạm Minh Đức</td>
                                    <td>duc.pm@runmax.vn</td>
                                    <td>0934567890</td>
                                    <td>Nhân viên</td>
                                    <td><span class="badge-status badge-active">Hoạt động</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/tai-khoan/nhan-vien/chi-tiet.jsp?activePage=tai-khoan&activeSubmenu=nv&id=4"
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
