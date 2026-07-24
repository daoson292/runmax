<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Phiếu Giảm Giá - RunMax Admin</title>
        <meta name="description" content="Chi tiết và cập nhật phiếu giảm giá RunMax">

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
                    <h1 class="page-title">Chi Tiết Phiếu Giảm Giá</h1>

                    <!-- Form Section -->
                    <div class="form-section">
                        <h2>Thông tin phiếu giảm giá</h2>

                        <div class="form-row">
                            <div class="form-group">
                                <select class="form-select" id="loaiGiam">
                                    <option value="phan-tram" selected>Giảm theo %</option>
                                    <option value="tien">Giảm theo VNĐ</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <input type="number" class="form-input" id="giaTriGiam" placeholder="Giá trị giảm" value="10">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <input type="number" class="form-input" id="soLuong" placeholder="Số lượng" value="100">
                            </div>
                            <div class="form-group">
                                <input type="number" class="form-input" id="giamToiDa" placeholder="Giảm tối đa" value="500000">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="ngayBatDau">Ngày bắt đầu</label>
                                <input type="date" class="form-input" id="ngayBatDau" value="2025-12-01">
                            </div>
                            <div class="form-group">
                                <label for="ngayKetThuc">Ngày kết thúc</label>
                                <input type="date" class="form-input" id="ngayKetThuc" value="2025-12-31">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="dieuKien" placeholder="Điều kiện" value="Đơn tối thiểu 2.000.000đ">
                            </div>
                        </div>

                        <div class="detail-actions-top">
                            <button type="button" class="btn-outline-danger-custom" id="btnNgungHoatDong">Ngừng hoạt động</button>
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
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    </body>

    </html>
