<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Khách Hàng - RunMax Admin</title>
        <meta name="description" content="Thêm khách hàng mới vào hệ thống RunMax">

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
                <jsp:param name="activeSubmenu" value="kh" />
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="/includes/header.jsp" />

                <!-- Page Content -->
                <div class="page-content">
                    <h1 class="page-title">Thêm khách hàng mới</h1>

                    <!-- Personal Info Section -->
                    <div class="form-section">
                        <h2>Thông tin cá nhân</h2>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="hoTen" placeholder="Họ và tên">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="email" class="form-input" id="email" placeholder="Email">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="tel" class="form-input" id="soDienThoai" placeholder="Số điện thoại">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <select class="form-select" id="tinhThanhPho">
                                    <option value="" disabled selected>Chọn tỉnh/thành phố</option>
                                    <option value="ha-noi">Hà Nội</option>
                                    <option value="ho-chi-minh">Hồ Chí Minh</option>
                                    <option value="da-nang">Đà Nẵng</option>
                                    <option value="hai-phong">Hải Phòng</option>
                                    <option value="can-tho">Cần Thơ</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <select class="form-select" id="quanHuyen">
                                    <option value="" disabled selected>Chọn quận/huyện</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <select class="form-select" id="phuongXa">
                                    <option value="" disabled selected>Chọn phường/xã</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="diaChiCuThe" placeholder="Địa chỉ cụ thể">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-submit" id="btnThemKhachHang">Thêm</button>
                            <a href="${pageContext.request.contextPath}/tai-khoan/khach-hang/danh-sach.jsp?activePage=tai-khoan&activeSubmenu=kh"
                                class="btn-cancel">Hủy</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/address-helper.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    </body>

    </html>
