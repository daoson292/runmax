<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${sanPham != null && sanPham.id != null ? 'Cập nhật Sản phẩm & Biến thể' : 'Thêm Sản phẩm Mới'}" scope="request" />
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
        /* Card & Section styling */
        .sp-section-card {
            background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 1.5rem; overflow: hidden;
        }
        .sp-section-header {
            background: #1e2a3a; color: #fff; padding: 0.9rem 1.25rem;
            font-weight: 700; font-size: 0.95rem; display: flex; align-items: center; justify-content: space-between;
        }
        .sp-section-body { padding: 1.5rem; }

        /* Tag checkbox pills */
        .tag-picker { display: flex; flex-wrap: wrap; gap: 0.6rem; max-height: 180px; overflow-y: auto; padding: 0.5rem; background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; }
        .tag-item { display: inline-block; }
        .tag-item input[type="checkbox"] { display: none; }
        .tag-item label {
            cursor: pointer; padding: 0.35rem 0.85rem; border-radius: 20px;
            border: 1.5px solid #cbd5e1; background: #fff; color: #475569;
            font-size: 0.85rem; font-weight: 600; transition: all 0.18s; user-select: none;
            display: flex; align-items: center; gap: 0.35rem;
        }
        .tag-item input[type="checkbox"]:checked + label {
            border-color: #dc2626; background: #fef2f2; color: #dc2626;
        }
        .tag-item label:hover { border-color: #94a3b8; }

        /* Group variant table */
        .variant-group-header {
            background: #f1f5f9; color: #1e2a3a; font-weight: 700; padding: 0.75rem 1rem;
            border-left: 4px solid #dc2626; margin-top: 1.25rem; border-radius: 6px 6px 0 0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .variant-table th { background: #f8fafc; color: #64748b; font-weight: 600; font-size: 0.8rem; text-transform: uppercase; padding: 0.65rem 0.85rem; }
        .variant-table td { padding: 0.65rem 0.85rem; vertical-align: middle; }
        .variant-input { width: 130px; text-align: right; font-weight: 600; }

        /* Image boxes */
        .image-color-box {
            border: 2px dashed #cbd5e1; border-radius: 10px; padding: 1.2rem; text-align: center;
            background: #f8fafc; transition: all 0.2s; cursor: pointer;
        }
        .image-color-box:hover { border-color: #dc2626; background: #fef2f2; }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content pb-5">

                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">
                            <i class="bi bi-box-seam-fill text-danger me-2"></i>${pageTitle}
                        </h4>
                        <p class="text-muted small mb-0">Quản lý chi tiết thông tin, phân loại và tổ hợp biến thể (SKU) sản phẩm.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/san-pham" class="btn btn-outline-secondary fw-semibold">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                </div>

                <!-- Thông báo lỗi/thành công -->
                <c:if test="${not empty error || not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><strong>Lỗi:</strong> ${not empty error ? error : errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/san-pham" method="post" enctype="multipart/form-data" id="formMainSanPham" class="needs-validation" novalidate onsubmit="return validateFormSanPham(event)">
                    <input type="hidden" name="action" value="save">
                    <div id="hiddenFileInputsContainer" class="d-none"></div>
                    <c:if test="${sanPham != null && sanPham.id != null}">
                        <input type="hidden" name="id" value="${sanPham.id}">
                    </c:if>

                    <!-- CARD 1: THÔNG TIN CƠ BẢN -->
                    <div class="sp-section-card">
                        <div class="sp-section-header">
                            <span><i class="bi bi-info-circle-fill me-2 text-danger"></i>1. Thông tin cơ bản</span>
                            <span class="badge bg-danger">Bắt buộc</span>
                        </div>
                        <div class="sp-section-body">
                            <div class="row g-3">
                                <c:if test="${sanPham != null && sanPham.id != null}">
                                    <div class="col-md-4">
                                        <label class="form-label fw-semibold text-secondary small mb-1">Mã sản phẩm</label>
                                        <input type="text" name="maSp" class="form-control bg-light text-secondary fw-semibold" value="${sanPham.maSp}"
                                               readonly tabindex="-1">
                                    </div>
                                </c:if>
                                <div class="${sanPham != null && sanPham.id != null ? 'col-md-8' : 'col-md-12'}">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" name="tenSp" class="form-control" required value="${sanPham.tenSp}"
                                           placeholder="VD: Giày Chạy Bộ Nam RunMax Pro X1">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Thương hiệu <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <select name="thuongHieuId" id="selectThuongHieu" class="form-select" required>
                                            <option value="">-- Chọn Thương hiệu --</option>
                                            <c:forEach var="th" items="${thuongHieus}">
                                                <option value="${th.id}" ${sanPham.thuongHieu != null && sanPham.thuongHieu.id == th.id ? 'selected' : ''}>${th.ten}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="button" class="btn btn-outline-danger fw-bold" title="Thêm nhanh Thương hiệu"
                                                onclick="openQuickAdd('thuong-hieu', 'Thương hiệu', 'selectThuongHieu')">
                                            <i class="bi bi-plus-lg"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Chất liệu <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <select name="chatLieuId" id="selectChatLieu" class="form-select" required>
                                            <option value="">-- Chọn Chất liệu --</option>
                                            <c:forEach var="cl" items="${chatLieus}">
                                                <option value="${cl.id}" ${sanPham.chatLieu != null && sanPham.chatLieu.id == cl.id ? 'selected' : ''}>${cl.ten}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="button" class="btn btn-outline-danger fw-bold" title="Thêm nhanh Chất liệu"
                                                onclick="openQuickAdd('chat-lieu', 'Chất liệu', 'selectChatLieu')">
                                            <i class="bi bi-plus-lg"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Mô tả chi tiết sản phẩm</label>
                                    <textarea name="moTa" class="form-control" rows="3" placeholder="Giới thiệu công nghệ đệm, chất liệu vải co giãn, tính năng vượt trội...">${sanPham.moTa}</textarea>
                                </div>

                                <!-- Trạng thái chỉ xuất hiện khi Update -->
                                <c:if test="${sanPham != null && sanPham.id != null}">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-secondary small mb-1 d-block">Trạng thái kinh doanh</label>
                                        <div class="status-radio pt-1">
                                            <input type="radio" name="trangThai" id="ttActive" value="1" ${sanPham.trangThai == 1 ? 'checked' : ''}>
                                            <label for="ttActive">Đang kinh doanh</label>
                                            <input type="radio" name="trangThai" id="ttInactive" value="0" ${sanPham.trangThai == 0 ? 'checked' : ''}>
                                            <label for="ttInactive">Ngừng kinh doanh</label>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- CARD 2: BIẾN THỂ SẢN PHẨM (CHỌN TỔ HỢP) -->
                    <div class="sp-section-card">
                        <div class="sp-section-header">
                            <span><i class="bi bi-upc-scan me-2 text-danger"></i>2. Biến thể sản phẩm (Tổ hợp tự động)</span>
                            <small class="text-white-50">Chọn các màu sắc, kích cỡ và đế giày để tự động sinh SKU</small>
                        </div>
                        <div class="sp-section-body">
                            <div class="row g-4">
                                <!-- Màu sắc -->
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <label class="fw-bold text-dark small"><i class="bi bi-palette-fill text-danger me-1"></i>Màu sắc <span class="text-danger">*</span></label>
                                        <button type="button" class="btn btn-sm btn-link text-danger p-0 text-decoration-none fw-semibold"
                                                onclick="openQuickAdd('mau-sac', 'Màu sắc', 'tagContainerMauSac', true)">+ Thêm màu</button>
                                    </div>
                                    <div class="tag-picker" id="tagContainerMauSac">
                                        <c:forEach var="ms" items="${mauSacs}">
                                            <div class="tag-item">
                                                <input type="checkbox" id="chkMs_${ms.id}" class="chk-mausac" value="${ms.id}" data-ten="${ms.ten}">
                                                <label for="chkMs_${ms.id}"><i class="bi bi-check2"></i>${ms.ten}</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Kích cỡ -->
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <label class="fw-bold text-dark small"><i class="bi bi-rulers text-danger me-1"></i>Kích cỡ <span class="text-danger">*</span></label>
                                        <button type="button" class="btn btn-sm btn-link text-danger p-0 text-decoration-none fw-semibold"
                                                onclick="openQuickAdd('kich-co', 'Kích cỡ', 'tagContainerKichCo', true)">+ Thêm size</button>
                                    </div>
                                    <div class="tag-picker" id="tagContainerKichCo">
                                        <c:forEach var="kc" items="${kichCos}">
                                            <div class="tag-item">
                                                <input type="checkbox" id="chkKc_${kc.id}" class="chk-kichco" value="${kc.id}" data-ten="${kc.ten}">
                                                <label for="chkKc_${kc.id}"><i class="bi bi-check2"></i>${kc.ten}</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Đế giày -->
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <label class="fw-bold text-dark small"><i class="bi bi-shoe-prints text-danger me-1"></i>Đế giày <span class="text-danger">*</span></label>
                                        <button type="button" class="btn btn-sm btn-link text-danger p-0 text-decoration-none fw-semibold"
                                                onclick="openQuickAdd('de-giay', 'Đế giày', 'tagContainerDeGiay', true)">+ Thêm đế</button>
                                    </div>
                                    <div class="tag-picker" id="tagContainerDeGiay">
                                        <c:forEach var="dg" items="${deGiays}">
                                            <div class="tag-item">
                                                <input type="checkbox" id="chkDg_${dg.id}" class="chk-degiay" value="${dg.id}" data-ten="${dg.ten}">
                                                <label for="chkDg_${dg.id}"><i class="bi bi-check2"></i>${dg.ten}</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Nút tạo tự động -->
                                <div class="col-12 mt-4">
                                    <button type="button" class="btn btn-runmax w-100 py-2 fw-bold" onclick="generateVariants()">
                                        <i class="bi bi-lightning-charge-fill me-2"></i>Tạo Biến Thể Tự Động Từ Tổ Hợp Đã Chọn
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- CARD 3: DANH SÁCH BIẾN THỂ -->
                    <div class="sp-section-card" id="variantCard" style="${not empty existingVariants ? '' : 'display:none;'}">
                        <div class="sp-section-header">
                            <span><i class="bi bi-table me-2 text-danger"></i>3. Danh sách biến thể (<span id="variantCountText">${fn:length(existingVariants)}</span> SKU)</span>
                            <button type="button" class="btn btn-sm btn-outline-light" onclick="clearVariants()"><i class="bi bi-trash me-1"></i>Xóa tất cả</button>
                        </div>
                        <div class="sp-section-body">
                            <!-- Thanh áp dụng nhanh Bulk Apply -->
                            <div class="p-3 mb-4 bg-light border rounded-3 d-flex flex-wrap align-items-end gap-3">
                                <div>
                                    <label class="form-label small fw-bold text-secondary mb-1">Số lượng chung</label>
                                    <input type="text" inputmode="numeric" id="bulkSl" class="form-control form-control-sm currency-input" placeholder="VD: 100" min="0">
                                </div>
                                <div>
                                    <label class="form-label small fw-bold text-secondary mb-1">Đơn giá bán chung (VNĐ)</label>
                                    <input type="text" inputmode="numeric" id="bulkGia" class="form-control form-control-sm currency-input" placeholder="VD: 1200000" min="0">
                                </div>
                                <div>
                                    <button type="button" class="btn btn-sm btn-danger fw-semibold px-3" onclick="applyToAllVariants()">
                                        <i class="bi bi-check2-all me-1"></i>Áp dụng cho tất cả SKU
                                    </button>
                                </div>
                            </div>

                            <!-- Bảng các nhóm màu -->
                            <div id="variantTableContainer">
                                <c:if test="${not empty existingVariants}">
                                    <c:forEach var="spct" items="${existingVariants}">
                                        <!-- Điền sẵn dữ liệu khi sửa -->
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- CARD 4: ẢNH THEO MÀU SẮC -->
                    <div class="sp-section-card" id="imageCard" style="display:none;">
                        <div class="sp-section-header">
                            <span><i class="bi bi-images me-2 text-danger"></i>4. Ảnh theo màu sắc</span>
                            <small class="text-white-50">Tải lên hoặc chọn hình ảnh minh họa cho từng màu giày</small>
                        </div>
                        <div class="sp-section-body">
                            <div class="row g-3" id="imageBoxesContainer">
                            </div>
                        </div>
                    </div>

                    <!-- Sticky Bottom Bar -->
                    <div class="sticky-bottom bg-white p-3 border-top shadow-lg d-flex justify-content-end align-items-center gap-3" style="border-radius: 0 0 12px 12px;">
                        <span class="text-muted small me-auto"><i class="bi bi-info-circle me-1"></i>Vui lòng kiểm tra kỹ danh sách SKU trước khi bấm lưu.</span>
                        <a href="${pageContext.request.contextPath}/san-pham" class="btn btn-outline-secondary px-4 fw-semibold">Hủy bỏ</a>
                        <button type="submit" class="btn btn-runmax px-5 py-2 fw-bold">
                            <i class="bi bi-floppy-fill me-2"></i>Lưu Sản Phẩm & Biến Thể
                        </button>
                    </div>
                </form>

            </div>
        </main>
    </div>

    <!-- Modal Thêm nhanh Thuộc tính (Thương hiệu, Chất liệu, Màu sắc, Kích cỡ, Đế giày) -->
    <div class="modal fade" id="modalQuickAdd" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow:hidden;">
                <div class="modal-header bg-danger text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="quickAddTitle">Thêm mới thuộc tính</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" id="quickAddLoai">
                    <input type="hidden" id="quickAddTargetId">
                    <input type="hidden" id="quickAddIsTag">

                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary small mb-1">Tên thuộc tính <span class="text-danger">*</span></label>
                        <input type="text" id="quickAddTen" class="form-control" placeholder="Nhập tên thuộc tính...">
                        <small class="text-danger d-block mt-1" id="quickAddError"></small>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 px-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-semibold px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-danger fw-bold px-4" onclick="submitQuickAdd()"><i class="bi bi-check2 me-1"></i>Lưu & Chọn ngay</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        // Cấu trúc lưu trữ biến thể đang hiển thị
        // variantMap[colorId_sizeId_soleId] = { colorId, colorTen, sizeId, sizeTen, soleId, soleTen, sl, gia }
        let generatedVariants = [];

        // Nếu đang ở chế độ sửa và có sẵn variants
        <c:if test="${not empty existingVariants}">
        window.addEventListener('DOMContentLoaded', () => {
            window.colorImagePreviews = window.colorImagePreviews || {};
            <c:forEach var="spct" items="${existingVariants}">
            if ('${spct.mauSac.id}' && '${spct.anhDaiDien}') {
                window.colorImagePreviews['${spct.mauSac.id}'] = '${spct.anhDaiDien}';
            }
            generatedVariants.push({
                colorId: '${spct.mauSac.id}', colorTen: '${fn:escapeXml(spct.mauSac.ten)}',
                sizeId: '${spct.kichCo.id}', sizeTen: '${fn:escapeXml(spct.kichCo.ten)}',
                soleId: '${spct.deGiay.id}', soleTen: '${fn:escapeXml(spct.deGiay.ten)}',
                sl: ${spct.soLuongTon}, gia: ${spct.giaBan}, anh: '${spct.anhDaiDien}'
            });
            // Tự động check các checkbox thuộc tính của biến thể có sẵn
            const chkMs = document.querySelector('.chk-mausac[value="${spct.mauSac.id}"]'); if (chkMs) chkMs.checked = true;
            const chkKc = document.querySelector('.chk-kichco[value="${spct.kichCo.id}"]'); if (chkKc) chkKc.checked = true;
            const chkDg = document.querySelector('.chk-degiay[value="${spct.deGiay.id}"]'); if (chkDg) chkDg.checked = true;
            </c:forEach>
            renderVariantTable();
        });
        </c:if>

        // Mở modal thêm nhanh
        const modalQuickObj = new bootstrap.Modal(document.getElementById('modalQuickAdd'));
        function openQuickAdd(loai, tenLoai, targetId, isTag = false) {
            document.getElementById('quickAddLoai').value = loai;
            document.getElementById('quickAddTargetId').value = targetId;
            document.getElementById('quickAddIsTag').value = isTag ? 'true' : 'false';
            document.getElementById('quickAddTitle').innerText = 'Thêm nhanh ' + tenLoai;
            document.getElementById('quickAddTen').value = '';
            document.getElementById('quickAddError').innerText = '';
            modalQuickObj.show();
        }

        async function submitQuickAdd() {
            const loai = document.getElementById('quickAddLoai').value;
            const ten = document.getElementById('quickAddTen').value.trim();
            const targetId = document.getElementById('quickAddTargetId').value;
            const isTag = document.getElementById('quickAddIsTag').value === 'true';
            const errorEl = document.getElementById('quickAddError');

            if (!ten) {
                errorEl.innerText = "Vui lòng nhập tên thuộc tính!";
                return;
            }
            if (loai === 'kich-co') {
                const num = parseInt(ten, 10);
                if (isNaN(num) || num < 15 || num > 60) {
                    errorEl.innerText = "Kích cỡ giày phải là số từ 15 đến 60!";
                    return;
                }
            }

            const formData = new URLSearchParams();
            formData.append('loai', loai);
            formData.append('action', 'save');
            formData.append('ten', ten);
            formData.append('ajax', 'true');

            try {
                const res = await fetch('${pageContext.request.contextPath}/thuoc-tinh', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                    body: formData.toString()
                });
                const data = await res.json();
                if (data.success) {
                    modalQuickObj.hide();
                    if (!isTag) {
                        const selectEl = document.getElementById(targetId);
                        const opt = new Option(data.ten, data.id, true, true);
                        selectEl.add(opt);
                    } else {
                        const container = document.getElementById(targetId);
                        const div = document.createElement('div');
                        div.className = 'tag-item';
                        const chkId = 'chk_' + loai + '_' + data.id;
                        let clsName = 'chk-mausac';
                        if (loai === 'kich-co') clsName = 'chk-kichco';
                        else if (loai === 'de-giay') clsName = 'chk-degiay';
                        div.innerHTML = `<input type="checkbox" id="\${chkId}" class="\${clsName}" value="\${data.id}" data-ten="\${data.ten}" checked>
                                         <label for="\${chkId}"><i class="bi bi-check2"></i>\${data.ten}</label>`;
                        container.appendChild(div);
                    }
                } else {
                    errorEl.innerText = data.message || "Lỗi khi lưu thuộc tính!";
                }
            } catch (e) {
                errorEl.innerText = "Có lỗi kết nối xảy ra!";
            }
        }

        // Tạo tổ hợp biến thể
        function generateVariants() {
            const selectedColors = Array.from(document.querySelectorAll('.chk-mausac:checked')).map(el => ({ id: el.value, ten: el.dataset.ten }));
            const selectedSizes = Array.from(document.querySelectorAll('.chk-kichco:checked')).map(el => ({ id: el.value, ten: el.dataset.ten }));
            const selectedSoles = Array.from(document.querySelectorAll('.chk-degiay:checked')).map(el => ({ id: el.value, ten: el.dataset.ten }));

            if (selectedColors.length === 0 || selectedSizes.length === 0 || selectedSoles.length === 0) {
                showBootstrapAlert("Vui lòng chọn ít nhất 1 Màu sắc, 1 Kích cỡ và 1 Đế giày để tạo biến thể!", "danger");
                return;
            }

            // Tạo tổ hợp và giữ lại giá/số lượng cũ nếu đã có
            let newVariants = [];
            selectedColors.forEach(color => {
                selectedSizes.forEach(size => {
                    selectedSoles.forEach(sole => {
                        const existing = generatedVariants.find(v => v.colorId === color.id && v.sizeId === size.id && v.soleId === sole.id);
                        if (existing) {
                            newVariants.push(existing);
                        } else {
                            newVariants.push({
                                colorId: color.id, colorTen: color.ten,
                                sizeId: size.id, sizeTen: size.ten,
                                soleId: sole.id, soleTen: sole.ten,
                                sl: 10, gia: 1200000
                            });
                        }
                    });
                });
            });

            generatedVariants = newVariants;
            renderVariantTable();
        }

        function clearVariants() {
            showBootstrapConfirm("Bạn có chắc chắn muốn xóa toàn bộ danh sách biến thể bên dưới?", function() {
                generatedVariants = [];
                renderVariantTable();
            });
        }

        function removeRow(idx) {
            generatedVariants.splice(idx, 1);
            renderVariantTable();
        }

        function applyToAllVariants() {
            const bulkSl = document.getElementById('bulkSl').value.replace(/[^\d]/g, '');
            const bulkGia = document.getElementById('bulkGia').value.replace(/[^\d]/g, '');

            if (!bulkSl && !bulkGia) {
                showBootstrapAlert("Vui lòng nhập Số lượng hoặc Đơn giá chung để áp dụng!", "danger");
                return;
            }
            generatedVariants.forEach(v => {
                if (bulkSl !== "") v.sl = parseInt(bulkSl, 10) || 0;
                if (bulkGia !== "") v.gia = parseInt(bulkGia, 10) || 0;
            });
            renderVariantTable();
        }

        function renderVariantTable() {
            const container = document.getElementById('variantTableContainer');
            const imgContainer = document.getElementById('imageBoxesContainer');
            const card = document.getElementById('variantCard');
            const imgCard = document.getElementById('imageCard');
            const countText = document.getElementById('variantCountText');

            if (generatedVariants.length === 0) {
                card.style.display = 'none';
                imgCard.style.display = 'none';
                container.innerHTML = '';
                imgContainer.innerHTML = '';
                countText.innerText = '0';
                return;
            }

            card.style.display = 'block';
            imgCard.style.display = 'block';
            countText.innerText = generatedVariants.length;

            // Nhóm biến thể theo Màu sắc
            const colorGroups = {};
            generatedVariants.forEach((v, idx) => {
                if (!colorGroups[v.colorId]) {
                    colorGroups[v.colorId] = { colorId: v.colorId, colorTen: v.colorTen, items: [] };
                }
                colorGroups[v.colorId].items.push({ ...v, index: idx });
            });

            let html = '';
            let imgHtml = '';

            Object.keys(colorGroups).forEach(cId => {
                const grp = colorGroups[cId];
                html += `<div class="variant-group-header">
                            <span><i class="bi bi-circle-fill text-danger me-2 small"></i>Màu \${grp.colorTen} (\${grp.items.length} kích cỡ)</span>
                            <span class="text-muted small">Tổ hợp tự sinh</span>
                         </div>
                         <div class="table-responsive border border-top-0 rounded-bottom">
                            <table class="table variant-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Màu sắc</th>
                                        <th>Kích cỡ</th>
                                        <th>Đế giày</th>
                                        <th class="text-end">Số lượng tồn <span class="text-danger">*</span></th>
                                        <th class="text-end">Đơn giá bán (VNĐ) <span class="text-danger">*</span></th>
                                        <th class="text-center">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody>`;
                grp.items.forEach(v => {
                    html += `<tr>
                                <td class="fw-bold text-dark"><i class="bi bi-palette me-1 text-danger"></i>\${v.colorTen}</td>
                                <td><span class="badge bg-danger rounded-pill px-3">\${v.sizeTen}</span></td>
                                <td class="text-secondary">\${v.soleTen}</td>
                                <td class="text-end">
                                    <input type="hidden" name="variantMauSacId" value="\${v.colorId}">
                                    <input type="hidden" name="variantKichCoId" value="\${v.sizeId}">
                                    <input type="hidden" name="variantDeGiayId" value="\${v.soleId}">
                                    <input type="text" inputmode="numeric" name="variantSoLuong" class="form-control form-control-sm variant-input ms-auto currency-input"
                                           value="\${v.sl ? new Intl.NumberFormat('vi-VN').format(v.sl) : 0}" min="0" required onchange="generatedVariants[\${v.index}].sl = parseInt(this.value.replace(/[^0-9]/g, ''))||0">
                                </td>
                                <td class="text-end">
                                    <input type="text" inputmode="numeric" name="variantGiaBan" class="form-control form-control-sm variant-input ms-auto currency-input"
                                           value="\${v.gia ? new Intl.NumberFormat('vi-VN').format(v.gia) : 0}" min="0" required onchange="generatedVariants[\${v.index}].gia = parseInt(this.value.replace(/[^0-9]/g, ''))||0">
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa dòng này" onclick="removeRow(\${v.index})">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </td>
                             </tr>`;
                });
                html += `</tbody></table></div>`;

                // Render image color box
                window.colorImagePreviews = window.colorImagePreviews || {};
                const currentImgUrl = window.colorImagePreviews[grp.colorId] || '';
                const hiddenContainer = document.getElementById('hiddenFileInputsContainer');
                if (hiddenContainer && !document.getElementById('fileInput_color_' + grp.colorId)) {
                    const input = document.createElement('input');
                    input.type = 'file';
                    input.name = 'fileAnh_color_' + grp.colorId;
                    input.id = 'fileInput_color_' + grp.colorId;
                    input.accept = 'image/png, image/jpeg, image/jpg';
                    input.className = 'd-none';
                    input.onchange = function() { previewColorImage(this, grp.colorId); };
                    hiddenContainer.appendChild(input);

                    const hiddenOld = document.createElement('input');
                    hiddenOld.type = 'hidden';
                    hiddenOld.name = 'oldAnh_color_' + grp.colorId;
                    hiddenOld.id = 'oldInput_color_' + grp.colorId;
                    hiddenOld.value = currentImgUrl;
                    hiddenContainer.appendChild(hiddenOld);
                }

                imgHtml += `<div class="col-md-3">
                                <div class="image-color-box text-center p-3 border rounded bg-white shadow-sm position-relative">
                                    <div class="mb-2 position-relative d-inline-block rounded overflow-hidden border bg-light" style="width: 110px; height: 110px; cursor: pointer;" onclick="document.getElementById('fileInput_color_\${grp.colorId}').click();" title="Bấm để chọn/đổi ảnh">
                                        <div id="icon_color_\${grp.colorId}" class="w-100 h-100 d-flex align-items-center justify-content-center text-secondary \${currentImgUrl ? 'd-none' : ''}">
                                            <i class="bi bi-camera" style="font-size: 2.2rem;"></i>
                                        </div>
                                        <img id="preview_color_\${grp.colorId}" src="\${currentImgUrl}" alt="Ảnh màu \${grp.colorTen}" class="w-100 h-100 object-fit-cover position-absolute top-0 start-0 \${currentImgUrl ? '' : 'd-none'}">
                                    </div>
                                    <h6 class="fw-bold text-dark mb-1">\${grp.colorTen}</h6>
                                    <span class="badge bg-light text-muted border mb-2">\${grp.items.length} biến thể</span>
                                    <div><button type="button" class="btn btn-sm btn-outline-danger w-100 fw-semibold" onclick="document.getElementById('fileInput_color_\${grp.colorId}').click();"><i class="bi bi-upload me-1"></i>\${currentImgUrl ? 'Đổi ảnh' : 'Chọn ảnh'}</button></div>
                                </div>
                            </div>`;
            });

            container.innerHTML = html;
            imgContainer.innerHTML = imgHtml;
        }

        function previewColorImage(input, colorId) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    window.colorImagePreviews = window.colorImagePreviews || {};
                    window.colorImagePreviews[colorId] = e.target.result;
                    const previewImg = document.getElementById('preview_color_' + colorId);
                    const iconDiv = document.getElementById('icon_color_' + colorId);
                    if (previewImg && iconDiv) {
                        previewImg.src = e.target.result;
                        previewImg.classList.remove('d-none');
                        iconDiv.classList.add('d-none');
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function validateFormSanPham(event) {
            const form = document.getElementById('formMainSanPham');
            if (form && !form.checkValidity()) {
                if (event) { event.preventDefault(); event.stopPropagation(); }
                form.classList.add('was-validated');
                showToast("Vui lòng kiểm tra và điền đầy đủ các thông tin có viền đỏ!", "danger", "Thiếu thông tin");
                return false;
            }
            const tenSpInput = document.querySelector('input[name="tenSp"]');
            const tenSp = tenSpInput ? tenSpInput.value.trim() : '';
            if (!tenSp) {
                if (tenSpInput) tenSpInput.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng nhập tên sản phẩm!", "danger");
                if (event) { event.preventDefault(); event.stopPropagation(); }
                if (form) form.classList.add('was-validated');
                return false;
            }
            const thEl = document.getElementById('selectThuongHieu');
            const clEl = document.getElementById('selectChatLieu');
            const thId = thEl ? thEl.value : '';
            const clId = clEl ? clEl.value : '';
            if (!thId || !clId) {
                if (!thId && thEl) thEl.classList.add('is-invalid');
                if (!clId && clEl) clEl.classList.add('is-invalid');
                showBootstrapAlert("Vui lòng chọn đầy đủ Thương hiệu và Chất liệu cho sản phẩm!", "danger");
                if (event) { event.preventDefault(); event.stopPropagation(); }
                if (form) form.classList.add('was-validated');
                return false;
            }
            // Nếu có biến thể, kiểm tra số lượng và giá không được âm
            const slInputs = document.querySelectorAll('input[name="variantSoLuong"]');
            const giaInputs = document.querySelectorAll('input[name="variantGiaBan"]');
            for (let i = 0; i < slInputs.length; i++) {
                if (parseInt(slInputs[i].value, 10) < 0 || parseInt(giaInputs[i].value, 10) < 0) {
                    slInputs[i].classList.add('is-invalid');
                    giaInputs[i].classList.add('is-invalid');
                    showBootstrapAlert("Số lượng và đơn giá biến thể không được là số âm!", "danger");
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
                    if (window.unformatCurrencyInputs) window.unformatCurrencyInputs(form);
                    form.submit();
                }
            });

            return false; // Luôn trả về false để onsubmit gốc không tự chạy
        }
    </script>
</body>
</html>
