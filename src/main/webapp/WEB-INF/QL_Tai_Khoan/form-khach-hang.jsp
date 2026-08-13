<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${khachHang != null && khachHang.id != null ? 'Cập nhật Khách hàng' : 'Thêm Khách hàng Mới'}" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .avatar-upload-box {
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .avatar-upload-box:hover {
            border-color: var(--runmax-primary) !important;
            transform: scale(1.03);
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.15);
        }
        .address-card {
            border: 1px solid var(--runmax-border);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            background-color: #fff;
            transition: all 0.2s ease;
        }
        .address-card:hover {
            border-color: #fca5a5;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .address-card.is-default {
            border-color: var(--runmax-primary);
            background-color: #fffcfc;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="runmax-card" style="max-width: 1200px; margin: 0 auto; padding: 2rem;">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                        <h5 class="fw-bold mb-0 text-danger d-flex align-items-center">
                            <i class="bi bi-person-lines-fill me-2 fs-4"></i> Quản lý khách hàng / <span class="text-dark ms-1 fs-6 fw-normal">${khachHang != null && khachHang.id != null ? 'Cập nhật' : 'Thêm mới'}</span>
                        </h5>
                        <a href="${pageContext.request.contextPath}/khach-hang" class="btn btn-sm btn-outline-secondary px-3">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>

                    <form action="${pageContext.request.contextPath}/khach-hang" method="post" id="khachHangForm" class="needs-validation" novalidate onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="save">
                        <c:if test="${khachHang != null && khachHang.id != null}">
                            <input type="hidden" name="id" value="${khachHang.id}">
                        </c:if>

                        <!-- GRID THÔNG TIN CƠ BẢN (2 CỘT) -->
                        <div class="row g-3">
                            <c:if test="${khachHang != null && khachHang.id != null}">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Mã khách hàng</label>
                                    <input type="text" name="maKh" class="form-control bg-light text-secondary fw-semibold" readonly tabindex="-1"
                                           value="${khachHang.maKh}">
                                </div>
                            </c:if>
                            <div class="${khachHang != null && khachHang.id != null ? 'col-md-6' : 'col-md-12'}">
                                <label class="form-label fw-semibold">Tên khách hàng <span class="text-danger">*</span></label>
                                <input type="text" name="hoTen" class="form-control" required
                                       value="${khachHang != null ? khachHang.hoTen : ''}" placeholder="Nhập tên khách hàng">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" name="sdt" class="form-control" required pattern="^0[0-9]{9}$" maxlength="10" minlength="10" title="Số điện thoại phải bao gồm 10 chữ số và bắt đầu bằng số 0"
                                       value="${khachHang != null ? khachHang.sdt : ''}" placeholder="VD: 0912345678">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="${khachHang != null ? khachHang.email : ''}" placeholder="VD: abc@gmail.com">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Ngày sinh</label>
                                <input type="date" name="ngaySinh" class="form-control"
                                       value="${khachHang != null && khachHang.ngaySinh != null ? khachHang.ngaySinh : ''}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold d-block">Giới tính</label>
                                <div class="pt-2 d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gioiTinh" id="genderNam" value="1"
                                               ${khachHang == null || khachHang.gioiTinh == null || khachHang.gioiTinh == 1 ? 'checked' : ''}>
                                        <label class="form-check-label" for="genderNam">Nam</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gioiTinh" id="genderNu" value="0"
                                               ${khachHang != null && khachHang.gioiTinh != null && khachHang.gioiTinh == 0 ? 'checked' : ''}>
                                        <label class="form-check-label" for="genderNu">Nữ</label>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${khachHang != null && khachHang.id != null}">
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold d-block">Trạng thái</label>
                                    <div class="pt-2 d-flex gap-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="trangThai" id="statusActive" value="1"
                                                   ${khachHang == null || khachHang.trangThai == null || khachHang.trangThai == 1 ? 'checked' : ''}>
                                            <label class="form-check-label text-success fw-medium" for="statusActive">Hoạt động</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="trangThai" id="statusInactive" value="0"
                                                   ${khachHang != null && khachHang.trangThai != null && khachHang.trangThai == 0 ? 'checked' : ''}>
                                            <label class="form-check-label text-secondary fw-medium" for="statusInactive">Không hoạt động</label>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- PHẦN QUẢN LÝ ĐỊA CHỈ -->
                        <div class="mt-4 pt-3 border-top">
                            <h6 class="fw-bold mb-3 text-dark d-flex align-items-center">
                                <i class="bi bi-geo-alt-fill text-danger me-2"></i> Quản lý địa chỉ
                            </h6>

                            <!-- Banner Thêm địa chỉ mới -->
                            <div class="p-3 rounded-3 mb-3 d-flex justify-content-between align-items-center" 
                                 style="background-color: var(--runmax-primary-light); border: 1px dashed var(--runmax-primary);">
                                <div>
                                    <div class="fw-bold text-danger mb-1">Thêm địa chỉ mới</div>
                                    <div class="text-muted small">Nhập thông tin địa chỉ để lưu vào danh sách bên dưới.</div>
                                </div>
                                <button type="button" class="btn btn-runmax btn-sm px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalThemDiaChi">
                                    <i class="bi bi-plus-lg me-1"></i> Thêm địa chỉ
                                </button>
                            </div>

                            <!-- Nơi hiển thị danh sách địa chỉ -->
                            <div id="addressContainer">
                                <!-- JS sẽ render thẻ địa chỉ vào đây -->
                            </div>
                            <div id="emptyAddressNote" class="text-muted small py-2">
                                Chưa có địa chỉ nào. Nhấn <b>Thêm địa chỉ</b> để tạo mới.<br>
                                <span class="text-secondary" style="font-size: 0.825rem;">Tối đa 5 địa chỉ.</span>
                            </div>

                            <!-- Chứa input hidden để submit danh sách địa chỉ lên server -->
                            <div id="addressHiddenInputs"></div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                            <span class="text-muted small"><i class="bi bi-info-circle me-1"></i> Vui lòng điền đầy đủ các thông tin bắt buộc (*)</span>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/khach-hang" class="btn btn-light border px-4">Hủy</a>
                                <button type="submit" class="btn btn-runmax px-4 shadow-sm">
                                    <i class="bi bi-check2-circle me-1"></i> ${khachHang != null && khachHang.id != null ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <!-- MODAL THÊM ĐỊA CHỈ (CHỈ CHỌN ĐỊA CHỈ - KHÔNG CẦN TÊN & SĐT) -->
    <div class="modal fade" id="modalThemDiaChi" tabindex="-1" aria-labelledby="modalThemDiaChiLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold" id="modalThemDiaChiLabel">
                        <i class="bi bi-geo-alt me-2"></i> Thêm địa chỉ
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-muted small mb-3 pb-2 border-bottom">
                        <i class="bi bi-info-circle text-danger me-1"></i> Nhập đầy đủ thông tin địa chỉ để thêm vào danh sách khách hàng.
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                            <select id="modalTinhThanh" class="form-select">
                                <option value="">-- Chọn Tỉnh/Thành phố --</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Quận/Huyện <span class="text-danger">*</span></label>
                            <select id="modalQuanHuyen" class="form-select" disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Phường/Xã/Đặc khu <span class="text-danger">*</span></label>
                            <select id="modalPhuongXa" class="form-select" disabled>
                                <option value="">-- Chọn Phường/Xã/Đặc khu --</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Địa chỉ chi tiết <span class="text-danger">*</span></label>
                            <input type="text" id="modalChiTiet" class="form-control" placeholder="VD: 12 Cầu Giấy, Tòa nhà A...">
                        </div>
                        <div class="col-12 pt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="modalMacDinh">
                                <label class="form-check-label fw-medium text-dark" for="modalMacDinh">
                                    Đặt làm mặc định
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light px-4 py-3">
                    <button type="button" class="btn btn-light border px-4" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-runmax px-4" onclick="addAddressFromModal()">
                        <i class="bi bi-plus-circle me-1"></i> Thêm địa chỉ
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/address-helper.js"></script>
    <script>
        // Mảng địa chỉ tạm đang quản lý trên form
        let addressList = [];

        // Pre-load địa chỉ cũ nếu đang ở chế độ chỉnh sửa (Cập nhật Khách hàng)
        <c:if test="${not empty diaChi}">
            <c:forEach var="dc" items="${diaChi}">
                addressList.push({
                    id: ${dc.id != null ? dc.id : 'null'},
                    tinhThanhPho: "${dc.tinhThanhPho != null ? dc.tinhThanhPho : ''}",
                    quanHuyen: "${dc.quanHuyen != null ? dc.quanHuyen : ''}",
                    phuongXa: "${dc.phuongXa != null ? dc.phuongXa : ''}",
                    diaChiChiTiet: "${dc.diaChiChiTiet != null ? dc.diaChiChiTiet : ''}",
                    trangThai: ${dc.trangThai != null ? dc.trangThai : 0}
                });
            </c:forEach>
        </c:if>

        // Render danh sách khi tải trang
        document.addEventListener("DOMContentLoaded", function() {
            renderAddresses();
            RunMaxAddressHelper.initCascading({
                provId: "modalTinhThanh",
                distId: "modalQuanHuyen",
                wardId: "modalPhuongXa",
                useIndexAsValue: false
            });
        });


        function renderAddresses() {
            const container = document.getElementById("addressContainer");
            const note = document.getElementById("emptyAddressNote");
            const hiddenContainer = document.getElementById("addressHiddenInputs");

            container.innerHTML = "";
            hiddenContainer.innerHTML = "";

            if (addressList.length === 0) {
                note.style.display = "block";
            } else {
                note.style.display = "none";
                addressList.forEach((addr, idx) => {
                    // Tạo card hiển thị
                    const card = document.createElement("div");
                    card.className = "address-card d-flex justify-content-between align-items-center " + (addr.trangThai === 1 ? "is-default" : "");
                    
                    let fullText = addr.diaChiChiTiet;
                    if (addr.phuongXa) fullText += ", " + addr.phuongXa;
                    if (addr.quanHuyen) fullText += ", " + addr.quanHuyen;
                    if (addr.tinhThanhPho) fullText += ", " + addr.tinhThanhPho;

                    card.innerHTML = `
                        <div class="pe-3">
                            <div class="fw-semibold text-dark mb-1">
                                \${fullText}
                                \${addr.trangThai === 1 ? '<span class="badge bg-danger ms-2" style="font-size:0.7rem;"><i class="bi bi-check-circle me-1"></i>Mặc định</span>' : ''}
                            </div>
                            <div class="d-flex align-items-center mt-2">
                                <div class="form-check form-check-inline mb-0">
                                    <input class="form-check-input" type="radio" name="defaultRadioGroup" id="radioDefault_\${idx}" 
                                           \${addr.trangThai === 1 ? 'checked' : ''} onchange="setDefaultAddress(\${idx})">
                                    <label class="form-check-label text-muted small cursor-pointer" for="radioDefault_\${idx}">Đặt làm mặc định</label>
                                </div>
                            </div>
                        </div>
                        <div>
                            <button type="button" class="btn btn-sm text-danger border-0 p-1" title="Xóa địa chỉ" onclick="removeAddress(\${idx})">
                                <i class="bi bi-trash fs-5"></i>
                            </button>
                        </div>
                    `;
                    container.appendChild(card);

                    // Tạo hidden inputs để submit
                    hiddenContainer.innerHTML += `
                        <input type="hidden" name="dc_tinhThanhPho" value="\${escapeHtml(addr.tinhThanhPho)}">
                        <input type="hidden" name="dc_quanHuyen" value="\${escapeHtml(addr.quanHuyen)}">
                        <input type="hidden" name="dc_phuongXa" value="\${escapeHtml(addr.phuongXa)}">
                        <input type="hidden" name="dc_diaChiChiTiet" value="\${escapeHtml(addr.diaChiChiTiet)}">
                        <input type="hidden" name="dc_trangThai" value="\${addr.trangThai}">
                    `;
                });
            }
        }

        function escapeHtml(str) {
            if (!str) return "";
            return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
        }

        function removeAddress(index) {
            addressList.splice(index, 1);
            // Nếu xóa mất mặc định mà vẫn còn địa chỉ thì đặt địa chỉ đầu làm mặc định
            if (addressList.length > 0 && !addressList.some(a => a.trangThai === 1)) {
                addressList[0].trangThai = 1;
            }
            renderAddresses();
        }

        function setDefaultAddress(index) {
            addressList.forEach((addr, idx) => {
                addr.trangThai = (idx === index) ? 1 : 0;
            });
            renderAddresses();
            <c:if test="${khachHang != null && khachHang.id != null}">
            if (addressList[index].id && addressList[index].id !== null && addressList[index].id !== 'null') {
                fetch('${pageContext.request.contextPath}/khach-hang?action=setDefaultAddress&id=' + addressList[index].id + '&khId=${khachHang.id}&ajax=true', {
                    method: 'POST'
                }).then(res => {
                    console.log('Đã cập nhật thuộc tính mặc định vào SQL thành công!');
                });
            }
            </c:if>
        }

        function addAddressFromModal() {
            const tinhThanhEl = document.getElementById("modalTinhThanh");
            const quanHuyenEl = document.getElementById("modalQuanHuyen");
            const phuongXaEl  = document.getElementById("modalPhuongXa");
            const chiTietEl   = document.getElementById("modalChiTiet");
            const macDinhEl   = document.getElementById("modalMacDinh");

            const tinhThanh = tinhThanhEl.options[tinhThanhEl.selectedIndex]?.text || "";
            const quanHuyen = quanHuyenEl.options[quanHuyenEl.selectedIndex]?.text || "";
            const phuongXa  = phuongXaEl.options[phuongXaEl.selectedIndex]?.text || "";
            const chiTiet   = chiTietEl.value.trim();

            [tinhThanhEl, quanHuyenEl, phuongXaEl, chiTietEl].forEach(el => el.classList.remove('is-invalid'));

            if (!tinhThanhEl.value || !tinhThanh) {
                tinhThanhEl.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng chọn Tỉnh/Thành phố!", "danger");
                tinhThanhEl.focus();
                return;
            }
            if (!quanHuyenEl.value || !quanHuyen || quanHuyen.includes("--")) {
                quanHuyenEl.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng chọn Quận/Huyện!", "danger");
                quanHuyenEl.focus();
                return;
            }
            if (!phuongXaEl.value || !phuongXa || phuongXa.includes("--")) {
                phuongXaEl.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng chọn Phường/Xã/Đặc khu!", "danger");
                phuongXaEl.focus();
                return;
            }
            if (!chiTiet) {
                chiTietEl.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng nhập Địa chỉ chi tiết (số nhà, đường...)!", "danger");
                chiTietEl.focus();
                return;
            }

            if (addressList.length >= 5) {
                showBootstrapAlert("Bạn chỉ được thêm tối đa 5 địa chỉ!", "warning");
                return;
            }

            let isDefault = macDinhEl.checked ? 1 : (addressList.length === 0 ? 1 : 0);
            if (isDefault === 1) {
                addressList.forEach(a => a.trangThai = 0);
            }

            addressList.push({
                id: null,
                tinhThanhPho: tinhThanh,
                quanHuyen: quanHuyen,
                phuongXa: phuongXa,
                diaChiChiTiet: chiTiet,
                trangThai: isDefault
            });

            renderAddresses();

            // Reset modal
            tinhThanhEl.value = "";
            quanHuyenEl.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
            quanHuyenEl.disabled = true;
            phuongXaEl.innerHTML = '<option value="">-- Chọn Phường/Xã/Đặc khu --</option>';
            phuongXaEl.disabled = true;
            chiTietEl.value = "";
            macDinhEl.checked = false;

            // Đóng modal
            const modalEl = document.getElementById('modalThemDiaChi');
            const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modalInstance.hide();
        }

        function validateForm() {
            const form = document.getElementById('khachHangForm');
            const hoTenInput = document.querySelector('input[name="hoTen"]');
            if (hoTenInput) {
                const val = hoTenInput.value.trim();
                if (val.length < 2) {
                    hoTenInput.classList.add('is-invalid');
                    showBootstrapAlert("Họ và tên khách hàng phải có ít nhất 2 ký tự và không được chỉ chứa khoảng trắng!", "danger");
                    hoTenInput.focus();
                    return false;
                }
                hoTenInput.value = val;
            }
            const sdtInput = document.querySelector('input[name="sdt"]');
            if (sdtInput && !/^0[0-9]{9}$/.test(sdtInput.value.trim())) {
                sdtInput.classList.add('is-invalid');
                showBootstrapAlert("Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0!", "danger");
                sdtInput.focus();
                return false;
            }
            if (form && !form.checkValidity()) {
                form.classList.add('was-validated');
                showToast("Vui lòng kiểm tra và điền đầy đủ các trường thông tin có viền đỏ!", "danger", "Thiếu thông tin");
                return false;
            }
            if (form) form.classList.add('was-validated');

            // Ngăn chặn form submit ngay lập tức
            if (event) {
                event.preventDefault();
            }

            // Hiển thị Popup xác nhận
            Swal.fire({
                title: '<span style="color: #333; font-weight: 700; font-size: 22px;">Xác nhận lưu?</span>',
                html: '<span style="color: #666; font-size: 15px;">Bạn có chắc chắn muốn lưu thông tin này vào hệ thống?</span>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="bi bi-floppy me-1"></i> Đồng ý lưu',
                cancelButtonText: 'Hủy bỏ',
                buttonsStyling: true,
                customClass: {
                    popup: 'rounded-4 shadow-sm border-0',
                    confirmButton: 'px-4 py-2 fw-bold rounded-pill',
                    cancelButton: 'px-4 py-2 fw-bold rounded-pill'
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    // Disable nút submit để tránh double-click
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
                        submitBtn.disabled = true;
                    }
                    // Thực hiện submit form bypass qua hàm onsubmit
                    form.submit();
                }
            });

            return false; // Luôn trả về false để onsubmit gốc không tự chạy
        }

    </script>
</body>
</html>
