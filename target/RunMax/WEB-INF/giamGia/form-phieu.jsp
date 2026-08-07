<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="isEdit" value="${phieu != null && phieu.id != null}" />
<c:set var="pageTitle" value="${isEdit ? 'Cập nhật Phiếu Giảm Giá' : 'Thêm Phiếu Giảm Giá Mới'}" scope="request" />
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
        /* ─── Form Layout ─── */
        .section-card {
            background: #fff;
            border: 1px solid #e8edf2;
            border-radius: 16px;
            padding: 1.75rem 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }
        .section-title {
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #94a3b8;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 1rem;
            margin-bottom: 1.25rem;
            border-bottom: 1px solid #f1f5f9;
        }
        .section-title .dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: #dc2626;
            flex-shrink: 0;
        }

        /* ─── Form inputs ─── */
        .form-label {
            font-size: 0.83rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.35rem;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border-color: #e2e8f0;
            font-size: 0.9rem;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220,38,38,0.12);
        }
        .form-hint { font-size: 0.78rem; color: #94a3b8; margin-top: 0.3rem; }

        /* ─── Input with suffix ─── */
        .input-with-suffix { position: relative; }
        .input-with-suffix .form-control { padding-right: 54px; }
        .input-suffix-label {
            position: absolute; right: 0; top: 0; bottom: 0;
            width: 48px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.78rem; font-weight: 700; color: #64748b;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-left: none;
            border-radius: 0 10px 10px 0;
            pointer-events: none;
        }

        /* ─── Loại giảm giá toggle ─── */
        .discount-type-group { display: flex; gap: 0.75rem; }
        .discount-type-option {
            flex: 1;
            position: relative;
        }
        .discount-type-option input[type="radio"] {
            position: absolute; opacity: 0; width: 0; height: 0;
        }
        .discount-type-label {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            padding: 0.85rem 1.1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            cursor: pointer;
            transition: all .2s;
            background: #f8fafc;
        }
        .discount-type-label .type-icon {
            width: 36px; height: 36px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            background: #f1f5f9;
            flex-shrink: 0;
            transition: all .2s;
        }
        .discount-type-label .type-text strong { font-size: 0.88rem; display: block; }
        .discount-type-label .type-text span { font-size: 0.75rem; color: #94a3b8; }

        .discount-type-option input:checked + .discount-type-label {
            border-color: #dc2626;
            background: #fef2f2;
        }
        .discount-type-option input:checked + .discount-type-label .type-icon {
            background: #dc2626;
            color: #fff;
        }
        .discount-type-option input:checked + .discount-type-label .type-text strong {
            color: #dc2626;
        }

        /* ─── Trạng thái toggle ─── */
        .status-toggle-group { display: flex; gap: 0.75rem; }
        .status-option { flex: 1; position: relative; }
        .status-option input[type="radio"] { position: absolute; opacity: 0; width:0; height:0; }
        .status-label {
            display: flex; align-items: center; gap: 0.6rem;
            padding: 0.8rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px; cursor: pointer;
            transition: all .2s; background: #f8fafc;
            font-size: 0.88rem; font-weight: 600;
        }
        .status-option input:checked + .status-label.active-label {
            border-color: #16a34a; background: #f0fdf4; color: #16a34a;
        }
        .status-option input:checked + .status-label.inactive-label {
            border-color: #dc2626; background: #fef2f2; color: #dc2626;
        }

        /* ─── Sticky Sidebar Wrapper ─── */
        .sticky-right-sidebar {
            position: sticky;
            top: 80px;
            z-index: 5;
        }

        /* ─── Summary Preview Card ─── */
        .preview-card {
            background: linear-gradient(135deg, #1e1b4b 0%, #dc2626 100%);
            border-radius: 16px;
            padding: 1.5rem;
            color: #fff;
        }
        .preview-card .preview-code {
            font-size: 1.6rem; font-weight: 800; letter-spacing: 0.1em;
            font-family: 'Courier New', monospace;
        }
        .preview-card .preview-value {
            font-size: 2.2rem; font-weight: 800; line-height: 1.1;
        }
        .preview-card .preview-meta { font-size: 0.8rem; opacity: 0.8; }

        /* ─── Date Range ─── */
        .date-range-divider {
            display: flex; align-items: center; justify-content: center;
            color: #94a3b8; font-size: 0.8rem; padding-top: 1.75rem;
        }

        /* ─── Action bar ─── */
        .action-bar {
            background: #fff;
            border-top: 1px solid #e8edf2;
            padding: 1rem 0;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
            position: sticky;
            bottom: 0;
            z-index: 10;
        }
        /* --- TICKET PREVIEW DESIGN --- */
        .ticket-preview-wrapper {
            display: flex;
            width: 100%;
            height: 120px;
            background: #fff;
            border-radius: 12px;
            mask-image: radial-gradient(circle at 35% 0px, transparent 8px, black 9px),
                        radial-gradient(circle at 35% 120px, transparent 8px, black 9px);
            -webkit-mask-image: radial-gradient(circle at 35% 0px, transparent 8px, black 9px),
                                radial-gradient(circle at 35% 120px, transparent 8px, black 9px);
            overflow: hidden;
            position: relative;
            border: 1px solid #e2e8f0;
        }

        .ticket-left {
            width: 35%;
            background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .ticket-value-box {
            display: flex;
            flex-direction: column;
        }

        .ticket-value {
            font-size: 1.8rem;
            font-weight: 900;
            line-height: 1.2;
        }

        .ticket-label-small {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.9;
        }

        .ticket-divider {
            position: absolute;
            left: 35%;
            top: 12px;
            bottom: 12px;
            width: 0;
            border-left: 2px dashed rgba(0, 0, 0, 0.1);
            transform: translateX(-50%);
        }

        .ticket-right {
            width: 65%;
            padding: 15px;
            display: flex;
            flex-direction: column;
            background: #fff;
        }

        .ticket-code {
            font-size: 0.8rem;
            font-weight: 800;
            color: #ff416c;
            margin-bottom: 4px;
            letter-spacing: 1px;
        }

        .ticket-name {
            font-size: 1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            white-space: normal;
        }

        .ticket-condition {
            font-size: 0.75rem;
            color: #64748b;
            font-weight: 500;
        }

        .ticket-date {
            font-size: 0.75rem;
            color: #94a3b8;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />
        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />
            <div class="runmax-content pb-5">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">
                            <i class="bi bi-ticket-perforated-fill text-danger me-2"></i>
                            ${isEdit ? 'Cập nhật phiếu giảm giá' : 'Thêm phiếu giảm giá mới'}
                        </h4>
                        <p class="text-muted small mb-0">Thiết lập chương trình khuyến mãi, điều kiện và thời gian áp dụng.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/phieu-giam-gia" class="btn btn-outline-secondary fw-semibold d-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>

                <!-- Alert lỗi -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger d-flex align-items-center gap-3 mb-4 shadow-sm border-0" role="alert">
                        <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                        <div><strong>Lỗi:</strong> ${errorMessage}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/phieu-giam-gia" method="post" id="formPhieu" class="needs-validation" novalidate onsubmit="return validatePhieuForm(event);">
                    <input type="hidden" name="action" value="save">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${phieu.id}">
                    </c:if>

                    <div class="row g-4">
                        <!-- LEFT: Main form -->
                        <div class="col-lg-8">

                            <!-- ①  Thông tin cơ bản -->
                            <div class="section-card">
                                <div class="section-title">
                                    <span class="dot"></span> Thông tin phiếu giảm giá
                                </div>
                                <div class="row g-3">
                                    <!-- Tên phiếu -->
                                    <div class="col-12">
                                        <label class="form-label">Tên chương trình / Phiếu giảm giá <span class="text-danger">*</span></label>
                                        <input type="text" name="tenPhieu" id="inputTenPhieu" class="form-control" required maxlength="200"
                                               value="${phieu != null ? phieu.tenPhieu : ''}"
                                               placeholder="VD: Flash Sale cuối tuần – Giảm 20% toàn bộ giày chạy bộ"
                                               oninput="updatePreview()">
                                        <div class="form-hint">Tên sẽ hiển thị với khách hàng và nhân viên thu ngân.</div>
                                        <div class="invalid-feedback">Vui lòng nhập tên chương trình!</div>
                                    </div>

                                    <!-- Mô tả -->
                                    <div class="col-12">
                                        <label class="form-label">Mô tả / Điều khoản áp dụng</label>
                                        <textarea name="moTa" class="form-control" rows="2"
                                                  placeholder="Ghi chú điều khoản, đối tượng áp dụng, sản phẩm được giảm giá...">${phieu != null ? phieu.moTa : ''}</textarea>
                                    </div>

                                    <!-- Mã phiếu (khi edit) + Số lượng -->
                                    <c:if test="${isEdit}">
                                        <div class="col-md-6">
                                            <label class="form-label">Mã giảm giá</label>
                                            <input type="text" name="maPhieu" class="form-control bg-light fw-bold text-danger" readonly tabindex="-1"
                                                   value="${phieu.maPhieu}">
                                            <div class="form-hint">Mã duy nhất – không thể thay đổi.</div>
                                        </div>
                                    </c:if>
                                    <div class="${isEdit ? 'col-md-6' : 'col-md-4'}">
                                        <label class="form-label">Số lượng phát hành <span class="text-danger">*</span></label>
                                        <div class="input-with-suffix">
                                            <input type="text" inputmode="numeric" name="soLuong" id="inputSoLuong" class="form-control currency-input" required min="1"
                                                   value="${phieu != null && phieu.soLuong != null ? phieu.soLuong : 100}"
                                                   oninput="updatePreview()">
                                            <span class="input-suffix-label">lượt</span>
                                        </div>
                                        <div class="form-hint">Tổng số lượt áp dụng phiếu.</div>
                                        <div class="invalid-feedback">Số lượng phát hành phải lớn hơn 0!</div>
                                    </div>
                                    <input type="hidden" name="loaiPhieu" value="1">
                                </div>
                            </div>

                            <!-- ②  Giá trị & Điều kiện giảm -->
                            <div class="section-card">
                                <div class="section-title">
                                    <span class="dot"></span> Giá trị & Điều kiện giảm giá
                                </div>
                                <div class="row g-3">
                                    <!-- Loại giảm giá -->
                                    <div class="col-12">
                                        <label class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
                                        <div class="discount-type-group">
                                            <div class="discount-type-option">
                                                <input type="radio" name="loaiGiam" id="loaiGiam1" value="1"
                                                       ${phieu == null || phieu.loaiGiam == 1 ? 'checked' : ''}
                                                       onchange="handleLoaiGiamChange()">
                                                <label class="discount-type-label" for="loaiGiam1">
                                                    <div class="type-icon"><i class="bi bi-percent"></i></div>
                                                    <div class="type-text">
                                                        <strong>Phần trăm (%)</strong>
                                                        <span>Giảm theo tỷ lệ % đơn hàng</span>
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="discount-type-option">
                                                <input type="radio" name="loaiGiam" id="loaiGiam2" value="2"
                                                       ${phieu != null && phieu.loaiGiam == 2 ? 'checked' : ''}
                                                       onchange="handleLoaiGiamChange()">
                                                <label class="discount-type-label" for="loaiGiam2">
                                                    <div class="type-icon"><i class="bi bi-cash-stack"></i></div>
                                                    <div class="type-text">
                                                        <strong>Số tiền cố định (VNĐ)</strong>
                                                        <span>Giảm trực tiếp số tiền cố định</span>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Giá trị giảm -->
                                    <div class="col-md-6">
                                        <label class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
                                        <div class="input-with-suffix">
                                            <input type="text" inputmode="numeric" name="giaTrigiam" id="inputGiaTriGiam" class="form-control fw-bold text-danger currency-input" required min="1" max="100"
                                                   value="${phieu != null && phieu.giaTrigiam != null ? phieu.giaTrigiam.toBigInteger() : 10}"
                                                   oninput="checkLivePhieuInput(); updatePreview()">
                                            <span class="input-suffix-label" id="suffixGiam">${phieu != null && phieu.loaiGiam == 2 ? 'VNĐ' : '%'}</span>
                                        </div>
                                        <div class="form-hint" id="noteGiaTriGiam">Nhập từ 1% đến 100%.</div>
                                        <div class="invalid-feedback" id="feedbackGiaTriGiam">Giá trị giảm phải từ 1% đến 100%!</div>
                                    </div>

                                    <!-- Giảm tối đa (chỉ khi loại %) -->
                                    <div class="col-md-6" id="boxGiamToiDa">
                                        <label class="form-label">Giảm tối đa <span class="text-muted fw-normal">(tùy chọn)</span></label>
                                        <div class="input-with-suffix">
                                            <input type="text" inputmode="numeric" name="giamToiDa" id="inputGiamToiDa" class="form-control currency-input" min="0"
                                                   value="${phieu != null && phieu.giamToiDa != null ? phieu.giamToiDa.toBigInteger() : ''}"
                                                   placeholder="Để trống = không giới hạn">
                                            <span class="input-suffix-label">VNĐ</span>
                                        </div>
                                        <div class="form-hint">Giới hạn số tiền giảm tối đa khi đơn giá trị lớn.</div>
                                    </div>

                                    <!-- Điều kiện tối thiểu -->
                                    <div class="col-md-6">
                                        <label class="form-label">Đơn hàng tối thiểu</label>
                                        <div class="input-with-suffix">
                                            <input type="text" inputmode="numeric" name="dieuKienGiam" id="inputDieuKienGiam" class="form-control currency-input" min="0"
                                                   value="${phieu != null && phieu.dieuKienGiam != null ? phieu.dieuKienGiam.toBigInteger() : 0}">
                                            <span class="input-suffix-label">VNĐ</span>
                                        </div>
                                        <div class="form-hint">Áp dụng với đơn ≥ mức này (0 = mọi đơn).</div>
                                    </div>
                                </div>
                            </div>

                            <!-- ③  Trạng thái (chỉ khi edit) -->
                            <c:if test="${isEdit}">
                                <div class="section-card">
                                    <div class="section-title">
                                        <span class="dot"></span> Trạng thái hoạt động
                                    </div>
                                    <div class="status-toggle-group">
                                        <div class="status-option">
                                            <input type="radio" name="trangThai" id="statusOn" value="1" ${phieu.trangThai != 3 ? 'checked' : ''}>
                                            <label class="status-label active-label" for="statusOn">
                                                <i class="bi bi-check-circle-fill"></i> Đang hoạt động
                                            </label>
                                        </div>
                                        <div class="status-option">
                                            <input type="radio" name="trangThai" id="statusOff" value="3" ${phieu.trangThai == 3 ? 'checked' : ''}>
                                            <label class="status-label inactive-label" for="statusOff">
                                                <i class="bi bi-x-circle-fill"></i> Vô hiệu hóa
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- ④  Thời gian áp dụng (xuống cuối) -->
                            <div class="section-card">
                                <div class="section-title">
                                    <span class="dot"></span> Thời gian áp dụng
                                </div>
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-5">
                                        <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="date" name="ngayBatDau" id="inputBatDau" class="form-control" required
                                               value="${phieu != null && phieu.ngayBatDau != null ? phieu.ngayBatDau.toLocalDate() : ''}"
                                               onchange="updatePreview()">
                                        <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu!</div>
                                    </div>
                                    <div class="col-md-2 date-range-divider">
                                        <i class="bi bi-arrow-right"></i>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                        <input type="date" name="ngayKetThuc" id="inputKetThuc" class="form-control" required
                                               value="${phieu != null && phieu.ngayKetThuc != null ? phieu.ngayKetThuc.toLocalDate() : ''}"
                                               onchange="updatePreview()">
                                        <div class="invalid-feedback">Ngày kết thúc không được nhỏ hơn ngày bắt đầu!</div>
                                    </div>
                                </div>
                            </div>

                        </div><!-- /col-lg-8 -->

                        <!-- RIGHT: Preview + Actions -->
                        <div class="col-lg-4">
                            <!-- Gom toàn bộ vào 1 khung ghim (Sticky Wrapper) để trượt xuống cùng nhau không bị đè lên -->
                            <div class="sticky-right-sidebar">
                                <!-- Preview Card -->
                                <div class="mb-4">
                                    <div class="fw-bold text-dark small mb-3"><i class="bi bi-eye-fill text-primary me-2"></i>Xem trước thẻ Voucher</div>
                                    
                                    <!-- CSS Ticket Design -->
                                    <div class="ticket-preview-wrapper shadow-sm">
                                        <!-- Nửa trái: Giá trị giảm -->
                                        <div class="ticket-left">
                                            <div class="ticket-value-box">
                                                <span id="previewValue" class="ticket-value">0%</span>
                                                <span class="ticket-label-small">GIẢM</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Đường đứt đoạn chia vé -->
                                        <div class="ticket-divider"></div>
                                        
                                        <!-- Nửa phải: Thông tin -->
                                        <div class="ticket-right">
                                            <div class="ticket-code" id="previewCode">
                                                <c:choose>
                                                    <c:when test="${isEdit}">${phieu.maPhieu}</c:when>
                                                    <c:otherwise>RUNMAX - AUTO</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="ticket-name text-truncate" id="previewName">
                                                ${phieu != null ? phieu.tenPhieu : 'Tên chương trình hiển thị ở đây'}
                                            </div>
                                            <div class="ticket-condition" id="previewCondition">
                                                Đơn tối thiểu: <fmt:formatNumber value="${phieu != null && phieu.dieuKienGiam != null ? phieu.dieuKienGiam : 0}" type="number"/> đ
                                            </div>
                                            <div class="ticket-date mt-auto d-flex justify-content-between">
                                                <span>HSD: <span id="previewTo">${phieu != null && phieu.ngayKetThuc != null ? phieu.ngayKetThuc.toLocalDate() : '---'}</span></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hướng dẫn nhanh -->
                                <div class="section-card p-3 mb-4" style="background:#f8fafc;">
                                    <div class="fw-bold text-dark small mb-2"><i class="bi bi-lightbulb-fill text-warning me-1"></i>Lưu ý khi tạo phiếu</div>
                                    <ul class="list-unstyled mb-0 text-muted small" style="line-height:1.8;">
                                        <li><i class="bi bi-check text-success me-1"></i>Phiếu <strong>%</strong>: đặt giảm tối đa để tránh giảm quá lớn</li>
                                        <li><i class="bi bi-check text-success me-1"></i>Điều kiện đơn = 0 nghĩa là không giới hạn</li>
                                        <li><i class="bi bi-check text-success me-1"></i>Hết lượt dùng → phiếu tự động vô hiệu</li>
                                        <li><i class="bi bi-check text-success me-1"></i>Mã phiếu được tạo tự động sau khi lưu</li>
                                    </ul>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex flex-column gap-2">
                                    <button type="submit" class="btn btn-runmax fw-bold py-2 fs-6 shadow-sm">
                                        <i class="bi bi-save-fill me-2"></i>${isEdit ? 'Cập nhật Phiếu Giảm Giá' : 'Lưu Phiếu Giảm Giá Mới'}
                                    </button>
                                    <a href="${pageContext.request.contextPath}/phieu-giam-gia" class="btn btn-light border fw-semibold py-2">
                                        <i class="bi bi-x-circle me-1"></i>Hủy bỏ
                                    </a>
                                </div>
                            </div>
                        </div><!-- /col-lg-4 -->
                    </div><!-- /row -->
                </form>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        // --- BẮT ĐẦU: Xử lý format tiền tệ realtime ---
        document.addEventListener('input', function(e) {
            if (e.target && e.target.classList && e.target.classList.contains('currency-input')) {
                let originalValue = e.target.value;
                let cursorPosition = e.target.selectionStart;
                let oldLength = originalValue.length;

                let val = originalValue.replace(/[^\d]/g, '');
                
                if (val !== '') {
                    let formattedValue = new Intl.NumberFormat('vi-VN').format(parseInt(val, 10));
                    e.target.value = formattedValue;
                    
                    let newLength = formattedValue.length;
                    cursorPosition = cursorPosition + (newLength - oldLength);
                    if(cursorPosition < 0) cursorPosition = 0;
                    
                    try { e.target.setSelectionRange(cursorPosition, cursorPosition); } catch(err) {}
                } else {
                    e.target.value = '';
                }
            }
        });

        window.unformatCurrencyInputs = function(form) {
            if (!form) return;
            const currencyInputs = form.querySelectorAll('.currency-input');
            currencyInputs.forEach(input => {
                input.value = input.value.replace(/\./g, '');
            });
        };

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.currency-input').forEach(input => {
                let val = input.value.replace(/[^\d]/g, '');
                if (val !== '') {
                    input.value = new Intl.NumberFormat('vi-VN').format(parseInt(val, 10));
                }
            });
        });
        // --- KẾT THÚC: Xử lý format tiền tệ realtime ---

        /* ─── Live Preview ─── */
        const moneyFormatter = new Intl.NumberFormat('vi-VN');

        function updatePreview() {
            const tenPhieu = document.getElementById('inputTenPhieu')?.value.trim() || '';
            const giaTri = document.getElementById('inputGiaTriGiam')?.value || '';
            const dieuKien = document.getElementById('inputDieuKienGiam')?.value || '';
            const ngayKetThuc = document.getElementById('inputKetThuc')?.value || '';
            
            const loaiGiam1 = document.getElementById('loaiGiam1'); 
            const isPhanTram = loaiGiam1 && loaiGiam1.checked;

            document.getElementById('previewName').innerText = tenPhieu !== '' ? tenPhieu : 'Tên chương trình hiển thị ở đây';
            
            const previewValueEl = document.getElementById('previewValue');
            if (giaTri === '' || isNaN(giaTri)) {
                previewValueEl.innerText = isPhanTram ? '0%' : '0đ';
            } else {
                if (isPhanTram) {
                    previewValueEl.innerText = giaTri + '%';
                } else {
                    const numGiaTri = parseInt(giaTri.replace(/[^\d]/g, ''));
                    if (!isNaN(numGiaTri) && numGiaTri >= 1000 && numGiaTri % 1000 === 0) {
                        previewValueEl.innerText = moneyFormatter.format(numGiaTri / 1000) + 'K';
                    } else {
                        previewValueEl.innerText = moneyFormatter.format(numGiaTri) + 'đ';
                    }
                }
            }

            const previewConditionEl = document.getElementById('previewCondition');
            if (dieuKien === '' || isNaN(dieuKien) || parseInt(dieuKien) === 0) {
                previewConditionEl.innerText = 'Áp dụng cho mọi đơn hàng';
            } else {
                previewConditionEl.innerText = 'Đơn tối thiểu: ' + moneyFormatter.format(parseInt(dieuKien)) + 'đ';
            }

            document.getElementById('previewTo').innerText = ngayKetThuc ? formatDateToVn(ngayKetThuc) : '---';
        }

        function formatDateToVn(dateString) {
            if(!dateString) return '---';
            const parts = dateString.split('-');
            if(parts.length === 3) {
                return parts[2] + '/' + parts[1] + '/' + parts[0];
            }
            return dateString;
        }

        document.addEventListener('DOMContentLoaded', function() {
            updatePreview();
        });

        /* ─── Loại giảm giá change ─── */
        function handleLoaiGiamChange() {
            const loai = document.querySelector('input[name="loaiGiam"]:checked')?.value || '1';
            const suffix = document.getElementById('suffixGiam');
            const note   = document.getElementById('noteGiaTriGiam');
            const boxGiamToiDa   = document.getElementById('boxGiamToiDa');
            const inputGiamToiDa = document.getElementById('inputGiamToiDa');
            const giaTriInput    = document.getElementById('inputGiaTriGiam');
            const feedback       = document.getElementById('feedbackGiaTriGiam');

            if (loai === '1') {
                suffix.innerText = '%';
                note.innerText   = 'Nhập từ 1% đến 100%.';
                boxGiamToiDa.style.display = '';
                inputGiamToiDa.disabled = false;
                if (giaTriInput) { giaTriInput.setAttribute('max', '100'); giaTriInput.setAttribute('min', '1'); }
                if (feedback) feedback.innerText = 'Giá trị giảm phải từ 1% đến 100%!';
            } else {
                suffix.innerText = 'VNĐ';
                note.innerText   = 'Nhập số tiền giảm cố định (> 0 VNĐ).';
                boxGiamToiDa.style.display = 'none';
                inputGiamToiDa.disabled = true;
                inputGiamToiDa.value = '';
                if (giaTriInput) { giaTriInput.removeAttribute('max'); giaTriInput.setAttribute('min', '1'); }
                if (feedback) feedback.innerText = 'Giá trị giảm phải lớn hơn 0 VNĐ!';
            }
            checkLivePhieuInput();
            updatePreview();
        }

        function checkLivePhieuInput() {
            const loai = document.querySelector('input[name="loaiGiam"]:checked')?.value || '1';
            const giaTriInput = document.getElementById('inputGiaTriGiam');
            if (!giaTriInput) return;
            const val = parseFloat(giaTriInput.value.replace(/[^\d]/g, ''));
            if (loai === '1') {
                giaTriInput.setCustomValidity((isNaN(val) || val < 1 || val > 100) ? 'Giá trị giảm phải từ 1% đến 100%!' : '');
            } else {
                giaTriInput.setCustomValidity((isNaN(val) || val <= 0) ? 'Giá trị giảm phải lớn hơn 0 VNĐ!' : '');
            }
        }

        /* ─── Validation ─── */
        function validatePhieuForm(event) {
            const form = document.getElementById('formPhieu');
            form.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

            const tenPhieuInput = document.getElementById('inputTenPhieu');
            if (!tenPhieuInput?.value.trim()) {
                tenPhieuInput.setCustomValidity('Vui lòng nhập tên chương trình!');
                tenPhieuInput.classList.add('is-invalid');
                showBootstrapAlert('Vui lòng nhập tên chương trình / phiếu giảm giá!', 'danger');
                tenPhieuInput.focus();
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            } else { tenPhieuInput.setCustomValidity(''); }

            const soLuongInput = document.getElementById('inputSoLuong');
            const soLuong = parseInt((soLuongInput?.value || '0').replace(/\./g, ''), 10);
            if (isNaN(soLuong) || soLuong <= 0) {
                soLuongInput.setCustomValidity('Số lượng phải lớn hơn 0!');
                soLuongInput.classList.add('is-invalid');
                showBootstrapAlert('Số lượng phiếu phát hành phải lớn hơn 0!', 'danger');
                soLuongInput.focus();
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            } else { soLuongInput.setCustomValidity(''); }

            const batDau  = document.getElementById('inputBatDau')?.value;
            const ketThucInput = document.getElementById('inputKetThuc');
            const ketThuc = ketThucInput?.value;
            if (!batDau || !ketThuc) {
                showBootstrapAlert('Vui lòng chọn đầy đủ Ngày bắt đầu và Ngày kết thúc!', 'danger');
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            }
            if (ketThuc < batDau) {
                ketThucInput.setCustomValidity('Ngày kết thúc không được nhỏ hơn ngày bắt đầu!');
                ketThucInput.classList.add('is-invalid');
                showBootstrapAlert('Ngày kết thúc không được nhỏ hơn ngày bắt đầu!', 'danger');
                ketThucInput.focus();
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            } else { ketThucInput.setCustomValidity(''); }

            const loai = document.querySelector('input[name="loaiGiam"]:checked')?.value || '1';
            const giaTriInput = document.getElementById('inputGiaTriGiam');
            const giaTriGiam  = parseFloat((giaTriInput?.value || '0').replace(/\./g, ''));
            if (loai === '1') {
                if (isNaN(giaTriGiam) || giaTriGiam < 1 || giaTriGiam > 100) {
                    giaTriInput.setCustomValidity('Giá trị giảm phải từ 1% đến 100%!');
                    giaTriInput.classList.add('is-invalid');
                    showBootstrapAlert('Giá trị giảm phải từ 1% đến 100%!', 'danger');
                    giaTriInput.focus();
                    event.preventDefault(); event.stopPropagation();
                    form.classList.add('was-validated');
                    return false;
                } else { giaTriInput.setCustomValidity(''); }
            } else {
                if (isNaN(giaTriGiam) || giaTriGiam <= 0) {
                    giaTriInput.setCustomValidity('Giá trị giảm phải lớn hơn 0 VNĐ!');
                    giaTriInput.classList.add('is-invalid');
                    showBootstrapAlert('Giá trị giảm phải lớn hơn 0 VNĐ!', 'danger');
                    giaTriInput.focus();
                    event.preventDefault(); event.stopPropagation();
                    form.classList.add('was-validated');
                    return false;
                } else { giaTriInput.setCustomValidity(''); }
            }

            const dieuKienInput = document.getElementById('inputDieuKienGiam');
            const dieuKienGiam  = parseFloat((dieuKienInput?.value || '0').replace(/\./g, ''));
            if (isNaN(dieuKienGiam) || dieuKienGiam < 0) {
                dieuKienInput.setCustomValidity('Điều kiện đơn hàng không được âm!');
                dieuKienInput.classList.add('is-invalid');
                showBootstrapAlert('Điều kiện đơn hàng tối thiểu không được là số âm!', 'danger');
                dieuKienInput.focus();
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                return false;
            } else { dieuKienInput.setCustomValidity(''); }

            const inputGiamToiDa = document.getElementById('inputGiamToiDa');
            if (loai === '1' && inputGiamToiDa.value !== '') {
                const giamToiDa = parseFloat((inputGiamToiDa.value || '0').replace(/\./g, ''));
                if (isNaN(giamToiDa) || giamToiDa < 0) {
                    inputGiamToiDa.setCustomValidity('Số tiền giảm tối đa không được âm!');
                    inputGiamToiDa.classList.add('is-invalid');
                    showBootstrapAlert('Số tiền giảm tối đa không được là số âm!', 'danger');
                    inputGiamToiDa.focus();
                    event.preventDefault(); event.stopPropagation();
                    form.classList.add('was-validated');
                    return false;
                } else { inputGiamToiDa.setCustomValidity(''); }
            } else if (inputGiamToiDa) { inputGiamToiDa.setCustomValidity(''); }

            if (form && !form.checkValidity()) {
                event.preventDefault(); event.stopPropagation();
                form.classList.add('was-validated');
                showToast('Vui lòng kiểm tra các trường còn thiếu!', 'danger', 'Thiếu thông tin');
                return false;
            }
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
                    if (window.unformatCurrencyInputs) window.unformatCurrencyInputs(form);
                    form.submit();
                }
            });

            return false; // Luôn trả về false để onsubmit gốc không tự chạy
        }

        // Init
        document.addEventListener('DOMContentLoaded', function() {
            handleLoaiGiamChange();
            
            // --- BẮT ĐẦU: Logic tự động set "Ngày mai" cho phiếu mới ---
            const inputBatDau = document.getElementById('inputBatDau');
            // Nếu ô ngày bắt đầu đang trống (tức là form Thêm Mới, không có dữ liệu cũ)
            if (inputBatDau && !inputBatDau.value) {
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1); // Lấy hôm nay + 1 ngày
                
                // Format về chuẩn YYYY-MM-DD để nhét vào thẻ <input type="date">
                const yyyy = tomorrow.getFullYear();
                const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
                const dd = String(tomorrow.getDate()).padStart(2, '0');
                
                inputBatDau.value = yyyy + '-' + mm + '-' + dd;
            }
            // --- KẾT THÚC ---

            // Gọi updatePreview sau khi đã có ngày để thẻ vé bên phải update theo
            updatePreview(); 
            
            const giaTriInput = document.getElementById('inputGiaTriGiam');
            if (giaTriInput) {
                giaTriInput.addEventListener('input', checkLivePhieuInput);
            }
        });
    </script>
</body>
</html>
