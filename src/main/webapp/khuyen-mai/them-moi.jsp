<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Phiếu Giảm Giá - RunMax Admin</title>
        <meta name="description" content="Thêm phiếu giảm giá mới cho hệ thống RunMax">

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
                    <h1 class="page-title">Thêm Phiếu Giảm Giá Mới</h1>

                    <!-- Form Section -->
                    <div class="form-section">
                        <h2>Thông tin phiếu giảm giá</h2>

                        <div class="form-row">
                            <div class="form-group">
                                <select class="form-select" id="loaiGiam">
                                    <option value="" disabled selected>Loại giảm</option>
                                    <option value="phan-tram">Giảm theo %</option>
                                    <option value="tien">Giảm theo VNĐ</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <input type="number" class="form-input" id="giaTriGiam" placeholder="Giá trị giảm">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <input type="number" class="form-input" id="soLuong" placeholder="Số lượng">
                            </div>
                            <div class="form-group">
                                <input type="number" class="form-input" id="giamToiDa" placeholder="Giảm tối đa">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="ngayBatDau">Ngày bắt đầu</label>
                                <input type="date" class="form-input" id="ngayBatDau">
                            </div>
                            <div class="form-group">
                                <label for="ngayKetThuc">Ngày kết thúc</label>
                                <input type="date" class="form-input" id="ngayKetThuc">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full-width">
                                <input type="text" class="form-input" id="dieuKien" placeholder="Điều kiện">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-submit" id="btnThemVoucher">Thêm</button>
                            <a href="${pageContext.request.contextPath}/khuyen-mai/danh-sach.jsp?activePage=khuyen-mai&activeSubmenu=pgg"
                                class="btn-cancel">Hủy</a>
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
