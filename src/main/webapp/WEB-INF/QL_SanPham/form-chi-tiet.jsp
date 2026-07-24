<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${spct != null && spct.id != null ? 'Cập nhật Sản Phẩm Chi Tiết (SKU)' : 'Thêm Mới Biến Thể Sản Phẩm (SKU)'}" scope="request" />
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
        .spct-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            max-width: 860px;
            margin: 0 auto;
        }
        .spct-header {
            background: linear-gradient(135deg, #1e2a3a 0%, #0f172a 100%);
            color: #ffffff;
            padding: 1.25rem 1.75rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .avatar-box-custom {
            width: 140px;
            height: 140px;
            border-radius: 12px;
            border: 2px dashed #cbd5e1;
            background: #f8fafc;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .avatar-box-custom:hover {
            border-color: #dc2626;
            background: #fef2f2;
            transform: translateY(-2px);
        }
        .form-section-title {
            font-size: 0.85rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1.5px solid #f1f5f9;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content pb-5">
                <!-- Thông báo lỗi -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert" style="max-width: 860px; margin: 0 auto 1.5rem auto;">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><strong>Lỗi:</strong> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="spct-card">
                    <div class="spct-header">
                        <div class="d-flex align-items-center">
                            <div class="bg-danger rounded-3 p-2 me-3 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                                <i class="bi bi-upc-scan fs-5 text-white"></i>
                            </div>
                            <div>
                                <h5 class="fw-bold mb-0 text-white">${pageTitle}</h5>
                                <small class="text-white-50">Cấu hình thuộc tính, hình ảnh và giá bán cho biến thể</small>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet" class="btn btn-sm btn-outline-light px-3 fw-semibold d-flex align-items-center">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                    </div>

                    <div class="p-4 p-md-5">
                        <form action="${pageContext.request.contextPath}/san-pham-chi-tiet" method="post" enctype="multipart/form-data" id="formChiTiet" class="needs-validation" novalidate onsubmit="return validateFormChiTiet(event)">
                            <input type="hidden" name="action" value="save">
                            <c:if test="${spct != null && spct.id != null}">
                                <input type="hidden" name="id" value="${spct.id}">
                                <input type="hidden" name="anhDaiDien" value="${spct.anhDaiDien}">
                            </c:if>

                            <!-- PHẦN 1: HÌNH ẢNH BIẾN THỂ -->
                            <div class="form-section-title"><i class="bi bi-image text-danger me-2"></i>Hình ảnh minh họa SKU</div>
                            <div class="text-center mb-4 pb-2">
                                <div class="avatar-box-custom mb-2" onclick="document.getElementById('avatarInput').click();" title="Bấm để chọn ảnh cho biến thể này">
                                    <div id="avatarText" class="text-secondary ${spct != null && not empty spct.anhDaiDien ? 'd-none' : ''}">
                                        <i class="bi bi-camera-fill d-block" style="font-size: 2.5rem; color: #94a3b8;"></i>
                                        <span class="small fw-semibold mt-1 d-block text-muted">Chọn hình ảnh</span>
                                    </div>
                                    <img id="avatarPreview" src="${spct != null && not empty spct.anhDaiDien ? spct.anhDaiDien : ''}" 
                                         alt="Ảnh biến thể" class="w-100 h-100 object-fit-cover position-absolute top-0 start-0 ${spct != null && not empty spct.anhDaiDien ? '' : 'd-none'}">
                                </div>
                                <input type="file" name="fileAnh" id="avatarInput" accept="image/png, image/jpeg, image/jpg, image/webp" class="d-none" onchange="previewAvatar(this)">
                                <div class="text-muted small">Định dạng hỗ trợ: PNG, JPG, WEBP – tối đa 5MB.</div>
                                <c:if test="${spct != null && not empty spct.anhDaiDien}">
                                    <div class="mt-2">
                                        <button type="button" class="btn btn-sm btn-outline-danger px-3 fw-semibold" onclick="document.getElementById('avatarInput').click();">
                                            <i class="bi bi-arrow-repeat me-1"></i>Đổi ảnh khác
                                        </button>
                                    </div>
                                </c:if>
                            </div>

                            <!-- PHẦN 2: THÔNG TIN PHÂN LOẠI -->
                            <div class="form-section-title mt-4"><i class="bi bi-tag-fill text-danger me-2"></i>Phân loại & Tổ hợp thuộc tính</div>
                            <div class="row g-3 mb-4">
                                <div class="col-12">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Sản phẩm gốc <span class="text-danger">*</span></label>
                                    <select name="sanPhamId" class="form-select bg-light fw-bold text-dark py-2" required>
                                        <option value="">-- Chọn sản phẩm cha --</option>
                                        <c:forEach var="sp" items="${sanPhams}">
                                            <option value="${sp.id}" ${spct != null && spct.sanPham != null && spct.sanPham.id == sp.id ? 'selected' : ''}>
                                                [${sp.maSp}] ${sp.tenSp}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1"><i class="bi bi-palette-fill text-danger me-1"></i>Màu sắc <span class="text-danger">*</span></label>
                                    <select name="mauSacId" class="form-select py-2" required>
                                        <option value="">-- Chọn màu --</option>
                                        <c:forEach var="ms" items="${mauSacs}">
                                            <option value="${ms.id}" ${spct != null && spct.mauSac != null && spct.mauSac.id == ms.id ? 'selected' : ''}>${ms.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1"><i class="bi bi-rulers text-danger me-1"></i>Kích cỡ <span class="text-danger">*</span></label>
                                    <select name="kichCoId" class="form-select py-2" required>
                                        <option value="">-- Chọn size --</option>
                                        <c:forEach var="kc" items="${kichCos}">
                                            <option value="${kc.id}" ${spct != null && spct.kichCo != null && spct.kichCo.id == kc.id ? 'selected' : ''}>Size ${kc.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1"><i class="bi bi-shoe-prints text-danger me-1"></i>Đế giày <span class="text-danger">*</span></label>
                                    <select name="deGiayId" class="form-select py-2" required>
                                        <option value="">-- Chọn đế --</option>
                                        <c:forEach var="dg" items="${deGiays}">
                                            <option value="${dg.id}" ${spct != null && spct.deGiay != null && spct.deGiay.id == dg.id ? 'selected' : ''}>${dg.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- PHẦN 3: GIÁ VÀ TỒN KHO -->
                            <div class="form-section-title mt-4"><i class="bi bi-currency-dollar text-danger me-2"></i>Giá bán & Quản lý tồn kho</div>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Giá nhập/gốc (VNĐ) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" name="giaGoc" class="form-control fw-bold py-2" required min="0" value="${spct != null ? spct.giaGoc : 2000000}">
                                        <span class="input-group-text bg-light fw-semibold">đ</span>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Giá niêm yết bán (VNĐ) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" name="giaBan" class="form-control fw-bold text-danger py-2" required min="0" value="${spct != null ? spct.giaBan : 2200000}">
                                        <span class="input-group-text bg-light fw-semibold">đ</span>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Số lượng tồn kho <span class="text-danger">*</span></label>
                                    <input type="number" name="soLuongTon" class="form-control fw-bold py-2" required min="0" value="${spct != null ? spct.soLuongTon : 10}">
                                </div>

                                <div class="col-md-12 mt-3">
                                    <label class="form-label fw-semibold text-secondary small mb-1">Trạng thái kinh doanh</label>
                                    <select name="trangThai" class="form-select py-2">
                                        <option value="1" ${spct == null || spct.trangThai == 1 ? 'selected' : ''}>🟢 Đang kinh doanh (Hoạt động)</option>
                                        <option value="0" ${spct != null && spct.trangThai == 0 ? 'selected' : ''}>🔴 Ngừng kinh doanh (Khóa)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mt-5 pt-4 border-top d-flex justify-content-end align-items-center gap-3">
                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet" class="btn btn-outline-secondary px-4 py-2 fw-semibold">Hủy bỏ</a>
                                <button type="submit" class="btn btn-runmax px-5 py-2 fw-bold shadow-sm">
                                    <i class="bi bi-floppy-fill me-2"></i>Lưu Biến Thể SKU
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('avatarPreview');
                    const text = document.getElementById('avatarText');
                    if (preview && text) {
                        preview.src = e.target.result;
                        preview.classList.remove('d-none');
                        text.classList.add('d-none');
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function validateFormChiTiet(event) {
            const form = document.getElementById('formChiTiet');
            if (form && !form.checkValidity()) {
                if (event) { event.preventDefault(); event.stopPropagation(); }
                form.classList.add('was-validated');
                return false;
            }
            if (form) form.classList.add('was-validated');
            return true;
        }
    </script>
</body>
</html>
