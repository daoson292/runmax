<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý Phiếu Giảm Giá" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phiếu Giảm Giá – RunMax</title>
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
        .filter-body .form-check-label { color: #334155; font-size: 0.88rem; font-weight: 500; }

        .pgg-table-head th {
            background: #1e2a3a; color: #e2e8f0; font-weight: 600; font-size: 0.8rem;
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0.9rem 1rem; border: none;
        }
        .pgg-table tbody td { padding: 0.8rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        .pgg-table tbody tr:hover { background-color: #fef2f2; }
        .pgg-table tbody tr:last-child td { border-bottom: none; }

        /* Trạng thái phiếu */
        .badge-upcoming  { background: #fef3c7; color: #92400e; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-active-pgg{ background: #d1fae5; color: #065f46; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-expired   { background: #f1f5f9; color: #64748b; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-disabled  { background: #fee2e2; color: #991b1b; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }

        /* Loại phiếu badge */
        .badge-public  { background: #dbeafe; color: #1e40af; padding: 0.22rem 0.55rem; border-radius: 12px; font-size: 0.75rem; font-weight: 700; }
        .badge-private { background: #ede9fe; color: #5b21b6; padding: 0.22rem 0.55rem; border-radius: 12px; font-size: 0.75rem; font-weight: 700; }

        /* Toggle */
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
                        <i class="bi bi-ticket-perforated-fill text-danger me-2"></i>Quản lý phiếu giảm giá
                    </h4>
                    <p class="text-muted small mb-0">Tạo và quản lý các chương trình khuyến mãi, ưu đãi cho khách hàng.</p>
                </div>

                <!-- Bộ lọc -->
                <div class="filter-card">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterPGG">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterPGG">
                        <form action="${pageContext.request.contextPath}/phieu-giam-gia" method="get" class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Nhập mã / tên phiếu giảm giá..." value="${keyword}">
                                </div>
                                <div class="col-md-2">
                                    <label>Loại giảm</label>
                                    <select name="loaiGiam" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="1" ${loaiGiam == '1' ? 'selected' : ''}>Giảm phần trăm</option>
                                        <option value="2" ${loaiGiam == '2' ? 'selected' : ''}>Giảm tiền</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label>Trạng thái</label>
                                    <select name="trangThai" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="0" ${trangThai == '0' ? 'selected' : ''}>Sắp diễn ra</option>
                                        <option value="1" ${trangThai == '1' ? 'selected' : ''}>Đang áp dụng</option>
                                        <option value="2" ${trangThai == '2' ? 'selected' : ''}>Kết thúc</option>
                                        <option value="3" ${trangThai == '3' ? 'selected' : ''}>Vô hiệu hóa</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label>Đến ngày</label>
                                    <input type="date" name="denNgay" class="form-control" value="${denNgay != null ? denNgay : ''}">
                                </div>
                                <div class="col-md-3 d-flex gap-2 align-items-end">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/phieu-giam-gia" class="btn btn-outline-secondary shadow-sm" title="Đặt lại">
                                        <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Nút hành động giữa bộ lọc và danh sách -->
                <div class="d-flex justify-content-end gap-2 mb-3">
                    <button class="btn btn-outline-success btn-sm fw-semibold shadow-sm" id="btnExcelPGG">
                        <i class="bi bi-file-earmark-excel-fill me-1"></i>Xuất Excel
                    </button>
                    <a href="${pageContext.request.contextPath}/phieu-giam-gia?action=add" class="btn btn-runmax btn-sm fw-semibold shadow-sm">
                        <i class="bi bi-plus-lg me-1"></i>Thêm mới
                    </a>
                </div>

                <!-- Danh sách -->
                <div class="runmax-card p-0">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <div class="fw-bold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách phiếu giảm giá
                            <span class="badge bg-secondary ms-1">${fn:length(phieuList)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table pgg-table mb-0" id="tablePGG">
                            <thead>
                                <tr class="pgg-table-head">
                                    <th>STT</th>
                                    <th>Mã giảm giá</th>
                                    <th>Tên giảm giá</th>
                                    <th>Giá trị giảm</th>
                                    <th>Đơn hàng tối thiểu</th>
                                    <th class="text-center">Số lượng</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty phieuList}">
                                        <c:forEach var="p" items="${phieuList}" varStatus="loop">
                                            <tr>
                                                <td class="text-muted fw-semibold">${loop.index + 1}</td>
                                                <td class="fw-bold text-danger" style="font-family:monospace;">${p.maPhieu}</td>
                                                <td class="fw-semibold">${p.tenPhieu}</td>
                                                <td class="fw-bold">
                                                    <c:choose>
                                                        <c:when test="${p.loaiGiam == 1}">${p.giaTrigiam}%</c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${p.giaTrigiam}" type="number" maxFractionDigits="0"/> đ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${p.dieuKienGiam}" type="number" maxFractionDigits="0"/> đ
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-secondary rounded-pill">${p.soLuong}</span>
                                                </td>
                                                <td class="small text-muted">${p.ngayBatDau.toLocalDate()}</td>
                                                <td class="small text-muted">${p.ngayKetThuc.toLocalDate()}</td>
                                                <td>
                                                    <%-- Trạng thái động: tính toán tại thời điểm hiển thị --%>
                                                    <c:choose>
                                                        <c:when test="${p.trangThaiDong == 3}">
                                                            <span class="badge-disabled"><i class="bi bi-slash-circle me-1"></i>Vô hiệu hóa</span>
                                                        </c:when>
                                                        <c:when test="${p.trangThaiDong == 0}">
                                                            <span class="badge-upcoming"><i class="bi bi-clock me-1"></i>Sắp diễn ra</span>
                                                        </c:when>
                                                        <c:when test="${p.trangThaiDong == 1}">
                                                            <span class="badge-active-pgg"><i class="bi bi-check-circle me-1"></i>Đang áp dụng</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-expired"><i class="bi bi-x-circle me-1"></i>Kết thúc</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/phieu-giam-gia?action=edit&id=${p.id}"
                                                           class="btn btn-sm btn-outline-warning"
                                                           style="width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;"
                                                           title="Chỉnh sửa">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <%-- Toggle vô hiệu hóa thủ công --%>
                                                        <form action="${pageContext.request.contextPath}/phieu-giam-gia" method="post" class="d-inline m-0">
                                                            <input type="hidden" name="action" value="toggle">
                                                            <input type="hidden" name="id" value="${p.id}">
                                                            <label class="toggle-switch" title="${p.trangThai == 3 ? 'Kích hoạt lại' : 'Vô hiệu hóa'}">
                                                                <input type="checkbox" ${p.trangThai != 3 ? 'checked' : ''} onchange="this.form.submit()">
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
                                            <td colspan="11" class="text-center py-5 text-muted">
                                                <i class="bi bi-ticket-perforated fs-1 d-block mb-2 text-secondary"></i>
                                                <div class="fw-semibold">Không có dữ liệu</div>
                                                <small>Chưa có phiếu giảm giá nào phù hợp với bộ lọc.</small>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination info -->
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 border-top no-print">
                        <small class="text-muted">
                            Hiển thị <strong>${fn:length(phieuList)}</strong> / tổng <strong>${totalRecords != null ? totalRecords : fn:length(phieuList)}</strong> bản ghi
                        </small>
                        <div class="d-flex align-items-center gap-2">
                            <c:set var="filterParams" value=""/>
                            <c:if test="${not empty param.keyword}">
                                <c:set var="filterParams" value="${filterParams}&keyword=${param.keyword}"/>
                            </c:if>
                            <c:if test="${not empty param.trangThai}">
                                <c:set var="filterParams" value="${filterParams}&trangThai=${param.trangThai}"/>
                            </c:if>
                            <c:if test="${not empty param.loaiGiam}">
                                <c:set var="filterParams" value="${filterParams}&loaiGiam=${param.loaiGiam}"/>
                            </c:if>
                            <c:if test="${not empty param.loaiPhieu}">
                                <c:set var="filterParams" value="${filterParams}&loaiPhieu=${param.loaiPhieu}"/>
                            </c:if>
                            <c:if test="${not empty param.denNgay}">
                                <c:set var="filterParams" value="${filterParams}&denNgay=${param.denNgay}"/>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/phieu-giam-gia?page=${currentPage - 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-outline-secondary" disabled><i class="bi bi-chevron-left"></i></button>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages > 0 ? totalPages : 1}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="btn btn-sm btn-danger">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                            <a href="${pageContext.request.contextPath}/phieu-giam-gia?page=${i}${filterParams}" class="btn btn-sm btn-outline-secondary">${i}</a>
                                        </c:if>
                                        <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                            <span class="btn btn-sm btn-outline-secondary border-0" disabled>...</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/phieu-giam-gia?page=${currentPage + 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-outline-secondary" disabled><i class="bi bi-chevron-right"></i></button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script>
    document.getElementById('btnExcelPGG').addEventListener('click', function () {
        const table = document.getElementById('tablePGG');
        if (!table) return;
        const wb = XLSX.utils.table_to_book(table, { sheet: 'Phiếu Giảm Giá' });
        XLSX.writeFile(wb, 'PhieuGiamGia_RunMax_' + new Date().toLocaleDateString('vi-VN').replace(/\//g, '-') + '.xlsx');
    });
    </script>
</body>
</html>
