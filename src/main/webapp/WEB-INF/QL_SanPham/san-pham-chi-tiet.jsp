<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Quản lý Sản Phẩm Chi Tiết RunMax" scope="request" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${pageTitle}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            </head>

            <body>
                <div class="runmax-wrapper">
                    <jsp:include page="/includes/sidebar.jsp" />

                    <main class="runmax-main">
                        <jsp:include page="/includes/header.jsp" />

                        <div class="runmax-content">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h4 class="fw-bold text-dark mb-1">Quản Lý Sản Phẩm Chi Tiết</h4>
                                    <p class="text-muted small mb-0">Quản lý chi tiết từng phiên bản giày chạy bộ nam
                                        theo Size (39-44), Màu sắc, Đế & Tồn kho.</p>
                            </div>

                            <!-- Bảng danh sách giày chạy bộ -->
                            <div class="runmax-card p-0">
                                <div class="table-responsive">
                                    <table class="table table-runmax align-middle">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Dòng Giày Chạy Bộ</th>
                                                <th>Size Nam</th>
                                                <th>Màu Sắc</th>
                                                <th>Công Nghệ Đế</th>
                                                <th>Giá Gốc</th>
                                                <th>Giá Bán</th>
                                                <th>Tồn Kho</th>
                                                <th>Trạng Thái</th>
                                                <th class="text-end">Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sku" items="${danhSachSPCT}">
                                                <tr>
                                                    <td class="fw-bold">#SP${sku.id}</td>
                                                    <td class="fw-bold text-dark">${sku.sanPham.tenSp}</td>
                                                    <td><span
                                                            class="badge bg-dark px-3 py-2 fs-6">${sku.kichCo.ten}</span>
                                                    </td>
                                                    <td><span class="badge bg-secondary">${sku.mauSac.ten}</span></td>
                                                    <td><span class="small text-muted">${sku.deGiay.ten}</span></td>
                                                    <td>
                                                        <fmt:formatNumber value="${sku.giaGoc}" type="number" /> đ
                                                    </td>
                                                    <td class="fw-bold text-danger">
                                                        <fmt:formatNumber value="${sku.giaBan}" type="number" /> đ
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${sku.soLuongTon > 10 ? 'bg-success' : 'bg-warning text-dark'}">
                                                            ${sku.soLuongTon} đôi
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${sku.trangThai == 1}">
                                                                <span
                                                                    class="badge bg-success bg-opacity-10 text-success">Đang
                                                                    kinh doanh</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-danger bg-opacity-10 text-danger">Ngừng
                                                                    bán</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet?action=toggleStatus&id=${sku.id}"
                                                            class="btn btn-sm ${sku.trangThai == 1 ? 'btn-outline-danger' : 'btn-outline-success'}">
                                                            <i class="bi bi-arrow-repeat"></i>
                                                        </a>
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
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>