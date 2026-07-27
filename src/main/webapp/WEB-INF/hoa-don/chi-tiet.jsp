<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Chi tiết Hóa đơn #${hoaDon.maHd}" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} – RunMax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        @media print {
            body * {
                visibility: hidden !important;
            }
            #thermalReceiptContainer, #thermalReceiptContainer * {
                visibility: visible !important;
            }
            #thermalReceiptContainer {
                position: absolute !important;
                left: 0 !important;
                top: 0 !important;
                width: 100% !important;
                max-width: 380px !important;
                margin: 0 auto !important;
                padding: 10px !important;
                background: white !important;
                color: black !important;
                border: none !important;
                box-shadow: none !important;
            }
            html, body {
                height: auto !important;
                overflow: visible !important;
                background: white !important;
            }
            @page {
                size: auto;
                margin: 5mm;
            }
        }

        .thermal-receipt {
            font-family: 'Courier New', Courier, monospace;
            color: #000;
            background: #fff;
            padding: 22px 18px;
            max-width: 380px;
            width: 100%;
            margin: 0 auto;
            border: 1px solid #ddd;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border-radius: 6px;
            font-size: 13px;
            line-height: 1.45;
        }
        .divider-dashed {
            border-bottom: 1px dashed #000;
            margin: 8px 0;
            width: 100%;
        }
        .receipt-items-table {
            width: 100%;
            border-collapse: collapse;
        }
        .receipt-items-table th {
            border-bottom: 1px dashed #000;
            font-weight: 700;
            padding: 4px 0;
            color: #000 !important;
        }
        .receipt-items-table td {
            padding: 3px 0;
            color: #000 !important;
        }
        .style-yellow-btn {
            background-color: #ffc107 !important;
            color: #000 !important;
            border: 1px solid #e0a800 !important;
            box-shadow: 0 2px 6px rgba(255, 193, 7, 0.3);
        }
        .style-yellow-btn:hover {
            background-color: #e0a800 !important;
            color: #000 !important;
        }

        /* Order Stepper Progress */
        .stepper-card {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .stepper-wrapper {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin-top: 1rem;
            margin-bottom: 1.5rem;
        }
        .stepper-wrapper::before {
            content: '';
            position: absolute;
            top: 18px;
            left: 5%;
            right: 5%;
            height: 4px;
            background: #e2e8f0;
            z-index: 1;
        }
        .stepper-item {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            text-align: center;
        }
        .stepper-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #fff;
            border: 3px solid #cbd5e1;
            color: #64748b;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.5rem;
            transition: all 0.3s;
        }
        .stepper-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
        }
        .stepper-item.completed .stepper-circle {
            background: #10b981;
            border-color: #10b981;
            color: #fff;
        }
        .stepper-item.completed .stepper-label { color: #0f172a; font-weight: 700; }
        .stepper-item.active .stepper-circle {
            background: #dc2626;
            border-color: #dc2626;
            color: #fff;
            box-shadow: 0 0 0 5px rgba(220, 38, 38, 0.2);
        }
        .stepper-item.active .stepper-label { color: #dc2626; font-weight: 700; }

        /* 3 Columns Layout */
        .info-col-card {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.04);
            height: 100%;
            overflow: hidden;
        }
        .info-col-header {
            background: #f8fafc;
            padding: 0.85rem 1.15rem;
            border-bottom: 1px solid #e2e8f0;
            font-weight: 700;
            font-size: 0.95rem;
            color: #1e2a3a;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .info-col-body { padding: 1.15rem; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 0.65rem; font-size: 0.9rem; }
        .info-row:last-child { margin-bottom: 0; }
        .info-label { color: #64748b; font-weight: 500; }
        .info-value { color: #0f172a; font-weight: 600; text-align: right; }

        /* Timeline */
        .timeline-box { position: relative; padding-left: 1.5rem; border-left: 2px solid #e2e8f0; margin-left: 0.5rem; }
        .timeline-item { position: relative; margin-bottom: 1.25rem; }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-dot {
            position: absolute; left: -1.85rem; top: 0.2rem;
            width: 12px; height: 12px; border-radius: 50%;
            background: #dc2626; border: 2px solid #fff; box-shadow: 0 0 0 3px #fee2e2;
        }
        .timeline-time { font-size: 0.78rem; color: #94a3b8; font-weight: 600; }
        .timeline-action { font-size: 0.88rem; color: #1e2a3a; font-weight: 600; }
        .timeline-user { font-size: 0.8rem; color: #64748b; }

        .badge-wait     { background: #fef3c7; color: #92400e; }
        .badge-confirm  { background: #dbeafe; color: #1e40af; }
        .badge-shipping { background: #ede9fe; color: #5b21b6; }
        .badge-done     { background: #d1fae5; color: #065f46; }
        .badge-cancel   { background: #f1f5f9; color: #64748b; }
        .status-badge   { display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.35rem 0.85rem; border-radius: 20px; font-size: 0.82rem; font-weight: 700; }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />

            <div class="runmax-content pb-5">

                <!-- Header navigation -->
                <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">
                            <i class="bi bi-file-earmark-text-fill text-danger me-2"></i>Chi tiết hóa đơn: <span class="text-danger">${hoaDon.maHd}</span>
                        </h4>
                        <p class="text-muted small mb-0">Quản lý trạng thái giao hàng, kiểm tra thông tin thanh toán và lịch sử thao tác.</p>
                    </div>
                    <div class="d-flex gap-2 btn-actions">
                        <a href="${pageContext.request.contextPath}/hoa-don" class="btn btn-outline-secondary fw-semibold">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                        <button onclick="openThermalReceiptModal()" class="btn btn-outline-dark fw-semibold">
                            <i class="bi bi-printer-fill me-1"></i>In Hóa Đơn
                        </button>
                    </div>
                </div>

                <!-- STEPPER & ACTION BAR CARD -->
                <div class="stepper-card no-print">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
                        <div class="d-flex align-items-center gap-3">
                            <span class="fw-bold text-dark"><i class="bi bi-flag-fill text-danger me-2"></i>Trạng thái hiện tại:</span>
                            <span class="${hoaDon.badgeClass} fs-6">${hoaDon.tenTrangThai}</span>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <!-- Nút thao tác nhanh theo trạng thái -->
                            <c:if test="${hoaDon.trangThai == 0}">
                                <button type="button" class="btn btn-success fw-bold px-4" onclick="confirmUpdateStatus(1, 'Xác nhận hoàn thành hóa đơn này?')">
                                    <i class="bi bi-check-circle-fill me-1"></i>Hoàn thành đơn hàng
                                </button>
                                <button type="button" class="btn btn-outline-danger fw-semibold px-3" onclick="openCancelModal()">
                                    <i class="bi bi-x-circle me-1"></i>Hủy đơn
                                </button>
                            </c:if>

                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="openNoteModal()" title="Thêm ghi chú">
                                <i class="bi bi-pencil-square me-1"></i>Ghi chú
                            </button>
                        </div>
                    </div>

                    <!-- Stepper bar (chỉ hiển thị theo 3 trạng thái: Đang chờ, Đã hoàn thành, Đã hủy) -->
                    <c:choose>
                        <c:when test="${hoaDon.trangThai == 2 || hoaDon.trangThai >= 4}">
                            <div class="alert alert-secondary mb-0 mt-3 d-flex align-items-center gap-3 py-2">
                                <i class="bi bi-x-circle-fill fs-4 text-secondary"></i>
                                <div>
                                    <strong>Đơn hàng này đã bị hủy.</strong>
                                    <div class="small">Lý do: ${not empty hoaDon.ghiChu ? hoaDon.ghiChu : 'Không có ghi chú hủy.'}</div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="stepper-wrapper">
                                <div class="stepper-item ${hoaDon.trangThai == 0 ? 'active' : 'completed'}">
                                    <div class="stepper-circle"><i class="${hoaDon.trangThai > 0 ? 'bi bi-check-lg' : 'bi bi-1-circle'}"></i></div>
                                    <div class="stepper-label">1. Đang chờ</div>
                                </div>
                                <div class="stepper-item ${hoaDon.trangThai == 1 || hoaDon.trangThai == 3 ? 'completed active' : ''}">
                                    <div class="stepper-circle"><i class="${hoaDon.trangThai == 1 || hoaDon.trangThai == 3 ? 'bi bi-check-lg' : 'bi bi-2-circle'}"></i></div>
                                    <div class="stepper-label">2. Đã hoàn thành</div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 3 COLUMNS INFO CARDS -->
                <div class="row g-4 mb-4">
                    <!-- Cột 1: Thông tin Đơn hàng -->
                    <div class="col-lg-4 col-md-6">
                        <div class="info-col-card">
                            <div class="info-col-header">
                                <span><i class="bi bi-info-circle-fill text-danger me-2"></i>Thông tin đơn hàng</span>
                                <span class="badge bg-light text-dark border">#${hoaDon.maHd}</span>
                            </div>
                            <div class="info-col-body">
                                <div class="info-row">
                                    <span class="info-label">Mã hóa đơn:</span>
                                    <span class="info-value text-danger fw-bold">${hoaDon.maHd}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Ngày tạo đơn:</span>
                                    <span class="info-value">${hoaDon.ngayTaoFormatted}</span>
                                </div>
                                <c:if test="${not empty lichSuTT}">
                                    <div class="info-row">
                                        <span class="info-label">Ngày thanh toán:</span>
                                        <span class="info-value text-success">${fn:substring(lichSuTT[0].ngayThanhToan.toString().replace('T', ' '), 0, 19)}</span>
                                    </div>
                                </c:if>

                                <div class="info-row">
                                    <span class="info-label">Nhân viên phụ trách:</span>
                                    <span class="info-value">${hoaDon.nhanVien != null ? hoaDon.nhanVien.hoTen : 'Hệ thống'}</span>
                                </div>
                                <hr class="my-2 text-muted">
                                <div class="small">
                                    <span class="info-label d-block mb-1">Ghi chú đơn hàng:</span>
                                    <span class="text-dark fst-italic">${not empty hoaDon.ghiChu ? hoaDon.ghiChu : 'Không có ghi chú nào.'}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Cột 2: Khách Hàng & Giao Nhận -->
                    <div class="col-lg-4 col-md-6">
                        <div class="info-col-card">
                            <div class="info-col-header">
                                <span><i class="bi bi-person-lines-fill text-danger me-2"></i>Khách hàng & Người nhận</span>
                                <c:if test="${hoaDon.khachHang != null}">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">Thành viên</span>
                                </c:if>
                            </div>
                            <div class="info-col-body">
                                <div class="info-row">
                                    <span class="info-label">Họ và tên:</span>
                                    <span class="info-value fw-bold">${hoaDon.tenKhachHangHienThi}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Số điện thoại:</span>
                                    <span class="info-value">${hoaDon.sdtHienThi}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Email:</span>
                                    <span class="info-value">${hoaDon.khachHang != null && not empty hoaDon.khachHang.email ? hoaDon.khachHang.email : '--'}</span>
                                </div>
                                <hr class="my-2 text-muted">
                                <div class="small">
                                    <span class="info-label d-block mb-1">Địa chỉ nhận hàng:</span>
                                    <span class="text-dark">
                                        <c:choose>
                                            <c:when test="${hoaDon.khachHang != null && not empty hoaDon.khachHang.diaChi}">
                                                ${hoaDon.khachHang.diaChi}
                                            </c:when>
                                            <c:otherwise>
                                                Mua trực tiếp tại quầy cửa hàng RunMax.
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Cột 3: Lịch Sử & Phương Thức Thanh Toán -->
                    <div class="col-lg-4 col-md-12">
                        <div class="info-col-card">
                            <div class="info-col-header">
                                <span><i class="bi bi-credit-card-2-front-fill text-danger me-2"></i>Thanh toán & Tổng kết</span>
                                <span class="badge ${hoaDon.trangThai == 1 || hoaDon.trangThai == 3 ? 'bg-success' : 'bg-warning text-dark'}">
                                    ${hoaDon.trangThai == 1 || hoaDon.trangThai == 3 ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                </span>
                            </div>
                            <div class="info-col-body">
                                <div class="info-row">
                                    <span class="info-label">Tổng tiền hàng:</span>
                                    <span class="info-value">${hoaDon.tienHangFormatted}</span>
                                </div>
                                <div class="info-row text-success">
                                    <span class="info-label">Voucher giảm giá:</span>
                                    <span class="info-value fw-bold">
                                        - ${hoaDon.soTienGiamFormatted}
                                    </span>
                                </div>
                                <c:if test="${hoaDon.phieuGiamGia != null}">
                                    <div class="bg-success-subtle border border-success-subtle rounded p-2 my-2 text-start small">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="bi bi-ticket-perforated-fill text-success fs-6 me-2"></i>
                                            <span class="fw-bold text-success-emphasis">${hoaDon.phieuGiamGia.tenPhieu}</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center text-muted" style="font-size:0.82rem;">
                                            <span>Mã voucher: <strong class="text-dark">${hoaDon.phieuGiamGia.maPhieu}</strong></span>
                                            <span class="badge bg-success text-white">Giảm ${hoaDon.soTienGiamFormatted}<c:if test="${hoaDon.phieuGiamGia.loaiGiam == 1}"> (${hoaDon.phieuGiamGia.giaTrigiam}%)</c:if></span>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${hoaDon.phieuGiamGia == null && (hoaDon.soTienGiam == null || hoaDon.soTienGiam == 0)}">
                                    <div class="text-muted small fst-italic mb-2">Đơn hàng không áp dụng voucher.</div>
                                </c:if>
                                <div class="info-row mt-2 pt-2 border-top">
                                    <span class="info-label fw-bold fs-6">TỔNG THANH TOÁN:</span>
                                    <span class="info-value text-danger fw-bold fs-5">${hoaDon.tongTienFormatted}</span>
                                </div>
                                <hr class="my-2 text-muted">
                                <div class="small">
                                    <span class="info-label d-block mb-1">Lịch sử thanh toán:</span>
                                    <c:choose>
                                        <c:when test="${not empty lichSuTT}">
                                            <c:forEach var="ls" items="${lichSuTT}">
                                                <div class="d-flex justify-content-between align-items-center mb-1 bg-light p-2 rounded">
                                                    <div>
                                                        <strong class="text-dark">${ls.phuongThucThanhToan.tenPhuongThuc}</strong>
                                                        <div class="text-muted" style="font-size:0.75rem;">${ls.ngayThanhToan.toString().replace('T', ' ')}</div>
                                                    </div>
                                                    <span class="fw-bold text-success"><fmt:formatNumber value="${ls.soTien != null ? ls.soTien : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-muted fst-italic">Chưa có giao dịch thanh toán nào.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bộ lọc tìm kiếm sản phẩm trong hóa đơn -->
                <div class="filter-card no-print mb-4">
                    <div class="filter-header" data-bs-toggle="collapse" data-bs-target="#filterHDCT">
                        <span><i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm Sản phẩm trong hóa đơn</span>
                        <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                    </div>
                    <div class="collapse show" id="filterHDCT">
                        <div class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-5">
                                    <label>Từ khóa tìm kiếm</label>
                                    <input type="text" id="inputSearchHDCT" class="form-control" placeholder="Tìm theo tên sản phẩm, mã SKU...">
                                </div>
                                <div class="col-md-3">
                                    <label>Màu sắc</label>
                                    <select id="selectColorHDCT" class="form-select">
                                        <option value="">-- Tất cả màu sắc --</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label>Kích cỡ (Size)</label>
                                    <select id="selectSizeHDCT" class="form-select">
                                        <option value="">-- Tất cả size --</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex gap-2 align-items-end">
                                    <button type="button" class="btn btn-outline-secondary flex-fill shadow-sm" id="btnResetHDCT" title="Làm mới bộ lọc">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt lại
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TABLE SẢN PHẨM TRONG ĐƠN HÀNG -->
                <div class="runmax-card p-0 mb-4 overflow-hidden">
                    <div class="p-3 bg-white border-bottom d-flex justify-content-between align-items-center">
                        <span class="fw-bold text-dark"><i class="bi bi-bag-check-fill text-danger me-2"></i>Danh sách Sản phẩm giày trong hóa đơn <span class="badge bg-secondary ms-1" id="badgeCountHDCT">${fn:length(chiTiets)}</span></span>

                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark" style="background:#1e2a3a;">
                                <tr>
                                    <th style="width: 60px;" class="text-center">STT</th>
                                    <th>Sản phẩm & Biến thể (SKU)</th>
                                    <th>Màu sắc</th>
                                    <th>Kích cỡ</th>
                                    <th class="text-end">Đơn giá bán</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyHDCT">
                                <c:forEach var="ct" items="${chiTiets}" varStatus="loop">
                                    <tr class="hdct-row" data-color="${fn:escapeXml(ct.sanPhamChiTiet.mauSac.ten)}" data-size="${fn:escapeXml(ct.sanPhamChiTiet.kichCo.ten)}">
                                        <td class="text-center text-muted fw-semibold">${loop.index + 1}</td>
                                        <td>
                                            <div class="fw-bold text-dark">${ct.sanPhamChiTiet.sanPham.tenSp}</div>
                                            <small class="text-muted">Mã SKU: ${ct.sanPhamChiTiet.maSpct != null ? ct.sanPhamChiTiet.maSpct : ct.sanPhamChiTiet.sanPham.maSp}</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><i class="bi bi-palette-fill text-danger me-1"></i>${ct.sanPhamChiTiet.mauSac.ten}</span></td>
                                        <td><span class="badge bg-danger rounded-pill px-3">${ct.sanPhamChiTiet.kichCo.ten}</span></td>
                                        <td class="text-end fw-semibold">
                                            <fmt:formatNumber value="${ct.donGia != null ? ct.donGia : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center"><span class="badge bg-dark px-3 py-2 fs-6">${ct.soLuong}</span></td>
                                        <td class="text-end fw-bold text-danger fs-6">
                                            <fmt:formatNumber value="${ct.thanhTien != null ? ct.thanhTien : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- LỊCH SỬ THAO TÁC (TIMELINE) -->
                <div class="runmax-card p-4 no-print">
                    <h6 class="fw-bold text-dark mb-4"><i class="bi bi-clock-history text-danger me-2"></i>Lịch sử hoạt động đơn hàng</h6>
                    <c:choose>
                        <c:when test="${not empty lichSuHD}">
                            <div class="timeline-box">
                                <c:forEach var="lshd" items="${lichSuHD}">
                                    <div class="timeline-item">
                                        <div class="timeline-dot"></div>
                                        <div class="timeline-time">${lshd.thoiGian.toString().replace('T', ' ')}</div>
                                        <div class="timeline-action">${lshd.hanhDong}</div>
                                        <div class="timeline-user">Thực hiện bởi: <strong>${lshd.nguoiThaoTac}</strong></div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic mb-0">Chưa ghi nhận lịch sử thao tác cho đơn hàng này.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

    <!-- Form ẩn để submit đổi trạng thái -->
    <form id="formUpdateStatus" method="POST" action="${pageContext.request.contextPath}/hoa-don" style="display:none;">
        <input type="hidden" name="action" value="updateStatus">
        <input type="hidden" name="id" value="${hoaDon.id}">
        <input type="hidden" name="status" id="inputStatus">
        <input type="hidden" name="ghiChu" id="inputGhiChu">
    </form>

    <!-- Modal Hủy Đơn Hàng -->
    <div class="modal fade" id="modalCancelOrder" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow:hidden;">
                <div class="modal-header bg-danger text-white border-0 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>Hủy hóa đơn #${hoaDon.maHd}</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/hoa-don">
                    <input type="hidden" name="action" value="huy">
                    <input type="hidden" name="id" value="${hoaDon.id}">
                    <div class="modal-body p-4">
                        <p class="text-secondary small mb-3">Vui lòng nhập rõ lý do hủy đơn hàng này để lưu vào lịch sử theo dõi:</p>
                        <textarea name="lyDo" class="form-control" rows="3" required placeholder="VD: Khách hàng đổi ý, hết size giày, sai thông tin đặt hàng..."></textarea>
                    </div>
                    <div class="modal-footer bg-light border-0 px-4 py-3">
                        <button type="button" class="btn btn-outline-secondary fw-semibold px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger fw-bold px-4"><i class="bi bi-check2 me-1"></i>Xác nhận Hủy Đơn</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Ghi chú -->
    <div class="modal fade" id="modalNote" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow:hidden;">
                <div class="modal-header bg-dark text-white border-0 py-3">
                    <h5 class="modal-title fw-bold">Cập nhật Ghi chú Đơn hàng</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <textarea id="textNoteContent" class="form-control" rows="3" placeholder="Nhập ghi chú cần bổ sung...">${hoaDon.ghiChu}</textarea>
                </div>
                <div class="modal-footer bg-light border-0 px-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-semibold px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-dark fw-bold px-4" onclick="saveNote()"><i class="bi bi-save me-1"></i>Lưu Ghi Chú</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xem trước hóa đơn (in nhiệt) -->
    <div class="modal fade" id="modalThermalReceipt" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow:hidden;">
                <div class="modal-header bg-white border-bottom py-3">
                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-printer me-2"></i>Xem trước hóa đơn (in nhiệt)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light d-flex justify-content-center">
                    <div id="thermalReceiptContainer" class="thermal-receipt">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <div class="fw-bold fs-5 mb-1" style="letter-spacing: 0.5px;">RunMax</div>
                                <div class="small mb-1">Đền Lừ, Hoàng Mai, Hà Nội</div>
                                <div class="small mb-1">Hotline: 0968038313</div>
                            </div>
                            <div class="text-center ms-2 flex-shrink-0">
                                <div id="receipt-thermal-qr" style="width: 78px; height: 78px; display: flex; align-items: center; justify-content: center; border: 1px solid #ddd; padding: 2px; background: white; margin: 0 auto;">
                                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=78x78&data=${hoaDon.maHd}" alt="QR Code ${hoaDon.maHd}" style="width: 74px; height: 74px; display: block;" onerror="this.style.display='none';">
                                </div>
                                <div style="font-size: 10px; margin-top: 2px; font-weight: 600;">#${hoaDon.maHd}</div>
                            </div>
                        </div>
                        
                        <div class="divider-dashed"></div>
                        <div class="text-center fw-bold my-2 fs-6">HÓA ĐƠN BÁN HÀNG</div>
                        <div class="divider-dashed"></div>
                        
                        <div class="d-flex justify-content-between small mt-2">
                            <span>Ngày: ${fn:length(hoaDon.ngayTaoFormatted) > 10 ? fn:substring(hoaDon.ngayTaoFormatted, 0, 10) : hoaDon.ngayTaoFormatted}</span>
                            <span>Số: ${hoaDon.maHd}</span>
                        </div>
                        <div class="small mb-2">
                            <span>In lúc: <fmt:formatDate value="${now}" pattern="HH:mm"/></span>
                        </div>
                        <div class="small mb-1">
                            <span>Khách: <strong>${hoaDon.tenKhachHangHienThi}</strong></span>
                        </div>
                        <div class="small mb-1">
                            <span>SĐT: ${not empty hoaDon.sdtHienThi && hoaDon.sdtHienThi != 'Khách lẻ' ? hoaDon.sdtHienThi : '--'}</span>
                        </div>
                        <div class="small mb-2">
                            <span>Đ/c: <c:choose><c:when test="${hoaDon.khachHang != null && not empty hoaDon.khachHang.diaChi}">${hoaDon.khachHang.diaChi}</c:when><c:otherwise>Đền Lừ, Hoàng Mai, Hà Nội</c:otherwise></c:choose></span>
                        </div>
                        
                        <div class="divider-dashed"></div>
                        
                        <table class="receipt-items-table w-100 small my-2">
                            <thead>
                                <tr>
                                    <th class="text-start py-1">Tên hàng</th>
                                    <th class="text-center py-1" style="width: 40px;">SL</th>
                                    <th class="text-end py-1" style="width: 110px;">Tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ct" items="${chiTiets}">
                                    <tr>
                                        <td class="text-start fw-bold pt-2">${ct.sanPhamChiTiet.sanPham.tenSp}</td>
                                        <td class="text-center pt-2">${ct.soLuong}</td>
                                        <td class="text-end fw-bold pt-2"><fmt:formatNumber value="${ct.thanhTien != null ? ct.thanhTien : 0}" type="number"/> đ</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="text-start pb-1 text-muted" style="font-size: 0.85em; color: #333 !important;">
                                            ${ct.sanPhamChiTiet.mauSac.ten} / Size ${ct.sanPhamChiTiet.kichCo.ten} &bull; ${ct.sanPhamChiTiet.maSpct != null ? ct.sanPhamChiTiet.maSpct : ct.sanPhamChiTiet.sanPham.maSp}
                                            <br>ĐG: <fmt:formatNumber value="${ct.donGia != null ? ct.donGia : 0}" type="number"/> đ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div class="divider-dashed"></div>
                        
                        <div class="d-flex justify-content-between small mt-2">
                            <span>Tổng tiền</span>
                            <span class="fw-bold"><fmt:formatNumber value="${hoaDon.tienHang != null ? hoaDon.tienHang : 0}" type="number"/> đ</span>
                        </div>
                        <div class="d-flex justify-content-between small mt-1 mb-2">
                            <span>Giảm giá <c:if test="${hoaDon.phieuGiamGia != null}"><br><small style="font-size:0.88em;color:#333;">[${hoaDon.phieuGiamGia.maPhieu}] ${hoaDon.phieuGiamGia.tenPhieu} <c:if test="${hoaDon.phieuGiamGia.loaiGiam == 1}">(-<fmt:formatNumber value="${hoaDon.phieuGiamGia.giaTrigiam}" maxFractionDigits="0"/>%)</c:if></small></c:if></span>
                            <span class="fw-bold">-<fmt:formatNumber value="${hoaDon.soTienGiam != null ? hoaDon.soTienGiam : 0}" type="number"/> đ</span>
                        </div>
                        
                        <div class="divider-dashed"></div>
                        
                        <div class="d-flex justify-content-between fw-bold my-2 fs-6">
                            <span>TỔNG THANH TOÁN</span>
                            <span><fmt:formatNumber value="${hoaDon.tongTien != null ? hoaDon.tongTien : 0}" type="number"/> đ</span>
                        </div>
                        
                        <div class="divider-dashed"></div>
                        
                        <div class="text-center fw-bold small mt-3 pt-1">
                            Cảm ơn quý khách & Hẹn gặp lại!
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white border-top py-3 d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-light border px-4 fw-semibold" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn px-4 fw-bold style-yellow-btn" onclick="window.print()">
                        <i class="bi bi-printer-fill me-1"></i>In / Lưu PDF
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        function confirmUpdateStatus(newStatus, msg) {
            showBootstrapConfirm(msg, function() {
                document.getElementById('inputStatus').value = newStatus;
                document.getElementById('formUpdateStatus').submit();
            });
        }

        const cancelModalObj = new bootstrap.Modal(document.getElementById('modalCancelOrder'));
        function openCancelModal(status) {
            cancelModalObj.show();
        }

        const noteModalObj = new bootstrap.Modal(document.getElementById('modalNote'));
        function openNoteModal() {
            noteModalObj.show();
        }

        function saveNote() {
            const note = document.getElementById('textNoteContent').value.trim();
            document.getElementById('inputStatus').value = ${hoaDon.trangThai};
            document.getElementById('inputGhiChu').value = note;
            document.getElementById('formUpdateStatus').submit();
        }

        let thermalReceiptModalObj = null;
        function openThermalReceiptModal() {
            if (!thermalReceiptModalObj) {
                thermalReceiptModalObj = new bootstrap.Modal(document.getElementById('modalThermalReceipt'));
            }
            thermalReceiptModalObj.show();
        }

        <c:if test="${param.print == 'true'}">
        window.addEventListener('load', function() {
            openThermalReceiptModal();
            setTimeout(function() { window.print(); }, 600);
        });
        </c:if>

        // Live filter cho danh sách sản phẩm trong hóa đơn
        document.addEventListener('DOMContentLoaded', function() {
            const inputSearch = document.getElementById('inputSearchHDCT');
            const selectColor = document.getElementById('selectColorHDCT');
            const selectSize = document.getElementById('selectSizeHDCT');
            const btnReset = document.getElementById('btnResetHDCT');
            const tbody = document.getElementById('tbodyHDCT');
            if (!tbody || !inputSearch) return;

            const rows = Array.from(tbody.querySelectorAll('tr.hdct-row'));
            const colors = new Set();
            const sizes = new Set();

            rows.forEach(row => {
                const c = row.getAttribute('data-color');
                const s = row.getAttribute('data-size');
                if (c) colors.add(c);
                if (s) sizes.add(s);
            });

            Array.from(colors).sort().forEach(c => {
                const opt = document.createElement('option');
                opt.value = c;
                opt.textContent = c;
                selectColor.appendChild(opt);
            });

            Array.from(sizes).sort().forEach(s => {
                const opt = document.createElement('option');
                opt.value = s;
                opt.textContent = s;
                selectSize.appendChild(opt);
            });

            function filterRows() {
                const kw = inputSearch.value.trim().toLowerCase();
                const col = selectColor.value;
                const sz = selectSize.value;
                let visibleCount = 0;

                const noRes = document.getElementById('noResultHDCTRow');
                if (noRes) noRes.remove();

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    const rCol = row.getAttribute('data-color') || '';
                    const rSz = row.getAttribute('data-size') || '';

                    const matchKw = !kw || text.includes(kw);
                    const matchCol = !col || rCol === col;
                    const matchSz = !sz || rSz === sz;

                    if (matchKw && matchCol && matchSz) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                const badgeCount = document.getElementById('badgeCountHDCT');
                if (badgeCount) {
                    badgeCount.textContent = visibleCount + (visibleCount !== rows.length ? ' / ' + rows.length : '');
                }

                if (visibleCount === 0 && rows.length > 0) {
                    const tr = document.createElement('tr');
                    tr.id = 'noResultHDCTRow';
                    tr.innerHTML = '<td colspan="7" class="text-center py-4 text-muted"><i class="bi bi-search me-2"></i>Không tìm thấy sản phẩm giày nào phù hợp với bộ lọc</td>';
                    tbody.appendChild(tr);
                }
            }

            inputSearch.addEventListener('input', filterRows);
            selectColor.addEventListener('change', filterRows);
            selectSize.addEventListener('change', filterRows);
            if (btnReset) {
                btnReset.addEventListener('click', function() {
                    inputSearch.value = '';
                    selectColor.value = '';
                    selectSize.value = '';
                    filterRows();
                });
            }
        });
    </script>

    <!-- MODAL QUÉT QR WEBCAM THÊM SẢN PHẨM VÀO ĐƠN HÀNG (TRANG CHI TIẾT HÓA ĐƠN) -->
    <div class="modal fade" id="modalScanQRAdd" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code-scan"></i> Quét mã QR Thêm vào Đơn hàng #${hoaDon.maHd}
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center bg-light">
                    <p class="text-muted small mb-3">Đưa tem mã QR của giày vào trước Camera webcam hoặc dùng súng bắn vạch.</p>
                    <div id="qr-camera-viewport" class="mx-auto border rounded-4 overflow-hidden shadow-sm bg-dark" style="width: 100%; max-width: 400px; min-height: 280px;"></div>
                    <div id="qr-scan-status" class="mt-3 fw-bold text-primary small"></div>

                    <div class="mt-4 pt-3 border-top text-start">
                        <label class="form-label small fw-semibold text-secondary">Hoặc nhập tay mã SKU / dùng súng quét:</label>
                        <div class="d-flex gap-2">
                            <input type="text" id="inputManualScanSKU" class="form-control" placeholder="VD: SPCT1, SPCT2, SP03...">
                            <button type="button" class="btn btn-runmax px-3 text-nowrap" onclick="if(document.getElementById('inputManualScanSKU').value.trim()) { processScannedSKU(document.getElementById('inputManualScanSKU').value.trim()); document.getElementById('inputManualScanSKU').value=''; }">
                                <i class="bi bi-plus-lg"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-2 border-top d-flex justify-content-between">
                    <span class="small text-muted"><i class="bi bi-volume-up-fill me-1"></i>Tự động kêu Bíp & thêm vào đơn khi nhận diện</span>
                    <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        let activeScanHdId = '${hoaDon.id}';
        let qrCameraScannerObj = null;

        const availableSpctList = [
            <c:forEach var="item" items="${allSpct}" varStatus="st">
            {
                id: ${item.id},
                maSpct: '${item.maSpct != null ? item.maSpct : "SPCT".concat(item.id)}',
                maSp: '${item.sanPham.maSp}',
                tenSp: '${fn:escapeXml(item.sanPham.tenSp)}',
                mauSac: '${fn:escapeXml(item.mauSac.ten)}',
                kichCo: '${fn:escapeXml(item.kichCo.ten)}',
                soLuongTon: ${item.soLuongTon}
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        function openInvoiceScanQRModal(hdId) {
            activeScanHdId = hdId || '${hoaDon.id}';
            const modalEl = document.getElementById('modalScanQRAdd');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();

            startCameraScanQR();
        }

        function startCameraScanQR() {
            const statusEl = document.getElementById('qr-scan-status');
            if (statusEl) statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-hourglass-split"></i> Đang khởi động camera...</span>';

            if (typeof Html5Qrcode === 'undefined') {
                if (statusEl) statusEl.innerHTML = '<span class="text-danger">Lỗi: Thư viện Html5Qrcode chưa tải được.</span>';
                return;
            }

            qrCameraScannerObj = new Html5Qrcode("qr-camera-viewport");
            qrCameraScannerObj.start(
                { facingMode: "environment" },
                { fps: 10, qrbox: { width: 240, height: 240 } },
                (decodedText) => {
                    processScannedSKU(decodedText);
                },
                (err) => {}
            ).then(() => {
                if (statusEl) statusEl.innerHTML = '<span class="text-success"><i class="bi bi-camera-video-fill"></i> Camera đang quét... Đưa tem QR vào khung</span>';
            }).catch(err => {
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: ${err}. Bạn có thể nhập mã ở dưới.</span>`;
            });
        }

        function stopCameraScanQR() {
            if (qrCameraScannerObj) {
                qrCameraScannerObj.stop().then(() => {
                    qrCameraScannerObj.clear();
                    qrCameraScannerObj = null;
                }).catch(err => {
                    qrCameraScannerObj = null;
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const modalEl = document.getElementById('modalScanQRAdd');
            if (modalEl) {
                modalEl.addEventListener('hidden.bs.modal', function () {
                    stopCameraScanQR();
                });
            }
            const inputManual = document.getElementById('inputManualScanSKU');
            if (inputManual) {
                inputManual.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' && inputManual.value.trim()) {
                        processScannedSKU(inputManual.value.trim());
                        inputManual.value = '';
                    }
                });
            }
        });

        function processScannedSKU(decodedText) {
            const code = (decodedText || '').toString().trim().toUpperCase();
            if (!code || !activeScanHdId) return;

            const statusEl = document.getElementById('qr-scan-status');
            if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện mã: <b class="text-danger">${code}</b>`;

            const matched = availableSpctList.find(p => 
                p.maSpct.toUpperCase() === code || 
                p.id.toString() === code || 
                p.maSp.toUpperCase() === code
            );

            if (matched) {
                if (matched.soLuongTon <= 0) {
                    alert(`Sản phẩm "${matched.tenSp} (Size ${matched.kichCo} - ${matched.mauSac})" đã HẾT HÀNG trong kho (${matched.soLuongTon})!`);
                    return;
                }

                try {
                    const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                    const osc = audioCtx.createOscillator();
                    const gain = audioCtx.createGain();
                    osc.connect(gain);
                    gain.connect(audioCtx.destination);
                    osc.frequency.value = 1350;
                    gain.gain.value = 0.15;
                    osc.start();
                    setTimeout(() => osc.stop(), 130);
                } catch(e) {}

                stopCameraScanQR();

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/hoa-don';
                form.style.display = 'none';

                const inputAction = document.createElement('input');
                inputAction.type = 'hidden';
                inputAction.name = 'action';
                inputAction.value = 'them-sp';
                form.appendChild(inputAction);

                const inputHd = document.createElement('input');
                inputHd.type = 'hidden';
                inputHd.name = 'hdId';
                inputHd.value = activeScanHdId;
                form.appendChild(inputHd);

                const inputSpct = document.createElement('input');
                inputSpct.type = 'hidden';
                inputSpct.name = 'spctId';
                inputSpct.value = matched.id;
                form.appendChild(inputSpct);

                const inputSl = document.createElement('input');
                inputSl.type = 'hidden';
                inputSl.name = 'soLuong';
                inputSl.value = '1';
                form.appendChild(inputSl);

                document.body.appendChild(form);
                form.submit();
            } else {
                alert(`Không tìm thấy biến thể giày nào trong kho ứng với mã QR: "${code}"!`);
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const qrBox = document.getElementById('receipt-thermal-qr');
            if (qrBox && typeof QRCode !== 'undefined') {
                qrBox.innerHTML = '';
                new QRCode(qrBox, {
                    text: '${hoaDon.maHd}',
                    width: 74,
                    height: 74,
                    colorDark : "#000000",
                    colorLight : "#ffffff",
                    correctLevel : QRCode.CorrectLevel.M
                });
            }
        });
    </script>
</body>
</html>
