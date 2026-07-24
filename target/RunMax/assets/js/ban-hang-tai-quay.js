/**
 * RunMax Admin - Bán Hàng Tại Quầy (POS) Interactive Logic
 * Handles tab navigation, mock product cart, dynamic totals calculation,
 * discount vouchers, payment confirmation, and receipt generation.
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. STATE MANAGEMENT
    let invoices = {
        'HDMKTI': {
            title: 'Hóa đơn HDMKTI',
            customer: 'khach-le',
            voucher: 'KM002',
            discount: 500000,
            paymentMethod: 'tien-mat',
            items: [
                {
                    id: 'SP01',
                    name: 'Nike Air Zoom Pegasus 40',
                    variant: 'Đỏ / Size 42',
                    price: 2500000,
                    qty: 1,
                    img: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100&q=80'
                },
                {
                    id: 'SP02',
                    name: 'Adidas Ultraboost Light',
                    variant: 'Trắng / Size 41',
                    price: 3200000,
                    qty: 1,
                    img: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=100&q=80'
                }
            ]
        },
        'HDSLA1': {
            title: 'Hóa đơn HDSLA1',
            customer: 'KH001',
            voucher: '',
            discount: 0,
            paymentMethod: 'chuyen-khoan',
            items: [
                {
                    id: 'SP05',
                    name: 'Asics Gel-Nimbus 26',
                    variant: 'Xám / Size 42',
                    price: 4200000,
                    qty: 1,
                    img: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=100&q=80'
                }
            ]
        }
    };

    let activeInvoiceId = 'HDMKTI';

    // Helper: Format currency
    function formatMoney(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
    }

    // Helper: Get current date formatted
    function getCurrentDateTime() {
        const now = new Date();
        const pad = n => n < 10 ? '0' + n : n;
        return `${pad(now.getDate())}/${pad(now.getMonth() + 1)}/${now.getFullYear()} ${pad(now.getHours())}:${pad(now.getMinutes())}`;
    }

    // 2. RENDER FUNCTIONS
    function renderTabs() {
        const tabsContainer = document.getElementById('invoiceTabs');
        if (!tabsContainer) return;
        tabsContainer.innerHTML = '';

        Object.keys(invoices).forEach(id => {
            const btn = document.createElement('button');
            btn.className = `pos-tab ${id === activeInvoiceId ? 'active' : ''}`;
            btn.setAttribute('data-id', id);
            btn.innerHTML = `${id} <span class="tab-close" title="Xóa hóa đơn">&times;</span>`;

            // Click tab to switch
            btn.addEventListener('click', (e) => {
                if (e.target.classList.contains('tab-close')) {
                    e.stopPropagation();
                    deleteInvoice(id);
                } else {
                    switchInvoice(id);
                }
            });

            tabsContainer.appendChild(btn);
        });
    }

    function renderActiveInvoice() {
        const invoice = invoices[activeInvoiceId];
        if (!invoice) return;

        // Title
        const titleEl = document.getElementById('currentInvoiceTitle');
        if (titleEl) titleEl.textContent = invoice.title;

        // Customer
        const customerSelect = document.getElementById('selectCustomer');
        if (customerSelect) {
            customerSelect.value = invoice.customer || 'khach-le';
            if (window.jQuery && $(customerSelect).hasClass('select2-hidden-accessible')) {
                $(customerSelect).trigger('change.select2'); // Sync Select2 UI without triggering our custom change event logic loop
            }
        } // Voucher input
        const voucherInput = document.getElementById('inputVoucherCode');
        if (voucherInput) voucherInput.value = invoice.voucher || '';

        // Payment method radios
        const radios = document.querySelectorAll('input[name="paymentMethod"]');
        radios.forEach(radio => {
            radio.checked = (radio.value === invoice.paymentMethod);
        });

        // Cart table
        const tbody = document.getElementById('cartTableBody');
        if (!tbody) return;

        if (invoice.items.length === 0) {
            tbody.innerHTML = `<tr><td colspan="7"><div class="pos-cart-empty">Chưa có sản phẩm nào trong hóa đơn này.<br><small>Nhấn "Thêm Sản Phẩm" để chọn giày vào đơn hàng.</small></div></td></tr>`;
        } else {
            tbody.innerHTML = '';
            invoice.items.forEach((item, index) => {
                const tr = document.createElement('tr');
                tr.setAttribute('data-id', item.id);
                tr.innerHTML = `
                    <td>
                        <div class="product-cell">
                            <img src="${item.img}" alt="${item.name}">
                            <div class="product-info">
                                <h4>${item.name}</h4>
                                <p>${item.variant}</p>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="qty-control-pos">
                            <button type="button" class="qty-btn-pos btn-minus" data-index="${index}">-</button>
                            <input type="text" class="qty-value-pos" value="${item.qty}" readonly>
                            <button type="button" class="qty-btn-pos btn-plus" data-index="${index}">+</button>
                        </div>
                    </td>
                    <td>${Math.floor(Math.random() * 30) + 10}</td>
                    <td class="price-col">${formatMoney(item.price)}</td>
                    <td class="price-col">${formatMoney(item.price)}</td>
                    <td class="total-col item-total">${formatMoney(item.price * item.qty)}</td>
                    <td>
                        <button type="button" class="btn-delete" data-index="${index}" title="Xóa sản phẩm">
                            <i class="bi bi-trash3-fill"></i>
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }

        // Attach event listeners for Qty and Delete buttons
        tbody.querySelectorAll('.btn-minus').forEach(btn => {
            btn.addEventListener('click', () => {
                const idx = parseInt(btn.getAttribute('data-index'));
                if (invoice.items[idx].qty > 1) {
                    invoice.items[idx].qty--;
                } else {
                    invoice.items.splice(idx, 1);
                }
                renderActiveInvoice();
            });
        });

        tbody.querySelectorAll('.btn-plus').forEach(btn => {
            btn.addEventListener('click', () => {
                const idx = parseInt(btn.getAttribute('data-index'));
                invoice.items[idx].qty++;
                renderActiveInvoice();
            });
        });

        tbody.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', () => {
                const idx = parseInt(btn.getAttribute('data-index'));
                invoice.items.splice(idx, 1);
                renderActiveInvoice();
            });
        });

        calculateTotals();
    }

    function calculateTotals() {
        const invoice = invoices[activeInvoiceId];
        if (!invoice) return;

        let subtotal = 0;
        invoice.items.forEach(item => {
            subtotal += item.price * item.qty;
        });

        // Determine discount based on voucher input
        let discount = 0;
        const voucherVal = invoice.voucher.trim().toUpperCase();
        const voucherCard = document.getElementById('activeVoucherCard');

        if (voucherVal === 'KM002' || voucherVal === 'KM500') {
            discount = 500000;
            if (voucherCard) voucherCard.style.display = 'block';
        } else if (voucherVal === 'KM001' || voucherVal === 'KM10') {
            discount = Math.min(subtotal * 0.1, 500000);
            if (voucherCard) voucherCard.style.display = 'block';
        } else {
            discount = invoice.discount || 0;
            if (voucherCard && discount === 0) voucherCard.style.display = 'none';
        }

        if (subtotal === 0) discount = 0;
        const total = Math.max(0, subtotal - discount);

        // Update summary elements
        const subtotalEl = document.getElementById('summarySubtotal');
        const discountEl = document.getElementById('summaryDiscount');
        const totalEl = document.getElementById('summaryTotal');

        if (subtotalEl) subtotalEl.textContent = formatMoney(subtotal);
        if (discountEl) discountEl.textContent = discount > 0 ? `-${formatMoney(discount)}` : '0đ';
        if (totalEl) totalEl.textContent = formatMoney(total);
    }

    // 3. TAB SWITCH & DELETE LOGIC
    function switchInvoice(id) {
        if (!invoices[id]) return;
        activeInvoiceId = id;
        renderTabs();
        renderActiveInvoice();
    }

    function deleteInvoice(id) {
        const keys = Object.keys(invoices);
        if (keys.length <= 1) {
            showBootstrapAlert('Không thể xóa hóa đơn cuối cùng!', 'warning');
            return;
        }

        delete invoices[id];
        if (activeInvoiceId === id) {
            activeInvoiceId = Object.keys(invoices)[0];
        }
        renderTabs();
        renderActiveInvoice();
    }

    // Create new invoice
    const btnCreateInvoice = document.getElementById('btnCreateInvoice');
    if (btnCreateInvoice) {
        btnCreateInvoice.addEventListener('click', () => {
            const randomCode = 'HD' + Math.random().toString(36).substring(2, 6).toUpperCase();
            invoices[randomCode] = {
                title: `Hóa đơn ${randomCode}`,
                customer: 'khach-le',
                voucher: '',
                discount: 0,
                paymentMethod: 'tien-mat',
                items: []
            };
            switchInvoice(randomCode);
        });
    }

    // 4. MODALS & INTERACTIONS
    // Modal Add Product
    const modalAddProduct = document.getElementById('modalAddProduct');
    const btnOpenAddProduct = document.getElementById('btnOpenAddProduct');
    const btnCloseAddProduct = document.getElementById('btnCloseAddProduct');

    if (btnOpenAddProduct && modalAddProduct) {
        btnOpenAddProduct.addEventListener('click', () => {
            modalAddProduct.classList.add('show');
        });
    }

    if (btnCloseAddProduct && modalAddProduct) {
        btnCloseAddProduct.addEventListener('click', () => {
            modalAddProduct.classList.remove('show');
        });
    }

    // Modal QR Scanner (Webcam)
    const modalQRScanner = document.getElementById('modalQRScanner');
    const btnOpenQRScanner = document.getElementById('btnOpenQRScanner');
    const btnCloseQRScanner = document.getElementById('btnCloseQRScanner');

    if (btnOpenQRScanner && modalQRScanner) {
        btnOpenQRScanner.addEventListener('click', () => {
            modalQRScanner.classList.add('show');
            startCameraQRScanner();
        });
    }

    if (btnCloseQRScanner && modalQRScanner) {
        btnCloseQRScanner.addEventListener('click', () => {
            modalQRScanner.classList.remove('show');
            stopCameraQRScanner();
        });
    }

    // Clicking product item in Modal adds to invoice
    const productGrid = document.getElementById('productGrid');
    if (productGrid) {
        productGrid.querySelectorAll('.product-select-item').forEach(item => {
            item.addEventListener('click', () => {
                const id = item.getAttribute('data-id');
                const name = item.getAttribute('data-name');
                const price = parseFloat(item.getAttribute('data-price'));
                const img = item.getAttribute('data-img');
                const colorSelect = item.querySelector('.select-color');
                const sizeSelect = item.querySelector('.select-size');
                
                const color = colorSelect ? colorSelect.value.replace('Màu: ', '') : 'Mặc định';
                const size = sizeSelect ? sizeSelect.value : '40';
                const variant = `Màu: ${color} | Size: ${size}`;

                const invoice = invoices[activeInvoiceId];
                // Check if item already exists in cart
                const existing = invoice.items.find(i => i.id === id && i.variant === variant);
                if (existing) {
                    existing.qty++;
                } else {
                    invoice.items.push({
                        id: id,
                        name: name,
                        variant: variant,
                        price: price,
                        qty: 1,
                        img: img
                    });
                }

                modalAddProduct.classList.remove('show');
                renderActiveInvoice();
            });
        });
    }

    // Voucher Input Change
    const inputVoucher = document.getElementById('inputVoucherCode');
    if (inputVoucher) {
        inputVoucher.addEventListener('input', (e) => {
            invoices[activeInvoiceId].voucher = e.target.value;
            calculateTotals();
        });
    }

    // 4.1. Initialize Select2 & Add Customer Modal
    if (window.jQuery) {
        $('#selectCustomer').select2({
            placeholder: "Tìm kiếm khách hàng...",
            allowClear: false,
            width: '100%',
            language: {
                noResults: function() {
                    return "Không tìm thấy khách hàng";
                }
            },
            ajax: {
                url: '/api/customers/search',
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    return {
                        term: params.term || ''
                    };
                },
                processResults: function (data) {
                    return {
                        results: data.results
                    };
                },
                cache: true
            }
        }).on('change', function(e) {
            if (invoices[activeInvoiceId]) {
                invoices[activeInvoiceId].customer = $(this).val();
            }
        });
    } else {
        const selectCustomer = document.getElementById('selectCustomer');
        if (selectCustomer) {
            selectCustomer.addEventListener('change', (e) => {
                invoices[activeInvoiceId].customer = e.target.value;
            });
        }
    }

    const modalAddCustomer = document.getElementById('modalAddCustomer');
    const btnOpenAddCustomer = document.getElementById('btnOpenAddCustomer');
    const btnCloseAddCustomer = document.getElementById('btnCloseAddCustomer');
    const btnCancelAddCustomer = document.getElementById('btnCancelAddCustomer');
    const btnSaveCustomer = document.getElementById('btnSaveCustomer');

    if (btnOpenAddCustomer && modalAddCustomer) {
        btnOpenAddCustomer.addEventListener('click', () => {
            modalAddCustomer.classList.add('show');
        });
    }

    const closeAddCustomerModal = () => {
        modalAddCustomer.classList.remove('show');
        document.getElementById('newCustomerName').value = '';
        document.getElementById('newCustomerPhone').value = '';
    };

    if (btnCloseAddCustomer) btnCloseAddCustomer.addEventListener('click', closeAddCustomerModal);
    if (btnCancelAddCustomer) btnCancelAddCustomer.addEventListener('click', closeAddCustomerModal);

    if (btnSaveCustomer) {
        btnSaveCustomer.addEventListener('click', () => {
            const name = document.getElementById('newCustomerName').value.trim();
            const phone = document.getElementById('newCustomerPhone').value.trim();
            if (!name || !phone) {
                if (typeof showToast === 'function') showToast('Vui lòng nhập đầy đủ Tên và SĐT!', 'danger');
                else alert('Vui lòng nhập đầy đủ Tên và SĐT!');
                return;
            }
            
            btnSaveCustomer.disabled = true;
            btnSaveCustomer.textContent = 'Đang lưu...';

            // Call API to save customer
            fetch('/api/customers/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'name': name,
                    'phone': phone
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Add to select2
                    if (window.jQuery) {
                        const newOption = new Option(data.text, data.id, true, true);
                        $('#selectCustomer').append(newOption).trigger('change');
                    } else {
                        const select = document.getElementById('selectCustomer');
                        const opt = document.createElement('option');
                        opt.value = data.id;
                        opt.text = data.text;
                        opt.selected = true;
                        select.appendChild(opt);
                        invoices[activeInvoiceId].customer = data.id;
                    }
                    
                    if (typeof showToast === 'function') showToast('Thêm khách hàng thành công!', 'success');
                    closeAddCustomerModal();
                } else {
                    if (typeof showToast === 'function') showToast(data.message || 'Có lỗi xảy ra', 'danger');
                    else alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error adding customer:', error);
                if (typeof showToast === 'function') showToast('Lỗi mạng, vui lòng thử lại', 'danger');
                else alert('Lỗi mạng, vui lòng thử lại');
            })
            .finally(() => {
                btnSaveCustomer.disabled = false;
                btnSaveCustomer.textContent = 'Lưu';
            });
        });
    }

    // Payment Method Change
    const radioMethods = document.querySelectorAll('input[name="paymentMethod"]');
    radioMethods.forEach(radio => {
        radio.addEventListener('change', (e) => {
            if (e.target.checked) {
                invoices[activeInvoiceId].paymentMethod = e.target.value;
            }
        });
    });

    // 5. PAYMENT & RECEIPT WORKFLOW
    const btnPay = document.getElementById('btnPay');
    const modalConfirmPayment = document.getElementById('modalConfirmPayment');
    const btnCancelConfirm = document.getElementById('btnCancelConfirm');
    const btnAgreePayment = document.getElementById('btnAgreePayment');
    const modalReceipt = document.getElementById('modalReceipt');
    const btnFinishReceipt = document.getElementById('btnFinishReceipt');

    if (btnPay) {
        btnPay.addEventListener('click', () => {
            const invoice = invoices[activeInvoiceId];
            if (invoice.items.length === 0) {
                showBootstrapAlert('Vui lòng thêm ít nhất 1 sản phẩm trước khi thanh toán!', 'danger');
                return;
            }

            const totalTxt = document.getElementById('summaryTotal').textContent;
            document.getElementById('confirmInvoiceCode').textContent = activeInvoiceId;
            document.getElementById('confirmTotalAmount').textContent = totalTxt;

            modalConfirmPayment.classList.add('show');
        });
    }

    if (btnCancelConfirm) {
        btnCancelConfirm.addEventListener('click', () => {
            modalConfirmPayment.classList.remove('show');
        });
    }

    if (btnAgreePayment) {
        btnAgreePayment.addEventListener('click', () => {
            modalConfirmPayment.classList.remove('show');

            // Populate receipt data
            const invoice = invoices[activeInvoiceId];
            document.getElementById('receiptCode').textContent = activeInvoiceId;
            document.getElementById('receiptDate').textContent = getCurrentDateTime();
            
            const custSelect = document.getElementById('selectCustomer');
            const custText = custSelect ? custSelect.options[custSelect.selectedIndex].text : 'Khách lẻ';
            document.getElementById('receiptCustomer').textContent = custText;

            const methodMap = {
                'tien-mat': 'Tiền mặt',
                'chuyen-khoan': 'Chuyển khoản',
                'ca-hai': 'Tiền mặt & Chuyển khoản'
            };
            document.getElementById('receiptPaymentMethod').textContent = methodMap[invoice.paymentMethod] || 'Tiền mặt';

            // Populate items table
            const receiptTbody = document.getElementById('receiptTableBody');
            receiptTbody.innerHTML = '';
            let subtotal = 0;

            invoice.items.forEach(item => {
                const itemTotal = item.price * item.qty;
                subtotal += itemTotal;
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${item.name}<br><small style="color: #666;">${item.variant}</small></td>
                    <td style="text-align: center;">${item.qty}</td>
                    <td style="text-align: right;">${formatMoney(item.price)}</td>
                    <td style="text-align: right;">${formatMoney(itemTotal)}</td>
                `;
                receiptTbody.appendChild(tr);
            });

            const discountTxt = document.getElementById('summaryDiscount').textContent;
            const totalTxt = document.getElementById('summaryTotal').textContent;

            document.getElementById('receiptSubtotal').textContent = formatMoney(subtotal);
            document.getElementById('receiptDiscount').textContent = discountTxt;
            document.getElementById('receiptGrandTotal').textContent = totalTxt;

            modalReceipt.classList.add('show');
        });
    }

    if (btnFinishReceipt) {
        btnFinishReceipt.addEventListener('click', () => {
            modalReceipt.classList.remove('show');
            // Remove paid invoice and switch
            deleteInvoice(activeInvoiceId);
        });
    }

    // Close modals on overlay click
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                overlay.classList.remove('show');
                if (overlay.id === 'modalQRScanner') {
                    stopCameraQRScanner();
                }
            }
        });
    });

    /* ─── XỬ LÝ QUÉT MÃ QR BẰNG WEBCAM / CAMERA TẠI QUẦY POS ─── */
    let html5QrCodeScannerInstance = null;

    function startCameraQRScanner() {
        const statusEl = document.getElementById('qr-reader-status');
        if (statusEl) statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-hourglass-split"></i> Đang khởi động camera...</span>';

        if (typeof Html5Qrcode === 'undefined') {
            if (statusEl) statusEl.innerHTML = '<span class="text-danger">Lỗi: Không tải được thư viện Html5Qrcode. Vui lòng kiểm tra kết nối mạng!</span>';
            return;
        }

        html5QrCodeScannerInstance = new Html5Qrcode("qr-reader");
        html5QrCodeScannerInstance.start(
            { facingMode: "environment" }, // Ưu tiên camera sau (hoặc webcam laptop)
            {
                fps: 10,
                qrbox: { width: 250, height: 250 }
            },
            (decodedText, decodedResult) => {
                // Khi quét được mã thành công
                handleQRScanSuccess(decodedText);
            },
            (errorMessage) => {
                // Quét liên tục chưa thấy mã thì bỏ qua
            }
        ).then(() => {
            if (statusEl) statusEl.innerHTML = '<span class="text-success"><i class="bi bi-camera-video-fill"></i> Camera đang hoạt động - Đưa mã QR vào khung</span>';
        }).catch(err => {
            if (statusEl) statusEl.innerHTML = `<span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Không thể mở Camera: ${err}. Bạn có thể nhập mã hoặc chọn mẫu bên dưới.</span>`;
        });
    }

    function stopCameraQRScanner() {
        if (html5QrCodeScannerInstance) {
            html5QrCodeScannerInstance.stop().then(() => {
                html5QrCodeScannerInstance.clear();
                html5QrCodeScannerInstance = null;
            }).catch(err => {
                console.error("Lỗi dừng camera:", err);
                html5QrCodeScannerInstance = null;
            });
        }
    }

    function handleQRScanSuccess(decodedText) {
        const code = (decodedText || '').toString().trim().toUpperCase();
        if (!code) return;

        // Hiển thị trạng thái mã nhận được
        const statusEl = document.getElementById('qr-reader-status');
        if (statusEl) statusEl.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i> Đã nhận diện mã: <b class="text-danger">${code}</b>`;

        const invoice = invoices[activeInvoiceId];
        if (!invoice) return;

        // Tìm trong productGrid trước
        let foundItem = null;
        const productGrid = document.getElementById('productGrid');
        if (productGrid) {
            productGrid.querySelectorAll('.product-select-item').forEach(item => {
                const id = item.getAttribute('data-id');
                if (id && id.toUpperCase() === code) {
                    const name = item.getAttribute('data-name');
                    const price = parseFloat(item.getAttribute('data-price'));
                    const img = item.getAttribute('data-img');
                    const colorSelect = item.querySelector('.select-color');
                    const sizeSelect = item.querySelector('.select-size');
                    const color = colorSelect ? colorSelect.value.replace('Màu: ', '') : 'Mặc định';
                    const size = sizeSelect ? sizeSelect.value : '40';
                    foundItem = {
                        id: id,
                        name: name,
                        variant: `Màu: ${color} | Size: ${size}`,
                        price: price,
                        img: img
                    };
                }
            });
        }

        // Nếu không có trong productGrid, tra từ điển mẫu SKU hoặc tạo nhanh theo mã quét
        if (!foundItem) {
            const skuDatabase = {
                'SPCT1': { name: 'Nike Air Zoom Pegasus 40 (SKU #1)', variant: 'Màu: Đỏ | Size: 41', price: 2500000, img: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100&q=80' },
                'SPCT2': { name: 'Adidas Ultraboost Light (SKU #2)', variant: 'Màu: Trắng | Size: 42', price: 3200000, img: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=100&q=80' },
                'SPCT3': { name: 'Nike Vaporfly 3 (SKU #3)', variant: 'Màu: Xanh | Size: 40', price: 6500000, img: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=200&q=80' },
                'SPCT4': { name: 'Adidas Adizero Adios Pro 3 (SKU #4)', variant: 'Màu: Đen | Size: 39', price: 6000000, img: 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=200&q=80' },
                'SPCT5': { name: 'Asics Gel-Nimbus 26 (SKU #5)', variant: 'Màu: Xám | Size: 43', price: 4200000, img: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=200&q=80' }
            };

            if (skuDatabase[code]) {
                foundItem = { id: code, ...skuDatabase[code] };
            } else if (code.startsWith('SPCT') || code.startsWith('SP')) {
                foundItem = {
                    id: code,
                    name: `Giày chạy bộ chính hãng (${code})`,
                    variant: 'Màu: Tiêu chuẩn | Size: 42',
                    price: 2800000,
                    img: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100&q=80'
                };
            }
        }

        if (foundItem) {
            const existing = invoice.items.find(i => i.id === foundItem.id && i.variant === foundItem.variant);
            if (existing) {
                existing.qty++;
            } else {
                invoice.items.push({ ...foundItem, qty: 1 });
            }

            renderActiveInvoice();

            // Âm thanh giả lập Bíp báo nhận diện thành công
            try {
                const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.connect(gain);
                gain.connect(audioCtx.destination);
                osc.frequency.value = 1300;
                gain.gain.value = 0.12;
                osc.start();
                setTimeout(() => osc.stop(), 130);
            } catch (e) {}

            if (typeof showToast === 'function') {
                showToast(`Đã nhận QR: Thêm "${foundItem.name}" vào hóa đơn!`, 'success');
            }
        } else {
            if (typeof showToast === 'function') {
                showToast(`Không tìm thấy thông tin cho mã QR: ${code}`, 'danger');
            } else {
                alert(`Không tìm thấy thông tin cho mã QR: ${code}`);
            }
        }
    }

    // Gán ra window để gọi từ inline onclick của các badge test mẫu / gõ tay
    window.handleQRScanSuccess = handleQRScanSuccess;

    const btnSubmitManualSKU = document.getElementById('btnSubmitManualSKU');
    const inputManualSKU = document.getElementById('inputManualSKU');
    if (btnSubmitManualSKU && inputManualSKU) {
        btnSubmitManualSKU.addEventListener('click', () => {
            if (inputManualSKU.value.trim()) {
                handleQRScanSuccess(inputManualSKU.value.trim());
                inputManualSKU.value = '';
            }
        });
        inputManualSKU.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && inputManualSKU.value.trim()) {
                handleQRScanSuccess(inputManualSKU.value.trim());
                inputManualSKU.value = '';
            }
        });
    }

    // INITIALIZE
    renderTabs();
    renderActiveInvoice();
});
