<%-- 
  KHỐI HEADER (Thanh trên cùng & Hệ thống Thông báo toàn cục)
  - Keyword search GG: "Bootstrap 5 Toast Alert Notification", "JSTL sessionScope EL Expression"
  - Nhiệm vụ: Hiển thị Tiêu đề trang, Tên Nhân viên đang đăng nhập (${sessionScope.nhanVien.hoTen}).
  - Logic quan trọng: Tự động bắt biến requestScope/sessionScope (msgSuccess, msgError) để hiển thị hộp thoại Toast thông báo thành công hoặc lỗi (ví dụ lỗi login sai mật khẩu, thêm giày thành công).
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- CORE RUNMAX GLOBAL LAYOUT DESIGN SYSTEM -->
<style>
    :root {
        --runmax-primary: #dc2626;
        --runmax-primary-dark: #b91c1c;
        --runmax-primary-light: #fef2f2;
        --runmax-bg: #f8fafc;
        --runmax-sidebar-width: 260px;
    }
    * {
        box-sizing: border-box;
    }
    body {
        background-color: var(--runmax-bg);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        color: #0f172a;
        margin: 0;
        padding: 0;
    }
    .runmax-wrapper {
        display: flex;
        min-height: 100vh;
    }
    .runmax-main {
        flex: 1;
        margin-left: var(--runmax-sidebar-width);
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background-color: var(--runmax-bg);
    }
    .runmax-content {
        padding: 2rem;
        flex: 1;
    }
    .runmax-header {
        height: 70px;
        background: #ffffff;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 2rem;
        position: sticky;
        top: 0;
        z-index: 1020;
        box-shadow: 0 1px 3px rgba(0,0,0,0.03);
    }
    .runmax-header-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: #0f172a;
        margin: 0;
        letter-spacing: -0.01em;
    }
    .btn-runmax {
        background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
        color: #ffffff;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        padding: 0.55rem 1.25rem;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }
    .btn-runmax:hover {
        background: #b91c1c;
        color: #ffffff;
        box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
        transform: translateY(-1px);
    }
    .runmax-card {
        background: #ffffff;
        border-radius: 14px;
        border: 1px solid #e2e8f0;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
        overflow: hidden;
    }
    .table-runmax {
        width: 100%;
        margin-bottom: 0;
    }
    .table-runmax thead th {
        background: #f8fafc;
        color: #475569;
        font-weight: 600;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        border-bottom: 2px solid #e2e8f0;
        padding: 1rem 1.25rem;
    }
    .table-runmax tbody td {
        padding: 1rem 1.25rem;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
        font-size: 0.925rem;
    }
    .table-runmax tbody tr:hover {
        background-color: #fef2f2;
    }
</style>

<header class="runmax-header">
    <div class="d-flex align-items-center gap-3">
        <h1 class="runmax-header-title">${not empty pageTitle ? pageTitle : 'RunMax Management System'}</h1>
    </div>

    <div class="runmax-user-profile">
        <c:choose>
            <c:when test="${not empty sessionScope.nhanVien}">
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <c:choose>
                            <c:when test="${not empty sessionScope.nhanVien.anhDaiDien}">
                                <c:set var="headerAvtUrl" value="${fn:startsWith(sessionScope.nhanVien.anhDaiDien, 'http') || fn:startsWith(sessionScope.nhanVien.anhDaiDien, '/') ? sessionScope.nhanVien.anhDaiDien : pageContext.request.contextPath.concat('/').concat(sessionScope.nhanVien.anhDaiDien)}" />
                                <img src="${headerAvtUrl}" class="rounded-circle shadow-sm"
                                     style="width:38px; height:38px; object-fit:cover;"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="rounded-circle bg-danger text-white align-items-center justify-content-center fw-bold shadow-sm"
                                     style="width:38px; height:38px; font-size: 1rem; display:none;">
                                    ${sessionScope.nhanVien.hoTen.substring(0, 1).toUpperCase()}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="rounded-circle bg-danger text-white d-flex align-items-center justify-content-center fw-bold shadow-sm"
                                     style="width:38px; height:38px; font-size: 1rem;">
                                    ${sessionScope.nhanVien.hoTen.substring(0, 1).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="d-none d-md-block text-end">
                            <div class="fw-bold text-dark" style="font-size: 0.9rem; line-height: 1.2;">${sessionScope.nhanVien.hoTen}</div>
                            <div class="text-muted" style="font-size: 0.75rem;">Vai trò: <span class="badge bg-danger">${sessionScope.nhanVien.vaiTro.tenVaiTro}</span></div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger d-flex align-items-center gap-1 rounded-pill px-3">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-danger rounded-pill px-4">Đăng nhập</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
window.decodeHtmlEntities = function(str) {
    if (!str) return '';
    var txt = document.createElement("textarea");
    txt.innerHTML = str;
    return txt.value;
};

// Global function to display beautiful SweetAlert2 Toast at top-right
window.showToast = function(message, type = 'info', title = null) {
    if (!message) return;
    message = window.decodeHtmlEntities(message);
    
    // Type mapping for SweetAlert2
    var swalType = type === 'danger' ? 'error' : type;
    if (!['success', 'error', 'warning', 'info', 'question'].includes(swalType)) {
        swalType = 'info';
    }

    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 4500,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer)
            toast.addEventListener('mouseleave', Swal.resumeTimer)
        }
    });

    Toast.fire({
        icon: swalType,
        title: title ? title : '',
        text: message
    });
};

// Global utility showBootstrapAlert calls showToast directly
window.showBootstrapAlert = function(message, type = 'danger') {
    showToast(message, type);
};

// Global utility for centered popup -> SweetAlert2
window.showBootstrapPopup = function(message, type = 'danger', title = null) {
    if (!message) return;
    message = window.decodeHtmlEntities(message);
    
    var swalType = type === 'danger' ? 'error' : type;
    if (!['success', 'error', 'warning', 'info', 'question'].includes(swalType)) {
        swalType = 'info';
    }

    Swal.fire({
        icon: swalType,
        title: title ? title : (type === 'success' ? 'Thành công' : type === 'danger' ? 'Thông báo lỗi' : 'Thông báo'),
        html: message,
        confirmButtonColor: '#dc2626', // RunMax Primary Red
        confirmButtonText: 'Đóng'
    });
};

// Global utility to show Confirm dynamically -> SweetAlert2
window.showBootstrapConfirm = function(message, onConfirmCallback, onCancelCallback) {
    message = window.decodeHtmlEntities(message);
    
    Swal.fire({
        title: 'Xác nhận thao tác',
        html: message,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc2626', // RunMax Primary Red
        cancelButtonColor: '#64748b',  // Slate-500
        confirmButtonText: '<i class="bi bi-check-circle me-1"></i> Đồng ý',
        cancelButtonText: '<i class="bi bi-x-circle me-1"></i> Hủy bỏ'
    }).then((result) => {
        if (result.isConfirmed) {
            if (typeof onConfirmCallback === 'function') {
                onConfirmCallback();
            }
        } else {
            if (typeof onCancelCallback === 'function') {
                onCancelCallback();
            }
        }
    });
};

// Override native window.alert across the entire application
window.originalAlert = window.alert;
window.alert = function(message) {
    showToast(message, 'danger');
};

// Global Bootstrap 5 Form Validation Engine across entire application
window.initBootstrapValidation = function() {
    var forms = document.querySelectorAll('form:not([action*="action=delete"]):not([action*="action=toggle"]):not(.no-bs-validation)');
    forms.forEach(function(form) {
        // 1. Force novalidate to permanently disable native browser tooltips (! Please fill out this field)
        if (!form.hasAttribute('novalidate')) {
            form.setAttribute('novalidate', 'novalidate');
        }
        if (!form.classList.contains('needs-validation')) {
            form.classList.add('needs-validation');
        }

        // 2. Automatically generate clean .invalid-feedback blocks for required inputs if missing
        var requiredElements = form.querySelectorAll('input[required], select[required], textarea[required]');
        requiredElements.forEach(function(el) {
            var parent = el.closest('.mb-3, .col-md-6, .col-md-4, .col-md-3, .col-12, .col-sm-6, .input-group') || el.parentElement;
            if (parent && !parent.querySelector('.invalid-feedback')) {
                var labelEl = parent.querySelector('label');
                var labelText = labelEl ? labelEl.innerText.replace(/\*/g, '').trim() : 'trường này';
                var feedback = document.createElement('div');
                feedback.className = 'invalid-feedback fw-semibold mt-1';
                feedback.innerHTML = '<i class="bi bi-exclamation-circle me-1"></i>Vui lòng nhập/chọn ' + labelText.toLowerCase() + '!';
                if (el.parentElement.classList.contains('input-group')) {
                    el.parentElement.parentElement.appendChild(feedback);
                } else {
                    parent.appendChild(feedback);
                }
            }
            // Auto clear invalid class when user types/changes value
            el.addEventListener('input', function() { el.classList.remove('is-invalid'); });
            el.addEventListener('change', function() { el.classList.remove('is-invalid'); });
        });

        // 3. Intercept submit to trigger Bootstrap was-validated CSS without native tooltips
        if (!form._hasBsValidationHandler) {
            form._hasBsValidationHandler = true;
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    form.classList.add('was-validated');
                    if (typeof showToast === 'function') {
                        showToast('Vui lòng kiểm tra và điền đầy đủ các trường thông tin có viền đỏ!', 'danger', 'Cảnh báo lỗi nhập liệu');
                    }
                } else {
                    form.classList.add('was-validated');
                }
            }, false);
        }
    });
};

// Automatically show Toast for all server-side messages on page load & init Bootstrap Validation
document.addEventListener("DOMContentLoaded", function() {
    initBootstrapValidation();

    var serverToasts = document.querySelectorAll('.runmax-server-toast-data');
    serverToasts.forEach(function(el) {
        var msg = el.innerHTML.trim();
        var type = el.getAttribute('data-type') || 'info';
        if (msg) {
            showToast(msg, type);
        }
        el.remove();
    });
});
</script>

<!-- Server-side alert data payload container (100% safe against quotes, newlines, backslashes) -->
<div id="runmaxServerAlertPayloads" style="display: none !important;">
    <c:if test="${not empty sessionScope.toastSuccess}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${sessionScope.toastSuccess}"/></div>
        <c:remove var="toastSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${sessionScope.successMessage}"/></div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.successMessage}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${requestScope.successMessage}"/></div>
    </c:if>
    <c:if test="${not empty sessionScope.message}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${sessionScope.message}"/></div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.message}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${requestScope.message}"/></div>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${sessionScope.error}"/></div>
        <c:remove var="error" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${requestScope.error}"/></div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${sessionScope.errorMessage}"/></div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${requestScope.errorMessage}"/></div>
    </c:if>

    <c:if test="${not empty sessionScope.toastInfo}">
        <div class="runmax-server-toast-data" data-type="info"><c:out value="${sessionScope.toastInfo}"/></div>
        <c:remove var="toastInfo" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.toastWarning}">
        <div class="runmax-server-toast-data" data-type="warning"><c:out value="${sessionScope.toastWarning}"/></div>
        <c:remove var="toastWarning" scope="session"/>
    </c:if>

    <c:if test="${not empty param.errorMessage}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${param.errorMessage}"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="runmax-server-toast-data" data-type="danger"><c:out value="${param.error}"/></div>
    </c:if>
    <c:if test="${not empty param.successMessage}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${param.successMessage}"/></div>
    </c:if>
    <c:if test="${not empty param.message}">
        <div class="runmax-server-toast-data" data-type="success"><c:out value="${param.message}"/></div>
    </c:if>
</div>