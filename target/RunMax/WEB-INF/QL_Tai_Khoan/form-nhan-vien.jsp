<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${nhanVienEdit != null ? 'Cập nhật nhân viên' : 'Thêm nhân viên'}" scope="request" />
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
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">
                <div class="runmax-card" style="max-width: 900px; margin: 0 auto;">
                    <!-- HEADER: Tiêu đề + Nút Quét QR CCCD & Quay lại -->
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                        <h5 class="fw-bold mb-0 text-danger d-flex align-items-center">
                            <i class="bi bi-person-badge-fill me-2 fs-4"></i> ${pageTitle}
                        </h5>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-sm btn-outline-danger px-3 d-flex align-items-center shadow-sm" onclick="showScanQRModal()">
                                <i class="bi bi-qr-code-scan me-2"></i> Quét QR CCCD
                            </button>
                            <a href="${pageContext.request.contextPath}/nhan-vien" class="btn btn-sm btn-outline-secondary px-3 d-flex align-items-center">
                                <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                            </a>
                        </div>
                    </div>

                    <!-- FORM DATA GRID -->
                    <form action="${pageContext.request.contextPath}/nhan-vien" method="post" enctype="multipart/form-data" id="formNhanVien" class="needs-validation" novalidate onsubmit="return validateFormNhanVien(event)">
                        <input type="hidden" name="action" value="save">
                        <c:if test="${nhanVienEdit != null}">
                            <input type="hidden" name="id" value="${nhanVienEdit.id}">
                            <input type="hidden" name="anhDaiDien" value="${nhanVienEdit.anhDaiDien}">
                        </c:if>

                        <!-- PHẦN AVATAR (GIỮA TRANG) -->
                        <div class="text-center mb-4 pb-2">
                            <div class="avatar-upload-box d-inline-flex align-items-center justify-content-center rounded-circle bg-light border text-secondary mb-2 position-relative overflow-hidden shadow-sm" 
                                 style="width: 86px; height: 86px; font-size: 1.8rem; font-weight: 700; color: #4b5563 !important; cursor: pointer;" 
                                 onclick="document.getElementById('avatarInput').click();" title="Bấm để chọn ảnh đại diện">
                                <span id="avatarText" class="${nhanVienEdit != null && not empty nhanVienEdit.anhDaiDien ? 'd-none' : ''}">NV</span>
                                <c:set var="editAvtUrl" value="${nhanVienEdit != null && not empty nhanVienEdit.anhDaiDien ? (fn:startsWith(nhanVienEdit.anhDaiDien, 'http') || fn:startsWith(nhanVienEdit.anhDaiDien, '/') ? nhanVienEdit.anhDaiDien : pageContext.request.contextPath.concat('/').concat(nhanVienEdit.anhDaiDien)) : ''}" />
                                <img id="avatarPreview" src="${editAvtUrl}" 
                                     alt="Avatar" class="w-100 h-100 object-fit-cover position-absolute top-0 start-0 ${nhanVienEdit != null && not empty nhanVienEdit.anhDaiDien ? '' : 'd-none'}"
                                     onerror="this.style.display='none'; document.getElementById('avatarText').classList.remove('d-none');">
                            </div>
                            <input type="file" name="fileAnh" id="avatarInput" accept="image/png, image/jpeg, image/jpg" class="d-none" onchange="previewAvatar(this)">
                            <div class="text-muted small" style="font-size: 0.8rem;">PNG, JPG, JPEG - tối đa 5MB.</div>
                        </div>

                        <div class="row g-3">
                            <!-- Hàng 1: Mã nhân viên | Chức vụ -->
                            <c:if test="${nhanVienEdit != null && nhanVienEdit.id != null}">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Mã nhân viên</label>
                                    <input type="text" name="maNv" class="form-control bg-light text-secondary fw-semibold" readonly tabindex="-1"
                                           value="${nhanVienEdit.maNv}">
                                </div>
                            </c:if>
                            <div class="${nhanVienEdit != null && nhanVienEdit.id != null ? 'col-md-6' : 'col-md-12'}">
                                <label class="form-label fw-semibold text-secondary small mb-1">Chức vụ <span class="text-danger">*</span></label>
                                <select name="vaiTroId" class="form-select" required>
                                    <c:forEach var="vt" items="${vaiTros}">
                                        <option value="${vt.id}" ${nhanVienEdit != null && nhanVienEdit.vaiTro != null && nhanVienEdit.vaiTro.id == vt.id ? 'selected' : ''}>
                                            ${vt.tenVaiTro}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Hàng 2: Tên nhân viên | Giới tính -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Tên nhân viên <span class="text-danger">*</span></label>
                                <input type="text" name="hoTen" class="form-control" required
                                       value="${nhanVienEdit != null ? nhanVienEdit.hoTen : ''}" placeholder="Nhập tên nhân viên...">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1 d-block">Giới tính</label>
                                <div class="pt-2 d-flex gap-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gioiTinh" id="genderNam" value="1"
                                               ${nhanVienEdit == null || nhanVienEdit.gioiTinh == null || nhanVienEdit.gioiTinh ? 'checked' : ''}>
                                        <label class="form-check-label text-dark" for="genderNam">Nam</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gioiTinh" id="genderNu" value="0"
                                               ${nhanVienEdit != null && nhanVienEdit.gioiTinh != null && !nhanVienEdit.gioiTinh ? 'checked' : ''}>
                                        <label class="form-check-label text-dark" for="genderNu">Nữ</label>
                                    </div>
                                </div>
                            </div>

                            <!-- Hàng 3: Số điện thoại | Email -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" name="sdt" class="form-control" required pattern="^0[0-9]{9}$" maxlength="10" minlength="10" title="Số điện thoại phải bao gồm 10 chữ số và bắt đầu bằng số 0"
                                       value="${nhanVienEdit != null ? nhanVienEdit.sdt : ''}" placeholder="VD: 0912345678">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Email <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="form-control" required
                                       value="${nhanVienEdit != null ? nhanVienEdit.email : ''}" placeholder="VD: abc@gmail.com">
                            </div>

                            <!-- Hàng 4: Ngày sinh | Tỉnh/Thành phố -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Ngày sinh</label>
                                <input type="date" name="ngaySinh" class="form-control"
                                       value="${nhanVienEdit != null && nhanVienEdit.ngaySinh != null ? nhanVienEdit.ngaySinh : ''}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                                <select id="tinhThanhSelect" name="tinhThanhPho" class="form-select" required>
                                    <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                </select>
                            </div>

                            <!-- Hàng 5: Quận/Huyện & Phường/Xã | Tên đường -->
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary small mb-1">Quận/Huyện <span class="text-danger">*</span></label>
                                <select id="quanHuyenSelect" name="quanHuyen" class="form-select" required disabled>
                                    <option value="">-- Chọn Quận/Huyện --</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary small mb-1">Phường/Xã/Đặc khu <span class="text-danger">*</span></label>
                                <select id="phuongXaSelect" name="phuongXa" class="form-select" required disabled>
                                    <option value="">-- Chọn Phường/Xã/Đặc khu --</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Tên đường <span class="text-danger">*</span></label>
                                <input type="text" name="diaChiChiTiet" class="form-control" required
                                       value="${nhanVienEdit != null ? nhanVienEdit.diaChiChiTiet : ''}" placeholder="Số nhà, tên đường...">
                            </div>

                            <!-- Hàng 6: Tài khoản | Mật khẩu (Tự động hoặc Khóa protection) -->
                            <c:if test="${nhanVienEdit == null}">
                                <!-- Banner thông báo tự tạo tài khoản & mật khẩu cho thêm mới -->
                                <div class="col-md-12" id="autoAuthBanner">
                                    <div class="p-3 bg-light border rounded-3 d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3 shadow-sm">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-circle bg-danger bg-opacity-10 text-danger p-2 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 44px; height: 44px;">
                                                <i class="bi bi-shield-lock-fill fs-5"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1 fw-bold text-dark">Tài khoản & Mật khẩu được thiết lập tự động</h6>
                                                <p class="mb-0 text-muted small">
                                                    Hệ thống tự lấy <strong class="text-danger">Số điện thoại</strong> hoặc <strong class="text-danger">Email</strong> làm tài khoản, đồng thời tạo mật khẩu ngẫu nhiên & gửi qua Email.
                                                </p>
                                            </div>
                                        </div>
                                        <div>
                                            <button type="button" class="btn btn-sm btn-outline-secondary text-nowrap d-flex align-items-center gap-1 px-3 shadow-sm" id="btnToggleAuth" onclick="toggleCustomAuth()">
                                                <i class="bi bi-pencil-square"></i> Tự chỉnh sửa / Nhập tay
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${nhanVienEdit != null}">
                                <div class="col-md-12 mb-1 d-flex justify-content-between align-items-center">
                                    <span class="fw-semibold text-secondary small"><i class="bi bi-person-lock me-1"></i>Thông tin đăng nhập hệ thống</span>
                                    <button type="button" class="btn btn-sm btn-outline-danger px-3 shadow-sm d-flex align-items-center gap-1" id="btnUnlockEditAuth" onclick="unlockEditAuth()">
                                        <i class="bi bi-pencil-square"></i> Chỉnh sửa tài khoản / mật khẩu
                                    </button>
                                </div>
                            </c:if>

                            <!-- Khung nhập tài khoản & mật khẩu (được ẩn/khóa mặc định) -->
                            <div id="authFieldsContainer" class="col-md-12" style="${nhanVienEdit == null ? 'display: none;' : ''}">
                                <div class="row g-3 p-3 bg-light border rounded-3 position-relative">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-secondary small mb-1">Tài khoản <span class="badge bg-secondary-subtle text-dark border ms-1" style="font-size:0.7rem;" id="badgeAccountStatus">${nhanVienEdit == null ? 'Tự nhập tay' : 'Đã khóa bảo vệ'}</span></label>
                                        <input type="text" id="inputTenDangNhap" name="tenDangNhap" class="form-control"
                                               value="${nhanVienEdit != null ? nhanVienEdit.tenDangNhap : ''}"
                                               placeholder="Nhập tên đăng nhập hoặc email..."
                                               ${nhanVienEdit == null ? 'disabled' : 'readonly'}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-secondary small mb-1">Mật khẩu <span class="badge bg-secondary-subtle text-dark border ms-1" style="font-size:0.7rem;" id="badgePasswordStatus">${nhanVienEdit == null ? 'Tự nhập tay' : 'Đã khóa bảo vệ'}</span></label>
                                        <input type="password" id="inputMatKhau" name="matKhau" class="form-control"
                                               placeholder="${nhanVienEdit == null ? 'Nhập mật khẩu cho nhân viên...' : '******** (Bỏ trống nếu không đổi)'}"
                                               ${nhanVienEdit == null ? 'disabled' : 'readonly'}>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${nhanVienEdit != null && nhanVienEdit.id != null}">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-secondary small mb-1 d-block">Trạng thái</label>
                                    <div class="pt-2 d-flex gap-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="trangThai" id="statusActive" value="1"
                                                   ${nhanVienEdit == null || nhanVienEdit.trangThai == null || nhanVienEdit.trangThai == 1 ? 'checked' : ''}>
                                            <label class="form-check-label text-success fw-medium" for="statusActive">Đang làm việc</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="trangThai" id="statusInactive" value="0"
                                                   ${nhanVienEdit != null && nhanVienEdit.trangThai != null && nhanVienEdit.trangThai == 0 ? 'checked' : ''}>
                                            <label class="form-check-label text-secondary fw-medium" for="statusInactive">Đã nghỉ việc</label>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- FOOTER -->
                        <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                            <span class="text-muted small" style="font-style: italic;">Vui lòng điền đầy đủ các thông tin.</span>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/nhan-vien" class="btn btn-light border px-4">Hủy</a>
                                <button type="submit" class="btn btn-runmax px-4 shadow-sm">
                                    <i class="bi bi-check2-circle me-1"></i> Lưu nhân viên
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <!-- MODAL QUÉT QR CCCD (Giả lập) -->
    <div class="modal fade" id="modalScanQR" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold"><i class="bi bi-qr-code-scan me-2"></i> Quét mã QR thẻ Căn cước công dân</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-4">
                    <div id="qr-reader" style="width: 100%; min-height: 250px;"></div>
                    <div class="alert alert-warning small mb-0 text-start">
                        <i class="bi bi-info-circle-fill me-1"></i> Tính năng quét trực tiếp cần thiết bị hỗ trợ Camera hoặc máy đọc mã vạch kết nối USB.
                    </div>
                </div>
                <div class="modal-footer bg-light px-4 py-2">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/address-helper.js"></script>
    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
                    document.getElementById('avatarPreview').style.display = '';
                    document.getElementById('avatarPreview').classList.remove('d-none');
                    document.getElementById('avatarText').classList.add('d-none');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function showScanQRModal() {
            const modalEl = document.getElementById('modalScanQR');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }

        // Khởi tạo bộ chọn địa chỉ Tỉnh - Huyện - Xã siêu tốc bằng RunMaxAddressHelper
        document.addEventListener("DOMContentLoaded", function() {
            RunMaxAddressHelper.initCascading({
                provId: "tinhThanhSelect",
                distId: "quanHuyenSelect",
                wardId: "phuongXaSelect",
                oldProv: "${nhanVienEdit != null && nhanVienEdit.tinhThanhPho != null ? nhanVienEdit.tinhThanhPho : ''}",
                oldDist: "${nhanVienEdit != null && nhanVienEdit.quanHuyen != null ? nhanVienEdit.quanHuyen : ''}",
                oldWard: "${nhanVienEdit != null && nhanVienEdit.phuongXa != null ? nhanVienEdit.phuongXa : ''}",
                useIndexAsValue: false
            });
        });

        // Đảm bảo trước khi submit form, nếu select có giá trị thì bật enable để gửi dữ liệu chính xác
        function validateFormNhanVien(event) {
            const form = document.getElementById('formNhanVien');
            const hoTenInput = form.querySelector('input[name="hoTen"]');
            if (hoTenInput && hoTenInput.value.trim().length < 2) {
                hoTenInput.classList.add('is-invalid');
                showToast("Họ và tên nhân viên phải có ít nhất 2 ký tự!", "danger", "Lỗi dữ liệu");
                hoTenInput.focus();
                event.preventDefault();
                event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            }

            const sdtInput = form.querySelector('input[name="sdt"]');
            if (sdtInput && !/^0[0-9]{9}$/.test(sdtInput.value.trim())) {
                sdtInput.classList.add('is-invalid');
                showToast("Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0!", "danger", "Lỗi dữ liệu");
                sdtInput.focus();
                event.preventDefault();
                event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            }

            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
                form.classList.add('was-validated');
                showToast("Vui lòng kiểm tra và điền đầy đủ các trường thông tin có viền đỏ!", "danger", "Thiếu thông tin");
                return false;
            }

            const distSelect = document.getElementById("quanHuyenSelect");
            const wardSelect = document.getElementById("phuongXaSelect");
            if (distSelect && distSelect.value !== "") distSelect.disabled = false;
            if (wardSelect && wardSelect.value !== "") wardSelect.disabled = false;
            form.classList.add('was-validated');

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
                } else {
                    // Khôi phục trạng thái disable để không bị lỗi UX nếu người dùng chọn Hủy
                    if (distSelect && distSelect.value !== "") distSelect.disabled = true;
                    if (wardSelect && wardSelect.value !== "") wardSelect.disabled = true;
                }
            });

            return false; // Luôn trả về false để onsubmit gốc không tự chạy
        }

        // Ẩn/Hiện và bật/tắt ô nhập tay Tài khoản & Mật khẩu cho form Thêm mới
        function toggleCustomAuth() {
            const container = document.getElementById("authFieldsContainer");
            const btn = document.getElementById("btnToggleAuth");
            const inputAcc = document.getElementById("inputTenDangNhap");
            const inputPass = document.getElementById("inputMatKhau");

            if (!container || !btn || !inputAcc || !inputPass) return;

            if (container.style.display === "none") {
                // Mở cho phép tự nhập
                container.style.display = "block";
                inputAcc.disabled = false;
                inputPass.disabled = false;
                btn.innerHTML = '<i class="bi bi-lock-fill"></i> Khóa lại (Dùng tự động)';
                btn.classList.remove("btn-outline-secondary");
                btn.classList.add("btn-danger");
                inputAcc.focus();
            } else {
                // Khóa lại (dùng tự động)
                container.style.display = "none";
                inputAcc.disabled = true;
                inputPass.disabled = true;
                inputAcc.value = "";
                inputPass.value = "";
                btn.innerHTML = '<i class="bi bi-pencil-square"></i> Tự chỉnh sửa / Nhập tay';
                btn.classList.remove("btn-danger");
                btn.classList.add("btn-outline-secondary");
            }
        }

        // Mở khóa chỉnh sửa Tài khoản / Mật khẩu cho form Cập nhật nhân viên
        function unlockEditAuth() {
            const inputAcc = document.getElementById("inputTenDangNhap");
            const inputPass = document.getElementById("inputMatKhau");
            const btn = document.getElementById("btnUnlockEditAuth");
            const badgeAcc = document.getElementById("badgeAccountStatus");
            const badgePass = document.getElementById("badgePasswordStatus");

            if (!inputAcc || !inputPass) return;

            if (inputAcc.readOnly) {
                // Mở khóa
                inputAcc.readOnly = false;
                inputPass.readOnly = false;
                if (badgeAcc) { badgeAcc.textContent = "Đang chỉnh sửa"; badgeAcc.className = "badge bg-warning text-dark border ms-1"; }
                if (badgePass) { badgePass.textContent = "Đang chỉnh sửa"; badgePass.className = "badge bg-warning text-dark border ms-1"; }
                if (btn) {
                    btn.innerHTML = '<i class="bi bi-check-circle-fill"></i> Đã mở khóa (Sẵn sàng sửa)';
                    btn.classList.remove("btn-outline-danger");
                    btn.classList.add("btn-success");
                }
                inputAcc.focus();
            } else {
                // Khóa lại
                inputAcc.readOnly = true;
                inputPass.readOnly = true;
                if (badgeAcc) { badgeAcc.textContent = "Đã khóa bảo vệ"; badgeAcc.className = "badge bg-secondary-subtle text-dark border ms-1"; }
                if (badgePass) { badgePass.textContent = "Đã khóa bảo vệ"; badgePass.className = "badge bg-secondary-subtle text-dark border ms-1"; }
                if (btn) {
                    btn.innerHTML = '<i class="bi bi-pencil-square"></i> Chỉnh sửa tài khoản / mật khẩu';
                    btn.classList.remove("btn-success");
                    btn.classList.add("btn-outline-danger");
                }
            }
        }
    </script>
    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        // ============================================================
        //  QR CCCD – Fuzzy Address Mapping với Fallback chặt chẽ
        // ============================================================

        /**
         * Chuẩn hoá chuỗi để so sánh fuzzy:
         *  - lowercase
         *  - bỏ dấu tiếng Việt (NFD decompose + strip combining)
         *  - xoá các tiền/hậu tố hành chính nhiễu
         */
        function normalizeAddrToken(str) {
            if (!str) return '';
            const NOISE = /\b(tinh|thanh pho|tp|quan|huyen|thi xa|tx|xa|phuong|thi tran|tt)\b/gi;
            return str
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '') // bỏ dấu
                .replace(/đ/g, 'd')
                .replace(NOISE, '')
                .replace(/\s+/g, ' ')
                .trim();
        }

        /**
         * Tìm option khớp nhất trong <select> dựa theo fuzzy match.
         * Trả về { value, text } của option tìm thấy, hoặc null.
         */
        function fuzzyFindOption(selectEl, keyword) {
            if (!selectEl || !keyword) return null;
            const needle = normalizeAddrToken(keyword);
            if (!needle) return null;

            let bestMatch = null;
            let bestScore = 0;

            Array.from(selectEl.options).forEach(opt => {
                if (!opt.value) return; // bỏ qua placeholder
                const hay = normalizeAddrToken(opt.text);

                // Exact match → điểm tuyệt đối
                if (hay === needle) {
                    bestMatch = opt;
                    bestScore = Infinity;
                    return;
                }

                // Chứa chuỗi → điểm cao
                if (hay.includes(needle) || needle.includes(hay)) {
                    const score = Math.max(
                        needle.length / Math.max(hay.length, 1),
                        hay.length / Math.max(needle.length, 1)
                    );
                    if (score > bestScore) {
                        bestScore = score;
                        bestMatch = opt;
                    }
                }
            });

            // Ngưỡng tối thiểu: tỷ lệ độ dài ký tự chung >= 0.55
            return bestScore >= 0.55 ? bestMatch : null;
        }

        /**
         * Đợi một <select> được populate (không còn disabled hoặc chỉ có 1 option).
         * Timeout sau maxMs ms.
         */
        function waitForSelectPopulated(selectEl, maxMs = 4000) {
            return new Promise(resolve => {
                const deadline = Date.now() + maxMs;
                const check = () => {
                    const ready = !selectEl.disabled && selectEl.options.length > 1;
                    if (ready || Date.now() > deadline) return resolve(ready);
                    setTimeout(check, 80);
                };
                check();
            });
        }

        /**
         * Hàm mapping địa chỉ tự động từ chuỗi CCCD sang 3 dropdown + diaChiChiTiet.
         *
         * @param {string} rawAddress  – parts[5] từ QR CCCD, VD: "123 Lê Lợi, Phường Bến Thành, Quận 1, Thành phố Hồ Chí Minh"
         */
        async function autoSelectAddressMapping(rawAddress) {
            const diaChiInput   = document.querySelector('input[name="diaChiChiTiet"]');
            const tinhSelect    = document.getElementById('tinhThanhSelect');
            const huyenSelect   = document.getElementById('quanHuyenSelect');
            const xuaSelect     = document.getElementById('phuongXaSelect');

            // --- Helper: đặt toàn bộ địa chỉ vào ô chi tiết và reset dropdown ---
            function dumpFullToChiTiet(msg) {
                if (diaChiInput) diaChiInput.value = rawAddress;
                console.warn('[QR-CCCD]', msg, '– Đã đổ toàn bộ địa chỉ vào ô chi tiết.');
            }

            // --- 1. Bóc tách chuỗi địa chỉ ---
            // Tách theo dấu phẩy, cắt bỏ khoảng trắng thừa
            const segments = rawAddress.split(',').map(s => s.trim()).filter(Boolean);
            // Lấy từ dưới lên: cuối cùng = Tỉnh, kế = Huyện, kế nữa = Xã, còn lại = chi tiết
            const rawTinh   = segments.length >= 1 ? segments[segments.length - 1] : '';
            const rawHuyen  = segments.length >= 2 ? segments[segments.length - 2] : '';
            const rawXa     = segments.length >= 3 ? segments[segments.length - 3] : '';
            const rawChiTiet = segments.length >= 4
                ? segments.slice(0, segments.length - 3).join(', ')
                : '';

            // --- 2. Đợi dropdown Tỉnh sẵn sàng (được load bởi RunMaxAddressHelper) ---
            const tinhReady = await waitForSelectPopulated(tinhSelect, 5000);
            if (!tinhReady || !rawTinh) {
                dumpFullToChiTiet('Dropdown Tỉnh chưa sẵn sàng hoặc không có dữ liệu Tỉnh');
                return;
            }

            // --- 3. Fuzzy match Tỉnh/TP ---
            const tinhOpt = fuzzyFindOption(tinhSelect, rawTinh);
            if (!tinhOpt) {
                dumpFullToChiTiet('Không tìm thấy Tỉnh/TP: "' + rawTinh + '"');
                return; // DỪNG – đổ toàn bộ vào chi tiết
            }

            // Chọn Tỉnh và trigger change để load Huyện
            tinhSelect.value = tinhOpt.value;
            tinhSelect.dispatchEvent(new Event('change', { bubbles: true }));

            // --- 4. Đợi dropdown Huyện được populate ---
            const huyenReady = await waitForSelectPopulated(huyenSelect, 4000);
            if (!huyenReady || !rawHuyen) {
                // Tỉnh ok nhưng Huyện không load được: đổ Xã + Huyện + Chi tiết vào ô
                if (diaChiInput) {
                    const fallback = [rawChiTiet, rawXa, rawHuyen].filter(Boolean).join(', ');
                    diaChiInput.value = fallback || rawAddress;
                }
                console.warn('[QR-CCCD] Dropdown Huyện chưa sẵn sàng – Fallback Huyện+Xã+ChiTiết vào ô.');
                return;
            }

            // --- 5. Fuzzy match Quận/Huyện ---
            const huyenOpt = fuzzyFindOption(huyenSelect, rawHuyen);
            if (!huyenOpt) {
                // Không khớp Huyện: đổ "Xã cũ + Huyện cũ + Chi tiết" vào ô
                if (diaChiInput) {
                    const fallback = [rawChiTiet, rawXa, rawHuyen].filter(Boolean).join(', ');
                    diaChiInput.value = fallback || rawAddress;
                }
                console.warn('[QR-CCCD] Không tìm thấy Huyện: "' + rawHuyen + '" – Fallback vào ô chi tiết.');
                return; // DỪNG
            }

            // Chọn Huyện và trigger change để load Xã
            huyenSelect.value = huyenOpt.value;
            huyenSelect.dispatchEvent(new Event('change', { bubbles: true }));

            // --- 6. Đợi dropdown Xã được populate ---
            const xaReady = await waitForSelectPopulated(xuaSelect, 4000);
            if (!xaReady || !rawXa) {
                // Huyện ok nhưng Xã không load: đổ "Xã cũ + Chi tiết" vào ô
                if (diaChiInput) {
                    const fallback = [rawChiTiet, rawXa].filter(Boolean).join(', ');
                    diaChiInput.value = fallback || rawAddress;
                }
                console.warn('[QR-CCCD] Dropdown Xã chưa sẵn sàng – Fallback Xã+ChiTiết vào ô.');
                return;
            }

            // --- 7. Fuzzy match Phường/Xã ---
            const xaOpt = fuzzyFindOption(xuaSelect, rawXa);
            if (!xaOpt) {
                // Không khớp Xã: đổ "Xã cũ + Chi tiết" vào ô, giữ Tỉnh + Huyện đã chọn
                if (diaChiInput) {
                    const fallback = [rawChiTiet, rawXa].filter(Boolean).join(', ');
                    diaChiInput.value = fallback || rawAddress;
                }
                console.warn('[QR-CCCD] Không tìm thấy Xã: "' + rawXa + '" – Fallback Xã vào ô chi tiết (Tỉnh+Huyện đã chọn).');
                return; // DỪNG (Tỉnh, Huyện vẫn được giữ)
            }

            // Chọn Xã
            xuaSelect.value = xaOpt.value;
            xuaSelect.dispatchEvent(new Event('change', { bubbles: true }));

            // --- 8. Đặt phần địa chỉ chi tiết (số nhà, tên đường còn lại) ---
            if (diaChiInput) {
                diaChiInput.value = rawChiTiet;
            }

            console.info('[QR-CCCD] Mapping hoàn tất:', {
                tinh: tinhOpt.text,
                huyen: huyenOpt.text,
                xa: xaOpt.text,
                chiTiet: rawChiTiet
            });
        }

        // ============================================================
        //  QR Scanner bootstrap
        // ============================================================
        let html5QrcodeScanner;

        const modalScanQREl = document.getElementById('modalScanQR');
        if (modalScanQREl) {
            modalScanQREl.addEventListener('shown.bs.modal', function () {
                html5QrcodeScanner = new Html5QrcodeScanner(
                    "qr-reader", { fps: 10, qrbox: 250 }, false);
                html5QrcodeScanner.render(onScanSuccess);
            });

            modalScanQREl.addEventListener('hidden.bs.modal', function () {
                if (html5QrcodeScanner) {
                    html5QrcodeScanner.clear();
                }
            });
        }

        async function onScanSuccess(decodedText, decodedResult) {
            const parts = decodedText.split('|');
            if (parts.length < 6) return;

            // ── Họ & Tên ──
            const hoTenInput = document.querySelector('input[name="hoTen"]');
            if (hoTenInput) hoTenInput.value = parts[2];

            // ── Ngày sinh ──
            const ngaySinhInput = document.querySelector('input[name="ngaySinh"]');
            if (ngaySinhInput) {
                const dobRaw = parts[3];
                if (dobRaw.length === 8) {
                    const day   = dobRaw.substring(0, 2);
                    const month = dobRaw.substring(2, 4);
                    const year  = dobRaw.substring(4, 8);
                    ngaySinhInput.value = year + '-' + month + '-' + day;
                }
            }

            // ── Giới tính ──
            const genderStr = (parts[4] || '').toLowerCase();
            if (genderStr.includes('nam')) {
                const genderNam = document.getElementById('genderNam');
                if (genderNam) genderNam.checked = true;
            } else {
                const genderNu = document.getElementById('genderNu');
                if (genderNu) genderNu.checked = true;
            }

            // ── Địa chỉ – đặt raw trước để không bao giờ mất dữ liệu,
            //    rồi chạy mapping tự động (có thể ghi đè hoặc để nguyên fallback) ──
            const diaChiInput = document.querySelector('input[name="diaChiChiTiet"]');
            if (diaChiInput) diaChiInput.value = parts[5]; // safety net

            await autoSelectAddressMapping(parts[5]);

            // ── Toast / Alert ──
            if (typeof showToast === 'function') {
                showToast('Quét mã CCCD thành công!', 'success', 'Thành công');
            } else if (typeof Swal !== 'undefined') {
                Swal.fire('Thành công', 'Quét mã CCCD thành công!', 'success');
            } else {
                alert('Quét mã CCCD thành công!');
            }

            // ── Đóng modal ──
            const modal = bootstrap.Modal.getInstance(modalScanQREl);
            if (modal) modal.hide();
        }
    </script>
</body>
</html>
