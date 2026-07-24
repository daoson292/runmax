<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.runmax.service.ThuongHieuService, com.runmax.service.ChatLieuService, com.runmax.entity.ThuongHieu, com.runmax.entity.ChatLieu, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    List<ThuongHieu> dsThuongHieu = new ThuongHieuService().getAll(null);
    List<ChatLieu> dsChatLieu = new ChatLieuService().getAll(null);
    request.setAttribute("dsThuongHieu", dsThuongHieu);
    request.setAttribute("dsChatLieu", dsChatLieu);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Sản Phẩm - RunMax Admin</title>
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
                    <h2 class="fw-bold text-dark mb-1" style="font-size: 24px;">THÊM SẢN PHẨM MỚI</h2>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Tạo mới sản phẩm giày sneaker và liên kết thuộc tính</p>
                </div>
                <a href="${pageContext.request.contextPath}/san-pham/danh-sach.jsp?activePage=san-pham&activeSubmenu=sp" class="btn btn-outline-secondary d-flex align-items-center gap-2">
                    <i class="bi bi-arrow-left"></i> Quay lại Danh sách
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-5">
                    <form action="${pageContext.request.contextPath}/admin/san-pham/store" method="POST">
                        <div class="row g-4">
                            <!-- Left Column -->
                            <div class="col-lg-6">
                                <h5 class="fw-bold mb-3 border-bottom pb-2">1. Thông tin cơ bản</h5>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Mã Sản Phẩm (Tự động sinh)</label>
                                    <input type="text" name="maSp" class="form-control bg-light text-secondary fw-semibold" placeholder="Tự động sinh khi lưu" readonly tabindex="-1">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Tên Sản Phẩm <span class="text-danger">*</span></label>
                                    <input type="text" name="tenSp" class="form-control" placeholder="Ví dụ: Nike Air Zoom Pegasus 40..." required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Mô tả sản phẩm</label>
                                    <textarea name="moTa" rows="4" class="form-control" placeholder="Mô tả chi tiết về sản phẩm giày..."></textarea>
                                </div>
                            </div>

                            <!-- Right Column -->
                            <div class="col-lg-6">
                                <h5 class="fw-bold mb-3 border-bottom pb-2">2. Thuộc tính & Phân loại</h5>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Thương Hiệu <span class="text-danger">*</span></label>
                                    <select name="thuongHieuId" class="form-select" required>
                                        <option value="">-- Chọn Thương Hiệu --</option>
                                        <c:forEach var="th" items="${dsThuongHieu}">
                                            <option value="${th.id}">${th.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Chất Liệu <span class="text-danger">*</span></label>
                                    <select name="chatLieuId" class="form-select" required>
                                        <option value="">-- Chọn Chất Liệu --</option>
                                        <c:forEach var="cl" items="${dsChatLieu}">
                                            <option value="${cl.id}">${cl.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="alert alert-info border-0 bg-info-subtle text-info-emphasis mt-4 rounded-3">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Sau khi lưu sản phẩm, bạn có thể thêm các phiên bản kích cỡ và màu sắc trong phần quản lý chi tiết sản phẩm.
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-3 mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/san-pham/danh-sach.jsp" class="btn btn-light px-4">Hủy</a>
                            <button type="submit" class="btn btn-primary px-5 fw-semibold"><i class="bi bi-check-lg me-1"></i> Lưu Sản Phẩm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>