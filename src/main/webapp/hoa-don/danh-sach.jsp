<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.runmax.service.HoaDonService, com.runmax.entity.HoaDon, java.util.List, java.text.NumberFormat, java.util.Locale, java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("danhSachHoaDon") == null) {
        String kw = request.getParameter("keyword");
        String stStr = request.getParameter("trangThai");
        Integer st = null;
        if (stStr != null && !stStr.trim().isEmpty()) {
            try { st = Integer.parseInt(stStr); } catch (Exception ignored) {}
        }
        List<HoaDon> ds = new HoaDonService().getAll(kw, st);
        request.setAttribute("danhSachHoaDon", ds);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hóa Đơn - RunMax Admin</title>
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="admin-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="activePage" value="hoa-don" />
        <jsp:param name="activeSubmenu" value="" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="/includes/header.jsp" />

        <div class="page-content" style="padding: 24px 32px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1" style="font-size: 24px;">QUẢN LÝ HÓA ĐƠN</h2>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Quản lý toàn bộ hóa đơn và trạng thái thanh toán</p>
                </div>
                <button type="button" class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#modalTaoHoaDon">
                    <i class="bi bi-plus-lg"></i> Tạo Hóa Đơn Mới
                </button>
            </div>

            <!-- Filter Card -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/hoa-don" method="GET" class="row g-3">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                                <input type="text" name="keyword" class="form-control bg-light border-start-0" placeholder="Tìm kiếm mã HĐ, tên khách hàng, số điện thoại..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="trangThai" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="0" ${param.trangThai == '0' ? 'selected' : ''}>Chờ thanh toán</option>
                                <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Đã thanh toán</option>
                                <option value="2" ${param.trangThai == '2' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-dark w-100"><i class="bi bi-funnel"></i> Lọc hóa đơn</button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/admin/hoa-don" class="btn btn-outline-secondary w-100"><i class="bi bi-arrow-clockwise"></i> Làm mới</a>
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
                                <th style="width: 70px;">ID</th>
                                <th>Mã HĐ</th>
                                <th>Khách Hàng</th>
                                <th>Số Điện Thoại</th>
                                <th>Tổng Tiền</th>
                                <th>Ngày Tạo</th>
                                <th>Trạng Thái</th>
                                <th class="text-end" style="width: 170px;">Cập Nhật</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="hd" items="${danhSachHoaDon}">
                                <tr>
                                    <td class="fw-bold text-secondary">#${hd.id}</td>
                                    <td><span class="badge bg-light text-dark border fw-bold">${hd.maHd}</span></td>
                                    <td class="fw-semibold text-dark">${hd.tenKhachHang}</td>
                                    <td class="text-secondary">${hd.sdt != null ? hd.sdt : '---'}</td>
                                    <td class="fw-bold text-primary">
                                        <%= hd.getTongTien() != null ? String.format("%,d VNĐ", hd.getTongTien().longValue()) : "0 VNĐ" %>
                                    </td>
                                    <td class="text-secondary small">
                                        ${hd.ngayTao != null ? hd.ngayTao.toString().replace('T', ' ').substring(0, 16) : ''}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${hd.trangThai == 1}">
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${hd.trangThai == 2}">
                                                <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-pill">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning-emphasis px-3 py-2 rounded-pill">Chờ thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/hoa-don/update-status" method="POST" class="d-inline">
                                            <input type="hidden" name="id" value="${hd.id}">
                                            <input type="hidden" name="trangThai" value="1">
                                            <button type="submit" class="btn btn-sm btn-outline-success me-1" title="Xác nhận đã thanh toán" ${hd.trangThai == 1 ? 'disabled' : ''}>
                                                <i class="bi bi-check-circle-fill"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/hoa-don/update-status" method="POST" class="d-inline me-1">
                                            <input type="hidden" name="id" value="${hd.id}">
                                            <input type="hidden" name="trangThai" value="2">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Hủy hóa đơn" ${hd.trangThai == 2 ? 'disabled' : ''}>
                                                <i class="bi bi-x-circle-fill"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/hoa-don/delete" method="POST" class="d-inline" onsubmit="event.preventDefault(); var form = this; showBootstrapConfirm('Bạn có chắc chắn muốn xóa hóa đơn này?', function() { form.submit(); });">
                                            <input type="hidden" name="id" value="${hd.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-dark" title="Xóa hóa đơn"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty danhSachHoaDon}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-secondary">
                                        <i class="bi bi-receipt fs-2 d-block mb-2"></i>
                                        Chưa có hóa đơn nào được tạo trong hệ thống.
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

<!-- Modal Tạo Hóa Đơn -->
<div class="modal fade" id="modalTaoHoaDon" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/admin/hoa-don/create" method="POST" class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tạo Hóa Đơn Bán Hàng Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên Khách Hàng</label>
                    <input type="text" name="tenKhachHang" class="form-control" placeholder="Khách lẻ">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Số Điện Thoại</label>
                    <input type="text" name="sdt" class="form-control" placeholder="Ví dụ: 0912345678">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tổng Tiền Đơn Hàng (VNĐ) <span class="text-danger">*</span></label>
                    <input type="number" name="tongTien" class="form-control" placeholder="Ví dụ: 2500000" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Ghi chú</label>
                    <textarea name="ghiChu" rows="2" class="form-control" placeholder="Ghi chú thêm..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Tạo Hóa Đơn</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>