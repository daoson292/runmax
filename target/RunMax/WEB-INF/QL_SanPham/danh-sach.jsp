<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý Danh sách Sản phẩm" scope="request" />
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
                <!-- Thanh tìm kiếm & Bộ lọc -->
                <div class="runmax-card mb-4">
                    <form action="${pageContext.request.contextPath}/san-pham" method="get" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-secondary">Từ khóa</label>
                            <input type="text" name="keyword" class="form-control" placeholder="Tên hoặc mã sản phẩm..." value="${keyword}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-semibold small text-secondary">Thương hiệu</label>
                            <select name="thuongHieuId" class="form-select">
                                <option value="">-- Tất cả --</option>
                                <c:forEach var="th" items="${thuongHieus}">
                                    <option value="${th.id}" ${thuongHieuId == th.id ? 'selected' : ''}>${th.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-semibold small text-secondary">Chất liệu</label>
                            <select name="chatLieuId" class="form-select">
                                <option value="">-- Tất cả --</option>
                                <c:forEach var="cl" items="${chatLieus}">
                                    <option value="${cl.id}" ${chatLieuId == cl.id ? 'selected' : ''}>${cl.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-semibold small text-secondary">Trạng thái</label>
                            <select name="trangThai" class="form-select">
                                <option value="">-- Tất cả --</option>
                                <option value="1" ${trangThai == 1 ? 'selected' : ''}>Đang kinh doanh</option>
                                <option value="0" ${trangThai == 0 ? 'selected' : ''}>Ngừng kinh doanh</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-runmax flex-grow-1">
                                <i class="bi bi-search me-1"></i> Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/san-pham?action=add" class="btn btn-danger fw-semibold">
                                <i class="bi bi-plus-lg"></i> Thêm mới
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Bảng sản phẩm -->
                <div class="runmax-card">
                    <div class="table-responsive">
                        <table class="table-runmax">
                            <thead>
                                <tr>
                                    <th>Mã SP</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Thương hiệu</th>
                                    <th>Chất liệu</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty sanPhams}">
                                        <c:forEach var="sp" items="${sanPhams}">
                                            <tr>
                                                <td class="fw-bold text-danger">${sp.maSp}</td>
                                                <td class="fw-semibold">${sp.tenSp}</td>
                                                <td><span class="badge bg-light text-dark border">${sp.thuongHieu.ten}</span></td>
                                                <td>${sp.chatLieu.ten}</td>
                                                <td class="text-muted small">${sp.moTa}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sp.trangThai == 1}">
                                                            <span class="badge-status-active">Đang kinh doanh</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status-inactive">Ngừng kinh doanh</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/san-pham?action=edit&id=${sp.id}" class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/san-pham" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="id" value="${sp.id}">
                                                        <button type="submit" class="btn btn-sm ${sp.trangThai == 1 ? 'btn-outline-danger' : 'btn-outline-success'}" title="Đổi trạng thái">
                                                            <i class="bi ${sp.trangThai == 1 ? 'bi-lock-fill' : 'bi-unlock-fill'}"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-4 text-muted">Không tìm thấy sản phẩm nào phù hợp</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
