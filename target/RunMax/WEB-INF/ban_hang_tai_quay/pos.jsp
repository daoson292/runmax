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
                                            <span class="badge bg-secondary ms-1">${hd.tenKhachHang != null ? hd.tenKhachHang : 'Khách lẻ'}</span>
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

                        <!-- 2. Tìm kiếm Giày Chạy Bộ & Thêm vào đơn -->
                        <div class="runmax-card p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="fw-bold text-dark mb-0">
                                    <i class="bi bi-search text-danger me-1"></i> TRA CỨU GIÀY CHẠY BỘ NAM & THÊM VÀO GIỎ
                                </h6>
                                <c:if test="${currentHd != null}">
                                    <button type="button" class="btn btn-sm btn-danger fw-semibold d-flex align-items-center gap-1 shadow-sm" onclick="openInvoiceScanQRModal('${currentHd.id}')" title="Quét mã QR sản phẩm bằng Camera">
                                        <i class="bi bi-qr-code-scan"></i> Quét QR Camera
                                    </button>
                                </c:if>
                            </div>
                            <form action="${pageContext.request.contextPath}/ban-hang" method="GET" class="row g-2 mb-3" onsubmit="attachPosCustomerInfoToForm(this)">
                                <c:if test="${currentHd != null}">
                                    <input type="hidden" name="hdId" value="${currentHd.id}">
                                </c:if>
                                <div class="col-md-9">
                                    <input type="text" name="kw" class="form-control" placeholder="Nhập tên giày chạy bộ nam, size 39-44, hoặc mã ID..." value="${param.kw}">
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-outline-danger w-100 fw-semibold">
                                        <i class="bi bi-search"></i> Tìm kiếm
                                    </button>
                                </div>
                            </form>

                            <!-- Danh sách SKU giày tìm thấy -->
                            <div class="table-responsive" style="max-height: 250px;">
                                <table class="table table-hover table-sm align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Sản phẩm Giày Nam</th>
                                            <th>Size</th>
                                            <th>Màu sắc</th>
                                            <th>Đơn giá</th>
                                            <th>Tồn</th>
                                            <th class="text-end">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="spct" items="${allSpct}">
                                            <tr class="${spct.soLuongKhaDung <= 0 ? 'table-secondary opacity-75' : ''}">
                                                <td class="fw-bold text-dark">
                                                    <span class="badge bg-secondary me-1">${spct.sanPham.thuongHieu != null ? spct.sanPham.thuongHieu.ten : ''}</span>
                                                    ${spct.sanPham.tenSp}
                                                    <small class="text-muted d-block fw-normal">[Mã: ${spct.sanPham.maSp}]</small>
                                                </td>
                                                <td><span class="badge bg-dark">${spct.kichCo.ten}</span></td>
                                                <td>${spct.mauSac.ten}</td>
                                                <td class="text-danger fw-semibold">
                                                    <fmt:formatNumber value="${spct.giaBan}" type="number" /> đ
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${spct.soLuongKhaDung <= 0}">
                                                            <span class="badge bg-danger text-white px-2 py-1"><i class="bi bi-x-circle me-1"></i>Hết hàng (0)</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="fw-bold text-dark">${spct.soLuongKhaDung}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <c:choose>
                                                        <c:when test="${currentHd != null && spct.soLuongKhaDung > 0}">
                                                            <form action="${pageContext.request.contextPath}/ban-hang" method="POST" class="d-inline" onsubmit="attachPosCustomerInfoToForm(this)">
                                                                <input type="hidden" name="action" value="them-sp">
                                                                <input type="hidden" name="hdId" value="${currentHd.id}">
                                                                <input type="hidden" name="spctId" value="${spct.id}">
                                                                <button type="submit" class="btn btn-sm btn-danger shadow-sm">
                                                                    <i class="bi bi-cart-plus"></i> Chọn
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${spct.soLuongKhaDung <= 0}">
                                                            <button type="button" class="btn btn-sm btn-secondary text-white-50 border-0 opacity-50" disabled style="cursor: not-allowed;" title="Sản phẩm đã hết số lượng tồn kho">
                                                                <i class="bi bi-cart-x"></i> Hết hàng
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-sm btn-light border text-muted opacity-50" disabled title="Vui lòng tạo hoặc chọn một hóa đơn đang chờ">
                                                                <i class="bi bi-cart-plus"></i> Chọn
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- 3. Chi tiết giỏ hàng trong Hóa đơn hiện tại -->
                        <div class="runmax-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                <h6 class="fw-bold text-dark mb-0">
                                    <i class="bi bi-bag-check-fill text-danger me-1"></i> CHI TIẾT SẢN PHẨM TRONG ĐƠN:
                                    <span class="text-danger">${currentHd != null ? currentHd.maHd : 'Chưa chọn'}</span>
                                </h6>
                                <c:if test="${currentHd != null}">
                                    <button type="button" class="btn btn-danger fw-bold d-flex align-items-center gap-2 px-3 py-2 shadow-sm" onclick="openInvoiceScanQRModal('${currentHd.id}')" style="border-radius: 8px; font-size: 0.95rem;">
                                        <i class="bi bi-qr-code-scan fs-5"></i> Quét QR Thêm Ngay Vào Giỏ
                                    </button>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${currentHd != null}">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>#</th>
                                                    <th>Tên Giày Nam Chạy Bộ</th>
                                                    <th>Size / Màu</th>
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
                                                            Size <b>${ct.sanPhamChiTiet.kichCo.ten}</b> | ${ct.sanPhamChiTiet.mauSac.ten}
                                                        <td><fmt:formatNumber value="${ct.donGia}" type="number"/> đ</td>
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
                                                <c:if test="${empty chiTiets}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-4">
                                                            Đơn hàng chưa có giày chạy bộ nào. Vui lòng chọn sản phẩm ở bảng trên!
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-5">
                                        Vui lòng chọn hoặc tạo hóa đơn ở trên để tiến hành bán hàng tại quầy POS!
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- CỘT PHẢI: THÔNG TIN THANH TOÁN POS -->
                    <div class="col-lg-4">
                        <div class="runmax-card p-4">
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
                                                   value="${currentHd.sdt}" placeholder="Nhập SĐT khách hàng (10 số)..." maxlength="11" pattern="[0-9]{10,11}" autocomplete="off">
                                            <ul class="dropdown-menu w-100 shadow-sm" id="sdtSuggestions" style="display: none; max-height: 200px; overflow-y: auto; position: absolute; z-index: 1000;"></ul>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Tên khách hàng Runner</label>
                                            <input type="text" name="tenKhachHang" id="posInputTenKh" class="form-control"
                                                   value="${currentHd.tenKhachHang != null ? currentHd.tenKhachHang : ''}"
                                                   placeholder="Tên khách hàng...">
                                        </div>

                                        <!-- Chọn và Áp Dụng Phiếu Giảm Giá -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Mã Giảm Giá / Voucher</label>
                                            <div class="input-group">
                                                <select name="phieuGiamGiaId" class="form-select" id="selectPgg">
                                                    <option value="">-- Không áp dụng voucher --</option>
                                                    <c:forEach var="pgg" items="${phieuGiamGias}">
                                                        <option value="${pgg.id}" ${currentHd.phieuGiamGia != null && currentHd.phieuGiamGia.id == pgg.id ? 'selected' : ''}>
                                                            ${pgg.maPhieu} - Giảm <fmt:formatNumber value="${pgg.giaTrigiam}" type="number"/> ${pgg.loaiGiam == 1 ? '%' : 'đ'} (Đơn từ <fmt:formatNumber value="${pgg.dieuKienGiam}" type="number"/> đ)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <button type="button" class="btn btn-outline-danger" onclick="apDungVoucherPOS(${currentHd.id})">
                                                    Áp Dụng
                                                </button>
                                            </div>
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
                                            <select name="ptttId" class="form-select">
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
            if (chiTietCount <= 0) {
                event.preventDefault();
                event.stopPropagation();
                showBootstrapAlert('Hóa đơn hiện tại chưa có sản phẩm nào. Vui lòng chọn ít nhất 1 sản phẩm vào đơn!', 'warning');
                return false;
            }
            const form = event.target;
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
            return form.checkValidity();
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
            document.getElementById('posActionInput').value = 'ap-voucher';
            document.getElementById('posHdIdInput').value = hdId;
            document.getElementById('posPggIdInput').value = selectPgg ? selectPgg.value : '';
            document.getElementById('posSdtInput').value = sdtInput ? sdtInput.value.trim() : '';
            document.getElementById('posTenKhInput').value = tenKhInput ? tenKhInput.value.trim() : '';
            document.getElementById('posActionForm').submit();
        }

        function xoaDonChoPOS(hdId) {
            showBootstrapConfirm('Bạn có chắc chắn muốn xóa hóa đơn đang chờ này không?', function() {
                document.getElementById('posActionInput').value = 'xoa-don';
                document.getElementById('posHdIdInput').value = hdId;
                document.getElementById('posActionForm').submit();
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            const sdtInput = document.getElementById('posInputSdt');
            const tenKhInput = document.getElementById('posInputTenKh');
            const sdtSuggestions = document.getElementById('sdtSuggestions');
            let searchTimeout;

            if (sdtInput) {
                sdtInput.addEventListener('input', function() {
                    const kw = this.value.trim();
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
                                    if (data && data.results && data.results.length > 0 && sdtSuggestions) {
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
                                            };
                                            li.appendChild(a);
                                            sdtSuggestions.appendChild(li);
                                        });
                                        sdtSuggestions.style.display = 'block';
                                    }
                                })
                                .catch(err => console.error('Lỗi tìm kiếm:', err));
                        }, 300);
                    }
                });

                // Hide dropdown when clicking outside
                document.addEventListener('click', function(e) {
                    if (sdtSuggestions && !sdtInput.contains(e.target) && !sdtSuggestions.contains(e.target)) {
                        sdtSuggestions.style.display = 'none';
                    }
                });
            }
            if (tenKhInput) {
                tenKhInput.addEventListener('input', autoSaveKhachHangPOS);
                tenKhInput.addEventListener('blur', autoSaveKhachHangPOS);
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

        // Danh sách toàn bộ SPCT từ server để tra cứu nhanh khi quét
        const availableSpctList = [
            <c:forEach var="item" items="${allSpct}" varStatus="st">
            {
                id: ${item.id},
                maSpct: '${item.maSpct != null ? item.maSpct : "SPCT".concat(item.id)}',
                maSp: '${item.sanPham.maSp}',
                tenSp: '${fn:escapeXml(item.sanPham.tenSp)}',
                mauSac: '${fn:escapeXml(item.mauSac.ten)}',
                kichCo: '${fn:escapeXml(item.kichCo.ten)}',
                soLuongTon: ${item.soLuongTon}
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
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: ${err}. Bạn có thể nhập mã ở dưới.</span>`;
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
            if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện mã: <b class="text-danger">${code}</b>`;

            // Tìm sản phẩm trong availableSpctList
            const matched = availableSpctList.find(p => 
                p.maSpct.toUpperCase() === code || 
                p.id.toString() === code || 
                p.maSp.toUpperCase() === code
            );

            if (matched) {
                if (matched.soLuongTon <= 0) {
                    alert(`Sản phẩm "${matched.tenSp} (Size ${matched.kichCo} - ${matched.mauSac})" đã HẾT HÀNG trong kho (${matched.soLuongTon})!`);
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
                alert(`Không tìm thấy biến thể giày nào trong kho ứng với mã QR: "${code}"!`);
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
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: ${err}. Bạn có thể nhập mã ở dưới.</span>`;
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
