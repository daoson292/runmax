<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý Khách hàng" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách hàng – RunMax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- DataTables Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">
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
        .kh-table-head th {
            background: #1e2a3a; color: #e2e8f0; font-weight: 600; font-size: 0.82rem;
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0.9rem 1rem; border: none;
        }
        .kh-table tbody td { padding: 0.8rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        .kh-table tbody tr:hover { background-color: #fef2f2; }
        .kh-table tbody tr:last-child td { border-bottom: none; }

        /* Avatar initials */
        .avatar-initials {
            width: 36px; height: 36px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.82rem; color: #fff;
            flex-shrink: 0;
        }

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

        /* Custom DataTable layout & styling inside khach-hang.jsp (to bypass caching issues) */
        .dataTables_wrapper .dataTables_paginate {
            margin: 0;
        }
        .dataTables_wrapper .dataTables_paginate .pagination {
            display: flex !important;
            align-items: center !important;
            gap: 0.25rem !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        .dataTables_wrapper .dataTables_paginate .page-item .page-link {
            padding: 0.25rem 0.75rem !important;
            font-size: 0.875rem !important;
            border-radius: 0.375rem !important;
            border: 1px solid #cbd5e1 !important;
            color: #475569 !important;
            background-color: #ffffff !important;
            transition: all 0.15s ease-in-out !important;
            box-shadow: none !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            min-width: 32px !important;
            height: 32px !important;
        }
        .dataTables_wrapper .dataTables_paginate .page-item.active .page-link {
            background-color: #dc2626 !important;
            border-color: #dc2626 !important;
            color: #ffffff !important;
            font-weight: 600 !important;
        }
        .dataTables_wrapper .dataTables_paginate .page-item:not(.active):not(.disabled) .page-link:hover {
            background-color: #fef2f2 !important;
            border-color: #dc2626 !important;
            color: #dc2626 !important;
        }
        .dataTables_wrapper .dataTables_paginate .page-item.disabled .page-link {
            color: #94a3b8 !important;
            background-color: #f8fafc !important;
            border-color: #e2e8f0 !important;
            cursor: not-allowed !important;
            opacity: 0.6 !important;
        }
        
        /* Fallback for non-Bootstrap-5 DataTable pagination layout */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.25rem 0.75rem !important;
            font-size: 0.875rem !important;
            border-radius: 0.375rem !important;
            border: 1px solid #cbd5e1 !important;
            color: #475569 !important;
            background: #ffffff !important;
            transition: all 0.15s ease-in-out !important;
            box-shadow: none !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            min-width: 32px !important;
            height: 32px !important;
            margin-left: 2px !important;
            cursor: pointer !important;
            text-decoration: none !important;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background: #dc2626 !important;
            border-color: #dc2626 !important;
            color: #ffffff !important;
            font-weight: 600 !important;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button:not(.current):not(.disabled):hover {
            background: #fef2f2 !important;
            border-color: #dc2626 !important;
            color: #dc2626 !important;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover {
            color: #94a3b8 !important;
            background: #f8fafc !important;
            border-color: #e2e8f0 !important;
            cursor: not-allowed !important;
            opacity: 0.6 !important;
        }

        .dataTables_info {
            font-size: 0.875rem !important;
            color: #64748b !important;
        }
        .dataTables_wrapper .dataTables_length {
            margin: 0 !important;
        }
        .dataTables_wrapper .dataTables_length select {
            width: 155px !important;
            padding: 0.25rem 1.75rem 0.25rem 0.75rem !important;
            font-size: 0.875rem !important;
            border-radius: 0.375rem !important;
            border: 1px solid #cbd5e1 !important;
            color: #1e293b !important;
            background-color: #ffffff !important;
        }
        .dataTables_wrapper .dataTables_length select:focus {
            border-color: #dc2626 !important;
            box-shadow: 0 0 0 3px rgba(220,38,38,0.15) !important;
            outline: none !important;
        }
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
                        <i class="bi bi-people-fill text-danger me-2"></i>Quản lý Khách hàng
                    </h4>
                    <p class="text-muted small mb-0">Quản lý thông tin và tài khoản khách hàng trong hệ thống.</p>
                </div>

                <!-- Bộ lọc -->
                <div class="filter-card">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterKH">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterKH">
                        <form action="${pageContext.request.contextPath}/khach-hang" method="get" class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-6">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo Mã KH, Tên, SĐT, Email, Tỉnh/TP, Địa chỉ..." value="${keyword}">
                                </div>
                                <div class="col-md-4">
                                    <label class="d-block">Trạng thái</label>
                                    <div class="status-radio">
                                        <input type="radio" name="trangThai" id="ttAll" value="" ${trangThai == null ? 'checked' : ''}>
                                        <label for="ttAll">Tất cả</label>
                                        <input type="radio" name="trangThai" id="ttActive" value="1" ${trangThai == 1 ? 'checked' : ''}>
                                        <label for="ttActive">Hoạt động</label>
                                        <input type="radio" name="trangThai" id="ttInactive" value="0" ${trangThai == 0 ? 'checked' : ''}>
                                        <label for="ttInactive">Khóa</label>
                                    </div>
                                </div>
                                <div class="col-md-2 d-flex gap-2 align-items-end">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/khach-hang" class="btn btn-outline-secondary shadow-sm" title="Làm mới">
                                        <i class="bi bi-arrow-counterclockwise"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Nút hành động giữa bộ lọc và danh sách -->
                <div class="d-flex justify-content-end gap-2 mb-3">
                    <button class="btn btn-outline-success btn-sm fw-semibold shadow-sm" id="btnExcelKH">
                        <i class="bi bi-file-earmark-excel-fill me-1"></i>Xuất Excel
                    </button>
                    <a href="${pageContext.request.contextPath}/khach-hang?action=add" class="btn btn-runmax btn-sm fw-semibold shadow-sm">
                        <i class="bi bi-person-plus-fill me-1"></i>Thêm Khách hàng
                    </a>
                </div>

                <!-- Bảng danh sách -->
                <div class="runmax-card p-0">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <div class="fw-bold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách khách hàng
                            <span class="badge bg-secondary ms-1">${fn:length(khachHangs)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table id="tableKhachHang" class="table table-runmax kh-table mb-0">
                            <thead>
                                <tr class="kh-table-head">
                                    <th>#</th>
                                    <th>Mã KH</th>
                                    <th>Họ và tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Email</th>
                                    <th>Địa chỉ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty khachHangs}">
                                        <c:forEach var="kh" items="${khachHangs}" varStatus="loop">
                                            <tr>
                                                <td class="text-muted fw-semibold">${loop.index + 1}</td>
                                                <td class="fw-bold text-danger" style="font-family:monospace;">${kh.maKh}</td>
                                                <td class="fw-semibold">${kh.hoTen}</td>
                                                <td><i class="bi bi-telephone me-1 text-muted"></i>${kh.sdt}</td>
                                                <td class="text-muted small">${kh.email}</td>
                                                <td class="text-muted small" style="max-width:260px; white-space:normal; word-break:break-word;"
                                                    title="${kh.diaChiMacDinh}">
                                                    <c:choose>
                                                        <c:when test="${not empty kh.diaChiMacDinh && kh.diaChiMacDinh != 'Chưa cập nhật'}">
                                                            <i class="bi bi-geo-alt me-1 text-danger"></i>${kh.diaChiMacDinh}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-secondary fst-italic">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${kh.trangThai == 1}">
                                                            <span class="badge bg-success rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger rounded-pill"><i class="bi bi-lock-fill me-1"></i>Khóa</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/khach-hang?action=edit&id=${kh.id}"
                                                           class="btn btn-sm btn-outline-warning" title="Chỉnh sửa"
                                                           style="width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <%-- Toggle switch bật/tắt trạng thái thay cho nút thùng rác --%>
                                                        <form action="${pageContext.request.contextPath}/khach-hang" method="post" class="d-inline m-0">
                                                            <input type="hidden" name="action" value="toggle">
                                                            <input type="hidden" name="id" value="${kh.id}">
                                                            <label class="toggle-switch" title="${kh.trangThai == 1 ? 'Khóa khách hàng' : 'Mở khóa khách hàng'}">
                                                                <input type="checkbox" ${kh.trangThai == 1 ? 'checked' : ''} onchange="var cb = this; var form = cb.form; var wasChecked = !cb.checked; showBootstrapConfirm('Bạn có chắc muốn ' + (wasChecked ? 'khóa' : 'mở khóa') + ' tài khoản khách hàng ${kh.hoTen}?', function() { form.submit(); }, function() { cb.checked = wasChecked; });">
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
                                            <td colspan="8" class="text-center py-4 text-muted">Không tìm thấy khách hàng</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination info -->
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 border-top no-print">
                        <small class="text-muted">
                            Hiển thị <strong>${fn:length(khachHangs)}</strong> / tổng <strong>${totalRecords != null ? totalRecords : fn:length(khachHangs)}</strong> bản ghi
                        </small>
                        <div class="d-flex align-items-center gap-2">
                            <c:set var="filterParams" value=""/>
                            <c:if test="${not empty param.keyword}">
                                <c:set var="filterParams" value="${filterParams}&keyword=${param.keyword}"/>
                            </c:if>
                            <c:if test="${not empty param.trangThai}">
                                <c:set var="filterParams" value="${filterParams}&trangThai=${param.trangThai}"/>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/khach-hang?page=${currentPage - 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
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
                                            <a href="${pageContext.request.contextPath}/khach-hang?page=${i}${filterParams}" class="btn btn-sm btn-outline-secondary">${i}</a>
                                        </c:if>
                                        <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                            <span class="btn btn-sm btn-outline-secondary border-0" disabled>...</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/khach-hang?page=${currentPage + 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
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

    <!-- jQuery, Bootstrap 5, DataTables -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
    <!-- SheetJS for Excel export -->
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
    $(document).ready(function() {
        $('#tableKhachHang').DataTable({
            searching: false,
            paging: false,
            info: false,
            columnDefs: [
                { orderable: false, targets: [0, 7] }
            ],
            order: [[1, 'asc']],
            responsive: true,
        });
    });

    document.getElementById('btnExcelKH').addEventListener('click', function () {
        const table = document.getElementById('tableKhachHang');
        if (!table) return;
        const wb = XLSX.utils.table_to_book(table, { sheet: 'Danh sách KH' });
        XLSX.writeFile(wb, 'KhachHang_RunMax_' + new Date().toLocaleDateString('vi-VN').replace(/\//g, '-') + '.xlsx');
    });
    </script>
</body>
</html>
