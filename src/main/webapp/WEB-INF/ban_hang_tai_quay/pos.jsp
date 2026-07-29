<%-- 
  QUẦY BÁN HÀNG TẠI QUẦY POS (/ban-hang)
  - Keyword search GG: "JSTL c:forEach dynamic table", "HTML Form action POST to Servlet"
  - Nhiệm vụ & Bố cục chia làm 3 cột chính:
    1. Cột Trái (Danh sách đơn chờ): Tạo đơn mới (action=tao-don), chuyển đổi giữa các đơn đang mở.
    2. Cột Giữa (Kho giày & Giỏ hàng): Tìm kiếm sản phẩm, bấm Thêm vào giỏ (action=them-sp), chỉnh sửa số lượng hoặc xóa sản phẩm khỏi giỏ.
    3. Cột Phải (Thanh toán): Áp dụng mã Voucher giảm giá (action=ap-pgg), tính tổng tiền và bấm Thanh Toán Hoàn Tất (submit tới /ban-hang?action=thanh-toan).
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quầy POS Bán Giày Chạy Bộ Nam RunMax" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <c:choose>
                            <c:when test="${param.error == 'max-pending'}">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i><b>Đã đạt giới hạn tối đa!</b> Hệ thống chỉ cho phép tối đa <b>10 hóa đơn đang chờ</b> tại quầy để tránh spam và dễ kiểm soát. Vui lòng thanh toán hoặc hủy bớt các đơn chờ cũ trước khi tạo thêm đơn mới!
                            </c:when>
                            <c:when test="${param.error == 'sl-vuot-ton'}">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i><b>Thêm sản phẩm thất bại:</b> Số lượng vượt quá tồn kho hiện tại!
                            </c:when>
                            <c:when test="${param.error == 'tao-don-that-bai'}">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i><b>Tạo hóa đơn thất bại:</b> Vui lòng thử lại sau!
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>Có lỗi xảy ra (${param.error}).
                            </c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- KHUNG POS CHÍNH (2 CỘT) -->
                <div class="row g-4">
                    <!-- CỘT TRÁI: HÓA ĐƠN CHỜ & GIỎ HÀNG & TÌM KIẾM GIÀY -->
                    <div class="col-lg-8">
                        <!-- 1. Danh sách Hóa đơn chờ (Tabs) -->
                        <div class="runmax-card p-3 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-receipt text-danger"></i> ĐƠN HÀNG ĐANG GIAO DỊCH TẠI QUẦY
                                    <c:if test="${isQuanLy}">
                                        <span class="badge bg-warning text-dark ms-1" title="Quản lý xem được toàn bộ đơn chờ của tất cả nhân viên">
                                            <i class="bi bi-shield-check me-1"></i>Tất cả nhân viên
                                        </span>
                                    </c:if>
                                    <span class="badge ${fn:length(pendingOrders) >= 10 ? 'bg-danger text-white' : 'bg-light text-dark border'} ms-1" title="Giới hạn tối đa 10 hóa đơn chờ">
                                        <i class="bi bi-stack me-1"></i>Đang chờ: ${fn:length(pendingOrders)}/10
                                    </span>
                                </h6>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${fn:length(pendingOrders) >= 10}">
                                            <button type="button" class="btn btn-sm btn-secondary text-white-50 opacity-75" onclick="alert('Hệ thống giới hạn tối đa 10 hóa đơn đang chờ tại quầy để tránh spam và dễ quản lý! Vui lòng thanh toán hoặc hủy bớt các đơn chờ cũ trước khi tạo mới.')" title="Đã đạt giới hạn tối đa 10 hóa đơn chờ">
                                                <i class="bi bi-exclamation-octagon me-1"></i> Đạt giới hạn (10/10)
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/ban-hang" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="tao-don">
                                                <button type="submit" class="btn btn-sm btn-runmax">
                                                    <i class="bi bi-plus-lg"></i> Tạo hóa đơn mới
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                    <button type="button" class="btn btn-sm btn-outline-danger fw-bold d-inline-flex align-items-center gap-1" onclick="openInvoiceLookupQRModal()" title="Quét mã QR tờ hóa đơn để kiểm tra / đổi trả">
                                        <i class="bi bi-qr-code-scan"></i> Quét QR Hóa Đơn
                                    </button>
                                </div>
                            </div>

                            <ul class="nav nav-pills gap-2 flex-wrap">
                                <c:forEach var="hd" items="${pendingOrders}">
                                    <li class="nav-item">
                                        <a class="nav-link ${currentHd != null && currentHd.id == hd.id ? 'active bg-danger' : 'bg-light text-dark border'}"
                                           href="${pageContext.request.contextPath}/ban-hang?hdId=${hd.id}"
                                           title="${isQuanLy ? 'NV: '.concat(hd.nhanVien != null ? hd.nhanVien.hoTen : 'N/A') : ''}">
                                            <i class="bi bi-tag-fill me-1"></i> ${hd.maHd}
                                            <span class="badge bg-secondary ms-1">${hd.tenKhachHangHienThi}</span>
                                            <c:if test="${isQuanLy}">
                                                <span class="badge bg-info text-dark ms-1" style="font-size:0.65rem;">
                                                    <i class="bi bi-person-fill"></i> ${hd.nhanVien != null ? hd.nhanVien.hoTen : '?'}
                                                </span>
                                            </c:if>
                                        </a>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty pendingOrders}">
                                    <li class="text-muted small">Chưa có hóa đơn nào đang chờ. Nhấn "Tạo hóa đơn mới" để bắt đầu!</li>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 3. Chi tiết giỏ hàng trong Hóa đơn hiện tại -->
                        <div class="runmax-card p-4" id="pos-cart-container">
                            <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                <h6 class="fw-bold text-dark mb-0">
                                    <i class="bi bi-bag-check-fill text-danger me-1"></i> CHI TIẾT SẢN PHẨM TRONG ĐƠN:
                                    <span class="text-danger">${currentHd != null ? currentHd.maHd : 'Chưa chọn'}</span>
                                </h6>
                                <c:if test="${currentHd != null && not empty chiTiets}">
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-danger fw-bold d-flex align-items-center gap-2 px-3 py-2 shadow-sm" onclick="openSearchModal()" style="border-radius: 8px; font-size: 0.95rem;">
                                            <i class="bi bi-search fs-5"></i> Thêm Sản Phẩm
                                        </button>
                                        <button type="button" class="btn btn-danger fw-bold d-flex align-items-center gap-2 px-3 py-2 shadow-sm" onclick="openInvoiceScanQRModal('${currentHd.id}')" style="border-radius: 8px; font-size: 0.95rem;">
                                            <i class="bi bi-qr-code-scan fs-5"></i> Quét QR
                                        </button>
                                    </div>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${currentHd != null}">
                                    <c:choose>
                                        <c:when test="${empty chiTiets}">
                                            <!-- TRẠNG THÁI TRỐNG (EMPTY STATE) -->
                                            <div class="text-center py-5">
                                                <div class="mb-3">
                                                    <i class="bi bi-cart-x text-muted opacity-25" style="font-size: 5rem;"></i>
                                                </div>
                                                <h5 class="fw-bold text-dark mb-2">Giỏ hàng đang trống</h5>
                                                <p class="text-muted mb-4">Hóa đơn <b class="text-danger">${currentHd.maHd}</b> chưa có sản phẩm nào.<br>Hãy tìm kiếm hoặc quét QR để thêm sản phẩm vào giỏ.</p>
                                                <div class="d-flex justify-content-center gap-3">
                                                    <button type="button" class="btn btn-lg btn-outline-danger fw-bold px-4 shadow-sm" style="border-radius: 12px;" onclick="openSearchModal()">
                                                        <i class="bi bi-search me-2"></i>Tìm & Thêm Sản Phẩm
                                                    </button>
                                                    <button type="button" class="btn btn-lg btn-danger fw-bold px-4 shadow-sm" style="border-radius: 12px;" onclick="openInvoiceScanQRModal('${currentHd.id}')">
                                                        <i class="bi bi-qr-code-scan me-2"></i>Quét QR Camera
                                                    </button>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive" style="min-height: 250px;">
                                                <table class="table table-hover align-middle mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>#</th>
                                                            <th>Tên Giày Nam Chạy Bộ</th>
                                                            <th>Size / Màu / Đế / Chất liệu</th>
                                                            <th>Đơn giá</th>
                                                            <th>Số lượng</th>
                                                            <th>Thành tiền</th>
                                                            <th>Xóa</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="ct" items="${chiTiets}" varStatus="stt">
                                                            <tr>
                                                                <td>${stt.index + 1}</td>
                                                                <td class="fw-bold">
                                                                    <span class="badge bg-secondary me-1">${ct.sanPhamChiTiet.sanPham.thuongHieu != null ? ct.sanPhamChiTiet.sanPham.thuongHieu.ten : ''}</span>
                                                                    ${ct.sanPhamChiTiet.sanPham.tenSp}
                                                                    <small class="text-muted d-block fw-normal">[Mã: ${ct.sanPhamChiTiet.sanPham.maSp}]</small>
                                                                </td>
                                                                <td>
                                                                    <div class="mb-1">Size <b>${ct.sanPhamChiTiet.kichCo.ten}</b> | ${ct.sanPhamChiTiet.mauSac.ten}</div>
                                                                    <span class="badge bg-info text-dark bg-opacity-10 border border-info" style="font-size: 0.7rem;">Đế: ${ct.sanPhamChiTiet.deGiay.ten}</span>
                                                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary" style="font-size: 0.7rem;">Chất liệu: ${ct.sanPhamChiTiet.sanPham.chatLieu.ten}</span>
                                                                </td>
                                                                <td class="text-danger fw-semibold"><fmt:formatNumber value="${ct.donGia}" type="number"/> đ</td>
                                                                <td style="width: 140px;">
                                                                    <form action="${pageContext.request.contextPath}/ban-hang" method="POST" class="d-flex align-items-center justify-content-center m-0" onsubmit="attachPosCustomerInfoToForm(this)">
                                                                        <input type="hidden" name="action" value="cap-nhat-sl">
                                                                        <input type="hidden" name="hdId" value="${currentHd.id}">
                                                                        <input type="hidden" name="chiTietId" value="${ct.id}">
                                                                        <div class="input-group input-group-sm" style="width: 125px;">
                                                                            <button type="button" class="btn btn-outline-secondary px-2 fw-bold" onclick="var inp = this.parentNode.querySelector('input'); var val = parseInt(inp.value||1); if(val > 1) { inp.value = val - 1; submitPosFormWithCustomer(inp.form); } else { showBootstrapConfirm('Bạn có chắc muốn xóa sản phẩm này khỏi đơn?', function() { inp.value = 0; submitPosFormWithCustomer(inp.form); }); }" title="Giảm số lượng">-</button>
                                                                            <input type="number" name="soLuong" class="form-control text-center fw-bold px-1" value="${ct.soLuong}" min="1" max="${ct.sanPhamChiTiet.soLuongKhaDung + ct.soLuong}" onchange="if(parseInt(this.value) <= 0) { var inp=this; showBootstrapConfirm('Bạn có chắc muốn xóa sản phẩm này?', function() { submitPosFormWithCustomer(inp.form); }); } else { submitPosFormWithCustomer(this.form); }">
                                                                            <button type="button" class="btn btn-outline-secondary px-2 fw-bold" onclick="var inp = this.parentNode.querySelector('input'); var max = parseInt(inp.getAttribute('max') || 9999); var val = parseInt(inp.value||1); if(val < max) { inp.value = val + 1; submitPosFormWithCustomer(inp.form); } else { showBootstrapAlert('Số lượng vượt quá tồn kho khả dụng hiện tại (' + max + ')!', 'warning'); }" title="Tăng số lượng">+</button>
                                                                        </div>
                                                                    </form>
                                                                </td>
                                                                <td class="fw-bold text-danger">
                                                                    <fmt:formatNumber value="${ct.thanhTien}" type="number"/> đ
                                                                </td>
                                                                <td>
                                                                    <form action="${pageContext.request.contextPath}/ban-hang" method="POST" onsubmit="attachPosCustomerInfoToForm(this)">
                                                                        <input type="hidden" name="action" value="xoa-sp">
                                                                        <input type="hidden" name="hdId" value="${currentHd.id}">
                                                                        <input type="hidden" name="chiTietId" value="${ct.id}">
                                                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash3"></i></button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <!-- CHƯA CHỌN HÓA ĐƠN -->
                                    <div class="text-center py-5">
                                        <div class="mb-3">
                                            <i class="bi bi-receipt text-muted opacity-25" style="font-size: 5rem;"></i>
                                        </div>
                                        <h5 class="fw-bold text-dark mb-2">Chưa chọn Hóa Đơn</h5>
                                        <p class="text-muted mb-0">Vui lòng chọn 1 hóa đơn đang chờ bên cột trái, hoặc nhấn <b class="text-danger">Tạo hóa đơn mới</b> để bắt đầu bán hàng.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- CỘT PHẢI: THÔNG TIN THANH TOÁN POS -->
                    <div class="col-lg-4">
                        <div class="runmax-card p-4" id="pos-payment-block">
                            <h6 class="fw-bold text-dark border-bottom pb-3 mb-3">
                                <i class="bi bi-wallet2 text-danger me-1"></i> THANH TOÁN ĐƠN HÀNG
                            </h6>

                            <c:choose>
                                <c:when test="${currentHd != null}">
                                    <form action="${pageContext.request.contextPath}/ban-hang" method="POST" class="needs-validation" novalidate onsubmit="return validateThanhToanPOS(event, ${empty chiTiets ? 0 : chiTiets.size()})">
                                        <input type="hidden" name="action" value="thanh-toan">
                                        <input type="hidden" name="hdId" value="${currentHd.id}">

                                        <div class="mb-3 position-relative">
                                            <label class="form-label small fw-semibold text-muted">Số điện thoại tích điểm</label>
                                            <input type="text" name="sdt" id="posInputSdt" class="form-control"
                                                   value="${currentHd.khachHang != null ? currentHd.khachHang.sdt : ''}" placeholder="Nhập SĐT khách hàng (10 số)..." maxlength="11" pattern="[0-9]{10,11}" autocomplete="off">
                                            <ul class="dropdown-menu w-100 shadow-sm" id="sdtSuggestions" style="display: none; max-height: 200px; overflow-y: auto; position: absolute; z-index: 1000;"></ul>
                                        </div>

                                        <div class="mb-3" id="khNameBlock" style="${currentHd.khachHang == null ? 'display: none;' : ''}">
                                            <label class="form-label small fw-semibold text-muted">Tên khách hàng Runner</label>
                                            <div class="input-group">
                                                <input type="text" name="tenKhachHang" id="posInputTenKh" class="form-control"
                                                       value="${currentHd.khachHang != null ? currentHd.khachHang.hoTen : ''}"
                                                       placeholder="Nhập tên khách hàng mới..."
                                                       onkeydown="if(event.key === 'Enter') { event.preventDefault(); document.getElementById('btnQuickAddKh').click(); }">
                                                <button type="button" id="btnQuickAddKh" class="btn btn-danger fw-bold px-3" style="display: none;" onclick="quickAddKhachHang(document.getElementById('posInputSdt').value)">
                                                    <i class="bi bi-person-plus-fill me-1"></i> Lưu Nhanh
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Chọn và Áp Dụng Phiếu Giảm Giá -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Mã Giảm Giá / Voucher</label>
                                            <input type="hidden" id="selectPgg" value="${currentHd.phieuGiamGia != null ? currentHd.phieuGiamGia.id : ''}">
                                            
                                            <c:choose>
                                                <c:when test="${currentHd.phieuGiamGia != null}">
                                                    <div class="voucher-ticket active mb-0" style="cursor: default;">
                                                        <style>
                                                            /* Overrides for mini ticket on white background */
                                                            .mini-ticket-bg::before, .mini-ticket-bg::after { background: #fff !important; }
                                                        </style>
                                                        <div class="voucher-ticket mini-ticket-bg w-100 m-0" style="height: 65px; border: 1px solid #198754; box-shadow: 0 0 0 2px rgba(25,135,84,0.1);">
                                                            <div class="voucher-left bg-success bg-opacity-10 text-success d-flex flex-column justify-content-center align-items-center border-end border-success border-opacity-25" style="width: 30%;">
                                                                <span class="fs-5 fw-bold">
                                                                    <c:choose>
                                                                        <c:when test="${currentHd.phieuGiamGia.loaiGiam == 1}">
                                                                            <fmt:formatNumber value="${currentHd.phieuGiamGia.giaTrigiam}" type="number" maxFractionDigits="0"/>%
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <fmt:formatNumber value="${currentHd.phieuGiamGia.giaTrigiam / 1000}" type="number" maxFractionDigits="0"/>K
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                            <div class="voucher-right flex-grow-1 p-2 d-flex flex-column justify-content-center position-relative">
                                                                <div class="fw-bold text-success mb-1" style="font-size: 0.9rem;">
                                                                    <i class="bi bi-ticket-perforated-fill me-1"></i>${currentHd.phieuGiamGia.maPhieu}
                                                                </div>
                                                                <div class="small text-muted" style="font-size: 0.75rem;">
                                                                    Đơn từ <fmt:formatNumber value="${currentHd.phieuGiamGia.dieuKienGiam}" type="number"/>đ
                                                                </div>
                                                                <button type="button" class="btn-close btn-sm position-absolute top-50 end-0 translate-middle-y me-2" aria-label="Close" title="Gỡ Voucher" onclick="document.getElementById('selectPgg').value=''; apDungVoucherPOS(${currentHd.id});"></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-outline-danger w-100 fw-bold d-flex align-items-center justify-content-center gap-2" style="border-style: dashed; padding: 10px;" onclick="new bootstrap.Modal(document.getElementById('modalVoucherPicker')).show()">
                                                        <i class="bi bi-ticket-perforated"></i> Chọn Mã Giảm Giá
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Tính toán tổng tiền -->
                                        <div class="bg-light p-3 rounded-3 mb-4">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="text-muted">Tổng tiền hàng:</span>
                                                <span class="fw-semibold">
                                                    <fmt:formatNumber value="${currentHd.tienHang != null ? currentHd.tienHang : 0}" type="number"/> đ
                                                </span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="text-muted">Giảm giá voucher:</span>
                                                <span class="text-success fw-semibold">
                                                    - <fmt:formatNumber value="${currentHd.soTienGiam != null ? currentHd.soTienGiam : 0}" type="number"/> đ
                                                </span>
                                            </div>
                                            <hr class="my-2">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="fw-bold text-dark">KHÁCH PHẢI TRẢ:</span>
                                                <span class="fw-bold text-danger fs-5">
                                                    <fmt:formatNumber value="${currentHd.tongTien != null ? currentHd.tongTien : 0}" type="number"/> đ
                                                </span>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Phương thức thanh toán</label>
                                            <select name="ptttId" class="form-select" onchange="handlePtttChange(this)">
                                                <option value="1">Tiền mặt tại quầy</option>
                                                <option value="2">Chuyển khoản QR Code</option>
                                            </select>
                                        </div>

                                        <button type="submit" class="btn btn-runmax w-100 py-3 fw-bold fs-6 mb-2">
                                            <i class="bi bi-check-circle-fill me-1"></i> HOÀN TẤT & THANH TOÁN
                                        </button>
                                        <button type="button" class="btn btn-outline-danger w-100 py-2 fw-semibold" onclick="xoaDonChoPOS(${currentHd.id})">
                                            <i class="bi bi-trash3 me-1"></i> Xóa Đơn Chờ Này
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted small text-center my-4">Chưa có hóa đơn nào được chọn.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Form ẩn cho thao tác POS -->
    <form id="posActionForm" action="${pageContext.request.contextPath}/ban-hang" method="POST" style="display:none;">
        <input type="hidden" name="action" id="posActionInput">
        <input type="hidden" name="hdId" id="posHdIdInput">
        <input type="hidden" name="phieuGiamGiaId" id="posPggIdInput">
        <input type="hidden" name="sdt" id="posSdtInput">
        <input type="hidden" name="tenKhachHang" id="posTenKhInput">
    </form>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function attachPosCustomerInfoToForm(form) {
            if (!form) return;
            const sdtInput = document.getElementById('posInputSdt');
            const tenKhInput = document.getElementById('posInputTenKh');
            if (sdtInput && tenKhInput) {
                let sdtHidden = form.querySelector('input[name="sdt"]');
                if (!sdtHidden) {
                    sdtHidden = document.createElement('input');
                    sdtHidden.type = 'hidden';
                    sdtHidden.name = 'sdt';
                    form.appendChild(sdtHidden);
                }
                sdtHidden.value = sdtInput.value.trim();

                let tenKhHidden = form.querySelector('input[name="tenKhachHang"]');
                if (!tenKhHidden) {
                    tenKhHidden = document.createElement('input');
                    tenKhHidden.type = 'hidden';
                    tenKhHidden.name = 'tenKhachHang';
                    form.appendChild(tenKhHidden);
                }
                tenKhHidden.value = tenKhInput.value.trim();
            }
        }

        function submitPosFormWithCustomer(form) {
            if (!form) return;
            attachPosCustomerInfoToForm(form);
            form.submit();
        }

        function autoSaveKhachHangPOS() {
            const hdId = ${currentHd != null ? currentHd.id : 'null'};
            if (!hdId) return;
            const sdtInput = document.getElementById('posInputSdt');
            const tenKhInput = document.getElementById('posInputTenKh');
            if (!sdtInput || !tenKhInput) return;
            const sdt = sdtInput.value.trim();
            const tenKh = tenKhInput.value.trim();
            fetch('${pageContext.request.contextPath}/ban-hang?action=save-kh-ajax&hdId=' + hdId + '&sdt=' + encodeURIComponent(sdt) + '&tenKhachHang=' + encodeURIComponent(tenKh))
                .catch(err => console.error('Lỗi tự động lưu thông tin khách:', err));
        }

        document.addEventListener('submit', function(event) {
            attachPosCustomerInfoToForm(event.target);
        });

        function validateThanhToanPOS(event, chiTietCount) {
            // Ngăn chặn form submit mặc định để dùng hộp thoại bất đồng bộ
            event.preventDefault();
            event.stopPropagation();

            if (chiTietCount <= 0) {
                showBootstrapAlert('Hóa đơn hiện tại chưa có sản phẩm nào. Vui lòng chọn ít nhất 1 sản phẩm vào đơn!', 'warning');
                return false;
            }
            
            const form = event.target;
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return false;
            }
            form.classList.add('was-validated');
            
            // Gọi custom bootstrap confirm thay vì trình duyệt mặc định
            showBootstrapConfirm('Bạn có chắc chắn muốn chốt đơn này?', function() {
                submitPosFormWithCustomer(form);
            });
            
            return false;
        }

        function apDungVoucherPOS(hdId) {
            if (!hdId) {
                showBootstrapAlert('Vui lòng chọn hoặc tạo hóa đơn đang chờ trước khi áp dụng voucher!', 'warning');
                return;
            }
            const chiTietCount = ${empty chiTiets ? 0 : chiTiets.size()};
            const selectPgg = document.getElementById('selectPgg');
            if (chiTietCount <= 0 && selectPgg && selectPgg.value !== '') {
                showBootstrapAlert('Đơn hàng chưa có sản phẩm nào để áp dụng giảm giá!', 'warning');
                return;
            }
            const sdtInput = document.getElementById('posInputSdt');
            const tenKhInput = document.getElementById('posInputTenKh');
            if (sdtInput && sdtInput.value.trim() !== '' && !/^[0-9]{10,11}$/.test(sdtInput.value.trim())) {
                showBootstrapAlert('Số điện thoại phải từ 10 đến 11 chữ số hợp lệ!', 'warning');
                if (sdtInput.focus) sdtInput.focus();
                return;
            }
            const formData = new URLSearchParams();
            formData.append('action', 'ap-voucher');
            formData.append('hdId', hdId);
            formData.append('phieuGiamGiaId', selectPgg ? selectPgg.value : '');
            
            // Send AJAX request
            fetch('${pageContext.request.contextPath}/ban-hang', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.text().then(html => ({ url: res.url, html })))
            .then(({url, html}) => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newPaymentBlock = doc.getElementById('pos-payment-block');
                
                if (newPaymentBlock) {
                    document.getElementById('pos-payment-block').innerHTML = newPaymentBlock.innerHTML;
                    
                    // Kiểm tra URL xem có params lỗi không
                    const urlParams = new URL(url).searchParams;
                    const error = urlParams.get('error');
                    if (error) {
                        let errorMsg = 'Có lỗi xảy ra khi áp dụng mã!';
                        if (error === 'khong-du-dieu-kien') errorMsg = 'Hóa đơn không đủ điều kiện để áp dụng mã giảm giá này!';
                        else if (error === 'het-so-luong') errorMsg = 'Mã giảm giá đã hết lượt sử dụng!';
                        showBootstrapAlert(errorMsg, 'danger');
                    } else if (selectPgg && selectPgg.value !== '') {
                        showBootstrapAlert('Áp dụng mã giảm giá thành công!', 'success');
                    } else {
                        showBootstrapAlert('Đã gỡ mã giảm giá!', 'info');
                    }
                    
                    // Ẩn modal nếu đang mở
                    const modalEl = document.getElementById('modalVoucherPicker');
                    if (modalEl) {
                        const modal = bootstrap.Modal.getInstance(modalEl);
                        if (modal) modal.hide();
                    }
                }
            })
            .catch(err => {
                console.error('Lỗi khi áp mã giảm giá:', err);
                showBootstrapAlert('Có lỗi xảy ra, vui lòng thử lại sau!', 'danger');
            });
        }

        function xoaDonChoPOS(hdId) {
            showBootstrapConfirm('Bạn có chắc chắn muốn xóa hóa đơn đang chờ này không?', function() {
                document.getElementById('posActionInput').value = 'xoa-don';
                document.getElementById('posHdIdInput').value = hdId;
                document.getElementById('posActionForm').submit();
            });
        }

        let searchTimeout;

        // Sử dụng event delegation cho toàn bộ document thay vì gắn cứng vào thẻ input
        // Điều này giúp form vẫn hoạt động bình thường kể cả khi bị AJAX thay thế HTML (như khi f5 lại cục pos-payment-block)
        document.addEventListener('input', function(e) {
            if (e.target && e.target.id === 'posInputSdt') {
                const sdtInput = e.target;
                const tenKhInput = document.getElementById('posInputTenKh');
                const sdtSuggestions = document.getElementById('sdtSuggestions');
                const kw = sdtInput.value.trim();
                
                if (sdtSuggestions) {
                    sdtSuggestions.style.display = 'none';
                    sdtSuggestions.innerHTML = '';
                }
                
                // Update current input and trigger save
                autoSaveKhachHangPOS();
                
                if (kw.length >= 3) {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        fetch('${pageContext.request.contextPath}/api/customers/search?kw=' + encodeURIComponent(kw))
                            .then(res => res.json())
                            .then(data => {
                                if (sdtSuggestions) {
                                    sdtSuggestions.innerHTML = '';
                                    if (data && data.results && data.results.length > 0) {
                                        // Ẩn khối nhập tên nếu đang mở
                                        const nameBlock = document.getElementById('khNameBlock');
                                        if(nameBlock && tenKhInput && !tenKhInput.value) nameBlock.style.display = 'none';
                                        const btnQuickAdd = document.getElementById('btnQuickAddKh');
                                        if(btnQuickAdd) btnQuickAdd.style.display = 'none';

                                        data.results.forEach(kh => {
                                            const li = document.createElement('li');
                                            const a = document.createElement('a');
                                            a.className = 'dropdown-item d-flex justify-content-between align-items-center py-2';
                                            a.href = 'javascript:void(0)';
                                            a.innerHTML = '<span><strong>' + kh.sdt + '</strong> - ' + kh.hoTen + '</span><i class="bi bi-person-check text-success"></i>';
                                            a.onclick = function() {
                                                sdtInput.value = kh.sdt;
                                                if (tenKhInput) tenKhInput.value = kh.hoTen;
                                                sdtSuggestions.style.display = 'none';
                                                autoSaveKhachHangPOS();
                                                // Sau khi chọn thì hiện lại khối tên (chỉ đọc hoặc có giá trị)
                                                if(nameBlock) nameBlock.style.display = 'block';
                                            };
                                            li.appendChild(a);
                                            sdtSuggestions.appendChild(li);
                                        });
                                    } else if (kw.length >= 10 && /^[0-9]+$/.test(kw)) {
                                        // Không tìm thấy SĐT -> Mở khối Tên Khách Hàng bên dưới
                                        const nameBlock = document.getElementById('khNameBlock');
                                        if(nameBlock) nameBlock.style.display = 'block';
                                        const btnQuickAdd = document.getElementById('btnQuickAddKh');
                                        if(btnQuickAdd) {
                                            btnQuickAdd.style.display = 'block';
                                            // Cập nhật lại onclick để truyền kw hiện tại
                                            btnQuickAdd.setAttribute('onclick', 'quickAddKhachHang("' + kw + '")');
                                        }
                                        
                                        // Focus vào ô tên để tiện gõ luôn
                                        if (tenKhInput) {
                                            tenKhInput.value = '';
                                            tenKhInput.focus();
                                        }
                                    }
                                    
                                    if (sdtSuggestions.innerHTML !== '') {
                                        sdtSuggestions.style.display = 'block';
                                    } else {
                                        sdtSuggestions.style.display = 'none';
                                    }
                                }
                            })
                            .catch(err => console.error('Lỗi tìm kiếm:', err));
                    }, 300);
                }
            } else if (e.target && e.target.id === 'posInputTenKh') {
                autoSaveKhachHangPOS();
            }
        });

        // Xử lý ẩn dropdown khi click ra ngoài
        document.addEventListener('click', function(e) {
            const sdtInput = document.getElementById('posInputSdt');
            const sdtSuggestions = document.getElementById('sdtSuggestions');
            if (sdtSuggestions && sdtInput && !sdtInput.contains(e.target) && !sdtSuggestions.contains(e.target)) {
                sdtSuggestions.style.display = 'none';
            }
        });

        // Bắt sự kiện blur cho posInputTenKh
        document.addEventListener('focusout', function(e) {
            if (e.target && e.target.id === 'posInputTenKh') {
                autoSaveKhachHangPOS();
            }
        });

        <c:if test="${not empty param.printHdId}">
        window.addEventListener('DOMContentLoaded', function() {
            window.open('${pageContext.request.contextPath}/hoa-don?action=detail&id=${param.printHdId}&print=true', '_blank');
        });
        </c:if>
    </script>

    <!-- MODAL QUÉT QR WEBCAM THÊM SẢN PHẨM VÀO ĐƠN -->
    <div class="modal fade" id="modalScanQRAdd" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code-scan"></i> Quét mã QR Thêm vào Đơn hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center bg-light">
                    <p class="text-muted small mb-3">Đưa tem mã QR của giày vào trước Camera webcam hoặc dùng súng bắn vạch.</p>
                    <div id="qr-camera-viewport" class="mx-auto border rounded-4 overflow-hidden shadow-sm bg-dark" style="width: 100%; max-width: 400px; min-height: 280px;"></div>
                    <div id="qr-scan-status" class="mt-3 fw-bold text-primary small"></div>

                    <div class="mt-4 pt-3 border-top text-start">
                        <label class="form-label small fw-semibold text-secondary">Hoặc nhập tay mã SKU / dùng súng quét:</label>
                        <div class="d-flex gap-2">
                            <input type="text" id="inputManualScanSKU" class="form-control" placeholder="VD: SPCT1, SPCT2, SP03...">
                            <button type="button" class="btn btn-runmax px-3 text-nowrap" onclick="if(document.getElementById('inputManualScanSKU').value.trim()) { processScannedSKU(document.getElementById('inputManualScanSKU').value.trim()); document.getElementById('inputManualScanSKU').value=''; }">
                                <i class="bi bi-plus-lg"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-2 border-top d-flex justify-content-between">
                    <span class="small text-muted"><i class="bi bi-volume-up-fill me-1"></i>Tự động kêu Bíp & thêm vào đơn khi nhận diện</span>
                    <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        let activeScanHdId = null;
        let qrCameraScannerObj = null;

        // Danh sách toàn bộ SPCT từ server để tra cứu nhanh khi quét và Lọc/Phân trang Client-Side
        const availableSpctList = [
            <c:forEach var="item" items="${allSpct}" varStatus="st">
            {
                id: ${item.id},
                maSpct: '${item.maSpct != null ? item.maSpct : "SPCT".concat(item.id)}',
                maSp: '${item.sanPham.maSp}',
                tenSp: '${fn:escapeXml(item.sanPham.tenSp)}',
                thuongHieu: '${item.sanPham.thuongHieu != null ? fn:escapeXml(item.sanPham.thuongHieu.ten) : ""}',
                chatLieu: '${item.sanPham.chatLieu != null ? fn:escapeXml(item.sanPham.chatLieu.ten) : ""}',
                deGiay: '${item.deGiay != null ? fn:escapeXml(item.deGiay.ten) : ""}',
                mauSac: '${fn:escapeXml(item.mauSac.ten)}',
                kichCo: '${fn:escapeXml(item.kichCo.ten)}',
                giaBan: ${item.giaBan != null ? item.giaBan : 0},
                soLuongTon: ${item.soLuongTon},
                soLuongKhaDung: ${item.soLuongKhaDung}
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        function openInvoiceScanQRModal(hdId) {
            if (!hdId || hdId === 'null' || hdId === '') {
                alert('Vui lòng chọn hoặc tạo hóa đơn chờ trước khi quét mã QR!');
                return;
            }
            activeScanHdId = hdId;
            const modalEl = document.getElementById('modalScanQRAdd');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();

            startCameraScanQR();
        }

        function startCameraScanQR() {
            const statusEl = document.getElementById('qr-scan-status');
            if (statusEl) statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-hourglass-split"></i> Đang khởi động camera...</span>';

            if (typeof Html5Qrcode === 'undefined') {
                if (statusEl) statusEl.innerHTML = '<span class="text-danger">Lỗi: Thư viện Html5Qrcode chưa tải được.</span>';
                return;
            }

            qrCameraScannerObj = new Html5Qrcode("qr-camera-viewport");
            qrCameraScannerObj.start(
                { facingMode: "environment" },
                { fps: 10, qrbox: { width: 240, height: 240 } },
                (decodedText) => {
                    processScannedSKU(decodedText);
                },
                (err) => {}
            ).then(() => {
                if (statusEl) statusEl.innerHTML = '<span class="text-success"><i class="bi bi-camera-video-fill"></i> Camera đang quét... Đưa tem QR vào khung</span>';
            }).catch(err => {
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: \${err}. Bạn có thể nhập mã ở dưới.</span>`;
            });
        }

        function stopCameraScanQR() {
            if (qrCameraScannerObj) {
                qrCameraScannerObj.stop().then(() => {
                    qrCameraScannerObj.clear();
                    qrCameraScannerObj = null;
                }).catch(err => {
                    qrCameraScannerObj = null;
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const modalEl = document.getElementById('modalScanQRAdd');
            if (modalEl) {
                modalEl.addEventListener('hidden.bs.modal', function () {
                    stopCameraScanQR();
                });
            }
            const inputManual = document.getElementById('inputManualScanSKU');
            if (inputManual) {
                inputManual.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' && inputManual.value.trim()) {
                        processScannedSKU(inputManual.value.trim());
                        inputManual.value = '';
                    }
                });
            }
        });

        function processScannedSKU(decodedText) {
            const code = (decodedText || '').toString().trim().toUpperCase();
            if (!code || !activeScanHdId) return;

            const statusEl = document.getElementById('qr-scan-status');
            if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện mã: <b class="text-danger">\${code}</b>`;

            // Tìm sản phẩm trong availableSpctList
            const matched = availableSpctList.find(p => 
                p.maSpct.toUpperCase() === code || 
                p.id.toString() === code || 
                p.maSp.toUpperCase() === code
            );

            if (matched) {
                if (matched.soLuongTon <= 0) {
                    alert(`Sản phẩm "\${matched.tenSp} (Size \${matched.kichCo} - \${matched.mauSac})" đã HẾT HÀNG trong kho (\${matched.soLuongTon})!`);
                    return;
                }

                // Phát âm thanh Bíp nhận diện thành công
                try {
                    const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                    const osc = audioCtx.createOscillator();
                    const gain = audioCtx.createGain();
                    osc.connect(gain);
                    gain.connect(audioCtx.destination);
                    osc.frequency.value = 1350;
                    gain.gain.value = 0.15;
                    osc.start();
                    setTimeout(() => osc.stop(), 130);
                } catch(e) {}

                stopCameraScanQR();

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/ban-hang';
                form.style.display = 'none';

                const inputAction = document.createElement('input');
                inputAction.type = 'hidden';
                inputAction.name = 'action';
                inputAction.value = 'them-sp';
                form.appendChild(inputAction);

                const inputHd = document.createElement('input');
                inputHd.type = 'hidden';
                inputHd.name = 'hdId';
                inputHd.value = activeScanHdId;
                form.appendChild(inputHd);

                const inputSpct = document.createElement('input');
                inputSpct.type = 'hidden';
                inputSpct.name = 'spctId';
                inputSpct.value = matched.id;
                form.appendChild(inputSpct);

                const inputSl = document.createElement('input');
                inputSl.type = 'hidden';
                inputSl.name = 'soLuong';
                inputSl.value = '1';
                form.appendChild(inputSl);

                document.body.appendChild(form);
                form.submit();
            } else {
                alert(`Không tìm thấy biến thể giày nào trong kho ứng với mã QR: "\${code}"!`);
            }
        }

        let qrHdCameraScannerObj = null;

        function openInvoiceLookupQRModal() {
            const modalEl = document.getElementById('modalScanQRHoaDon');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
            startHdCameraScanQR();
        }

        function startHdCameraScanQR() {
            const statusEl = document.getElementById('qr-hd-scan-status');
            if (statusEl) statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-hourglass-split"></i> Đang khởi động camera...</span>';

            if (typeof Html5Qrcode === 'undefined') {
                if (statusEl) statusEl.innerHTML = '<span class="text-danger">Lỗi: Thư viện Html5Qrcode chưa tải được.</span>';
                return;
            }

            qrHdCameraScannerObj = new Html5Qrcode("qr-hd-camera-viewport");
            qrHdCameraScannerObj.start(
                { facingMode: "environment" },
                { fps: 10, qrbox: { width: 240, height: 240 } },
                (decodedText) => {
                    processScannedHoaDonCode(decodedText);
                },
                (err) => {}
            ).then(() => {
                if (statusEl) statusEl.innerHTML = '<span class="text-success"><i class="bi bi-camera-video-fill"></i> Camera đang quét... Đưa tem QR vào khung</span>';
            }).catch(err => {
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: \${err}. Bạn có thể nhập mã ở dưới.</span>`;
            });
        }

        function stopHdCameraScanQR() {
            if (qrHdCameraScannerObj) {
                qrHdCameraScannerObj.stop().then(() => {
                    qrHdCameraScannerObj.clear();
                    qrHdCameraScannerObj = null;
                }).catch(err => {
                    qrHdCameraScannerObj = null;
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const modalEl = document.getElementById('modalScanQRHoaDon');
            if (modalEl) {
                modalEl.addEventListener('hidden.bs.modal', function () {
                    stopHdCameraScanQR();
                });
            }
            const inputManual = document.getElementById('inputManualScanHD');
            if (inputManual) {
                inputManual.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' && inputManual.value.trim()) {
                        processScannedHoaDonCode(inputManual.value.trim());
                    }
                });
            }
        });

        function processScannedHoaDonCode(decodedText) {
            const code = (decodedText || '').toString().trim();
            if (!code) return;

            const statusEl = document.getElementById('qr-hd-scan-status');
            if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện: <b class="text-danger">${code}</b>`;

            try {
                const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.connect(gain);
                gain.connect(audioCtx.destination);
                osc.frequency.value = 1350;
                gain.gain.value = 0.15;
                osc.start();
                setTimeout(() => osc.stop(), 130);
            } catch(e) {}

            stopHdCameraScanQR();
            window.location.href = '${pageContext.request.contextPath}/hoa-don?action=find-by-qr&code=' + encodeURIComponent(code);
        }
    </script>

    <!-- MODAL TÌM KIẾM SẢN PHẨM (POS) -->
    <div class="modal fade" id="modalSearchProduct" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-search"></i> Tra Cứu Giày Chạy Bộ Nam
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light">
                    <div class="row h-100">
                        <!-- Cột Trái: Tìm kiếm & Kết quả (70%) -->
                        <div class="col-lg-8 d-flex flex-column h-100 pe-4">
                            <!-- Khối Lọc -->
                            <div class="row g-2 mb-3">
                                <div class="col-md-12">
                                    <input type="text" id="posFilterKeyword" class="form-control form-control-lg shadow-sm" placeholder="Nhập tên giày, mã SP, phân loại...">
                                </div>
                                <div class="col-md-4">
                                    <select id="posFilterSize" class="form-select shadow-sm"><option value="">Tất cả Size</option></select>
                                </div>
                                <div class="col-md-4">
                                    <select id="posFilterColor" class="form-select shadow-sm"><option value="">Tất cả Màu</option></select>
                                </div>
                                <div class="col-md-4">
                                    <select id="posFilterSole" class="form-select shadow-sm"><option value="">Tất cả Đế</option></select>
                                </div>
                            </div>

                            <!-- Danh sách kết quả (Render bằng JS) -->
                            <div class="table-responsive bg-white rounded-3 shadow-sm border flex-grow-1 mb-3" style="min-height: 400px; max-height: 400px; overflow-y: auto;">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light sticky-top">
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Phân loại</th>
                                            <th>Đơn giá</th>
                                            <th>Tồn</th>
                                            <th class="text-end pe-3">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="posProductTableBody">
                                        <!-- JS Render here -->
                                        <tr><td colspan="5" class="text-center text-muted py-4"><span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang tải...</td></tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Phân trang -->
                            <nav>
                                <ul class="pagination justify-content-center mb-0" id="posProductPagination">
                                    <!-- JS Render here -->
                                </ul>
                            </nav>
                        </div>

                        <!-- Cột Phải: Giỏ Hàng Nháp (30%) -->
                        <div class="col-lg-4 d-flex flex-column h-100 border-start border-2 border-danger border-opacity-25 ps-4">
                            <h5 class="fw-bold text-dark mb-3">
                                <i class="bi bi-cart4 text-danger me-2"></i>Giỏ Hàng Nháp
                            </h5>
                            
                            <div id="stagingCartContainer" class="flex-grow-1 overflow-auto bg-white rounded-3 shadow-sm border mb-3 p-2" style="min-height: 400px; max-height: 400px;">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-box-seam opacity-25" style="font-size: 3rem;"></i>
                                    <p class="mt-2 mb-0">Chưa chọn sản phẩm nào</p>
                                </div>
                            </div>

                            <div class="bg-white rounded-3 shadow-sm border p-3 mt-auto">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted fw-semibold">Tổng số lượng:</span>
                                    <span class="fw-bold" id="stagingTotalQty">0</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="text-muted fw-semibold">Tạm tính:</span>
                                    <span class="text-danger fw-bold fs-5" id="stagingTotalPrice">0 đ</span>
                                </div>
                                <button type="button" class="btn btn-runmax btn-lg w-100 fw-bold shadow-sm py-2" onclick="submitStagingCart(${currentHd != null ? currentHd.id : 'null'})">
                                    <i class="bi bi-check2-all me-2"></i> XÁC NHẬN ĐẨY ĐƠN
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openSearchModal() {
            const modalEl = document.getElementById('modalSearchProduct');
            if (modalEl) {
                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                modal.show();
                setTimeout(() => {
                    const kwInput = modalEl.querySelector('input[name="kw"]');
                    if(kwInput) kwInput.focus();
                }, 500);
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('kw')) {
                openSearchModal();
            }
        });

        async function handleAjaxAddToCart(event, form) {
            event.preventDefault();
            const btn = form.querySelector('button[type="submit"]');
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
            btn.disabled = true;

            const formData = new FormData(form);
            const data = new URLSearchParams(formData);

            try {
                const response = await fetch('${pageContext.request.contextPath}/ban-hang', {
                    method: 'POST',
                    body: data,
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    redirect: 'follow'
                });

                const htmlText = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');

                const newCart = doc.getElementById('pos-cart-container');
                if (newCart) {
                    document.getElementById('pos-cart-container').innerHTML = newCart.innerHTML;
                }
                
                showBootstrapAlert('Đã thêm sản phẩm vào giỏ!', 'success');
                
                const oldPaymentBlock = document.getElementById('pos-payment-block');
                const newPaymentBlock = doc.getElementById('pos-payment-block');
                if (oldPaymentBlock && newPaymentBlock) {
                    oldPaymentBlock.innerHTML = newPaymentBlock.innerHTML;
                }
                
                setTimeout(() => {
                    btn.innerHTML = '<i class="bi bi-check-lg"></i> Xong';
                    btn.classList.remove('btn-danger');
                    btn.classList.add('btn-success');
                    setTimeout(() => {
                        btn.innerHTML = originalHtml;
                        btn.disabled = false;
                        btn.classList.remove('btn-success');
                        btn.classList.add('btn-danger');
                    }, 1500);
                }, 300);

            } catch (err) {
                showBootstrapAlert('Lỗi kết nối khi thêm vào giỏ!', 'danger');
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            }
            return false;
        }
        
        // --- STAGING CART LOGIC ---
        let stagingCartItems = [];

        function addToStagingCart(id, name, size, color, price, maxQty) {
            let existing = stagingCartItems.find(item => item.id === id);
            if (existing) {
                if (existing.qty < maxQty) {
                    existing.qty++;
                } else {
                    showBootstrapAlert('Đã đạt số lượng tồn kho tối đa!', 'warning');
                }
            } else {
                stagingCartItems.push({
                    id: id,
                    name: name,
                    size: size,
                    color: color,
                    price: price,
                    maxQty: maxQty,
                    qty: 1
                });
            }
            renderStagingCart();
        }

        function updateStagingCartQty(id, newQty) {
            let item = stagingCartItems.find(i => i.id === id);
            if (item) {
                newQty = parseInt(newQty);
                if (isNaN(newQty) || newQty < 1) newQty = 1;
                if (newQty > item.maxQty) {
                    newQty = item.maxQty;
                    showBootstrapAlert('Số lượng vượt quá tồn kho khả dụng (' + item.maxQty + ')!', 'warning');
                }
                item.qty = newQty;
                renderStagingCart();
            }
        }

        function removeStagingCartItem(id) {
            stagingCartItems = stagingCartItems.filter(item => item.id !== id);
            renderStagingCart();
        }

        function renderStagingCart() {
            const container = document.getElementById('stagingCartContainer');
            if (stagingCartItems.length === 0) {
                container.innerHTML = `
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-box-seam opacity-25" style="font-size: 3rem;"></i>
                        <p class="mt-2 mb-0">Chưa chọn sản phẩm nào</p>
                    </div>
                `;
                document.getElementById('stagingTotalQty').innerText = '0';
                document.getElementById('stagingTotalPrice').innerText = '0 đ';
                return;
            }

            let html = '<ul class="list-group list-group-flush">';
            let totalQty = 0;
            let totalPrice = 0;

            stagingCartItems.forEach(item => {
                totalQty += item.qty;
                totalPrice += (item.qty * item.price);
                html += `
                    <li class="list-group-item px-0 py-3 border-bottom">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="pe-2">
                                <h6 class="fw-bold text-dark mb-1">\${item.name}</h6>
                                <div class="small text-muted">Size: <b>\${item.size}</b> | Màu: <b>\${item.color}</b></div>
                                <div class="text-danger fw-semibold mt-1">\${new Intl.NumberFormat('vi-VN').format(item.price)} đ</div>
                            </div>
                            <button class="btn btn-sm btn-link text-danger p-0 ms-auto" onclick="removeStagingCartItem(\${item.id})">
                                <i class="bi bi-trash3 fs-5"></i>
                            </button>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mt-2">
                            <span class="small text-muted">Tồn: \${item.maxQty}</span>
                            <div class="input-group input-group-sm" style="width: 110px;">
                                <button class="btn btn-outline-secondary px-2" type="button" onclick="updateStagingCartQty(\${item.id}, \${item.qty - 1})">-</button>
                                <input type="number" class="form-control text-center px-1" value="\${item.qty}" min="1" max="\${item.maxQty}" onchange="updateStagingCartQty(\${item.id}, this.value)">
                                <button class="btn btn-outline-secondary px-2" type="button" onclick="updateStagingCartQty(\${item.id}, \${item.qty + 1})">+</button>
                            </div>
                        </div>
                    </li>
                `;
            });
            html += '</ul>';
            
            container.innerHTML = html;
            document.getElementById('stagingTotalQty').innerText = totalQty;
            document.getElementById('stagingTotalPrice').innerText = new Intl.NumberFormat('vi-VN').format(totalPrice) + ' đ';
        }

        async function submitStagingCart(hdId) {
            if (!hdId) {
                showBootstrapAlert('Vui lòng chọn hoặc tạo hóa đơn trước khi thêm sản phẩm!', 'warning');
                return;
            }
            if (stagingCartItems.length === 0) {
                showBootstrapAlert('Giỏ hàng nháp đang trống!', 'warning');
                return;
            }

            // Lấy id nút bấm để disable tạm thời
            const btn = event.currentTarget || event.target;
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Đang xử lý...';
            btn.disabled = true;

            const formData = new URLSearchParams();
            formData.append('action', 'them-nhieu-sp');
            formData.append('hdId', hdId);
            stagingCartItems.forEach(item => {
                formData.append('spctIds[]', item.id);
                formData.append('soLuongs[]', item.qty);
            });

            try {
                const response = await fetch('${pageContext.request.contextPath}/ban-hang', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                });
                
                const htmlText = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');

                const newCart = doc.getElementById('pos-cart-container');
                if (newCart) {
                    document.getElementById('pos-cart-container').innerHTML = newCart.innerHTML;
                }
                
                const oldPaymentBlock = document.getElementById('pos-payment-block');
                const newPaymentBlock = doc.getElementById('pos-payment-block');
                if (oldPaymentBlock && newPaymentBlock) {
                    oldPaymentBlock.innerHTML = newPaymentBlock.innerHTML;
                }

                showBootstrapAlert('Đã đẩy thành công ' + stagingCartItems.length + ' sản phẩm vào hóa đơn!', 'success');

                // Clear and close
                stagingCartItems = [];
                renderStagingCart();
                const modalEl = document.getElementById('modalSearchProduct');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();
                
            } catch (err) {
                showBootstrapAlert('Lỗi kết nối khi đẩy vào hóa đơn!', 'danger');
            } finally {
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            }
        }

        // --- CLIENT-SIDE FILTERING & PAGINATION LOGIC ---
        let filteredSpctList = [];
        let posCurrentPage = 1;
        const posItemsPerPage = 10;

        function initPosFilters() {
            if (typeof availableSpctList === 'undefined' || availableSpctList.length === 0) return;

            // Extract unique values
            const sizes = [...new Set(availableSpctList.map(item => item.kichCo).filter(Boolean))].sort((a,b) => a - b);
            const colors = [...new Set(availableSpctList.map(item => item.mauSac).filter(Boolean))].sort();
            const soles = [...new Set(availableSpctList.map(item => item.deGiay).filter(Boolean))].sort();

            const sizeSelect = document.getElementById('posFilterSize');
            const colorSelect = document.getElementById('posFilterColor');
            const soleSelect = document.getElementById('posFilterSole');

            if(sizeSelect) sizes.forEach(s => sizeSelect.add(new Option(s, s)));
            if(colorSelect) colors.forEach(c => colorSelect.add(new Option(c, c)));
            if(soleSelect) soles.forEach(s => soleSelect.add(new Option(s, s)));

            // Add event listeners
            document.getElementById('posFilterKeyword').addEventListener('input', applyPosFilters);
            if(sizeSelect) sizeSelect.addEventListener('change', applyPosFilters);
            if(colorSelect) colorSelect.addEventListener('change', applyPosFilters);
            if(soleSelect) soleSelect.addEventListener('change', applyPosFilters);

            // Initial render
            applyPosFilters();
        }

        function applyPosFilters() {
            const kw = document.getElementById('posFilterKeyword').value.toLowerCase().trim();
            const size = document.getElementById('posFilterSize').value;
            const color = document.getElementById('posFilterColor').value;
            const sole = document.getElementById('posFilterSole').value;

            filteredSpctList = availableSpctList.filter(item => {
                let match = true;
                if (kw) {
                    const searchStr = `\${item.tenSp} \${item.maSp} \${item.maSpct} \${item.thuongHieu}`.toLowerCase();
                    if (!searchStr.includes(kw)) match = false;
                }
                if (size && item.kichCo !== size) match = false;
                if (color && item.mauSac !== color) match = false;
                if (sole && item.deGiay !== sole) match = false;
                return match;
            });

            posCurrentPage = 1;
            renderPosProductTable();
        }

        function renderPosProductTable() {
            const tbody = document.getElementById('posProductTableBody');
            const pagination = document.getElementById('posProductPagination');
            
            if (!tbody || !pagination) return;

            if (filteredSpctList.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">Không tìm thấy sản phẩm nào phù hợp!</td></tr>';
                pagination.innerHTML = '';
                return;
            }

            const totalPages = Math.ceil(filteredSpctList.length / posItemsPerPage);
            if (posCurrentPage > totalPages) posCurrentPage = totalPages;

            const startIndex = (posCurrentPage - 1) * posItemsPerPage;
            const endIndex = startIndex + posItemsPerPage;
            const currentItems = filteredSpctList.slice(startIndex, endIndex);

            let html = '';
            currentItems.forEach(spct => {
                const isOutOfStock = spct.soLuongKhaDung <= 0;
                const rowClass = isOutOfStock ? 'table-secondary opacity-75' : '';
                const brandBadge = spct.thuongHieu ? `<span class="badge bg-secondary me-1">\${spct.thuongHieu}</span>` : '';
                const stockHtml = isOutOfStock 
                    ? `<span class="badge bg-danger text-white px-2 py-1"><i class="bi bi-x-circle me-1"></i>Hết hàng (0)</span>`
                    : `<span class="fw-bold text-dark">\${spct.soLuongKhaDung}</span>`;
                
                const actionHtml = (!isOutOfStock)
                    ? `<button type="button" class="btn btn-danger fw-bold shadow-sm px-3" style="border-radius: 8px;"
                                onclick="addToStagingCart(\${spct.id}, '\${spct.tenSp.replace(/'/g, "\\'")}', '\${spct.kichCo}', '\${spct.mauSac}', \${spct.giaBan}, \${spct.soLuongKhaDung})">
                            <i class="bi bi-cart-plus me-1"></i> Chọn
                        </button>`
                    : `<button type="button" class="btn btn-secondary opacity-50 px-3" disabled style="border-radius: 8px;">
                            <i class="bi bi-cart-x me-1"></i> Hết
                        </button>`;

                html += `
                    <tr class="\${rowClass}">
                        <td class="fw-bold text-dark">
                            \${brandBadge}
                            \${spct.tenSp}
                            <small class="text-muted d-block fw-normal">[Mã: \${spct.maSp}]</small>
                        </td>
                        <td>
                            <div class="mb-1">Size <b>\${spct.kichCo}</b> | \${spct.mauSac}</div>
                            <span class="badge bg-info text-dark bg-opacity-10 border border-info" style="font-size: 0.7rem;">Đế: \${spct.deGiay}</span>
                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary" style="font-size: 0.7rem;">Chất liệu: \${spct.chatLieu}</span>
                        </td>
                        <td class="text-danger fw-semibold">
                            \${new Intl.NumberFormat('vi-VN').format(spct.giaBan)} đ
                        </td>
                        <td>\${stockHtml}</td>
                        <td class="text-end pe-3">\${actionHtml}</td>
                    </tr>
                `;
            });

            tbody.innerHTML = html;

            // Render pagination
            let pageHtml = '';
            if (totalPages > 1) {
                const prevDisabled = posCurrentPage === 1 ? 'disabled' : '';
                const nextDisabled = posCurrentPage === totalPages ? 'disabled' : '';
                
                pageHtml += `<li class="page-item \${prevDisabled}">
                                <a class="page-link text-danger" href="#" onclick="changePosPage(event, \${posCurrentPage - 1})">Trước</a>
                             </li>`;
                             
                for (let i = 1; i <= totalPages; i++) {
                    if (totalPages > 7) {
                        if (i !== 1 && i !== totalPages && Math.abs(i - posCurrentPage) > 2) {
                            if (i === 2 || i === totalPages - 1) {
                                pageHtml += `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`;
                            }
                            continue;
                        }
                    }
                    const activeClass = i === posCurrentPage ? 'active' : '';
                    const linkClass = i === posCurrentPage ? 'bg-danger border-danger' : 'text-danger';
                    pageHtml += `<li class="page-item \${activeClass}">
                                    <a class="page-link \${linkClass}" href="#" onclick="changePosPage(event, \${i})">\${i}</a>
                                 </li>`;
                }
                
                pageHtml += `<li class="page-item \${nextDisabled}">
                                <a class="page-link text-danger" href="#" onclick="changePosPage(event, \${posCurrentPage + 1})">Sau</a>
                             </li>`;
            }
            pagination.innerHTML = pageHtml;
        }

        function changePosPage(event, newPage) {
            event.preventDefault();
            const totalPages = Math.ceil(filteredSpctList.length / posItemsPerPage);
            if (newPage >= 1 && newPage <= totalPages) {
                posCurrentPage = newPage;
                renderPosProductTable();
            }
        }

        // Gọi API thêm nhanh khách hàng
        function quickAddKhachHang(sdt) {
            const nameInput = document.getElementById('posInputTenKh');
            const name = nameInput ? nameInput.value.trim() : '';
            if (!name) {
                if(typeof showBootstrapAlert === 'function') showBootstrapAlert('Vui lòng nhập tên khách hàng!', 'warning');
                else alert('Vui lòng nhập tên khách hàng!');
                return;
            }

            const formData = new URLSearchParams();
            formData.append('name', name);
            formData.append('phone', sdt);

            const btn = document.getElementById('btnQuickAddKh');
            const originalHtml = btn ? btn.innerHTML : '';
            if (btn) {
                btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
                btn.disabled = true;
            }

            fetch('${pageContext.request.contextPath}/api/customers/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    const sdtInput = document.getElementById('posInputSdt');
                    const tenKhInput = document.getElementById('posInputTenKh');
                    if (sdtInput) sdtInput.value = sdt;
                    if (tenKhInput) tenKhInput.value = name;
                    
                    const sdtSuggestions = document.getElementById('sdtSuggestions');
                    if (sdtSuggestions) sdtSuggestions.style.display = 'none';
                    
                    if(typeof showBootstrapAlert === 'function') showBootstrapAlert('Đã thêm khách mới thành công!', 'success');
                    autoSaveKhachHangPOS();
                    
                    if (btn) {
                        btn.innerHTML = originalHtml;
                        btn.disabled = false;
                        btn.style.display = 'none';
                    }
                } else {
                    if(typeof showBootstrapAlert === 'function') showBootstrapAlert(data.message || 'Lỗi khi thêm khách hàng!', 'danger');
                    else alert(data.message || 'Lỗi khi thêm khách hàng!');
                    if (btn) {
                        btn.innerHTML = originalHtml;
                        btn.disabled = false;
                    }
                }
            })
            .catch(err => {
                console.error('Lỗi thêm KH:', err);
                if (btn) {
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                }
            });
        }

        // Xử lý VietQR khi chọn phương thức thanh toán
        function handlePtttChange(selectEl) {
            if (selectEl.value === '2') { // 2 = Chuyển khoản QR Code
                const tongTien = ${currentHd != null && currentHd.tongTien != null ? currentHd.tongTien : 0};
                const maHd = '${currentHd != null ? currentHd.maHd : ""}';
                
                if (tongTien > 0 && maHd) {
                    // Cấu hình Bank theo thông tin user cung cấp
                    const bankId = 'OCB'; // Liobank (thuộc OCB)
                    const stk = '898968689999';
                    const name = 'DAO VAN SON';
                    
                    const amount = Math.round(tongTien);
                    const addInfo = maHd;
                    
                    // URL API VietQR
                    const qrUrl = `https://img.vietqr.io/image/\${bankId}-\${stk}-compact2.png?amount=\${amount}&addInfo=\${addInfo}&accountName=\${encodeURIComponent(name)}`;
                    
                    document.getElementById('imgVietQR').src = qrUrl;
                    document.getElementById('textQrAmount').innerText = new Intl.NumberFormat('vi-VN').format(amount) + ' đ';
                    document.getElementById('textQrAddInfo').innerText = addInfo;
                    
                    new bootstrap.Modal(document.getElementById('modalVietQR')).show();
                } else {
                    if (typeof showBootstrapAlert === 'function') {
                        showBootstrapAlert('Hóa đơn chưa có sản phẩm hoặc số tiền không hợp lệ để tạo QR!', 'warning');
                    }
                    selectEl.value = '1'; // Reset về tiền mặt
                }
            }
        }

        // Initialize when modal is fully opened to avoid DOM issues, or just on DOM ready.
        document.addEventListener('DOMContentLoaded', function() {
            initPosFilters();
        });
    </script>

    <!-- MODAL VOUCHER PICKER -->
    <style>
        .voucher-ticket {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #dee2e6;
            display: flex;
            background: #fff;
            transition: all 0.2s;
            cursor: pointer;
        }
        .voucher-ticket:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .voucher-ticket.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            filter: grayscale(100%);
        }
        .voucher-ticket.disabled:hover {
            box-shadow: none;
            transform: none;
        }
        .voucher-ticket.active {
            border-color: #198754;
            box-shadow: 0 0 0 2px rgba(25, 135, 84, 0.25);
        }
        .voucher-ticket::before,
        .voucher-ticket::after {
            content: '';
            position: absolute;
            width: 24px; height: 24px;
            background: #f8f9fa; /* modal body bg */
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
            border: 1px solid #dee2e6;
            z-index: 1;
        }
        .voucher-ticket::before { left: -13px; border-left-color: transparent; border-top-color: transparent; border-bottom-color: transparent; transform: translateY(-50%) rotate(45deg); }
        .voucher-ticket::after  { right: -13px; border-right-color: transparent; border-top-color: transparent; border-bottom-color: transparent; transform: translateY(-50%) rotate(-45deg); }
        
        .voucher-left {
            background: #dc3545;
            color: #fff;
            width: 35%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 15px 10px;
            border-right: 2px dashed rgba(255,255,255,0.5);
        }
        .voucher-right {
            width: 65%;
            padding: 15px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
    </style>

    <div class="modal fade" id="modalVoucherPicker" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0"><i class="bi bi-ticket-perforated me-2"></i>Chọn Mã Giảm Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-3 bg-light">
                    <c:choose>
                        <c:when test="${empty phieuGiamGias}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-ticket-x fs-1 opacity-25"></i>
                                <p class="mt-2 mb-0">Chưa có mã giảm giá nào khả dụng.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="pgg" items="${phieuGiamGias}">
                                    <c:set var="tienHang" value="${currentHd.tienHang != null ? currentHd.tienHang : 0}" />
                                    <c:set var="duDieuKien" value="${tienHang >= pgg.dieuKienGiam}" />
                                    <c:set var="isDangApDung" value="${currentHd.phieuGiamGia != null && currentHd.phieuGiamGia.id == pgg.id}" />
                                    
                                    <div class="voucher-ticket ${!duDieuKien ? 'disabled' : ''} ${isDangApDung ? 'active' : ''}" 
                                         onclick="if(${duDieuKien}) { document.getElementById('selectPgg').value = '${pgg.id}'; apDungVoucherPOS(${currentHd.id}); }">
                                        <div class="voucher-left">
                                            <span class="fs-4 fw-bold">
                                                <c:choose>
                                                    <c:when test="${pgg.loaiGiam == 1}">
                                                        <fmt:formatNumber value="${pgg.giaTrigiam}" type="number" maxFractionDigits="0"/>%
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${pgg.giaTrigiam / 1000}" type="number" maxFractionDigits="0"/>K
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="small opacity-75">Giảm</span>
                                        </div>
                                        <div class="voucher-right position-relative">
                                            <div class="fw-bold text-dark mb-1">${pgg.maPhieu}</div>
                                            <div class="small text-muted mb-1">Đơn tối thiểu <fmt:formatNumber value="${pgg.dieuKienGiam}" type="number"/>đ</div>
                                            <c:if test="${pgg.giamToiDa != null && pgg.giamToiDa > 0}">
                                                <div class="small text-danger fw-semibold mb-2">Giảm tối đa: <fmt:formatNumber value="${pgg.giamToiDa}" type="number"/>đ</div>
                                            </c:if>
                                            <c:if test="${pgg.giamToiDa == null || pgg.giamToiDa == 0}">
                                                <div class="mb-2"></div>
                                            </c:if>
                                            <div class="d-flex justify-content-between align-items-center mt-auto">
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary" style="font-size: 0.7rem;">Còn: ${pgg.soLuong}</span>
                                                <c:if test="${!duDieuKien}">
                                                    <span class="small text-danger fw-semibold" style="font-size: 0.7rem;">Chưa đủ ĐK</span>
                                                </c:if>
                                                <c:if test="${isDangApDung}">
                                                    <span class="small text-success fw-bold"><i class="bi bi-check-circle-fill me-1"></i>Đang áp dụng</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THANH TOÁN VIETQR -->
    <div class="modal fade" id="modalVietQR" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 480px;">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code"></i> Quét mã thanh toán VietQR
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center bg-light">
                    <p class="text-muted small mb-3">Khách hàng vui lòng dùng App Ngân Hàng quét mã dưới đây để thanh toán tự động.</p>
                    
                    <div class="bg-white p-3 rounded-4 shadow-sm mb-3 mx-auto" style="max-width: 420px;">
                        <img id="imgVietQR" src="" alt="VietQR" class="img-fluid rounded w-100">
                    </div>
                    
                    <div class="text-start bg-white p-3 rounded-3 border">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Ngân hàng:</span>
                            <span class="fw-bold">Liobank (OCB)</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Chủ tài khoản:</span>
                            <span class="fw-bold">DAO VAN SON</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Số tài khoản:</span>
                            <span class="fw-bold text-primary">898968689999</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Số tiền:</span>
                            <span class="fw-bold text-danger" id="textQrAmount">0 đ</span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted small">Nội dung:</span>
                            <span class="fw-bold" id="textQrAddInfo">HD...</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-2 border-top">
                    <div class="w-100 text-center text-muted small mb-2">
                        <i class="bi bi-info-circle me-1"></i> Sau khi khách quét thành công, vui lòng bấm nút <strong class="text-danger">Hoàn tất & Thanh toán</strong> bên ngoài.
                    </div>
                    <button type="button" class="btn btn-secondary w-100 fw-bold" data-bs-dismiss="modal">Đã hiểu & Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUÉT QR TRA CỨU HÓA ĐƠN (POS) -->
    <div class="modal fade" id="modalScanQRHoaDon" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code-scan"></i> Quét QR Tra Cứu Hóa Đơn
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center bg-light">
                    <p class="text-muted small mb-3">Đưa tem mã QR trên phiếu in hóa đơn vào trước Webcam để tra cứu nhanh.</p>
                    <div id="qr-hd-camera-viewport" class="mx-auto border rounded-4 overflow-hidden shadow-sm bg-dark" style="width: 100%; max-width: 400px; min-height: 280px;"></div>
                    <div id="qr-hd-scan-status" class="mt-3 fw-bold text-primary small"></div>

                    <div class="mt-4 pt-3 border-top text-start">
                        <label class="form-label small fw-semibold text-secondary">Hoặc nhập tay Mã Hóa Đơn / dùng súng vạch:</label>
                        <div class="d-flex gap-2">
                            <input type="text" id="inputManualScanHD" class="form-control" placeholder="VD: HD172000... hoặc HD001...">
                            <button type="button" class="btn btn-runmax px-3 text-nowrap" onclick="if(document.getElementById('inputManualScanHD').value.trim()) { processScannedHoaDonCode(document.getElementById('inputManualScanHD').value.trim()); }">
                                <i class="bi bi-search"></i> Tra cứu
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-2 border-top d-flex justify-content-between">
                    <span class="small text-muted"><i class="bi bi-volume-up-fill me-1"></i>Tự động kêu Bíp & chuyển tới hóa đơn</span>
                    <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
