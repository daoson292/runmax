<%-- 
  KHỐI SIDEBAR (Thanh điều hướng bên trái toàn trang)
  - Các danh mục chính in cứng trực tiếp trên menu
  - Sản phẩm: Sổ ra Sản phẩm & Biến thể
  - Thuộc tính: Sổ ra Thương hiệu, Chất liệu, Màu sắc, Kích cỡ, Đế giày
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String currentPath = request.getServletPath();
    String loaiParam   = request.getParameter("loai");
    if (loaiParam == null) loaiParam = "thuong-hieu";

    boolean isProductActive = "/san-pham".equals(currentPath) || "/san-pham-chi-tiet".equals(currentPath);
    boolean isThuocTinhActive = "/thuoc-tinh".equals(currentPath);
%>

<style>
    .runmax-sidebar {
        width: 260px;
        background: #ffffff;
        border-right: 1px solid #e2e8f0;
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        z-index: 1040;
        display: flex;
        flex-direction: column;
        box-shadow: 2px 0 12px rgba(0, 0, 0, 0.03);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }
    .runmax-brand {
        height: 70px;
        display: flex;
        align-items: center;
        padding: 0 1.5rem;
        border-bottom: 1px solid #f1f5f9;
        text-decoration: none;
        gap: 0.75rem;
        flex-shrink: 0;
    }
    .runmax-brand-text {
        font-size: 1.35rem;
        font-weight: 800;
        color: #0f172a;
        letter-spacing: -0.03em;
    }
    .runmax-brand-text span { color: #dc2626; }

    .runmax-sidebar-menu {
        padding: 0.85rem 0.6rem;
        flex: 1;
        overflow-y: auto;
        list-style: none;
        margin: 0;
    }

    .runmax-menu-item { margin-bottom: 0.25rem; }

    /* Top-level static links or dropdown headers */
    .runmax-menu-link {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.65rem 0.95rem;
        color: #334155;
        text-decoration: none;
        border-radius: 9px;
        font-weight: 600;
        font-size: 0.92rem;
        transition: all 0.18s ease;
        cursor: pointer;
    }
    .runmax-menu-link-left {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .runmax-menu-link i.main-icon {
        font-size: 1.15rem;
        color: #64748b;
        transition: all 0.18s ease;
        min-width: 22px;
        text-align: center;
    }
    .runmax-menu-link .chevron-icon {
        font-size: 0.8rem;
        color: #94a3b8;
        transition: transform 0.25s ease;
    }
    .runmax-menu-link:hover {
        background-color: #fef2f2;
        color: #dc2626;
    }
    .runmax-menu-link:hover i.main-icon,
    .runmax-menu-link:hover .chevron-icon { color: #dc2626; }

    .runmax-menu-link.active {
        background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
        color: #dc2626;
        font-weight: 700;
        border-left: 3px solid #dc2626;
    }
    .runmax-menu-link.active i.main-icon { color: #dc2626; }

    .runmax-menu-link[aria-expanded="true"] .chevron-icon {
        transform: rotate(180deg);
        color: #dc2626;
    }
    .runmax-menu-link[aria-expanded="true"] {
        color: #dc2626;
    }
    .runmax-menu-link[aria-expanded="true"] i.main-icon {
        color: #dc2626;
    }

    /* Submenu (sổ ra) */
    .runmax-submenu {
        list-style: none;
        padding: 0.2rem 0 0.2rem 2.2rem;
        margin: 0;
    }
    .runmax-submenu-link {
        display: flex;
        align-items: center;
        padding: 0.5rem 0.8rem;
        color: #64748b;
        text-decoration: none;
        border-radius: 7px;
        font-weight: 500;
        font-size: 0.87rem;
        transition: all 0.15s ease;
        gap: 0.5rem;
    }
    .runmax-submenu-link i {
        font-size: 0.95rem;
        color: #94a3b8;
    }
    .runmax-submenu-link:hover {
        color: #dc2626;
        background-color: #fff1f2;
    }
    .runmax-submenu-link:hover i { color: #dc2626; }
    .runmax-submenu-link.sub-active {
        color: #dc2626;
        font-weight: 600;
        background-color: #fef2f2;
    }
    .runmax-submenu-link.sub-active i { color: #dc2626; }

    .rm-divider {
        height: 1px;
        background: #f1f5f9;
        margin: 0.65rem 0;
    }

    .runmax-sidebar-footer {
        padding: 0.85rem 1.25rem;
        border-top: 1px solid #f1f5f9;
        background: #f8fafc;
        flex-shrink: 0;
    }
</style>

<aside class="runmax-sidebar">
    <!-- Brand Logo -->
    <a href="${pageContext.request.contextPath}/trang-chu" class="runmax-brand">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png?v=2" alt="RunMax Logo" style="max-height: 50px; width: auto; object-fit: contain;">
        <div class="runmax-brand-text">RUN<span>MAX</span></div>
    </a>

    <!-- Menu Navigation -->
    <ul class="runmax-sidebar-menu">

        <!-- 1. Trang chủ -->
        <li class="runmax-menu-item">
            <a href="${pageContext.request.contextPath}/trang-chu"
               class="runmax-menu-link <%= "/trang-chu".equals(currentPath) || "/".equals(currentPath) ? "active" : "" %>">
                <div class="runmax-menu-link-left">
                    <i class="bi bi-house-door-fill main-icon"></i>
                    <span>Trang chủ</span>
                </div>
            </a>
        </li>

        <!-- 2. Thống kê (chỉ Admin) -->
        <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
            <% boolean isThongKeActive = "/dashboard".equals(currentPath) || "/thong-ke".equals(currentPath); %>
            <li class="runmax-menu-item">
                <a class="runmax-menu-link <%= isThongKeActive ? "active" : "" %>"
                   data-bs-toggle="collapse" href="#submenuThongKe"
                   role="button" aria-expanded="<%= isThongKeActive ? "true" : "false" %>" aria-controls="submenuThongKe">
                    <div class="runmax-menu-link-left">
                        <i class="bi bi-bar-chart-line-fill main-icon"></i>
                        <span>Thống kê</span>
                    </div>
                    <i class="bi bi-chevron-down chevron-icon"></i>
                </a>
                <div class="collapse <%= isThongKeActive ? "show" : "" %>" id="submenuThongKe">
                    <ul class="runmax-submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/dashboard"
                               class="runmax-submenu-link <%= "/dashboard".equals(currentPath) ? "sub-active" : "" %>">
                                <i class="bi bi-pie-chart-fill"></i> Tổng quan
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/thong-ke"
                               class="runmax-submenu-link <%= "/thong-ke".equals(currentPath) ? "sub-active" : "" %>">
                                <i class="bi bi-funnel-fill"></i> Báo cáo & Bộ lọc
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
        </c:if>


        <!-- 3. Bán Hàng tại quầy -->
        <li class="runmax-menu-item">
            <a href="${pageContext.request.contextPath}/ban-hang"
               class="runmax-menu-link <%= "/ban-hang".equals(currentPath) ? "active" : "" %>">
                <div class="runmax-menu-link-left">
                    <i class="bi bi-cart-check-fill main-icon"></i>
                    <span>Bán Hàng tại quầy</span>
                </div>
            </a>
        </li>

        <li class="rm-divider"></li>

        <!-- 4. Hóa đơn -->
        <li class="runmax-menu-item">
            <a href="${pageContext.request.contextPath}/hoa-don"
               class="runmax-menu-link <%= "/hoa-don".equals(currentPath) ? "active" : "" %>">
                <div class="runmax-menu-link-left">
                    <i class="bi bi-receipt-cutoff main-icon"></i>
                    <span>Hóa đơn</span>
                </div>
            </a>
        </li>

        <li class="rm-divider"></li>

        <!-- 5. SẢN PHẨM (Sổ ra: Sản phẩm & Biến thể) -->
        <li class="runmax-menu-item">
            <a class="runmax-menu-link <%= isProductActive ? "active" : "" %>"
               data-bs-toggle="collapse" href="#submenuSanPham"
               role="button" aria-expanded="<%= isProductActive ? "true" : "false" %>" aria-controls="submenuSanPham">
                <div class="runmax-menu-link-left">
                    <i class="bi bi-box-seam-fill main-icon"></i>
                    <span>Sản phẩm</span>
                </div>
                <i class="bi bi-chevron-down chevron-icon"></i>
            </a>
            <div class="collapse <%= isProductActive ? "show" : "" %>" id="submenuSanPham">
                <ul class="runmax-submenu">
                    <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/san-pham"
                               class="runmax-submenu-link <%= "/san-pham".equals(currentPath) ? "sub-active" : "" %>">
                                <i class="bi bi-box"></i> Danh sách Sản phẩm
                            </a>
                        </li>
                    </c:if>
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet"
                           class="runmax-submenu-link <%= "/san-pham-chi-tiet".equals(currentPath) ? "sub-active" : "" %>">
                            <i class="bi bi-upc-scan"></i> Biến thể (SKU)
                        </a>
                    </li>
                </ul>
            </div>
        </li>

        <!-- 5. THUỘC TÍNH (Sổ ra: Thương hiệu, Chất liệu, Màu sắc, Kích cỡ, Đế giày) -->
        <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
            <li class="runmax-menu-item">
                <a class="runmax-menu-link <%= isThuocTinhActive ? "active" : "" %>"
                   data-bs-toggle="collapse" href="#submenuThuocTinh"
                   role="button" aria-expanded="<%= isThuocTinhActive ? "true" : "false" %>" aria-controls="submenuThuocTinh">
                    <div class="runmax-menu-link-left">
                        <i class="bi bi-tags-fill main-icon"></i>
                        <span>Thuộc tính</span>
                    </div>
                    <i class="bi bi-chevron-down chevron-icon"></i>
                </a>
                <div class="collapse <%= isThuocTinhActive ? "show" : "" %>" id="submenuThuocTinh">
                    <ul class="runmax-submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=thuong-hieu"
                               class="runmax-submenu-link <%= (isThuocTinhActive && "thuong-hieu".equals(loaiParam)) ? "sub-active" : "" %>">
                                <i class="bi bi-award"></i> Thương hiệu
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=chat-lieu"
                               class="runmax-submenu-link <%= (isThuocTinhActive && "chat-lieu".equals(loaiParam)) ? "sub-active" : "" %>">
                                <i class="bi bi-grid-3x3-gap"></i> Chất liệu
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=mau-sac"
                               class="runmax-submenu-link <%= (isThuocTinhActive && "mau-sac".equals(loaiParam)) ? "sub-active" : "" %>">
                                <i class="bi bi-palette"></i> Màu sắc
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=kich-co"
                               class="runmax-submenu-link <%= (isThuocTinhActive && "kich-co".equals(loaiParam)) ? "sub-active" : "" %>">
                                <i class="bi bi-rulers"></i> Kích cỡ (Size)
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/thuoc-tinh?loai=de-giay"
                               class="runmax-submenu-link <%= (isThuocTinhActive && "de-giay".equals(loaiParam)) ? "sub-active" : "" %>">
                                <i class="bi bi-shoe-prints"></i> Đế giày
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
        </c:if>

        <li class="rm-divider"></li>

        <!-- 6. Phiếu giảm giá -->
        <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
            <li class="runmax-menu-item">
                <a href="${pageContext.request.contextPath}/phieu-giam-gia"
                   class="runmax-menu-link <%= "/phieu-giam-gia".equals(currentPath) ? "active" : "" %>">
                    <div class="runmax-menu-link-left">
                        <i class="bi bi-ticket-perforated-fill main-icon"></i>
                        <span>Phiếu giảm giá</span>
                    </div>
                </a>
            </li>
        </c:if>

        <li class="rm-divider"></li>

        <!-- 7. Khách hàng -->
        <li class="runmax-menu-item">
            <a href="${pageContext.request.contextPath}/khach-hang"
               class="runmax-menu-link <%= "/khach-hang".equals(currentPath) ? "active" : "" %>">
                <div class="runmax-menu-link-left">
                    <i class="bi bi-people-fill main-icon"></i>
                    <span>Khách hàng</span>
                </div>
            </a>
        </li>

        <!-- 8. Nhân viên -->
        <c:if test="${sessionScope.vaiTro == 'ROLE_ADMIN' || sessionScope.vaiTro == 'ADMIN'}">
            <li class="runmax-menu-item">
                <a href="${pageContext.request.contextPath}/nhan-vien"
                   class="runmax-menu-link <%= "/nhan-vien".equals(currentPath) ? "active" : "" %>">
                    <div class="runmax-menu-link-left">
                        <i class="bi bi-person-badge-fill main-icon"></i>
                        <span>Nhân viên</span>
                    </div>
                </a>
            </li>
        </c:if>

    </ul>

    <!-- Footer Sidebar info -->
    <div class="runmax-sidebar-footer">
        <div class="d-flex align-items-center justify-content-between">
            <span class="text-muted" style="font-size: 0.75rem;">Phiên bản</span>
            <span class="badge bg-danger">v2.5 Pro</span>
        </div>
    </div>
</aside>

<!-- Quản lý lưu và phục hồi trạng thái mở/đóng menu Sidebar bằng localStorage (Không bị thu lại khi chuyển trang) -->
<script>
(function() {
    // 1. Phục hồi ngay lập tức menu nào đang được mở trước đó trong localStorage trước khi trình duyệt hiển thị
    var expandedMenus = [];
    try {
        var saved = localStorage.getItem('runmax_sidebar_expanded_menus');
        if (saved) {
            expandedMenus = JSON.parse(saved);
        }
    } catch(e) {}

    // Kết hợp với menu đang active theo URL từ server (nếu có)
    var activeSubmenu = document.querySelector('.runmax-sidebar .collapse.show');
    if (activeSubmenu && activeSubmenu.id && expandedMenus.indexOf(activeSubmenu.id) === -1) {
        expandedMenus.push(activeSubmenu.id);
    }

    // Áp dụng class 'show' và thuộc tính 'aria-expanded=true' cho các menu đã lưu
    expandedMenus.forEach(function(id) {
        var submenu = document.getElementById(id);
        if (submenu && !submenu.classList.contains('show')) {
            submenu.classList.add('show');
            var toggleLink = document.querySelector('.runmax-sidebar .runmax-menu-link[href="#' + id + '"]');
            if (toggleLink) {
                toggleLink.setAttribute('aria-expanded', 'true');
            }
        }
    });

    // 2. Lắng nghe thao tác bấm đóng/mở menu của người dùng để lưu vào localStorage
    function initSidebarCollapseTracking() {
        var collapseLinks = document.querySelectorAll('.runmax-sidebar .runmax-menu-link[data-bs-toggle="collapse"]');
        collapseLinks.forEach(function(link) {
            if (!link._hasCollapseListener) {
                link._hasCollapseListener = true;
                link.addEventListener('click', function() {
                    setTimeout(function() {
                        var openList = [];
                        document.querySelectorAll('.runmax-sidebar .collapse.show').forEach(function(el) {
                            if (el.id) openList.push(el.id);
                        });
                        try {
                            localStorage.setItem('runmax_sidebar_expanded_menus', JSON.stringify(openList));
                        } catch(e) {}
                    }, 250); // Chờ hiệu ứng chuyển động collapse của Bootstrap hoàn tất
                });
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSidebarCollapseTracking);
    } else {
        initSidebarCollapseTracking();
    }
})();
</script>