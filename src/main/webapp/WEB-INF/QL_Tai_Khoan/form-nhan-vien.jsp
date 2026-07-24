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
                                <label class="form-label fw-semibold text-secondary small mb-1">Số điện thoại</label>
                                <input type="text" name="sdt" class="form-control"
                                       value="${nhanVienEdit != null ? nhanVienEdit.sdt : ''}" placeholder="VD: 0912345678">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="${nhanVienEdit != null ? nhanVienEdit.email : ''}" placeholder="VD: abc@gmail.com">
                            </div>

                            <!-- Hàng 4: Ngày sinh | Tỉnh/Thành phố -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Ngày sinh</label>
                                <input type="date" name="ngaySinh" class="form-control"
                                       value="${nhanVienEdit != null && nhanVienEdit.ngaySinh != null ? nhanVienEdit.ngaySinh : ''}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Tỉnh/Thành phố</label>
                                <select id="tinhThanhSelect" name="tinhThanhPho" class="form-select">
                                    <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                </select>
                            </div>

                            <!-- Hàng 5: Quận/Huyện & Phường/Xã | Tên đường -->
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary small mb-1">Quận/Huyện</label>
                                <select id="quanHuyenSelect" name="quanHuyen" class="form-select" disabled>
                                    <option value="">-- Chọn Quận/Huyện --</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary small mb-1">Phường/Xã/Đặc khu</label>
                                <select id="phuongXaSelect" name="phuongXa" class="form-select" disabled>
                                    <option value="">-- Chọn Phường/Xã/Đặc khu --</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-secondary small mb-1">Tên đường</label>
                                <input type="text" name="diaChiChiTiet" class="form-control"
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
                    <div class="p-4 bg-light border rounded-3 mb-3 d-flex flex-column align-items-center justify-content-center" style="height: 220px; border-style: dashed !important;">
                        <i class="bi bi-camera-video text-danger mb-2" style="font-size: 3rem;"></i>
                        <p class="text-muted small mb-0">Đưa mã QR trên thẻ CCCD vào khung hình camera để tự động điền thông tin.</p>
                    </div>
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
    <script src="${pageContext.request.contextPath}/assets/js/address-helper.js"></script>
    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
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
            return true;
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
</body>
</html>
