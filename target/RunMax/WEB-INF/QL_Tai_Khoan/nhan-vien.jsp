<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý Nhân viên" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhân viên – RunMax</title>
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
        .nv-table-head th {
            background: #1e2a3a; color: #e2e8f0; font-weight: 600; font-size: 0.82rem;
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0.9rem 1rem; border: none;
        }
        .nv-table tbody td { padding: 0.8rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        .nv-table tbody tr:hover { background-color: #fef2f2; }
        .nv-table tbody tr:last-child td { border-bottom: none; }

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

        /* Status badge */
        .badge-active   { background: #d1fae5; color: #065f46; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-inactive { background: #f1f5f9; color: #64748b; padding: 0.28rem 0.65rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }

        /* Trạng thái radio pill */
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
                        <i class="bi bi-person-badge-fill text-danger me-2"></i>Quản lý nhân viên
                    </h4>
                    <p class="text-muted small mb-0">Quản lý thông tin và phân quyền nhân viên trong hệ thống.</p>
                </div>

                <%-- Alert hiển thị mật khẩu tạm khi nhân viên chưa có email --%>
                <c:if test="${not empty sessionScope.tempPasswordAlert}">
                    <div class="alert alert-warning alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-key-fill me-2 fs-5 text-warning"></i>
                        <strong>Mật khẩu tạm – Vui lòng bàn giao trực tiếp:</strong><br>
                        ${sessionScope.tempPasswordAlert}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="tempPasswordAlert" scope="session"/>
                </c:if>

                <!-- Bộ lọc -->
                <div class="filter-card">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterNV">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterNV">
                        <form action="${pageContext.request.contextPath}/nhan-vien" method="get" class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-5">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo mã NV, tên, email, SĐT..." value="${keyword}">
                                </div>
                                <div class="col-md-3">
                                    <label>Chức vụ</label>
                                    <select name="vaiTroId" class="form-select">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="vt" items="${vaiTros}">
                                            <option value="${vt.id}" ${vaiTroId == vt.id ? 'selected' : ''}>${vt.tenVaiTro}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="d-block">Trạng thái</label>
                                    <div class="status-radio">
                                        <input type="radio" name="trangThai" id="ttAll" value="" ${trangThai == null ? 'checked' : ''}>
                                        <label for="ttAll">Tất cả</label>
                                        <input type="radio" name="trangThai" id="ttActive" value="1" ${trangThai == 1 ? 'checked' : ''}>
                                        <label for="ttActive">Đang làm</label>
                                        <input type="radio" name="trangThai" id="ttInactive" value="0" ${trangThai == 0 ? 'checked' : ''}>
                                        <label for="ttInactive">Đã nghỉ</label>
                                    </div>
                                </div>
                                <div class="col-md-2 d-flex gap-2 align-items-end">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/nhan-vien" class="btn btn-outline-secondary shadow-sm" title="Làm mới">
                                        <i class="bi bi-arrow-counterclockwise"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Nút hành động giữa bộ lọc và danh sách -->
                <div class="d-flex justify-content-end gap-2 mb-3">
                    <button class="btn btn-outline-success btn-sm fw-semibold shadow-sm" id="btnExcelNV">
                        <i class="bi bi-file-earmark-excel-fill me-1"></i>Xuất Excel
                    </button>
                    <a href="${pageContext.request.contextPath}/nhan-vien?action=add" class="btn btn-runmax btn-sm fw-semibold shadow-sm">
                        <i class="bi bi-person-plus-fill me-1"></i>Thêm nhân viên
                    </a>
                </div>

                <!-- Bảng danh sách -->
                <div class="runmax-card p-0">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <div class="fw-bold text-dark">
                            <i class="bi bi-table me-1 text-danger"></i>Danh sách nhân viên
                            <span class="badge bg-secondary ms-1">${fn:length(nhanViens)}</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table id="tableNhanVien" class="table nv-table mb-0">
                            <thead>
                                <tr class="nv-table-head">
                                    <th>#</th>
                                    <th>Ảnh</th>
                                    <th>Mã NV</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>SĐT</th>
                                    <th>Địa chỉ</th>
                                    <th>Chức vụ</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty nhanViens}">
                                        <c:forEach var="nv" items="${nhanViens}" varStatus="loop">
                                            <tr>
                                                <td class="text-muted fw-semibold">${loop.index + 1}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty nv.anhDaiDien}">
                                                            <c:set var="nvImgUrl" value="${fn:startsWith(nv.anhDaiDien, 'http') || fn:startsWith(nv.anhDaiDien, '/') ? nv.anhDaiDien : pageContext.request.contextPath.concat('/').concat(nv.anhDaiDien)}" />
                                                            <img src="${nvImgUrl}"
                                                                 class="rounded-circle" width="36" height="36" style="object-fit:cover;"
                                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <div class="avatar-initials"
                                                                 style="display:none; background: hsl(${(nv.id * 47) % 360}, 65%, 50%);">
                                                                ${nv.hoTen.length() >= 2 ? nv.hoTen.substring(0,1).toUpperCase().concat(nv.hoTen.substring(nv.hoTen.lastIndexOf(' ') > 0 ? nv.hoTen.lastIndexOf(' ') + 1 : 1, nv.hoTen.lastIndexOf(' ') > 0 ? nv.hoTen.lastIndexOf(' ') + 2 : 2).toUpperCase()) : nv.hoTen.substring(0,1).toUpperCase()}
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="avatar-initials"
                                                                 style="background: hsl(${(nv.id * 47) % 360}, 65%, 50%);">
                                                                ${nv.hoTen.length() >= 2 ? nv.hoTen.substring(0,1).toUpperCase().concat(nv.hoTen.substring(nv.hoTen.lastIndexOf(' ') > 0 ? nv.hoTen.lastIndexOf(' ') + 1 : 1, nv.hoTen.lastIndexOf(' ') > 0 ? nv.hoTen.lastIndexOf(' ') + 2 : 2).toUpperCase()) : nv.hoTen.substring(0,1).toUpperCase()}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold text-danger">${nv.maNv}</td>
                                                <td><div class="fw-semibold text-dark">${nv.hoTen}</div></td>
                                                <td class="text-muted small">${nv.email != null ? nv.email : '—'}</td>
                                                <td>${nv.sdt != null ? nv.sdt : '—'}</td>
                                                <td class="text-muted small" style="max-width:220px; white-space:normal; word-break:break-word;">
                                                    ${nv.diaChiDayDu != null ? nv.diaChiDayDu : '—'}
                                                </td>
                                                <td><span class="badge bg-secondary-subtle text-secondary border fw-medium">${nv.vaiTro != null ? nv.vaiTro.tenVaiTro : '—'}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${nv.trangThai == 1}">
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                                <i class="bi bi-circle-fill me-1" style="font-size:0.5rem;"></i>Đang làm
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                                                                <i class="bi bi-circle-fill me-1" style="font-size:0.5rem;"></i>Đã nghỉ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center align-items-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/nhan-vien?action=edit&id=${nv.id}"
                                                           class="btn btn-sm btn-light border text-primary" title="Chỉnh sửa">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/nhan-vien" method="post" class="d-inline m-0" id="formToggle_${nv.id}">
                                                            <input type="hidden" name="action" value="toggle">
                                                            <input type="hidden" name="id" value="${nv.id}">
                                                            <label class="toggle-switch mb-0" title="${nv.trangThai == 1 ? 'Đang làm (Nhấn để chuyển sang Đã nghỉ / Xóa mềm)' : 'Đã nghỉ (Nhấn để kích hoạt lại)'}">
                                                                <input type="checkbox" ${nv.trangThai == 1 ? 'checked' : ''}
                                                                       onchange="var chk = this; chk.checked = !chk.checked; showBootstrapConfirm('Bạn có chắc muốn ${nv.trangThai == 1 ? 'chuyển sang Đã nghỉ (xóa mềm)' : 'kích hoạt lại'} tài khoản nhân viên ${nv.hoTen}?', function() { chk.checked = !chk.checked; document.getElementById('formToggle_${nv.id}').submit(); });">
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
                                            <td colspan="10" class="text-center py-4 text-muted">
                                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>Không tìm thấy nhân viên nào
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
                            Hiển thị <strong>${fn:length(nhanViens)}</strong> / tổng <strong>${totalRecords != null ? totalRecords : fn:length(nhanViens)}</strong> bản ghi
                        </small>
                        <div class="d-flex align-items-center gap-2">
                            <c:set var="filterParams" value=""/>
                            <c:if test="${not empty param.keyword}">
                                <c:set var="filterParams" value="${filterParams}&keyword=${param.keyword}"/>
                            </c:if>
                            <c:if test="${not empty param.vaiTroId}">
                                <c:set var="filterParams" value="${filterParams}&vaiTroId=${param.vaiTroId}"/>
                            </c:if>
                            <c:if test="${not empty param.trangThai}">
                                <c:set var="filterParams" value="${filterParams}&trangThai=${param.trangThai}"/>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/nhan-vien?page=${currentPage - 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
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
                                            <a href="${pageContext.request.contextPath}/nhan-vien?page=${i}${filterParams}" class="btn btn-sm btn-outline-secondary">${i}</a>
                                        </c:if>
                                        <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                            <span class="btn btn-sm btn-outline-secondary border-0" disabled>...</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/nhan-vien?page=${currentPage + 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
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
    <!-- SheetJS for Excel export -->
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script>
    document.getElementById('btnExcelNV').addEventListener('click', function () {
        const table = document.getElementById('tableNhanVien');
        if (!table) return;
        const wb = XLSX.utils.table_to_book(table, { sheet: 'Danh sách NV' });
        XLSX.writeFile(wb, 'NhanVien_RunMax_' + new Date().toLocaleDateString('vi-VN').replace(/\//g, '-') + '.xlsx');
    });
    </script>
</body>
</html>
