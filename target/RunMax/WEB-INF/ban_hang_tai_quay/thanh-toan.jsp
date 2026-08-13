<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán Hóa đơn ${currentHd.maHd}" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <div class="row g-4">
                    <!-- Bên trái: Chi tiết các mặt hàng cần thanh toán -->
                    <div class="col-lg-6">
                        <div class="runmax-card h-100">
                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                                <h6 class="fw-bold mb-0 text-danger">
                                    <i class="bi bi-receipt-cutoff me-1"></i> Các mặt hàng trong hóa đơn ${currentHd.maHd}
                                </h6>
                                <a href="${pageContext.request.contextPath}/ban-hang?hdId=${currentHd.id}" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại giỏ hàng
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table-runmax">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th class="text-center">SL</th>
                                            <th class="text-end">Đơn giá</th>
                                            <th class="text-end">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ct" items="${chiTiets}">
                                            <tr>
                                                <td>
                                                    <div class="fw-semibold">${ct.sanPhamChiTiet.sanPham.tenSp}</div>
                                                    <div class="small text-muted">Size ${ct.sanPhamChiTiet.kichCo.ten} - ${ct.sanPhamChiTiet.mauSac.ten}</div>
                                                </td>
                                                <td class="text-center fw-bold">${ct.soLuong}</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${ct.donGia}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td class="text-end fw-bold text-danger">
                                                    <fmt:formatNumber value="${ct.thanhTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Bên phải: Form chọn khách hàng, voucher & phương thức thanh toán -->
                    <div class="col-lg-6">
                        <div class="runmax-card">
                            <h6 class="fw-bold mb-3 text-dark">
                                <i class="bi bi-credit-card me-1 text-danger"></i> Thông tin thanh toán
                            </h6>

                            <form id="thanhToanForm" action="${pageContext.request.contextPath}/ban-hang" method="post" class="needs-validation" novalidate onsubmit="if(${empty chiTiets ? 0 : chiTiets.size()} <= 0) { event.preventDefault(); showBootstrapAlert('Hóa đơn chưa có sản phẩm nào để thanh toán!', 'warning'); return false; } if(!this.checkValidity()) { event.preventDefault(); event.stopPropagation(); } this.classList.add('was-validated'); return this.checkValidity();">
                                <input type="hidden" name="action" value="thanh-toan">
                                <input type="hidden" name="hdId" value="${currentHd.id}">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Thông tin khách hàng</label>
                                    <div class="row g-2">
                                        <div class="col-md-6 position-relative">
                                            <input type="text" id="ttInputTenKh" name="tenKhachHang" class="form-control" placeholder="Tên khách hàng (Khách lẻ)" value="${currentHd.khachHang != null ? currentHd.khachHang.hoTen : ''}">
                                        </div>
                                        <div class="col-md-6 position-relative">
                                            <input type="text" id="ttInputSdt" name="sdt" class="form-control" placeholder="Số điện thoại (10 số)" value="${currentHd.khachHang != null ? currentHd.khachHang.sdt : ''}" maxlength="10" minlength="10" pattern="[0-9]{10}">
                                            <div class="invalid-feedback">Số điện thoại phải đúng 10 chữ số!</div>
                                            <ul class="dropdown-menu w-100 shadow-sm" id="ttSdtSuggestions" style="display: none; max-height: 200px; overflow-y: auto; position: absolute; z-index: 1000;"></ul>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Phiếu giảm giá (Khuyến mãi)</label>
                                    <div class="input-group">
                                        <select name="phieuGiamGiaId" id="selectPggTT" class="form-select">
                                            <option value="">-- Không áp dụng voucher --</option>
                                            <c:forEach var="p" items="${phieuGiamGias}">
                                                <option value="${p.id}" ${currentHd.phieuGiamGia != null && currentHd.phieuGiamGia.id == p.id ? 'selected' : ''}>
                                                    ${p.maPhieu} - Giảm <fmt:formatNumber value="${p.giaTrigiam}" type="number"/> ${p.loaiGiam == 1 ? '%' : 'đ'} (Đơn từ <fmt:formatNumber value="${p.dieuKienGiam}" type="number"/> đ)
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <button type="button" class="btn btn-outline-danger" onclick="apDungVoucherTT(${currentHd.id})">Áp Dụng</button>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-semibold small">Phương thức thanh toán <span class="text-danger">*</span></label>
                                    <select name="ptttId" class="form-select" required>
                                        <c:forEach var="pt" items="${ptttList}">
                                            <c:if test="${pt.id == 1 || pt.id == 2}">
                                                <option value="${pt.id}">${pt.tenPhuongThuc}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="bg-light p-3 rounded mb-4">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Tổng tiền hàng:</span>
                                        <span class="fw-bold">
                                            <fmt:formatNumber value="${currentHd.tienHang != null ? currentHd.tienHang : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2 text-success">
                                        <span>Giảm giá voucher:</span>
                                        <span class="fw-bold">- <fmt:formatNumber value="${currentHd.soTienGiam != null ? currentHd.soTienGiam : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                                    </div>
                                    <div class="d-flex justify-content-between border-top pt-2 mt-2">
                                        <span class="fw-bold fs-5">Khách phải trả:</span>
                                        <span class="fw-bold fs-4 text-danger">
                                            <fmt:formatNumber value="${currentHd.tongTien != null ? currentHd.tongTien : (currentHd.tienHang != null ? currentHd.tienHang : 0)}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-runmax w-100 py-3 fs-6">
                                    <i class="bi bi-check-circle-fill me-2"></i> Hoàn tất Thanh toán & In hóa đơn
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <form id="ttActionForm" action="${pageContext.request.contextPath}/ban-hang" method="POST" style="display:none;">
        <input type="hidden" name="action" id="ttActionInput">
        <input type="hidden" name="hdId" id="ttHdIdInput">
        <input type="hidden" name="phieuGiamGiaId" id="ttPggIdInput">
        <input type="hidden" name="sdt" id="ttSdtInput">
        <input type="hidden" name="tenKhachHang" id="ttTenKhInput">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function apDungVoucherTT(hdId) {
            const selectPgg = document.getElementById('selectPggTT');
            const chiTietCount = ${empty chiTiets ? 0 : chiTiets.size()};
            if (chiTietCount <= 0 && selectPgg && selectPgg.value !== '') {
                showBootstrapAlert('Hóa đơn chưa có sản phẩm nào để áp dụng voucher!', 'warning');
                return;
            }
            const sdtInput = document.getElementById('ttInputSdt');
            const tenKhInput = document.getElementById('ttInputTenKh');
            if (sdtInput && sdtInput.value.trim() !== '' && !/^[0-9]{10,11}$/.test(sdtInput.value.trim())) {
                showBootstrapAlert('Số điện thoại phải từ 10 đến 11 chữ số hợp lệ!', 'warning');
                if (sdtInput.focus) sdtInput.focus();
                return;
            }
            document.getElementById('ttActionInput').value = 'ap-voucher';
            document.getElementById('ttHdIdInput').value = hdId;
            document.getElementById('ttPggIdInput').value = selectPgg ? selectPgg.value : '';
            document.getElementById('ttSdtInput').value = sdtInput ? sdtInput.value.trim() : '';
            document.getElementById('ttTenKhInput').value = tenKhInput ? tenKhInput.value.trim() : '';
            document.getElementById('ttActionForm').submit();
        }
    </script>
</body>
</html>
