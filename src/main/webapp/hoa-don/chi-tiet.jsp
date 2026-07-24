<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Hóa Đơn - RunMax Admin</title>
        <meta name="description" content="Chi tiết hóa đơn bán hàng RunMax">

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
                <jsp:param name="activePage" value="hoa-don" />
                <jsp:param name="activeSubmenu" value="" />
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="/includes/header.jsp" />

                <!-- Page Content -->
                <div class="page-content">
                    <!-- Page Title Badge -->
                    <div class="page-title-badge">Quản Lý Hóa Đơn</div>

                    <!-- Order Status Timeline -->
                    <div class="content-card">
                        <h4 style="font-weight: 700; margin-bottom: 20px;">Trạng Thái Đơn Hàng</h4>

                        <div class="order-timeline">
                            <!-- Step 1: Chờ Xác Nhận (Active) -->
                            <div class="timeline-step active">
                                <div class="timeline-icon">
                                    <i class="bi bi-bag-check-fill"></i>
                                </div>
                                <span class="timeline-label">Chờ Xác Nhận</span>
                            </div>

                            <!-- Step 2: Đã Xác Nhận Thông Tin Thanh Toán -->
                            <div class="timeline-step">
                                <div class="timeline-icon">
                                    <i class="bi bi-cart-check-fill"></i>
                                </div>
                                <span class="timeline-label">Đã Xác Nhận Thanh Toán</span>
                            </div>

                            <!-- Step 3: Đã Hoàn Thành -->
                            <div class="timeline-step">
                                <div class="timeline-icon">
                                    <i class="bi bi-star-fill"></i>
                                </div>
                                <span class="timeline-label">Đã Hoàn Thành</span>
                            </div>
                        </div>

                        <!-- Timeline Actions -->
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="timeline-actions">
                                <button class="btn-timeline-continue">Tiếp tục</button>
                                <button class="btn-timeline-cancel">Hủy đơn và hoàn tiền</button>
                            </div>
                            <button class="btn-history">
                                <i class="bi bi-clock-history"></i> LỊCH SỬ HÓA ĐƠN
                            </button>
                        </div>
                    </div>

                    <!-- Order Information -->
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span style="font-weight: 700; font-size: 15px;">
                                    Thông tin đơn hàng có mã hóa đơn:
                                    <a href="#" class="order-code-link">HDMKT1</a>
                                </span>
                            </div>
                            <button class="btn-payment-history">
                                <i class="bi bi-play-circle-fill"></i> Lịch sử thanh toán
                            </button>
                        </div>

                        <!-- Products Table -->
                        <div style="overflow-x: auto;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="text-align: left; padding-left: 16px;">Sản phẩm</th>
                                        <th>Số Lượng</th>
                                        <th>Kho</th>
                                        <th>Giá hiện tại</th>
                                        <th>Giá được tính</th>
                                        <th>Tổng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="text-align: left;">
                                            <div class="product-info-cell">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/z8005183448802_75e8cf71d05f3f28a69ec52efc22c187.jpg"
                                                    alt="Product">
                                                <div class="product-details">
                                                    <span class="product-name">Giày Sneaker Unisex Puma Speedcat
                                                        Og</span>
                                                    <span class="product-meta">Màu: Đỏ &nbsp;&nbsp; Size: 42</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>1</td>
                                        <td>100</td>
                                        <td>2.500.000 đ</td>
                                        <td>2.500.000 đ</td>
                                        <td class="text-red fw-700">2.500.000 đ</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left;">
                                            <div class="product-info-cell">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/z8005183921700_df3998f4197a368a35e9a6edfbe2413e.jpg"
                                                    alt="Product">
                                                <div class="product-details">
                                                    <span class="product-name">Speedcat OG Sneakers Unisex</span>
                                                    <span class="product-meta">Màu: Đen &nbsp;&nbsp; Size: 43</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>3</td>
                                        <td>50</td>
                                        <td>7.500.000 đ</td>
                                        <td>7.500.000 đ</td>
                                        <td class="text-red fw-700">7.500.000 đ</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Customer Info + Invoice Summary -->
                    <div class="row">
                        <!-- Customer Information -->
                        <div class="col-lg-7">
                            <div class="content-card">
                                <h5 style="font-weight: 700; margin-bottom: 20px;">Thông tin khách hàng</h5>

                                <div class="customer-info">
                                    <div class="mb-3">
                                        <span class="info-label">Địa Chỉ</span>
                                        <input type="text" class="form-control-custom"
                                            value="123 Đường ABC, Quận XYZ, HN" readonly>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <span class="info-label">Tên Người Nhận</span>
                                            <input type="text" class="form-control-custom" value="Nguyễn Văn A"
                                                readonly>
                                        </div>
                                        <div class="col-md-6">
                                            <span class="info-label">Số Điện Thoại</span>
                                            <input type="text" class="form-control-custom" value="0254447899" readonly>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <span class="info-label">Ghi Chú</span>
                                        <textarea class="form-control-custom" rows="4" placeholder="Ghi Chú"
                                            readonly></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Invoice Summary -->
                        <div class="col-lg-5">
                            <div class="content-card">
                                <h5 style="font-weight: 700; margin-bottom: 20px;">Hóa đơn</h5>

                                <div class="invoice-summary">
                                    <div class="summary-row">
                                        <span>Tổng tiền:</span>
                                        <span>2.500.000 đ</span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Giảm giá:</span>
                                        <span>-100.000 đ</span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Phụ phí:</span>
                                        <span>+ 0 đ</span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Hoàn Phí:</span>
                                        <span>- 0 đ</span>
                                    </div>
                                    <div class="summary-row total">
                                        <span>Cần Thanh Toán:</span>
                                        <span class="amount">2.400.000 đ</span>
                                    </div>
                                </div>

                                <div class="text-center mt-4">
                                    <button class="btn-update-order">
                                        CẬP NHẬT ĐƠN HÀNG
                                    </button>
                                </div>
                            </div>
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