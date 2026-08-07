<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý ${tenLoai}" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} – RunMax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Bộ lọc thu gọn (giao diện trắng đồng bộ) */
        .filter-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border: 1px solid rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .filter-header {
            background: #1e2a3a;
            color: #ffffff;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 1.25rem; cursor: pointer; user-select: none;
            font-weight: 600; font-size: 0.95rem;
            transition: background 0.2s;
        }
        .filter-header:hover { background: #111827; }
        .filter-body {
            padding: 1.25rem;
            background: #ffffff;
            border-top: 1px solid #f1f5f9;
        }
        .filter-body label { color: #475569; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.4rem; }
        .filter-body .form-control, .filter-body .form-select {
            background: #ffffff;
            border: 1px solid #cbd5e1;
            color: #1e293b;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .filter-body .form-control::placeholder { color: #94a3b8; }
        .filter-body .form-control:focus, .filter-body .form-select:focus {
            background: #ffffff; border-color: #dc2626; color: #1e293b;
            box-shadow: 0 0 0 3px rgba(220,38,38,0.15);
        }

        /* Table */
        .tt-table-head th {
            background: #1e2a3a; color: #e2e8f0; font-weight: 600; font-size: 0.82rem;
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0.9rem 1rem; border: none;
        }
        .tt-table tbody td { padding: 0.8rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        .tt-table tbody tr:hover { background-color: #fef2f2; }
        .tt-table tbody tr:last-child td { border-bottom: none; }

        /* Toggle switch */
        .toggle-switch { position: relative; display: inline-block; width: 44px; height: 24px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider {
            position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
            background-color: #cbd5e1; transition: .3s; border-radius: 24px;
        }
        .toggle-slider:before {
            position: absolute; content: ""; height: 18px; width: 18px;
            left: 3px; bottom: 3px; background-color: white;
            transition: .3s; border-radius: 50%; box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        input:checked + .toggle-slider { background-color: #22c55e; }
        input:checked + .toggle-slider:before { transform: translateX(20px); }

        /* Status radio pill */
        .status-radio { display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap; }
        .status-radio label {
            cursor: pointer; padding: 0.3rem 0.75rem; border-radius: 20px;
            border: 2px solid #e2e8f0; font-size: 0.85rem; font-weight: 600; color: #64748b;
            transition: all 0.18s;
        }
        .status-radio input[type=radio]:checked + label { border-color: #dc2626; color: #dc2626; background: #fef2f2; }
        .status-radio input[type=radio] { display: none; }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content">

                <!-- Page Header -->
                <div class="mb-4">
                    <h4 class="fw-bold text-dark mb-1">
                        <i class="bi bi-tags-fill text-danger me-2"></i>Quản lý ${tenLoai}
                    </h4>
                    <p class="text-muted small mb-0">Quản lý danh sách các thuộc tính ${tenLoai} cho sản phẩm giày dép RunMax.</p>
                </div>

                <!-- Bộ lọc thu gọn -->
                <div class="filter-card">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterThuocTinh">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm ${tenLoai}</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterThuocTinh">
                        <form action="${pageContext.request.contextPath}/thuoc-tinh" method="get" class="filter-body">
                            <input type="hidden" name="loai" value="${loaiHienTai}">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-8">
                                    <label>Từ khóa tìm kiếm</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo Mã hoặc Tên ${tenLoai}..." value="${param.keyword}">
                                </div>
                                <div class="col-md-4 d-flex gap-2 align-items-end">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=${loaiHienTai}" class="btn btn-outline-secondary shadow-sm" title="Làm mới">
                                        <i class="bi bi-arrow-counterclockwise"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Nút hành động giữa bộ lọc và danh sách -->
                <div class="d-flex justify-content-end gap-2 mb-3">
                    <button type="button" class="btn btn-runmax btn-sm fw-semibold shadow-sm" onclick="openAddModal()">
                        <i class="bi bi-plus-lg me-1"></i>Thêm ${tenLoai}
                    </button>
                </div>

                <!-- Bảng danh sách Thuộc tính -->
                <div class="runmax-card p-0">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <div class="fw-bold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách ${tenLoai}
                            <span class="badge bg-secondary ms-1">${fn:length(items)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table tt-table mb-0">
                            <thead>
                                <tr class="tt-table-head">
                                    <th>STT</th>
                                    <th>Mã ${tenLoai}</th>
                                    <th>Tên ${tenLoai}</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty items}">
                                        <c:forEach var="item" items="${items}" varStatus="loop">
                                            <tr>
                                                <td class="text-muted fw-semibold">${loop.index + 1}</td>
                                                <td class="fw-bold text-danger" style="font-family:monospace;">${item.ma}</td>
                                                <td class="fw-semibold">${item.ten}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${item.trangThai == 1}">
                                                            <span class="badge bg-success rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger rounded-pill"><i class="bi bi-lock-fill me-1"></i>Khóa</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                                        <button type="button" class="btn btn-sm btn-outline-warning" title="Sửa thông tin"
                                                                style="width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;"
                                                                onclick="openEditModal(${item.id}, '${item.ma}', '${fn:escapeXml(item.ten)}', ${item.trangThai})">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/thuoc-tinh" method="post" class="d-inline m-0">
                                                            <input type="hidden" name="loai" value="${loaiHienTai}">
                                                            <input type="hidden" name="action" value="toggle">
                                                            <input type="hidden" name="id" value="${item.id}">
                                                            <label class="toggle-switch" title="${item.trangThai == 1 ? 'Khóa' : 'Mở khóa'}">
                                                                <input type="checkbox" ${item.trangThai == 1 ? 'checked' : ''} onchange="this.form.submit()">
                                                                <span class="toggle-slider"></span>
                                                            </label>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">Chưa có dữ liệu ${tenLoai} nào</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination Footer -->
                    <c:if test="${totalPages > 1}">
                        <div class="d-flex justify-content-between align-items-center p-3 border-top bg-light">
                            <div class="text-muted small fw-semibold">
                                Trang ${currentPage} / ${totalPages}
                            </div>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?loai=${loaiHienTai}&keyword=${param.keyword}&page=${currentPage - 1}">Trước</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?loai=${loaiHienTai}&keyword=${param.keyword}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?loai=${loaiHienTai}&keyword=${param.keyword}&page=${currentPage + 1}">Sau</a>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal Thêm / Chỉnh sửa Thuộc tính -->
    <div class="modal fade" id="modalThuocTinh" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius:14px; overflow:hidden;">
                <div class="modal-header bg-danger text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="modalTitle">Thêm mới ${tenLoai}</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/thuoc-tinh" method="post" id="formThuocTinh" class="needs-validation" novalidate onsubmit="return validateThuocTinhForm(event)">
                    <input type="hidden" name="loai" value="${loaiHienTai}">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="id" id="modalId" value="">

                    <div class="modal-body p-4">
                        <div class="mb-3" id="modalMaGroup">
                            <label class="form-label fw-semibold text-secondary small mb-1">Mã ${tenLoai} (Tự động sinh)</label>
                            <input type="text" name="ma" id="modalMa" class="form-control bg-light text-secondary fw-semibold"
                                   placeholder="Tự động sinh khi lưu" readonly tabindex="-1">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small mb-1">Tên ${tenLoai} <span class="text-danger">*</span></label>
                            <input type="text" name="ten" id="modalTen" class="form-control"
                                   placeholder="${loaiHienTai == 'kich-co' ? 'VD: 39, 40, 41 (từ 15 đến 60)...' : 'Nhập tên '.concat(tenLoai).concat('...')}" required>
                            <c:if test="${loaiHienTai == 'kich-co'}">
                                <small class="text-danger d-block mt-1"><i class="bi bi-info-circle me-1"></i>Lưu ý: Kích cỡ giày hợp lệ là số từ 15 đến 60 (không cho phép số âm hoặc quá lớn).</small>
                            </c:if>
                        </div>

                        <!-- Trạng thái chỉ xuất hiện khi Update (Sửa) theo yêu cầu -->
                        <div class="mb-3" id="modalStatusGroup" style="display:none;">
                            <label class="form-label fw-semibold text-secondary small mb-1 d-block">Trạng thái</label>
                            <div class="status-radio pt-1">
                                <input type="radio" name="trangThai" id="ttModalActive" value="1" checked>
                                <label for="ttModalActive">Hoạt động</label>
                                <input type="radio" name="trangThai" id="ttModalInactive" value="0">
                                <label for="ttModalInactive">Khóa</label>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer bg-light border-top-0 px-4 py-3">
                        <button type="button" class="btn btn-outline-secondary px-4 fw-semibold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger px-4 fw-semibold"><i class="bi bi-floppy me-1"></i>Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        const loaiHienTai = "${loaiHienTai}";
        const modalEl = document.getElementById('modalThuocTinh');
        const modalObj = new bootstrap.Modal(modalEl);

        function openAddModal() {
            document.getElementById('modalTitle').innerText = 'Thêm mới ${tenLoai}';
            document.getElementById('modalId').value = '';
            document.getElementById('modalMa').value = '';
            document.getElementById('modalTen').value = '';
            // Khi Thêm mới (Add): Ẩn chọn Trạng thái và ô Mã tự sinh
            document.getElementById('modalStatusGroup').style.display = 'none';
            document.getElementById('modalMaGroup').style.display = 'none';
            document.getElementById('ttModalActive').checked = true;
            modalObj.show();
        }

        function openEditModal(id, ma, ten, trangThai) {
            document.getElementById('modalTitle').innerText = 'Cập nhật ${tenLoai}';
            document.getElementById('modalId').value = id;
            document.getElementById('modalMa').value = ma;
            document.getElementById('modalTen').value = ten;
            // Khi Cập nhật (Edit): Hiện chọn Trạng thái và ô Mã
            document.getElementById('modalStatusGroup').style.display = 'block';
            document.getElementById('modalMaGroup').style.display = 'block';
            if (trangThai == 1) {
                document.getElementById('ttModalActive').checked = true;
            } else {
                document.getElementById('ttModalInactive').checked = true;
            }
            modalObj.show();
        }

        function validateThuocTinhForm(event) {
            const form = document.getElementById('formThuocTinh');
            const modalTen = document.getElementById('modalTen');
            const tenVal = modalTen ? modalTen.value.trim() : '';
            if (form && !form.checkValidity()) {
                if (event) { event.preventDefault(); event.stopPropagation(); }
                form.classList.add('was-validated');
                showToast("Vui lòng nhập tên ${tenLoai} có viền đỏ!", "danger", "Thiếu thông tin");
                return false;
            }
            if (!tenVal) {
                if (modalTen) modalTen.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng nhập tên ${tenLoai}!", "danger");
                if (event) { event.preventDefault(); event.stopPropagation(); }
                if (form) form.classList.add('was-validated');
                return false;
            }
            if (loaiHienTai === 'kich-co') {
                const sizeNum = parseInt(tenVal, 10);
                if (isNaN(sizeNum) || sizeNum < 15 || sizeNum > 60) {
                    if (modalTen) modalTen.classList.add('is-invalid');
                    showBootstrapAlert("Kích cỡ giày không hợp lệ! Vui lòng nhập số thực tế từ 15 đến 60 (không cho phép số âm hoặc quá lớn như 99).", "danger");
                    if (event) { event.preventDefault(); event.stopPropagation(); }
                    if (form) form.classList.add('was-validated');
                    return false;
                }
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

        // Nếu có lỗi trả về từ server khi thao tác modal, tự động mở lại modal nếu cần
        <c:if test="${editItem != null}">
            window.addEventListener('DOMContentLoaded', () => {
                openEditModal(${editItem.id}, '${editItem.ma}', '${fn:escapeXml(editItem.ten)}', ${editItem.trangThai});
            });
        </c:if>
    </script>
</body>
</html>
