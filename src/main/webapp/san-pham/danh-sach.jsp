<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.runmax.service.SanPhamService, com.runmax.service.ThuongHieuService, com.runmax.entity.SanPham, com.runmax.entity.ThuongHieu, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("danhSachSanPham") == null) {
        String kw = request.getParameter("keyword");
        String thIdStr = request.getParameter("thuongHieuId");
        Long thId = null;
        if (thIdStr != null && !thIdStr.trim().isEmpty()) {
            try { thId = Long.parseLong(thIdStr); } catch (Exception ignored) {}
        }
        List<SanPham> dsSp = new SanPhamService().getAll(kw, thId);
        List<ThuongHieu> dsTh = new ThuongHieuService().getAll(null);
        request.setAttribute("danhSachSanPham", dsSp);
        request.setAttribute("danhSachThuongHieu", dsTh);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - RunMax Admin</title>
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="admin-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="activePage" value="san-pham" />
        <jsp:param name="activeSubmenu" value="sp" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="/includes/header.jsp" />

        <div class="page-content" style="padding: 24px 32px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1" style="font-size: 24px;">QUẢN LÝ SẢN PHẨM</h2>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Danh sách sản phẩm giày sneaker trong hệ thống RunMax</p>
                </div>
                <a href="${pageContext.request.contextPath}/san-pham/them-moi.jsp?activePage=san-pham&activeSubmenu=sp" class="btn btn-primary d-flex align-items-center gap-2">
                    <i class="bi bi-plus-lg"></i> Thêm Sản Phẩm
                </a>
            </div>

            <!-- Filter & Search Card -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/san-pham" method="GET" class="row g-3">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                                <input type="text" name="keyword" class="form-control bg-light border-start-0" placeholder="Tìm kiếm theo mã, tên sản phẩm..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="thuongHieuId" class="form-select">
                                <option value="">Tất cả thương hiệu</option>
                                <c:forEach var="th" items="${danhSachThuongHieu}">
                                    <option value="${th.id}" ${param.thuongHieuId == th.id ? 'selected' : ''}>${th.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-dark w-100"><i class="bi bi-filter"></i> Lọc dữ liệu</button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-outline-secondary w-100"><i class="bi bi-arrow-clockwise"></i> Làm mới</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Table Card -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>Mã SP</th>
                                <th>Tên Sản Phẩm</th>
                                <th>Thương Hiệu</th>
                                <th>Chất Liệu</th>
                                <th>Mô Tả</th>
                                <th>Trạng Thái</th>
                                <th class="text-end" style="width: 160px;">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="sp" items="${danhSachSanPham}">
                                <tr>
                                    <td class="fw-bold text-secondary">#${sp.id}</td>
                                    <td><span class="badge bg-light text-dark border">${sp.maSp}</span></td>
                                    <td class="fw-semibold text-dark">${sp.tenSp}</td>
                                    <td>${sp.thuongHieu != null ? sp.thuongHieu.ten : '---'}</td>
                                    <td>${sp.chatLieu != null ? sp.chatLieu.ten : '---'}</td>
                                    <td class="text-secondary small">${sp.moTa != null ? sp.moTa : ''}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sp.trangThai == 1}">
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill">Đang bán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary px-3 py-2 rounded-pill">Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/san-pham/toggle-status" method="POST" class="d-inline">
                                            <input type="hidden" name="id" value="${sp.id}">
                                            <button type="submit" class="btn btn-sm ${sp.trangThai == 1 ? 'btn-outline-warning' : 'btn-outline-success'}" title="Đổi trạng thái">
                                                <i class="bi ${sp.trangThai == 1 ? 'bi-pause-fill' : 'bi-play-fill'}"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/san-pham/delete" method="POST" class="d-inline" onsubmit="event.preventDefault(); var form = this; showBootstrapConfirm('Bạn có chắc chắn muốn xóa sản phẩm này?', function() { form.submit(); });">
                                            <input type="hidden" name="id" value="${sp.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty danhSachSanPham}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-secondary">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                        Chưa có sản phẩm nào trong hệ thống. Hãy nhấn "Thêm Sản Phẩm" để tạo mới!
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>