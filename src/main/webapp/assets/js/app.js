/* ============================================
   RunMax Admin Dashboard - JavaScript
   ============================================ */

document.addEventListener('DOMContentLoaded', function () {

    // === Sidebar Toggle (Submenu expand/collapse) ===
    // Để Bootstrap 5 tự xử lý collapse qua data-bs-toggle="collapse", tránh xung đột toggle 2 lần (lúc được lúc không).
    // Chỉ lắng nghe event native của Bootstrap để đồng bộ trạng thái aria-expanded và xoay mũi tên.
    const collapseElements = document.querySelectorAll('.sidebar-submenu, #submenuSanPham, #submenuThuocTinh');
    collapseElements.forEach(function (submenu) {
        submenu.addEventListener('show.bs.collapse', function () {
            const parentLink = document.querySelector(`[href="#${this.id}"], [data-bs-target="#${this.id}"]`);
            if (parentLink) {
                parentLink.setAttribute('aria-expanded', 'true');
                const arrow = parentLink.querySelector('.chevron-icon, .menu-arrow');
                if (arrow) arrow.classList.add('rotated');
            }
        });
        submenu.addEventListener('hide.bs.collapse', function () {
            const parentLink = document.querySelector(`[href="#${this.id}"], [data-bs-target="#${this.id}"]`);
            if (parentLink) {
                parentLink.setAttribute('aria-expanded', 'false');
                const arrow = parentLink.querySelector('.chevron-icon, .menu-arrow');
                if (arrow) arrow.classList.remove('rotated');
            }
        });
    });

    // === Quantity Control (+ / - buttons) ===
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('qty-btn')) {
            const action = e.target.getAttribute('data-action');
            const input = e.target.parentElement.querySelector('.qty-value');

            if (input) {
                let val = parseInt(input.value) || 0;

                if (action === 'increase') {
                    val++;
                } else if (action === 'decrease' && val > 0) {
                    val--;
                }

                input.value = val;
            }
        }
    });

    // === Tab switching ===
    const tabLinks = document.querySelectorAll('.tab-link');
    tabLinks.forEach(function (tab) {
        tab.addEventListener('click', function () {
            // Remove active from siblings
            const parent = this.closest('.nav-tabs-custom');
            if (parent) {
                parent.querySelectorAll('.tab-link').forEach(function (t) {
                    t.classList.remove('active');
                });
            }
            this.classList.add('active');
        });
    });

    // === Dark mode toggle placeholder ===
    const darkModeBtn = document.getElementById('darkModeToggle');
    if (darkModeBtn) {
        darkModeBtn.addEventListener('click', function () {
            // Placeholder: future dark mode implementation
            console.log('Dark mode toggle clicked');
        });
    }

    // === Search form - Làm mới (Reset) ===
    const resetBtns = document.querySelectorAll('.btn-reset');
    resetBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const form = this.closest('.content-card');
            if (form) {
                const inputs = form.querySelectorAll('input, select');
                inputs.forEach(function (input) {
                    if (input.type === 'text' || input.type === 'search' || input.type === 'date') {
                        input.value = '';
                    }
                    if (input.tagName === 'SELECT') {
                        input.selectedIndex = 0;
                    }
                });
            }
        });
    });

    // === Mobile sidebar toggle ===
    const sidebarToggleBtn = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');

    if (sidebarToggleBtn && sidebar) {
        sidebarToggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }

    // === Mock Interactive Feedback for Admin Forms (Voucher & Account) ===
    const btnSubmitList = document.querySelectorAll('#btnThemVoucher, #btnThemNhanVien, #btnThemKhachHang');
    btnSubmitList.forEach(btn => {
        btn.addEventListener('click', function () {
            showBootstrapAlert('Đã thêm mới thành công!', 'success');
            setTimeout(() => window.history.back(), 1000);
        });
    });

    const btnUpdateList = document.querySelectorAll('#btnCapNhat');
    btnUpdateList.forEach(btn => {
        btn.addEventListener('click', function () {
            showBootstrapAlert('Cập nhật thông tin thành công!', 'success');
        });
    });

    const btnDeactivateList = document.querySelectorAll('#btnNgungHoatDong');
    btnDeactivateList.forEach(btn => {
        btn.addEventListener('click', function () {
            showBootstrapConfirm('Bạn có chắc chắn muốn ngừng hoạt động tài khoản/phiếu giảm giá này?', function() {
                showBootstrapAlert('Đã chuyển sang trạng thái: Ngừng hoạt động!', 'warning');
            });
        });
    });

    const btnActivateList = document.querySelectorAll('#btnHoatDong');
    btnActivateList.forEach(btn => {
        btn.addEventListener('click', function () {
            showBootstrapAlert('Đã kích hoạt hoạt động thành công!', 'success');
        });
    });

    const btnResetPwd = document.getElementById('btnCaiLaiMatKhau');
    if (btnResetPwd) {
        btnResetPwd.addEventListener('click', function () {
            showBootstrapConfirm('Khôi phục mật khẩu mặc định (123456) cho tài khoản này?', function() {
                showBootstrapAlert('Đã cài lại mật khẩu thành công!', 'success');
            });
        });
    }

});
