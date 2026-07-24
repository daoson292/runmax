<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.runmax.service.ChatLieuService, com.runmax.entity.ChatLieu, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("danhSachChatLieu") == null) {
        String kw = request.getParameter("keyword");
        List<ChatLieu> ds = new ChatLieuService().getAll(kw);
        request.setAttribute("danhSachChatLieu", ds);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Chất Liệu - RunMax Admin</title>
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
        <jsp:param name="activeSubmenu" value="cl" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="/includes/header.jsp" />

        <div class="page-content" style="padding: 24px 32px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1" style="font-size: 24px;">DANH SÁCH CHẤT LIỆU</h2>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Quản lý danh mục chất liệu sản xuất giày RunMax</p>
                </div>
                <button type="button" class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#modalThemChatLieu">
                    <i class="bi bi-plus-lg"></i> Thêm Chất Liệu
                </button>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/chat-lieu" method="GET" class="row g-3 mb-4">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                                <input type="text" name="keyword" class="form-control bg-light border-start-0" placeholder="Tìm kiếm theo tên chất liệu..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-dark w-100">Tìm kiếm</button>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">ID</th>
                                <th>Tên Chất Liệu</th>
                                <th>Trạng Thái</th>
                                <th class="text-end" style="width: 180px;">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="cl" items="${danhSachChatLieu}">
                                <tr>
                                    <td class="fw-bold text-secondary">#${cl.id}</td>
                                    <td class="fw-semibold text-dark">${cl.ten}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cl.trangThai == 1}">
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary px-3 py-2 rounded-pill">Ngừng hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1"
                                                onclick="openEditModal(${cl.id}, '${cl.ten}', ${cl.trangThai})">
                                            <i class="bi bi-pencil"></i> Sửa
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/chat-lieu/toggle-status" method="POST" class="d-inline">
                                            <input type="hidden" name="id" value="${cl.id}">
                                            <button type="submit" class="btn btn-sm ${cl.trangThai == 1 ? 'btn-outline-danger' : 'btn-outline-success'}">
                                                <i class="bi ${cl.trangThai == 1 ? 'bi-lock' : 'bi-unlock'}"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty danhSachChatLieu}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-secondary">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                        Chưa có chất liệu nào được tạo.
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

<!-- Modal Thêm Chất Liệu -->
<div class="modal fade" id="modalThemChatLieu" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/admin/chat-lieu/store" method="POST" class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Thêm Chất Liệu Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên chất liệu <span class="text-danger">*</span></label>
                    <input type="text" name="ten" class="form-control" placeholder="Ví dụ: Da thật, Vải lưới, Cao su..." required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu Chất Liệu</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa Chất Liệu -->
<div class="modal fade" id="modalSuaChatLieu" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/admin/chat-lieu/update" method="POST" class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Cập Nhật Chất Liệu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="id" id="editId">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên chất liệu <span class="text-danger">*</span></label>
                    <input type="text" name="ten" id="editTen" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Trạng thái</label>
                    <select name="trangThai" id="editTrangThai" class="form-select">
                        <option value="1">Hoạt động</option>
                        <option value="0">Ngừng hoạt động</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu Cập Nhật</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEditModal(id, ten, trangThai) {
        document.getElementById('editId').value = id;
        document.getElementById('editTen').value = ten;
        document.getElementById('editTrangThai').value = trangThai;
        new bootstrap.Modal(document.getElementById('modalSuaChatLieu')).show();
    }
</script>
</body>
</html>