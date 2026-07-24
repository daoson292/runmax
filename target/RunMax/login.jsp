<%-- 
  TRANG ĐĂNG NHẬP (Màn hình Login toàn ứng dụng)
  - Keyword search GG: "HTML Form POST Servlet action", "JSTL c:if error message display"
  - Nhiệm vụ: Giao diện nhập Tài khoản (email/maNV) & Mật khẩu. Submit POST tới LoginServlet (/login).
  - Kết nối Backend: Khi nhập sai mật khẩu, LoginServlet gửi về biến ${error}, trang sẽ tự động hiển thị dải thông báo lỗi đỏ trên form.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - RunMax Men's Running POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #111827 0%, #1f2937 50%, #374151 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 1.5rem;
        }
        .login-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.45);
            width: 100%;
            max-width: 480px;
            padding: 2.8rem 2.4rem;
            position: relative;
            overflow: hidden;
        }
        .login-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #dc3545, #fd7e14);
        }
        .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            border: 1.5px solid #e5e7eb;
            font-size: 0.95rem;
        }
        .form-control:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.15);
        }
        .btn-runmax {
            background: #dc3545;
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.2s;
        }
        .btn-runmax:hover {
            background: #b02a37;
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.35);
        }
        .shake-alert {
            animation: shake 0.4s ease-in-out;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }
        .account-box {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1rem;
            border: 1px dashed #ced4da;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <!-- Logo chính thức của dự án -->
        <div class="text-center mb-4">
            <div class="mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="RunMax Logo" style="max-height: 85px; width: auto; object-fit: contain;">
            </div>
            <h4 class="fw-bold mb-1" style="letter-spacing: -0.03em;">HỆ THỐNG POS RUN<span class="text-danger">MAX</span></h4>
            <p class="text-muted small mb-0 fw-semibold">Quản lý & Bán Giày Nam Chạy Bộ Chuyên Nghiệp</p>
        </div>

        <!-- THÔNG BÁO LỖI ĐĂNG NHẬP (SAI MẬT KHẨU / TÀI KHOẢN) -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shake-alert d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div class="small fw-semibold">${error}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- THÔNG BÁO ĐĂNG XUẤT HOẶC CẦN ĐĂNG NHẬP -->
        <c:if test="${param.logout == 'true'}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div class="small fw-semibold">Bạn đã đăng xuất khỏi hệ thống thành công!</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate onsubmit="if(!this.checkValidity()){ event.preventDefault(); event.stopPropagation(); this.classList.add('was-validated'); return false; } this.classList.add('was-validated'); return true;">
            <div class="mb-3">
                <label class="form-label fw-semibold small text-dark">Tên đăng nhập hoặc Email</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-person-fill"></i></span>
                    <input type="text" name="tenDangNhap" class="form-control border-start-0" required
                           placeholder="Tên đăng nhập hoặc địa chỉ email..." value="${tenDangNhapCu}" oninput="this.classList.remove('is-invalid')">
                </div>
                <div class="invalid-feedback fw-semibold mt-1"><i class="bi bi-exclamation-circle me-1"></i>Vui lòng nhập tên đăng nhập hoặc email!</div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold small text-dark">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-key-fill"></i></span>
                    <input type="password" name="matKhau" class="form-control border-start-0" required
                           placeholder="Mật khẩu truy cập..." oninput="this.classList.remove('is-invalid')">
                </div>
                <div class="invalid-feedback fw-semibold mt-1"><i class="bi bi-exclamation-circle me-1"></i>Vui lòng nhập mật khẩu!</div>
            </div>

            <button type="submit" class="btn btn-runmax w-100 mb-4">
                <i class="bi bi-box-arrow-in-right me-1"></i> ĐĂNG NHẬP HỆ THỐNG
            </button>
        </form>

        <!-- DANH SÁCH TÀI KHOẢN THÀNH VIÊN NHÓM (Mật khẩu chung: 123456) -->
        <div class="account-box">
            <div class="small fw-bold text-dark mb-2 d-flex align-items-center gap-1">
                <i class="bi bi-people-fill text-danger"></i> TÀI KHOẢN THÀNH VIÊN NHÓM RUNMAX:
            </div>
            <div class="row g-2 small">
                <div class="col-6">
                    <div class="fw-semibold text-danger">👑 Quản lý (Admin):</div>
                    <div class="text-muted" style="font-size: 0.82rem;">
                        • <b>daoson</b> (Đào Sơn)<br>
                        • <b>kieuanh</b> (Kiều Anh)
                    </div>
                </div>
                <div class="col-6">
                    <div class="fw-semibold text-primary">💼 POS (Nhân viên):</div>
                    <div class="text-muted" style="font-size: 0.82rem;">
                        • <b>khanh</b> (Khánh)<br>
                        • <b>thuhang</b> (Thu Hằng)
                    </div>
                </div>
            </div>
            <div class="text-center mt-2 pt-2 border-top small text-muted" style="font-size: 0.8rem;">
                Mật khẩu chung tất cả tài khoản: <span class="badge bg-danger">123456</span>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
