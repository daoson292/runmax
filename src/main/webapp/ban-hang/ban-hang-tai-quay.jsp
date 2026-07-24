<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.runmax.service.HoaDonService, com.runmax.service.SanPhamService, com.runmax.entity.HoaDon, com.runmax.entity.SanPham, java.util.List" %>
<%
    List<HoaDon> dsHoaDonCho = new HoaDonService().getAll(null, 0);
    List<SanPham> dsSanPhamPOS = new SanPhamService().getAll(null, null);
    request.setAttribute("dsHoaDonCho", dsHoaDonCho);
    request.setAttribute("dsSanPhamPOS", dsSanPhamPOS);
%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bán Hàng Tại Quầy - RunMax Admin</title>
        <meta name="description" content="Hệ thống bán hàng tại quầy POS RunMax">

        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    </head>

    <body>
        <div class="admin-wrapper">
            <!-- Sidebar -->
            <jsp:include page="/includes/sidebar.jsp">
                <jsp:param name="activePage" value="ban-hang" />
                <jsp:param name="activeSubmenu" value="pos" />
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="/includes/header.jsp" />

                <!-- Page Content -->
                <div class="page-content">
                    <!-- POS Title & Action Bar -->
                    <div class="pos-title-bar d-flex justify-content-between align-items-center">
                        <h1>Bán Hàng Tại Quầy</h1>
                        <button type="button" class="btn-outline-red" id="btnCreateInvoice">
                            <i class="bi bi-plus-circle"></i> Tạo hóa đơn chờ
                        </button>
                    </div>

                    <!-- 2-Column Layout -->
                    <div class="pos-layout">
                        <!-- LEFT COLUMN: Invoices & Products -->
                        <div class="pos-left">
                            <div class="content-card">
                                <!-- Tabs -->
                                <div class="pos-tabs" id="invoiceTabs">
                                    <button class="pos-tab active" data-id="HDMKTI">
                                        HDMKTI <span class="tab-close" title="Xóa hóa đơn">&times;</span>
                                    </button>
                                    <button class="pos-tab" data-id="HDSLA1">
                                        HDSLA1 <span class="tab-close" title="Xóa hóa đơn">&times;</span>
                                    </button>
                                </div>

                                <!-- Invoice Header -->
                                <div class="pos-invoice-header">
                                    <h3 id="currentInvoiceTitle">Hóa đơn HDMKTI</h3>
                                    <div>
                                        <button type="button" class="btn-outline-blue" id="btnOpenAddProduct">
                                            <i class="bi bi-plus-lg"></i> Thêm Sản Phẩm
                                        </button>
                                        <button type="button" class="btn-outline-red ms-2" id="btnOpenQRScanner" title="Quét QR Code bằng Webcam">
                                            <i class="bi bi-qr-code-scan"></i> Quét QR Camera
                                        </button>
                                    </div>
                                </div>

                                <!-- Cart Table -->
                                <div class="table-responsive">
                                    <table class="pos-cart-table">
                                        <thead>
                                            <tr>
                                                <th>Sản phẩm</th>
                                                <th style="width: 100px;">Số lượng</th>
                                                <th style="width: 60px;">Kho</th>
                                                <th>Giá hiện tại</th>
                                                <th>Giá được tính</th>
                                                <th>Tổng</th>
                                                <th style="width: 40px;"></th>
                                            </tr>
                                        </thead>
                                        <tbody id="cartTableBody">
                                            <!-- Product Item 1 -->
                                            <tr data-id="SP01" data-price="2500000">
                                                <td>
                                                    <div class="product-cell">
                                                        <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100&q=80" alt="Giày chạy bộ">
                                                        <div class="product-info">
                                                            <h4>Nike Air Zoom Pegasus 40</h4>
                                                            <p>Màu: Đỏ | Size: 42</p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="qty-control-pos">
                                                        <button type="button" class="qty-btn-pos btn-minus">-</button>
                                                        <input type="text" class="qty-value-pos" value="1" readonly>
                                                        <button type="button" class="qty-btn-pos btn-plus">+</button>
                                                    </div>
                                                </td>
                                                <td>45</td>
                                                <td class="price-col">2.500.000đ</td>
                                                <td class="price-col">2.500.000đ</td>
                                                <td class="total-col item-total">2.500.000đ</td>
                                                <td>
                                                    <button type="button" class="btn-delete" title="Xóa sản phẩm">
                                                        <i class="bi bi-trash3-fill"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <!-- Product Item 2 -->
                                            <tr data-id="SP02" data-price="3200000">
                                                <td>
                                                    <div class="product-cell">
                                                        <img src="https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=100&q=80" alt="Giày chạy bộ">
                                                        <div class="product-info">
                                                            <h4>Adidas Ultraboost Light</h4>
                                                            <p>Màu: Trắng | Size: 41</p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="qty-control-pos">
                                                        <button type="button" class="qty-btn-pos btn-minus">-</button>
                                                        <input type="text" class="qty-value-pos" value="1" readonly>
                                                        <button type="button" class="qty-btn-pos btn-plus">+</button>
                                                    </div>
                                                </td>
                                                <td>28</td>
                                                <td class="price-col">3.200.000đ</td>
                                                <td class="price-col">3.200.000đ</td>
                                                <td class="total-col item-total">3.200.000đ</td>
                                                <td>
                                                    <button type="button" class="btn-delete" title="Xóa sản phẩm">
                                                        <i class="bi bi-trash3-fill"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- RIGHT COLUMN: Customer & Payment -->
                        <div class="pos-right">
                            <!-- Customer Info Card -->
                            <div class="pos-sidebar-card">
                                <h3>Thông tin khách hàng</h3>
                                <div class="card-inner mb-3">
                                    <label for="selectCustomer">Khách hàng</label>
                                    <div class="d-flex gap-2">
                                        <select class="pos-select" id="selectCustomer" style="width: 100%;">
                                            <option value="khach-le" selected>Khách lẻ</option>
                                            <option value="KH001">Nguyễn Thị Hương - 0961234567</option>
                                            <option value="KH002">Trần Minh Quang - 0972345678</option>
                                        </select>
                                        <button type="button" class="btn-outline-blue" style="padding: 0 12px;" id="btnOpenAddCustomer" title="Thêm khách hàng mới">
                                            <i class="bi bi-person-plus-fill"></i>
                                        </button>
                                    </div>
                                </div>

                                <h3>Phiếu giảm giá</h3>
                                <input type="text" class="pos-voucher-input" id="inputVoucherCode" placeholder="Hãy nhập mã phiếu giảm giá">
                                
                                <div class="pos-voucher-card" id="activeVoucherCard">
                                    <div class="voucher-label">
                                        <i class="bi bi-ticket-perforated-fill"></i>
                                        <span>KM002 - 500.000 VNĐ</span>
                                    </div>
                                    <div style="font-size: 11px; color: var(--light-text);">
                                        Tối đa 2.000.000 VNĐ - Đơn từ 5.000.000 VNĐ
                                    </div>
                                </div>

                                <!-- Payment Methods -->
                                <div class="pos-radio-group">
                                    <label class="group-title">Hình thức thanh toán</label>
                                    <div class="pos-radio-options">
                                        <label class="radio-option">
                                            <input type="radio" name="paymentMethod" value="tien-mat" checked> Tiền mặt
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="paymentMethod" value="chuyen-khoan"> Chuyển khoản
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Summary Card -->
                            <div class="pos-payment-summary">
                                <div class="summary-row">
                                    <span class="label">Tổng tiền</span>
                                    <span class="value" id="summarySubtotal">5.700.000đ</span>
                                </div>
                                <div class="summary-row">
                                    <span class="label">Số tiền giảm</span>
                                    <span class="value discount" id="summaryDiscount">-500.000đ</span>
                                </div>
                                <div class="summary-row total">
                                    <span class="label">Tổng tiền sau giảm</span>
                                    <span class="value" id="summaryTotal">5.200.000đ</span>
                                </div>
                                <button type="button" class="btn-success-custom" id="btnPay">
                                    Thanh Toán
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL 1: Thêm Sản Phẩm -->
        <div class="modal-overlay product-select-modal" id="modalAddProduct">
            <div class="modal-box">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="mb-0">Chọn sản phẩm</h2>
                    <button type="button" class="btn-close" id="btnCloseAddProduct" aria-label="Close"></button>
                </div>
                <div class="search-bar mb-3" style="box-shadow: none; padding: 0;">
                    <input type="text" class="search-input" placeholder="Tìm tên sản phẩm, mã SP..." id="searchProductModal">
                    <button class="btn-primary-blue" type="button"><i class="bi bi-search"></i></button>
                </div>
                <div class="product-select-grid" id="productGrid">
                    <!-- Sample Product 1 -->
                    <div class="product-select-item" data-id="SP03" data-name="Nike Vaporfly 3" data-price="6500000" data-img="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=200&q=80">
                        <img src="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=200&q=80" alt="Nike Vaporfly">
                        <h4>Nike Vaporfly 3</h4>
                        <div class="price">6.500.000đ</div>
                        <div class="variant-select-row justify-content-center">
                            <select class="select-color"><option>Màu: Xanh</option><option>Màu: Cam</option></select>
                            <select class="select-size"><option>40</option><option>41</option><option>42</option></select>
                        </div>
                    </div>
                    <!-- Sample Product 2 -->
                    <div class="product-select-item" data-id="SP04" data-name="Adidas Adizero Adios Pro 3" data-price="6000000" data-img="https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=200&q=80">
                        <img src="https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=200&q=80" alt="Adidas Adizero">
                        <h4>Adidas Adizero Adios Pro 3</h4>
                        <div class="price">6.000.000đ</div>
                        <div class="variant-select-row justify-content-center">
                            <select class="select-color"><option>Màu: Đen</option><option>Màu: Trắng</option></select>
                            <select class="select-size"><option>39</option><option>40</option><option>41</option><option>42</option></select>
                        </div>
                    </div>
                    <!-- Sample Product 3 -->
                    <div class="product-select-item" data-id="SP05" data-name="Asics Gel-Nimbus 26" data-price="4200000" data-img="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=200&q=80">
                        <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=200&q=80" alt="Asics Gel-Nimbus">
                        <h4>Asics Gel-Nimbus 26</h4>
                        <div class="price">4.200.000đ</div>
                        <div class="variant-select-row justify-content-center">
                            <select class="select-color"><option>Màu: Xám</option><option>Màu: Đen</option></select>
                            <select class="select-size"><option>41</option><option>42</option><option>43</option></select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL QR SCANNER: Quét mã QR sản phẩm bằng Webcam -->
        <div class="modal-overlay" id="modalQRScanner">
            <div class="modal-box" style="max-width: 520px; text-align: center; padding: 24px;">
                <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                    <h3 class="mb-0 fw-bold d-flex align-items-center gap-2 text-danger">
                        <i class="bi bi-qr-code-scan"></i> Quét QR Sản Phẩm (POS)
                    </h3>
                    <button type="button" class="btn-close" id="btnCloseQRScanner" aria-label="Close"></button>
                </div>
                <p class="text-muted small mb-3">Đưa mã QR trên tem dán hộp giày vào trước Camera để tự động nhận diện & thêm vào hóa đơn.</p>
                
                <!-- Camera Reader Viewport -->
                <div id="qr-reader" class="mx-auto border rounded-4 overflow-hidden shadow-sm bg-dark" style="width: 100%; max-width: 440px; min-height: 280px;"></div>
                <div id="qr-reader-status" class="mt-3 fw-bold text-primary small"></div>
                
                <!-- Thêm thủ công / Giả lập nhanh (Hỗ trợ test & nhập mã trực tiếp) -->
                <div class="mt-4 pt-3 border-top text-start">
                    <label class="form-label small fw-semibold text-secondary">Hoặc nhập mã SKU (Súng bắn QR / Gõ tay):</label>
                    <div class="d-flex gap-2">
                        <input type="text" id="inputManualSKU" class="form-control" placeholder="VD: SPCT1, SP03, SP04...">
                        <button type="button" class="btn btn-runmax px-3 text-nowrap" id="btnSubmitManualSKU">
                            <i class="bi bi-plus-lg"></i> Thêm ngay
                        </button>
                    </div>
                    <div class="d-flex gap-1 flex-wrap mt-2 align-items-center">
                        <span class="small text-muted me-1">Test mẫu nhanh:</span>
                        <span class="badge bg-secondary-subtle text-dark border badge-test-sku px-2 py-1" style="cursor: pointer;" onclick="handleQRScanSuccess('SPCT1')">SPCT1</span>
                        <span class="badge bg-secondary-subtle text-dark border badge-test-sku px-2 py-1" style="cursor: pointer;" onclick="handleQRScanSuccess('SPCT2')">SPCT2</span>
                        <span class="badge bg-secondary-subtle text-dark border badge-test-sku px-2 py-1" style="cursor: pointer;" onclick="handleQRScanSuccess('SP03')">SP03</span>
                        <span class="badge bg-secondary-subtle text-dark border badge-test-sku px-2 py-1" style="cursor: pointer;" onclick="handleQRScanSuccess('SP04')">SP04</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL 2: Xác nhận thanh toán -->
        <div class="modal-overlay" id="modalConfirmPayment">
            <div class="modal-box text-center">
                <h2>Vui lòng xác nhận</h2>
                <p style="font-size: 16px; margin: 16px 0 24px; color: var(--dark-text); font-weight: 500;">Xác nhận thanh toán ?</p>
                <div class="modal-actions justify-content-center">
                    <button type="button" class="btn-modal-cancel" id="btnCancelConfirm">Hủy</button>
                    <button type="button" class="btn-modal-confirm" id="btnAgreePayment">Đồng ý</button>
                </div>
            </div>
        </div>

        <!-- MODAL THÊM KHÁCH MỚI -->
        <div class="modal-overlay" id="modalAddCustomer">
            <div class="modal-box" style="max-width: 400px;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="mb-0">Thêm khách hàng</h3>
                    <button type="button" class="btn-close" id="btnCloseAddCustomer" aria-label="Close"></button>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tên khách hàng <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="newCustomerName" placeholder="Nhập tên">
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="newCustomerPhone" placeholder="Nhập SĐT">
                </div>
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button type="button" class="btn-modal-cancel" id="btnCancelAddCustomer">Hủy</button>
                    <button type="button" class="btn-modal-confirm" id="btnSaveCustomer">Lưu</button>
                </div>
            </div>
        </div>

        <!-- MODAL 3: Hóa đơn bán hàng (Receipt) -->
        <div class="modal-overlay receipt-modal" id="modalReceipt">
            <div class="modal-box">
                <div class="receipt-content">
                    <!-- Logo / Header -->
                    <div style="font-size: 26px; font-weight: 900; color: var(--primary-red); margin-bottom: 4px;">RUNMAX</div>
                    <div style="font-size: 12px; color: var(--medium-text); margin-bottom: 20px;">Hệ thống giày chạy bộ chính hãng</div>
                    
                    <h2>Hóa Đơn Bán Hàng</h2>
                    
                    <div class="receipt-info">
                        <div class="info-row"><span class="label">Mã hóa đơn:</span> <span id="receiptCode">HDMKTI</span></div>
                        <div class="info-row"><span class="label">Ngày tạo:</span> <span id="receiptDate">08/07/2026 14:30</span></div>
                        <div class="info-row"><span class="label">Khách hàng:</span> <span id="receiptCustomer">Khách lẻ</span></div>
                        <div class="info-row"><span class="label">Thu ngân:</span> <span>Nguyễn Văn An (NV001)</span></div>
                        <div class="info-row"><span class="label">Hình thức TT:</span> <span id="receiptPaymentMethod">Tiền mặt</span></div>
                    </div>

                    <table class="receipt-table">
                        <thead>
                            <tr>
                                <th>Tên sản phẩm</th>
                                <th style="text-align: center;">SL</th>
                                <th style="text-align: right;">Đơn giá</th>
                                <th style="text-align: right;">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody id="receiptTableBody">
                            <tr>
                                <td>Nike Air Zoom Pegasus 40<br><small style="color: #666;">Đỏ / Size 42</small></td>
                                <td style="text-align: center;">1</td>
                                <td style="text-align: right;">2.500.000đ</td>
                                <td style="text-align: right;">2.500.000đ</td>
                            </tr>
                            <tr>
                                <td>Adidas Ultraboost Light<br><small style="color: #666;">Trắng / Size 41</small></td>
                                <td style="text-align: center;">1</td>
                                <td style="text-align: right;">3.200.000đ</td>
                                <td style="text-align: right;">3.200.000đ</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="receipt-totals">
                        <div class="total-row"><span>Tổng tiền hàng:</span> <span id="receiptSubtotal">5.700.000đ</span></div>
                        <div class="total-row"><span>Giám giá voucher:</span> <span id="receiptDiscount">-500.000đ</span></div>
                        <div class="total-row grand-total"><span>TỔNG THANH TOÁN:</span> <span id="receiptGrandTotal">5.200.000đ</span></div>
                    </div>

                    <div class="receipt-footer">
                        Cảm ơn quý khách và hẹn gặp lại!<br>
                        <small style="color: #888; font-weight: 400;">Hotline hỗ trợ: 1900 1234 - Website: runmax.vn</small>
                    </div>

                    <div class="mt-4">
                        <button type="button" class="btn-submit w-100" id="btnFinishReceipt">Hoàn Tất</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- HTML5 QR Code Scanner Library -->
        <script src="https://unpkg.com/html5-qrcode"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/ban-hang-tai-quay.js"></script>
    </body>

    </html>
