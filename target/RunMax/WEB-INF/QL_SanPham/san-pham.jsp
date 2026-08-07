<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Danh mục Sản phẩm" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} – RunMax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- DataTables Bootstrap 5 -->
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
        .sp-table-head th {
            background: #1e2a3a; color: #e2e8f0; font-weight: 600; font-size: 0.82rem;
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0.9rem 1rem; border: none;
        }
        .table-runmax tbody td { padding: 0.8rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        .table-runmax tbody tr:hover { background-color: #fef2f2; }

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

        /* Realtime Stock Update Animation */
        .flash-update-deduct { animation: flashRed 0.6s ease; }
        .flash-update-add { animation: flashGreen 0.6s ease; }
        
        @keyframes flashRed {
            0% { transform: scale(1); background-color: #fca5a5 !important; }
            50% { transform: scale(1.15); background-color: #ef4444 !important; color: white !important; }
            100% { transform: scale(1); }
        }
        @keyframes flashGreen {
            0% { transform: scale(1); background-color: #86efac !important; }
            50% { transform: scale(1.15); background-color: #22c55e !important; color: white !important; }
            100% { transform: scale(1); }
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
                        <i class="bi bi-box-seam-fill text-danger me-2"></i>Danh mục sản phẩm
                    </h4>
                    <p class="text-muted small mb-0">Quản lý dòng giày chạy bộ nam RunMax.</p>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty error || not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${not empty error ? error : errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty toastSuccess || not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${not empty toastSuccess ? toastSuccess : successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Bộ lọc thu gọn -->
                <div class="filter-card">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterSP">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm Sản phẩm</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterSP">
                        <form action="${pageContext.request.contextPath}/san-pham" method="GET" class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label>Từ khóa</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên, mã sản phẩm..." value="${keyword}">
                                </div>
                                <div class="col-md-3">
                                    <label>Thương hiệu</label>
                                    <select name="thuongHieuId" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <c:forEach var="th" items="${thuongHieus}">
                                            <option value="${th.id}" ${thuongHieuId == th.id ? 'selected' : ''}>${th.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label>Chất liệu</label>
                                    <select name="chatLieuId" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <c:forEach var="cl" items="${chatLieus}">
                                            <option value="${cl.id}" ${chatLieuId == cl.id ? 'selected' : ''}>${cl.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="d-block">Trạng thái</label>
                                    <div class="status-radio">
                                        <input type="radio" name="trangThai" id="ttAll" value="" ${trangThai == null ? 'checked' : ''}>
                                        <label for="ttAll">Tất cả</label>
                                        <input type="radio" name="trangThai" id="ttActive" value="1" ${trangThai != null && trangThai == 1 ? 'checked' : ''}>
                                        <label for="ttActive">HĐ</label>
                                        <input type="radio" name="trangThai" id="ttInactive" value="0" ${trangThai != null && trangThai == 0 ? 'checked' : ''}>
                                        <label for="ttInactive">Khóa</label>
                                    </div>
                                </div>
                                <div class="col-md-2 d-flex gap-2 align-items-end">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/san-pham" class="btn btn-outline-secondary shadow-sm" title="Làm mới">
                                        <i class="bi bi-arrow-counterclockwise"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Nút hành động giữa bộ lọc và danh sách -->
                <div class="d-flex justify-content-end gap-2 mb-3">
                    <button class="btn btn-outline-success btn-sm fw-semibold shadow-sm" id="btnExcelSP">
                        <i class="bi bi-file-earmark-excel-fill me-1"></i>Xuất Excel
                    </button>
                    <a href="${pageContext.request.contextPath}/san-pham?action=addForm" class="btn btn-runmax btn-sm fw-semibold shadow-sm">
                        <i class="bi bi-plus-circle-fill me-1"></i>Thêm sản phẩm mới
                    </a>
                </div>

                <!-- Bảng danh sách -->
                <div class="runmax-card p-0">
                    <div class="p-3 d-flex align-items-center justify-content-between border-bottom">
                        <div class="fw-semibold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách sản phẩm
                            <span class="badge bg-secondary ms-1">${fn:length(danhSachSanPham)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table id="tableSanPham" class="table table-runmax w-100 mb-0">
                            <thead>
                                <tr class="sp-table-head">
                                    <th>STT</th>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Thương hiệu</th>
                                    <th>Chất liệu</th>
                                    <th class="text-center">Hàng tồn</th>
                                    <th class="text-end">Khoảng giá</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sp" items="${danhSachSanPham}" varStatus="loop">
                                    <tr>
                                        <td class="text-muted fw-semibold">${(currentPage != null ? currentPage - 1 : 0) * (pageSize != null ? pageSize : 10) + loop.index + 1}</td>
                                        <td class="fw-bold text-danger" style="font-family:monospace;">${sp.maSp}</td>
                                        <td class="fw-semibold text-dark">${sp.tenSp}</td>
                                        <td>
                                            <span class="badge bg-danger rounded-pill" style="font-size:0.78rem;">
                                                ${sp.thuongHieu != null ? sp.thuongHieu.ten : '--'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary rounded-pill" style="font-size:0.78rem;">
                                                ${sp.chatLieu != null ? sp.chatLieu.ten : '--'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${sp.tongHangTon > 0 ? 'bg-info text-dark' : 'bg-warning text-dark'} fw-bold" style="font-size:0.82rem;">
                                                ${sp.tongHangTon}
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold text-danger">
                                            ${sp.khoangGiaFormatted}
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sp.trangThai == 1}">
                                                    <span class="badge bg-success rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill"><i class="bi bi-slash-circle me-1"></i>Ngừng kinh doanh</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-2">
                                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet?sanPhamId=${sp.id}"
                                                   class="btn btn-sm btn-outline-primary" title="Xem chi tiết biến thể">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/san-pham?action=edit&id=${sp.id}"
                                                   class="btn btn-sm btn-outline-warning" title="Sửa sản phẩm"
                                                   style="width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/san-pham" method="GET" class="d-inline m-0">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="id" value="${sp.id}">
                                                    <label class="toggle-switch" title="${sp.trangThai == 1 ? 'Ngừng kinh doanh sản phẩm này' : 'Kinh doanh lại sản phẩm này'}">
                                                        <input type="checkbox" ${sp.trangThai == 1 ? 'checked' : ''} onchange="this.form.submit()">
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

                    <!-- Pagination info -->
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 border-top no-print">
                        <small class="text-muted">
                            Hiển thị <strong>${fn:length(danhSachSanPham)}</strong> / tổng <strong>${totalRecords != null ? totalRecords : fn:length(danhSachSanPham)}</strong> bản ghi
                        </small>
                        <div class="d-flex align-items-center gap-2">
                            <c:set var="filterParams" value=""/>
                            <c:if test="${not empty param.keyword}">
                                <c:set var="filterParams" value="${filterParams}&keyword=${param.keyword}"/>
                            </c:if>
                            <c:if test="${not empty param.thuongHieuId}">
                                <c:set var="filterParams" value="${filterParams}&thuongHieuId=${param.thuongHieuId}"/>
                            </c:if>
                            <c:if test="${not empty param.chatLieuId}">
                                <c:set var="filterParams" value="${filterParams}&chatLieuId=${param.chatLieuId}"/>
                            </c:if>
                            <c:if test="${not empty param.trangThai}">
                                <c:set var="filterParams" value="${filterParams}&trangThai=${param.trangThai}"/>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${currentPage - 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
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
                                            <a href="${pageContext.request.contextPath}/san-pham?page=${i}${filterParams}" class="btn btn-sm btn-outline-secondary">${i}</a>
                                        </c:if>
                                        <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                            <span class="btn btn-sm btn-outline-secondary border-0" disabled>...</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${currentPage + 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
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

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
    $(document).ready(function() {
        $('#tableSanPham').DataTable({
            searching: false,
            paging: false,
            info: false,
            dom: "<'row'<'col-sm-12'tr>>",
            language: {
                emptyTable: "Không có dữ liệu trong bảng"
            },
            columnDefs: [
                { orderable: false, targets: [6, 7, 8] }
            ],
            order: [], // Bỏ sort mặc định để không làm xáo trộn STT của server
            responsive: true,
        });
    });

    document.getElementById('btnExcelSP').addEventListener('click', function () {
        const table = document.getElementById('tableSanPham');
        const wb = XLSX.utils.table_to_book(table, { sheet: 'Sản phẩm' });
        XLSX.writeFile(wb, 'SanPham_RunMax_' + new Date().toLocaleDateString('vi-VN').replace(/\//g,'_') + '.xlsx');
    });

    // Realtime Inventory Sync
    const inventoryChannel = new BroadcastChannel('inventory_sync_channel');
    inventoryChannel.onmessage = function(event) {
        console.log("Tab Danh Mục nhận được:", event.data);
        const data = event.data;
        if (!data || !data.maSp) return; // Bỏ qua nếu tin nhắn rác
        
        if (data.type === 'DEDUCT' || data.type === 'ADD_BACK') {
            const rows = document.querySelectorAll('table tbody tr');
            let found = false;
            rows.forEach((row, index) => {
                const rowText = row.innerText;
                if (rowText.includes(data.maSp)) {
                    found = true;
                    console.log(`Tìm thấy mã \${data.maSp} ở dòng thứ \${index + 1}`);
                    const cells = row.querySelectorAll('td');
                    let tdTon = null;
                    
                    // Lặp qua các ô, tìm ô chứa số lượng tồn hiện tại
                    // Dấu hiệu: ô chứa class badge nhưng không chứa rounded-pill, nội dung là số
                    cells.forEach(cell => {
                        const badge = cell.querySelector('.badge');
                        if (badge && !badge.classList.contains('rounded-pill')) {
                            const textVal = badge.innerText.trim();
                            if (/^\d+$/.test(textVal)) {
                                tdTon = cell;
                            }
                        }
                    });
                    
                    if (tdTon) {
                        const badge = tdTon.querySelector('.badge');
                        if (badge) {
                            let currentStock = parseInt(badge.innerText.trim()) || 0;
                            
                            if (data.type === 'DEDUCT') currentStock -= data.qty;
                            if (data.type === 'ADD_BACK') currentStock += data.qty;
                            
                            if (currentStock < 0) currentStock = 0;
                            
                            badge.innerText = currentStock;
                            console.log(`Cập nhật thành công dòng \${index + 1}: \${data.type} \${data.qty} -> Tồn kho mới: \${currentStock}`);
                            
                            // Update classes
                            badge.className = currentStock > 0 ? 'badge bg-info text-dark fw-bold' : 'badge bg-warning text-dark fw-bold';
                            
                            // Animation
                            const flashClass = data.type === 'DEDUCT' ? 'flash-update-deduct' : 'flash-update-add';
                            badge.classList.remove('flash-update-deduct', 'flash-update-add');
                            void badge.offsetWidth; // trigger reflow
                            badge.classList.add(flashClass);
                        }
                    } else {
                        console.warn(`Dòng \${index + 1} có mã \${data.maSp} nhưng không tìm thấy cột Tồn Kho hợp lệ`);
                    }
                }
            });
            if (!found) console.warn("Không tìm thấy dòng nào chứa mã:", data.maSp);
        }
    };
    </script>
</body>
</html>
