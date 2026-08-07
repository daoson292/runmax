<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản Lý Hóa Đơn" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hóa Đơn – RunMax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        @media print {
            .no-print, .runmax-sidebar, .runmax-header, #filterCard, .btn-actions { display: none !important; }
            .runmax-main { margin-left: 0 !important; }
            .runmax-content { padding: 0 !important; }
            body { background: white !important; }
        }

        /* Bộ lọc thu gọn (giao diện trắng đồng bộ) */
        .filter-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border: 1px solid rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .filter-header {
            background: #1e2a3a;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 1.25rem;
            cursor: pointer;
            user-select: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: background 0.2s;
        }
        .filter-header:hover { background: #111827; }
        .filter-body {
            padding: 1.25rem;
            background: #ffffff;
            border-top: 1px solid #f1f5f9;
        }
        .filter-body label { color: #475569; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.4rem; }
        .filter-body .form-control,
        .filter-body .form-select {
            background: #ffffff;
            border: 1px solid #cbd5e1;
            color: #1e293b;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .filter-body .form-control::placeholder { color: #94a3b8; }
        .filter-body .form-control:focus,
        .filter-body .form-select:focus {
            background: #ffffff;
            border-color: #dc2626;
            color: #1e293b;
            box-shadow: 0 0 0 3px rgba(220,38,38,0.15);
        }

        /* Tab lọc trạng thái */
        .status-tabs { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; }
        .status-tab {
            padding: 0.38rem 0.9rem;
            border-radius: 20px;
            border: 2px solid #e2e8f0;
            background: #fff;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            color: #64748b;
            transition: all 0.18s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }
        .status-tab:hover { border-color: #dc2626; color: #dc2626; }
        .status-tab.active { background: #dc2626; border-color: #dc2626; color: #fff; }
        .status-tab.tab-wait.active   { background: #f59e0b; border-color: #f59e0b; }
        .status-tab.tab-done.active   { background: #10b981; border-color: #10b981; }
        .status-tab.tab-cancel.active { background: #6b7280; border-color: #6b7280; }
        .status-tab.tab-delivery.active { background: #3b82f6; border-color: #3b82f6; }

        /* Table */
        .table-card { border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.04); }
        .table-head-dark th {
            background: #1e2a3a;
            color: #e2e8f0;
            font-weight: 600;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 0.9rem 1rem;
            border: none;
        }
        .table-body-row td {
            padding: 0.85rem 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
        }
        .table-body-row:hover { background-color: #fef2f2; }
        .table-body-row:last-child td { border-bottom: none; }

        /* Badge trạng thái */
        .badge-wait     { background: #fef3c7; color: #92400e; }
        .badge-confirm  { background: #dbeafe; color: #1e40af; }
        .badge-shipping { background: #ede9fe; color: #5b21b6; }
        .badge-done     { background: #d1fae5; color: #065f46; }
        .badge-cancel   { background: #f1f5f9; color: #64748b; }
        .badge-refund   { background: #fee2e2; color: #991b1b; }

        .status-badge {
            display: inline-flex; align-items: center; gap: 0.3rem;
            padding: 0.28rem 0.65rem; border-radius: 20px;
            font-size: 0.78rem; font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="runmax-wrapper">
        <jsp:include page="/includes/sidebar.jsp" />
        <main class="runmax-main">
            <jsp:include page="/includes/header.jsp" />
            <div class="runmax-content">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">
                            <i class="bi bi-receipt-cutoff text-danger me-2"></i>Quản lý hoá đơn
                        </h4>
                        <p class="text-muted small mb-0">Theo dõi toàn bộ giao dịch bán hàng tại quầy POS.</p>
                    </div>
                </div>

                <c:if test="${not empty error && error == 'qr-not-found'}">
                    <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm rounded-3 mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill fs-5 text-warning"></i>
                        <div>
                            Không tìm thấy hóa đơn nào trong hệ thống ứng với mã QR: <strong>${fn:escapeXml(errorCode)}</strong>. Vui lòng kiểm tra lại!
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Bộ lọc tìm kiếm -->
                <div class="filter-card no-print" id="filterCard">
                    <div class="filter-header d-flex justify-content-between align-items-center" data-bs-toggle="collapse" data-bs-target="#filterBody">
                        <div>
                            <i class="bi bi-funnel-fill text-danger me-2"></i>Bộ lọc tìm kiếm
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <button type="button" class="btn btn-sm btn-danger fw-bold d-flex align-items-center gap-1 px-3 shadow-sm" onclick="event.stopPropagation(); openInvoiceLookupQRModal();" title="Quét mã QR tờ hóa đơn bằng Camera" style="border-radius: 6px;">
                                <i class="bi bi-qr-code-scan fs-6"></i> Quét QR Hóa Đơn
                            </button>
                            <small class="text-white-50">Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-down"></i></small>
                        </div>
                    </div>
                    <div class="collapse show" id="filterBody">
                        <form method="GET" action="${pageContext.request.contextPath}/hoa-don" class="filter-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-4">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="maHd" class="form-control" placeholder="Nhập mã hóa đơn / tên khách / SĐT..."
                                           value="${maHd != null ? maHd : ''}">
                                </div>
                                <div class="col-md-3">
                                    <label>Từ ngày</label>
                                    <input type="date" name="tuNgay" class="form-control" value="${tuNgay != null && not empty tuNgay ? tuNgay : (param.tuNgay == null ? java.time.LocalDate.now() : '')}">
                                </div>
                                <div class="col-md-3">
                                    <label>Đến ngày</label>
                                    <input type="date" name="denNgay" class="form-control" value="${denNgay != null ? denNgay : ''}">
                                </div>
                                <div class="col-md-2 d-flex gap-2">
                                    <button type="submit" class="btn btn-danger flex-fill fw-semibold shadow-sm">
                                        <i class="bi bi-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/hoa-don" class="btn btn-outline-secondary fw-semibold shadow-sm" title="Làm mới">
                                        <i class="bi bi-arrow-counterclockwise"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tab lọc nhanh theo trạng thái và nút hành động -->
                <div class="d-flex justify-content-between align-items-center mb-3 no-print">
                    <div class="status-tabs mb-0">
                        <a href="${pageContext.request.contextPath}/hoa-don" class="status-tab ${trangThai == null ? 'active' : ''}">
                            <i class="bi bi-list-ul"></i> Tất cả
                            <span class="badge bg-secondary ms-1">${fn:length(hoaDons)}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/hoa-don?trangThai=0${not empty maHd ? '&maHd='.concat(maHd) : ''}"
                           class="status-tab tab-wait ${trangThai == 0 ? 'active' : ''}">
                            <i class="bi bi-clock"></i> Đang chờ
                        </a>
                        <a href="${pageContext.request.contextPath}/hoa-don?trangThai=1${not empty maHd ? '&maHd='.concat(maHd) : ''}"
                           class="status-tab tab-done ${trangThai == 1 || trangThai == 3 ? 'active' : ''}">
                            <i class="bi bi-check-circle-fill"></i> Đã hoàn thành
                        </a>
                        <a href="${pageContext.request.contextPath}/hoa-don?trangThai=2${not empty maHd ? '&maHd='.concat(maHd) : ''}"
                           class="status-tab tab-cancel ${trangThai == 2 || trangThai >= 4 ? 'active' : ''}">
                            <i class="bi bi-x-circle-fill"></i> Đã hủy
                        </a>
                    </div>
                    <div class="d-flex gap-2 btn-actions">
                        <button class="btn btn-outline-success btn-sm fw-semibold" id="btnExcelHD">
                            <i class="bi bi-file-earmark-excel-fill me-1"></i>Xuất Excel
                        </button>
                        <button class="btn btn-outline-secondary btn-sm fw-semibold" onclick="window.print()">
                            <i class="bi bi-printer-fill me-1"></i>In danh sách
                        </button>
                        <a href="${pageContext.request.contextPath}/ban-hang" class="btn btn-runmax btn-sm">
                            <i class="bi bi-cart-plus-fill"></i> Mở quầy POS
                        </a>
                    </div>
                </div>

                <!-- Danh sách hóa đơn -->
                <div class="runmax-card table-card p-0">
                    <div class="p-3 d-flex align-items-center justify-content-between border-bottom no-print">
                        <div class="fw-semibold text-dark">
                            <i class="bi bi-file-text me-1 text-danger"></i>Danh sách hóa đơn
                            <span class="text-muted fw-normal small ms-1">– Lọc nhanh theo trạng thái</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table mb-0" id="tableHoaDon">
                            <thead>
                                <tr class="table-head-dark">
                                    <th>STT</th>
                                    <th>Mã hóa đơn</th>
                                    <th>Mã nhân viên</th>
                                    <th>Khách hàng</th>
                                    <th>Số điện thoại</th>

                                    <th>Tổng tiền</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty hoaDons}">
                                        <c:forEach var="hd" items="${hoaDons}" varStatus="loop">
                                            <tr class="table-body-row">
                                                <td class="text-muted fw-semibold">${loop.index + 1}</td>
                                                <td class="fw-bold text-danger">${hd.maHd}</td>
                                                <td>
                                                    <div class="fw-bold text-dark">${hd.nhanVien != null ? hd.nhanVien.maNv : '--'}</div>
                                                </td>
                                                <td class="fw-semibold">${hd.tenKhachHangHienThi}</td>
                                                <td>${hd.sdtHienThi}</td>

                                                <td class="fw-bold text-danger">${hd.tongTienFormatted}</td>
                                                <td class="text-muted small">${hd.ngayTaoFormatted}</td>
                                                <td>
                                                    <span class="${hd.badgeClass}">${hd.tenTrangThai}</span>
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/hoa-don?action=detail&id=${hd.id}"
                                                       class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/hoa-don?action=detail&id=${hd.id}&print=true"
                                                       target="_blank" class="btn btn-sm btn-outline-info" title="In hóa đơn">
                                                        <i class="bi bi-printer"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                                <div class="fw-semibold">Không có dữ liệu</div>
                                                <small>Chưa có hóa đơn nào phù hợp với bộ lọc.</small>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination info -->
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 border-top no-print">
                        <small class="text-muted">
                            Hiển thị <strong>${fn:length(hoaDons)}</strong> / tổng <strong>${totalRecords != null ? totalRecords : fn:length(hoaDons)}</strong> bản ghi
                        </small>
                        <div class="d-flex align-items-center gap-2">
                            <c:set var="filterParams" value=""/>
                            <c:if test="${not empty param.maHd}">
                                <c:set var="filterParams" value="${filterParams}&maHd=${param.maHd}"/>
                            </c:if>
                            <c:if test="${not empty param.trangThai}">
                                <c:set var="filterParams" value="${filterParams}&trangThai=${param.trangThai}"/>
                            </c:if>
                            <c:if test="${not empty param.tuNgay}">
                                <c:set var="filterParams" value="${filterParams}&tuNgay=${param.tuNgay}"/>
                            </c:if>
                            <c:if test="${not empty param.denNgay}">
                                <c:set var="filterParams" value="${filterParams}&denNgay=${param.denNgay}"/>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/hoa-don?page=${currentPage - 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-outline-secondary" disabled><i class="bi bi-chevron-left"></i></button>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages > 0 ? totalPages : 1}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="btn btn-sm btn-danger">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                            <a href="${pageContext.request.contextPath}/hoa-don?page=${i}${filterParams}" class="btn btn-sm btn-outline-secondary">${i}</a>
                                        </c:if>
                                        <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                            <span class="btn btn-sm btn-outline-secondary border-0" disabled>...</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/hoa-don?page=${currentPage + 1}${filterParams}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-outline-secondary" disabled><i class="bi bi-chevron-right"></i></button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <!-- SheetJS for Excel export -->
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script>
    // Xuất Excel với SheetJS
    document.getElementById('btnExcelHD').addEventListener('click', function () {
        const table = document.getElementById('tableHoaDon');
        if (!table) return;
        const wb = XLSX.utils.table_to_book(table, { sheet: 'Danh sách HĐ' });
        XLSX.writeFile(wb, 'HoaDon_RunMax_' + new Date().toLocaleDateString('vi-VN').replace(/\//g, '-') + '.xlsx');
    });
    </script>

    <!-- MODAL QUÉT QR TRA CỨU HÓA ĐƠN -->
    <div class="modal fade" id="modalScanQRHoaDon" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-danger text-white p-3">
                    <h5 class="modal-title fw-bold mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-qr-code-scan"></i> Quét QR Tra Cứu Hóa Đơn
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center bg-light">
                    <p class="text-muted small mb-3">Đưa tem mã QR trên phiếu in hóa đơn vào trước Webcam để tra cứu nhanh.</p>
                    <div id="qr-hd-camera-viewport" class="mx-auto border rounded-4 overflow-hidden shadow-sm bg-dark" style="width: 100%; max-width: 400px; min-height: 280px;"></div>
                    <div id="qr-hd-scan-status" class="mt-3 fw-bold text-primary small"></div>

                    <div class="mt-4 pt-3 border-top text-start">
                        <label class="form-label small fw-semibold text-secondary">Hoặc nhập tay Mã Hóa Đơn / dùng súng vạch:</label>
                        <div class="d-flex gap-2">
                            <input type="text" id="inputManualScanHD" class="form-control" placeholder="VD: HD172000... hoặc HD001...">
                            <button type="button" class="btn btn-runmax px-3 text-nowrap" onclick="if(document.getElementById('inputManualScanHD').value.trim()) { processScannedHoaDonCode(document.getElementById('inputManualScanHD').value.trim()); }">
                                <i class="bi bi-search"></i> Tra cứu
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white p-2 border-top d-flex justify-content-between">
                    <span class="small text-muted"><i class="bi bi-volume-up-fill me-1"></i>Tự động kêu Bíp & chuyển tới hóa đơn</span>
                    <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        let qrHdCameraScannerObj = null;

        function openInvoiceLookupQRModal() {
            const modalEl = document.getElementById('modalScanQRHoaDon');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
            startHdCameraScanQR();
        }

        function startHdCameraScanQR() {
            const statusEl = document.getElementById('qr-hd-scan-status');
            if (statusEl) statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-hourglass-split"></i> Đang khởi động camera...</span>';

            if (typeof Html5Qrcode === 'undefined') {
                if (statusEl) statusEl.innerHTML = '<span class="text-danger">Lỗi: Thư viện Html5Qrcode chưa tải được.</span>';
                return;
            }

            qrHdCameraScannerObj = new Html5Qrcode("qr-hd-camera-viewport");
            qrHdCameraScannerObj.start(
                { facingMode: "environment" },
                { fps: 10, qrbox: { width: 240, height: 240 } },
                (decodedText) => {
                    processScannedHoaDonCode(decodedText);
                },
                (err) => {}
            ).then(() => {
                if (statusEl) statusEl.innerHTML = '<span class="text-success"><i class="bi bi-camera-video-fill"></i> Camera đang quét... Đưa tem QR vào khung</span>';
            }).catch(err => {
                if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: ${err}. Bạn có thể nhập mã ở dưới.</span>`;
            });
        }

        function stopHdCameraScanQR() {
            if (qrHdCameraScannerObj) {
                qrHdCameraScannerObj.stop().then(() => {
                    qrHdCameraScannerObj.clear();
                    qrHdCameraScannerObj = null;
                }).catch(err => {
                    qrHdCameraScannerObj = null;
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const modalEl = document.getElementById('modalScanQRHoaDon');
            if (modalEl) {
                modalEl.addEventListener('hidden.bs.modal', function () {
                    stopHdCameraScanQR();
                });
            }
            const inputManual = document.getElementById('inputManualScanHD');
            if (inputManual) {
                inputManual.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' && inputManual.value.trim()) {
                        processScannedHoaDonCode(inputManual.value.trim());
                    }
                });
            }
        });

        function processScannedHoaDonCode(decodedText) {
            const code = (decodedText || '').toString().trim();
            if (!code) return;

            const statusEl = document.getElementById('qr-hd-scan-status');
            if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện: <b class="text-danger">${code}</b>`;

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

            stopHdCameraScanQR();
            window.location.href = '${pageContext.request.contextPath}/hoa-don?action=find-by-qr&code=' + encodeURIComponent(code);
        }
    </script>
</body>
</html>
