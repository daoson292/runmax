<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${filterSanPham != null ? 'Chi tiết sản phẩm '.concat(filterSanPham.tenSp) : 'Kho Sản phẩm chi tiết Giày chạy bộ'}" scope="request" />
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
                <!-- Header trang -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">
                            <span class="text-muted fw-normal" style="font-size: 1.1rem;">Quản lý sản phẩm /</span> 
                            <c:choose>
                                <c:when test="${filterSanPham != null}">
                                    Chi tiết Sản phẩm: <span class="text-danger fw-bold">${filterSanPham.tenSp}</span>
                                    <span class="badge bg-danger ms-2 fs-6" style="vertical-align: middle;">${filterSanPham.maSp}</span>
                                </c:when>
                                <c:otherwise>
                                    Danh sách biến thể sản phẩm
                                </c:otherwise>
                            </c:choose>
                        </h4>
                        <p class="text-muted small mb-0">
                            <c:choose>
                                <c:when test="${filterSanPham != null}">
                                    Xem chi tiết thông tin chung và quản lý toàn bộ các biến thể (Màu sắc, Kích cỡ, Đế giày) của sản phẩm này
                                </c:when>
                                <c:otherwise>
                                    Tra cứu, lọc theo khoảng giá và quản lý chi tiết các biến thể sản phẩm trong kho
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="d-flex gap-2">
                        <c:if test="${filterSanPham != null}">
                            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet" class="btn btn-sm btn-outline-danger fw-semibold d-flex align-items-center px-3 py-2 shadow-sm">
                                <i class="bi bi-grid-3x3-gap-fill me-1"></i> Hiển thị tất cả biến thể
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham" class="btn btn-sm btn-secondary fw-semibold d-flex align-items-center px-3 py-2 shadow-sm">
                                <i class="bi bi-arrow-left me-1"></i> Quay lại DS Sản phẩm
                            </a>
                        </c:if>
                        <c:if test="${filterSanPham == null}">
                            <a href="${pageContext.request.contextPath}/san-pham" class="btn btn-sm btn-secondary fw-semibold d-flex align-items-center px-3 py-2 shadow-sm">
                                <i class="bi bi-arrow-left me-1"></i> Quay lại DS Sản phẩm
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Card Thông tin chung chi tiết sản phẩm (chỉ hiện khi xem chi tiết 1 sản phẩm cụ thể) -->
                <c:if test="${filterSanPham != null}">
                    <div class="runmax-card mb-4 border-0 shadow rounded-4 p-4" style="background: linear-gradient(135deg, #ffffff 0%, #fffefe 100%); border-left: 5px solid #dc2626 !important;">
                        <div class="d-flex justify-content-between align-items-start mb-3 border-bottom pb-3">
                            <div>
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <span class="badge bg-danger px-3 py-2 fs-6 fw-bold" style="font-family: monospace;">${filterSanPham.maSp}</span>
                                    <h5 class="fw-bold text-dark mb-0 fs-4">${filterSanPham.tenSp}</h5>
                                </div>
                                <p class="text-muted small mb-0"><i class="bi bi-info-circle me-1"></i>Thông tin tổng quan & thông số của sản phẩm gốc</p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${filterSanPham.trangThai == 1}">
                                        <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill fw-semibold"><i class="bi bi-check-circle-fill me-1"></i>Đang kinh doanh</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-2 rounded-pill fw-semibold"><i class="bi bi-slash-circle me-1"></i>Ngừng kinh doanh</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded-3 shadow-sm border">
                                    <small class="text-muted d-block fw-semibold mb-1">Thương hiệu</small>
                                    <span class="fw-bold text-dark fs-6"><i class="bi bi-tag-fill text-danger me-1"></i>${filterSanPham.thuongHieu.ten}</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded-3 shadow-sm border">
                                    <small class="text-muted d-block fw-semibold mb-1">Chất liệu</small>
                                    <span class="fw-bold text-dark fs-6"><i class="bi bi-layers-fill text-primary me-1"></i>${filterSanPham.chatLieu.ten}</span>
                                </div>
                            </div>
                            <c:set var="totalSKU" value="${spctList.size()}" />
                            <c:set var="totalStock" value="0" />
                            <c:forEach var="sku" items="${spctList}">
                                <c:set var="totalStock" value="${totalStock + sku.soLuongTon}" />
                            </c:forEach>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded-3 shadow-sm border">
                                    <small class="text-muted d-block fw-semibold mb-1">Số phân loại (SKU)</small>
                                    <span class="fw-bold text-primary fs-6"><i class="bi bi-grid-3x3-gap-fill me-1"></i>${totalSKU} biến thể</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded-3 shadow-sm border">
                                    <small class="text-muted d-block fw-semibold mb-1">Tổng tồn kho (tất cả SKU)</small>
                                    <span class="fw-bold ${totalStock > 0 ? 'text-success' : 'text-danger'} fs-6"><i class="bi bi-box-seam-fill me-1"></i>${totalStock} sản phẩm</span>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded-3 border">
                            <small class="text-secondary fw-bold d-block mb-1"><i class="bi bi-file-text-fill text-secondary me-1"></i>Mô tả sản phẩm:</small>
                            <p class="text-dark mb-0 small" style="white-space: pre-line;">${filterSanPham.moTa != null && !filterSanPham.moTa.trim().isEmpty() ? filterSanPham.moTa : 'Chưa có mô tả chi tiết cho sản phẩm này.'}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Bộ lọc tìm kiếm -->
                <div class="runmax-card mb-4 border-0 shadow-sm rounded-4 overflow-hidden p-0">
                    <div class="bg-dark text-white p-3 d-flex justify-content-between align-items-center" style="cursor: pointer;" onclick="toggleFilterSection()">
                        <h6 class="mb-0 fw-bold"><i class="bi bi-funnel-fill text-danger me-2"></i> Bộ lọc tìm kiếm</h6>
                        <span class="small text-light opacity-75"><i class="bi bi-chevron-up" id="filterToggleIcon"></i> Nhấn để thu gọn/mở rộng</span>
                    </div>
                    <div class="p-4 bg-white" id="filterSectionContent">
                        <form action="${pageContext.request.contextPath}/san-pham-chi-tiet" method="get" class="row g-3" id="filterForm">
                            <c:if test="${sanPhamId != null}">
                                <input type="hidden" name="sanPhamId" value="${sanPhamId}">
                            </c:if>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold small text-secondary">Tìm kiếm</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Tìm theo mã SP, mã SP chi tiết, tên, màu, kích cỡ..." value="${keyword}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label fw-semibold small text-secondary">Màu sắc</label>
                                <select name="mauSacId" class="form-select">
                                    <option value="">-- Chọn Màu sắc --</option>
                                    <c:forEach var="ms" items="${mauSacs}">
                                        <option value="${ms.id}" ${mauSacId != null && mauSacId == ms.id ? 'selected' : ''}>${ms.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label fw-semibold small text-secondary">Kích cỡ</label>
                                <select name="kichCoId" class="form-select">
                                    <option value="">-- Chọn Kích cỡ --</option>
                                    <c:forEach var="kc" items="${kichCos}">
                                        <option value="${kc.id}" ${kichCoId != null && kichCoId == kc.id ? 'selected' : ''}>${kc.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label fw-semibold small text-secondary">Đế giày</label>
                                <select name="deGiayId" class="form-select">
                                    <option value="">-- Chọn Đế giày --</option>
                                    <c:forEach var="dg" items="${deGiays}">
                                        <option value="${dg.id}" ${deGiayId != null && deGiayId == dg.id ? 'selected' : ''}>${dg.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold small text-secondary">Trạng thái</label>
                                <select name="trangThai" class="form-select">
                                    <option value="">-- Tất cả --</option>
                                    <option value="1" ${trangThai != null && trangThai == 1 ? 'selected' : ''}>Còn hàng (Hoạt động)</option>
                                    <option value="0" ${trangThai != null && trangThai == 0 ? 'selected' : ''}>Hết hàng (Ngừng bán)</option>
                                </select>
                            </div>

                            <div class="col-md-7 pt-2">
                                <c:set var="maxLimit" value="${sliderMax != null ? sliderMax : 10000000}" />
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <label class="form-label fw-semibold small text-secondary mb-0">Khoảng giá:</label>
                                    <span id="labelPrice" class="fw-bold text-danger small">0 đ - <fmt:formatNumber value="${maxLimit}" type="number" pattern="###,###" /> đ</span>
                                </div>
                                <div class="price-slider-container">
                                    <div class="slider-track"></div>
                                    <div id="sliderRange" class="slider-range"></div>
                                    <input type="range" id="rangeMin" min="0" max="${maxLimit}" step="50000" value="${giaMin != null && not empty giaMin ? giaMin : 0}" oninput="updatePriceSlider()">
                                    <input type="range" id="rangeMax" min="0" max="${maxLimit}" step="50000" value="${giaMax != null && not empty giaMax ? giaMax : maxLimit}" oninput="updatePriceSlider()">
                                </div>
                                <input type="hidden" name="giaMin" id="inputGiaMin" value="${giaMin != null ? giaMin : ''}">
                                <input type="hidden" name="giaMax" id="inputGiaMax" value="${giaMax != null ? giaMax : ''}">
                            </div>

                            <div class="col-md-5 d-flex justify-content-end align-items-end gap-2 pt-2">
                                <button type="submit" class="btn btn-runmax px-4 shadow-sm">
                                    <i class="bi bi-funnel-fill me-1"></i> Lọc biến thể
                                </button>
                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet${sanPhamId != null ? '?sanPhamId='.concat(sanPhamId) : ''}" class="btn btn-outline-secondary px-3 shadow-sm" title="Đặt lại bộ lọc">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i> Đặt lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <style>
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
                        transition: .3s; border-radius: 50%;
                    }
                    input:checked + .toggle-slider { background-color: #22c55e; }
                    input:checked + .toggle-slider:before { transform: translateX(20px); }

                    /* Dual Range Slider - Red & White Theme */
                    .price-slider-container {
                        position: relative;
                        height: 36px;
                        display: flex;
                        align-items: center;
                        margin-bottom: 4px;
                    }
                    .slider-track {
                        position: absolute;
                        width: 100%;
                        height: 8px;
                        background-color: #f1f5f9;
                        border: 1px solid #e2e8f0;
                        border-radius: 6px;
                    }
                    .slider-range {
                        position: absolute;
                        height: 8px;
                        background: linear-gradient(90deg, #ef4444, #dc2626);
                        border-radius: 6px;
                        z-index: 1;
                    }
                    .price-slider-container input[type="range"] {
                        position: absolute;
                        width: 100%;
                        height: 8px;
                        appearance: none;
                        -webkit-appearance: none;
                        background: none;
                        pointer-events: none;
                        z-index: 2;
                    }
                    .price-slider-container input[type="range"]::-webkit-slider-thumb {
                        height: 22px;
                        width: 22px;
                        border-radius: 50%;
                        background: #ffffff;
                        border: 4px solid #dc2626;
                        box-shadow: 0 2px 6px rgba(220, 38, 38, 0.4);
                        cursor: pointer;
                        pointer-events: auto;
                        appearance: none;
                        -webkit-appearance: none;
                        transition: transform 0.15s ease, box-shadow 0.15s ease;
                    }
                    .price-slider-container input[type="range"]::-webkit-slider-thumb:hover {
                        transform: scale(1.15);
                        box-shadow: 0 3px 8px rgba(220, 38, 38, 0.6);
                    }
                    .price-slider-container input[type="range"]::-moz-range-thumb {
                        height: 22px;
                        width: 22px;
                        border-radius: 50%;
                        background: #ffffff;
                        border: 4px solid #dc2626;
                        box-shadow: 0 2px 6px rgba(220, 38, 38, 0.4);
                        cursor: pointer;
                        pointer-events: auto;
                    }

                    /* Print Styles for QR Label */
                    @media print {
                        body * {
                            visibility: hidden !important;
                        }
                        #modalSkuQR, #modalSkuQR * {
                            visibility: visible !important;
                        }
                        #modalSkuQR {
                            position: absolute !important;
                            left: 0 !important;
                            top: 0 !important;
                            width: 100% !important;
                            height: auto !important;
                            overflow: visible !important;
                            background: transparent !important;
                        }
                        #modalSkuQR .modal-dialog, #modalSkuQR .modal-content, #modalSkuQR .modal-body {
                            margin: 0 !important;
                            padding: 0 !important;
                            border: none !important;
                            box-shadow: none !important;
                            background: transparent !important;
                            width: 100% !important;
                        }
                        #printQRCard {
                            margin: 0 auto !important;
                            padding: 18px !important;
                            border: 2px solid #000 !important;
                            box-shadow: none !important;
                            width: 330px !important;
                            page-break-inside: avoid;
                        }
                        .no-print, .modal-header, .modal-footer, .btn-close {
                            display: none !important;
                        }
                    }
                </style>

                <!-- Bảng SKU -->
                <div class="runmax-card p-0">
                    <div class="p-3 d-flex align-items-center justify-content-between border-bottom">
                        <div class="fw-semibold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách biến thể sản phẩm (SKU)
                            <span class="badge bg-secondary ms-1">${fn:length(spctList)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table-runmax mb-0" id="tableSPCT">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th class="text-center">Ảnh</th>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Mã SP chi tiết</th>
                                    <th>Màu sắc</th>
                                    <th>Kích cỡ</th>
                                    <th class="text-center">Số lượng tồn</th>
                                    <th class="text-end">Giá bán</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${spctList}" varStatus="loop">
                                    <tr>
                                        <td class="fw-semibold text-muted">${loop.index + 1}</td>
                                        <td class="text-center">
                                            <img src="${item.anhDaiDien != null && !item.anhDaiDien.isEmpty() ? item.anhDaiDien : pageContext.request.contextPath.concat('/assets/img/default-shoe.png')}"
                                                 class="rounded border shadow-sm" style="width:48px; height:48px; object-fit:cover;"
                                                 onerror="this.src='https://via.placeholder.com/48?text=Shoe'">
                                        </td>
                                        <td class="fw-bold text-danger" style="font-family:monospace;">${item.sanPham.maSp}</td>
                                        <td class="fw-semibold text-dark">${item.sanPham.tenSp}</td>
                                        <td class="fw-bold text-primary" style="font-family:monospace;">
                                            ${item.maSpct != null ? item.maSpct : ('SPCT'.concat(item.id))}
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${item.mauSac.ten}</span></td>
                                        <td><span class="badge bg-danger">${item.kichCo.ten}</span></td>
                                        <td class="text-center">
                                            <span id="stock-spct-${item.id}" class="badge ${item.soLuongTon > 10 ? 'bg-success' : 'bg-warning text-dark'}">
                                                ${item.soLuongTon}
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold text-danger">
                                            <fmt:formatNumber value="${item.giaBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.trangThai == 1}">
                                                    <span class="badge bg-success rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill"><i class="bi bi-slash-circle me-1"></i>Ngừng bán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-flex align-items-center justify-content-end gap-2">
                                                <button type="button" class="btn btn-sm btn-outline-info" title="Xem chi tiết SKU"
                                                        onclick="openSkuDetailModal('${item.id}', '${item.sanPham.maSp}', '${fn:escapeXml(item.sanPham.tenSp)}', '${item.maSpct != null ? item.maSpct : 'SPCT'.concat(item.id)}', '${fn:escapeXml(item.mauSac.ten)}', '${fn:escapeXml(item.kichCo.ten)}', '${fn:escapeXml(item.deGiay.ten)}', '${item.giaGoc}', '${item.giaBan}', '${item.soLuongTon}', '${item.trangThai}', '${item.anhDaiDien != null ? item.anhDaiDien : ''}')">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-dark" title="Xem & In Mã QR SKU"
                                                        onclick="openSkuQRModal('${item.id}', '${item.sanPham.maSp}', '${fn:escapeXml(item.sanPham.tenSp)}', '${item.maSpct != null ? item.maSpct : 'SPCT'.concat(item.id)}', '${fn:escapeXml(item.mauSac.ten)}', '${fn:escapeXml(item.kichCo.ten)}', '${item.giaBan}')">
                                                    <i class="bi bi-qr-code"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet?action=edit&id=${item.id}" class="btn btn-sm btn-outline-primary" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <%-- Toggle switch bật/tắt trạng thái thay cho nút thùng rác --%>
                                                <form action="${pageContext.request.contextPath}/san-pham-chi-tiet" method="post" class="d-inline m-0">
                                                    <input type="hidden" name="action" value="toggle">
                                                    <input type="hidden" name="id" value="${item.id}">
                                                    <c:if test="${sanPhamId != null}">
                                                        <input type="hidden" name="sanPhamId" value="${sanPhamId}">
                                                    </c:if>
                                                    <label class="toggle-switch" title="${item.trangThai == 1 ? 'Ngừng bán SKU này' : 'Kinh doanh lại SKU này'}">
                                                        <input type="checkbox" ${item.trangThai == 1 ? 'checked' : ''} onchange="this.form.submit()">
                                                        <span class="toggle-slider"></span>
                                                    </label>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- DataTables Bootstrap 5 JS & CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script>
        function updatePriceSlider() {
            const rangeMin = document.getElementById("rangeMin");
            const rangeMax = document.getElementById("rangeMax");
            const sliderRange = document.getElementById("sliderRange");
            const labelPrice = document.getElementById("labelPrice");
            const inputGiaMin = document.getElementById("inputGiaMin");
            const inputGiaMax = document.getElementById("inputGiaMax");

            if (!rangeMin || !rangeMax) return;

            let minVal = parseInt(rangeMin.value);
            let maxVal = parseInt(rangeMax.value);

            if (minVal > maxVal) {
                let tmp = minVal;
                minVal = maxVal;
                maxVal = tmp;
            }

            const minPercent = (minVal / rangeMin.max) * 100;
            const maxPercent = (maxVal / rangeMax.max) * 100;

            sliderRange.style.left = minPercent + "%";
            sliderRange.style.width = (maxPercent - minPercent) + "%";

            labelPrice.innerHTML = minVal.toLocaleString('vi-VN') + " đ - " + maxVal.toLocaleString('vi-VN') + " đ";

            if (minVal === 0 && maxVal === parseInt(rangeMax.max)) {
                inputGiaMin.value = "";
                inputGiaMax.value = "";
            } else {
                inputGiaMin.value = minVal;
                inputGiaMax.value = maxVal;
            }
        }

        function toggleFilterSection() {
            const body = document.getElementById("filterSectionContent");
            const icon = document.getElementById("filterToggleIcon");
            if (!body || !icon) return;
            if (body.style.display === "none") {
                body.style.display = "block";
                icon.className = "bi bi-chevron-up";
            } else {
                body.style.display = "none";
                icon.className = "bi bi-chevron-down";
            }
        }

        $(document).ready(function() {
            updatePriceSlider();

            $('#tableSPCT').DataTable({
                searching: false,
                dom: "<'row'<'col-sm-12'tr>>" +
                     "<'d-flex align-items-center justify-content-between px-4 py-3 border-top no-print'ipl>",
                language: {
                    emptyTable: "Không có dữ liệu trong bảng",
                    info: "Hiển thị <strong>_START_ - _END_</strong> / tổng <strong>_TOTAL_</strong> bản ghi",
                    infoEmpty: "Hiển thị <strong>0 - 0</strong> / tổng <strong>0</strong> bản ghi",
                    infoFiltered: "(được lọc từ _MAX_ bản ghi)",
                    lengthMenu: "_MENU_",
                    loadingRecords: "Đang tải...",
                    processing: "Đang xử lý...",
                    zeroRecords: "Không tìm thấy kết quả nào",
                    paginate: {
                        first: "Đầu",
                        last: "Cuối",
                        next: '<i class="bi bi-chevron-right"></i>',
                        previous: '<i class="bi bi-chevron-left"></i>'
                    }
                },
                lengthMenu: [
                    [10, 20, 50],
                    ["10 bản ghi / trang", "20 bản ghi / trang", "50 bản ghi / trang"]
                ],
                order: [[0, 'asc']],
                pageLength: 10
            });
        });

        function openSkuDetailModal(id, maSp, tenSp, maSpct, mauSac, kichCo, deGiay, giaGoc, giaBan, soLuongTon, trangThai, anhDaiDien) {
            document.getElementById('skuDetailMaSp').innerText = maSp;
            document.getElementById('skuDetailTenSp').innerText = tenSp;
            document.getElementById('skuDetailMaSpct').innerText = maSpct;
            document.getElementById('skuDetailMauSac').innerText = mauSac;
            document.getElementById('skuDetailKichCo').innerText = kichCo;
            document.getElementById('skuDetailDeGiay').innerText = deGiay;
            
            const gGocNum = Number(giaGoc);
            const gBanNum = Number(giaBan);
            document.getElementById('skuDetailGiaGoc').innerText = isNaN(gGocNum) ? giaGoc : gGocNum.toLocaleString('vi-VN') + ' đ';
            document.getElementById('skuDetailGiaBan').innerText = isNaN(gBanNum) ? giaBan : gBanNum.toLocaleString('vi-VN') + ' đ';
            
            const slNum = Number(soLuongTon);
            const slEl = document.getElementById('skuDetailSoLuongTon');
            slEl.innerText = slNum + ' sản phẩm';
            slEl.className = 'fw-bold fs-6 ' + (slNum > 10 ? 'text-success' : 'text-warning text-dark');
            
            const stEl = document.getElementById('skuDetailStatus');
            if (trangThai == '1') {
                stEl.className = 'badge bg-success py-2 fs-6 mt-2';
                stEl.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Hoạt động';
            } else {
                stEl.className = 'badge bg-secondary py-2 fs-6 mt-2';
                stEl.innerHTML = '<i class="bi bi-slash-circle me-1"></i>Ngừng bán';
            }
            
            const imgEl = document.getElementById('skuDetailImg');
            if (anhDaiDien && anhDaiDien !== 'null' && anhDaiDien.trim() !== '') {
                imgEl.src = anhDaiDien;
            } else {
                imgEl.src = '${pageContext.request.contextPath}/assets/img/default-shoe.png';
            }
            
            const modal = new bootstrap.Modal(document.getElementById('modalSkuDetail'));
            modal.show();
        }

        /* ─── XỬ LÝ TẠO & IN MÃ QR SKU ─── */
        let currentQRCodeInstance = null;
        let currentSKUCodeForDownload = "";

        function openSkuQRModal(id, maSp, tenSp, maSpct, mauSac, kichCo, giaBan) {
            currentSKUCodeForDownload = maSpct;
            document.getElementById('qrCardTenSp').innerText = tenSp;
            document.getElementById('qrCardMaSpct').innerText = maSpct;
            document.getElementById('qrCardMauSac').innerText = 'Màu: ' + mauSac;
            document.getElementById('qrCardKichCo').innerText = 'Size: ' + kichCo;
            
            const gBanNum = Number(giaBan);
            document.getElementById('qrCardGiaBan').innerText = isNaN(gBanNum) ? giaBan : gBanNum.toLocaleString('vi-VN') + ' đ';
            
            const container = document.getElementById("qrcodeContainer");
            container.innerHTML = "";
            
            currentQRCodeInstance = new QRCode(container, {
                text: maSpct,
                width: 168,
                height: 168,
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });
            
            // Đóng modal chi tiết nếu đang mở
            const detailModalEl = document.getElementById('modalSkuDetail');
            const detailModal = bootstrap.Modal.getInstance(detailModalEl);
            if (detailModal) { detailModal.hide(); }
            
            const modal = new bootstrap.Modal(document.getElementById('modalSkuQR'));
            modal.show();
        }

        function openQRFromDetailModal() {
            const maSp = document.getElementById('skuDetailMaSp').innerText;
            const tenSp = document.getElementById('skuDetailTenSp').innerText;
            const maSpct = document.getElementById('skuDetailMaSpct').innerText;
            const mauSac = document.getElementById('skuDetailMauSac').innerText;
            const kichCo = document.getElementById('skuDetailKichCo').innerText;
            const giaBanStr = document.getElementById('skuDetailGiaBan').innerText.replace(/\D/g, '');
            
            openSkuQRModal('', maSp, tenSp, maSpct, mauSac, kichCo, giaBanStr);
        }

        function printQRLabel() {
            window.print();
        }

        function downloadQRImage() {
            const container = document.getElementById("qrcodeContainer");
            const canvas = container.querySelector("canvas");
            const img = container.querySelector("img");
            
            let dataUrl = null;
            if (canvas) {
                dataUrl = canvas.toDataURL("image/png");
            } else if (img && img.src) {
                dataUrl = img.src;
            }
            
            if (dataUrl) {
                const link = document.createElement("a");
                link.href = dataUrl;
                link.download = (currentSKUCodeForDownload || "RUNMAX-SKU") + "-QR.png";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            } else {
                if (typeof showToast === 'function') {
                    showToast("Đang tạo ảnh QR, vui lòng thử lại sau 1 giây!", "warning");
                } else {
                    alert("Đang tạo ảnh QR, vui lòng thử lại sau 1 giây!");
                }
            }
        }
    </script>

    <!-- Modal Chi tiết SKU / Biến thể -->
    <div class="modal fade" id="modalSkuDetail" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-dark text-white p-4">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-info-circle-fill text-danger"></i>
                        Chi tiết Phân loại (SKU)
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light">
                    <div class="row g-4 align-items-center">
                        <div class="col-md-4 text-center">
                            <div class="p-3 bg-white rounded-4 shadow-sm border">
                                <img id="skuDetailImg" src="" alt="SKU Image" class="img-fluid rounded-3 mb-2" style="max-height: 200px; object-fit: contain;">
                                <span id="skuDetailStatus" class="badge d-block py-2 fs-6 mt-2"></span>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="bg-white p-4 rounded-4 shadow-sm border">
                                <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                    <h6 class="fw-bold text-dark mb-0 fs-5" id="skuDetailTenSp"></h6>
                                    <span class="badge bg-danger fs-6" id="skuDetailMaSp"></span>
                                </div>
                                <div class="row g-3 mb-3">
                                    <div class="col-sm-6">
                                        <label class="small text-secondary fw-semibold d-block">Mã SP chi tiết (SKU):</label>
                                        <span class="fw-bold text-primary fs-6" id="skuDetailMaSpct" style="font-family: monospace;"></span>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="small text-secondary fw-semibold d-block">Số lượng tồn kho:</label>
                                        <span class="fw-bold fs-6" id="skuDetailSoLuongTon"></span>
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="small text-secondary fw-semibold d-block">Màu sắc:</label>
                                        <span class="badge bg-light text-dark border px-3 py-2 fs-6" id="skuDetailMauSac"></span>
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="small text-secondary fw-semibold d-block">Kích cỡ:</label>
                                        <span class="badge bg-danger px-3 py-2 fs-6" id="skuDetailKichCo"></span>
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="small text-secondary fw-semibold d-block">Đế giày:</label>
                                        <span class="badge bg-secondary px-3 py-2 fs-6" id="skuDetailDeGiay"></span>
                                    </div>
                                </div>
                                <div class="row g-3 pt-2 border-top">
                                    <div class="col-sm-6">
                                        <label class="small text-secondary fw-semibold d-block">Giá gốc:</label>
                                        <span class="fw-semibold text-muted text-decoration-line-through fs-6" id="skuDetailGiaGoc"></span>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="small text-secondary fw-semibold d-block">Giá bán:</label>
                                        <span class="fw-bold text-danger fs-5" id="skuDetailGiaBan"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-3 border-top d-flex justify-content-between">
                    <button type="button" class="btn btn-dark px-4 fw-semibold d-flex align-items-center gap-2" onclick="openQRFromDetailModal()">
                        <i class="bi bi-qr-code"></i> Xem & In Tem QR SKU
                    </button>
                    <button type="button" class="btn btn-secondary px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Thẻ QR & In Tem Nhãn SKU -->
    <div class="modal fade" id="modalSkuQR" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-4 no-print">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code"></i>
                        Thẻ Mã QR & Tem Nhãn SKU
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light text-center">
                    <!-- KHUNG TEM NHÃN IN (Chuẩn thiết kế tem dán POS) -->
                    <div id="printQRCard" class="bg-white p-4 rounded-4 shadow border mx-auto" style="max-width: 340px;">
                        <div class="border-bottom pb-2 mb-3">
                            <div class="fw-bold text-danger" style="letter-spacing: 2px; font-size: 0.85rem;">RUNMAX SHOES</div>
                            <div class="fw-bold text-dark text-truncate" id="qrCardTenSp" style="font-size: 1.05rem;"></div>
                        </div>
                        
                        <!-- QR Code Container -->
                        <div id="qrcodeContainer" class="d-flex justify-content-center my-3 p-2 bg-light border rounded-3 mx-auto" style="width: 188px; height: 188px; align-items: center;"></div>
                        
                        <!-- SKU & Specs -->
                        <div class="mt-2">
                            <div class="fw-bold text-dark fs-4 mb-1" id="qrCardMaSpct" style="font-family: monospace; letter-spacing: 1.5px;"></div>
                            <div class="d-flex justify-content-center gap-2 mb-2">
                                <span class="badge bg-secondary-subtle text-dark border px-2 py-1" id="qrCardMauSac"></span>
                                <span class="badge bg-danger-subtle text-danger border px-2 py-1" id="qrCardKichCo"></span>
                            </div>
                            <div class="fw-bold text-danger fs-5 border-top pt-2 mt-2" id="qrCardGiaBan"></div>
                        </div>
                    </div>
                    <div class="text-muted small mt-3 no-print">
                        <i class="bi bi-info-circle me-1"></i> Quét mã QR bằng Camera hoặc súng quét tại quầy POS để nhận diện tự động.
                    </div>
                </div>
                <div class="modal-footer bg-white p-3 border-top no-print d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-secondary px-3" onclick="downloadQRImage()">
                        <i class="bi bi-download me-1"></i> Tải ảnh (.PNG)
                    </button>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-secondary px-3" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-runmax px-4 shadow-sm" onclick="printQRLabel()">
                            <i class="bi bi-printer-fill me-1"></i> In Tem Nhãn
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Lắng nghe sự kiện đồng bộ tồn kho từ tab POS
        if ('BroadcastChannel' in window) {
            const inventoryChannel = new BroadcastChannel('inventory_sync_channel');
            
            inventoryChannel.onmessage = function(event) {
                try {
                    const data = event.data;
                    if (data && data.type === 'DEDUCT' && data.spctId) {
                        const stockEl = document.getElementById('stock-spct-' + data.spctId);
                        if (stockEl) {
                            // Tính toán số lượng mới
                            let currentStock = parseInt(stockEl.innerText) || 0;
                            currentStock = Math.max(0, currentStock - data.qty);
                            stockEl.innerText = currentStock;
                            
                            // Cập nhật lại màu sắc (Warning nếu dưới 10)
                            if (currentStock <= 10) {
                                stockEl.className = 'badge bg-warning text-dark';
                            } else {
                                stockEl.className = 'badge bg-success';
                            }
                            
                            // Hiệu ứng Flash Color nháy sáng
                            const originalBg = stockEl.style.backgroundColor;
                            const originalColor = stockEl.style.color;
                            const originalTransition = stockEl.style.transition;
                            
                            stockEl.style.transition = 'all 0.3s ease';
                            stockEl.style.backgroundColor = '#dc3545'; // Đỏ nổi bật
                            stockEl.style.color = '#fff';
                            stockEl.style.transform = 'scale(1.2)';
                            stockEl.style.display = 'inline-block';
                            
                            setTimeout(() => {
                                stockEl.style.backgroundColor = originalBg;
                                stockEl.style.color = originalColor;
                                stockEl.style.transform = 'scale(1)';
                                setTimeout(() => {
                                    stockEl.style.transition = originalTransition;
                                }, 300);
                            }, 400);
                        }
                    }
                } catch (e) {
                    console.error('Inventory Sync Error:', e);
                }
            };
        }
    </script>
</body>
</html>
