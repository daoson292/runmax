<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập Nhật Khách Hàng - RunMax Admin</title>
        <meta name="description" content="Cập nhật thông tin khách hàng RunMax">

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
                    <h1 class="page-title">Cập Nhật Tài Khoản</h1>

                    <!-- Personal Info Section -->
                    <div class="form-section">
                        <h2>Thông tin cá nhân</h2>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="hoTen" placeholder="Họ và tên" value="Nguyễn Thị Hương">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="email" class="form-input" id="email" placeholder="Email" value="huong.nt@gmail.com">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="tel" class="form-input" id="soDienThoai" placeholder="Số điện thoại" value="0961234567">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <select class="form-select" id="tinhThanhPho">
                                    <option value="" disabled>Chọn tỉnh/thành phố</option>
                                    <option value="ha-noi" selected>Hà Nội</option>
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
                                    <option value="" disabled>Chọn quận/huyện</option>
                                    <option value="hoan-kiem" selected>Hoàn Kiếm</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <select class="form-select" id="phuongXa">
                                    <option value="" disabled>Chọn phường/xã</option>
                                    <option value="hang-trong" selected>Hàng Trống</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="diaChiCuThe" placeholder="Địa chỉ cụ thể" value="Số 15, Phố Nhà Thờ">
                            </div>
                        </div>

                        <div class="detail-actions-top">
                            <button type="button" class="btn-outline-danger-custom" id="btnNgungHoatDong">Ngừng hoạt động</button>
                            <button type="button" class="btn-outline-info-custom" id="btnCaiLaiMatKhau">Cài lại mật khẩu</button>
                        </div>

                        <div class="detail-actions-bottom">
                            <button type="button" class="btn-active-status" id="btnHoatDong">Hoạt động</button>
                            <button type="button" class="btn-update" id="btnCapNhat">Cập Nhật</button>
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
