/* ============================================================================
   RunMax Address Helper - Quản lý Tỉnh/Thành phố, Quận/Huyện, Phường/Xã
   - Tự động lấy dữ liệu từ API provinces.open-api.vn
   - Lưu cache vào localStorage để tải siêu tốc (0ms) cho các lần sau
   - Dữ liệu fallback phong phú khi mất mạng hoặc API chậm
   - Tối ưu thao tác DOM bằng document.createElement('option') chống lỗi re-render
   ============================================================================ */

const RunMaxAddressHelper = (function () {
    const CACHE_KEY = "RUNMAX_PROVINCES_CACHE_V2";

    // Dữ liệu dự phòng phong phú (10 tỉnh thành lớn cùng các quận/huyện/phường/xã)
    const fallbackProvinces = [
        {
            name: "Thành phố Hà Nội",
            districts: [
                { name: "Quận Ba Đình", wards: [{ name: "Phường Phúc Xá" }, { name: "Phường Trúc Bạch" }, { name: "Phường Kim Mã" }, { name: "Phường Giảng Võ" }] },
                { name: "Quận Cầu Giấy", wards: [{ name: "Phường Quan Hoa" }, { name: "Phường Dịch Vọng" }, { name: "Phường Mai Dịch" }, { name: "Phường Trung Hòa" }] },
                { name: "Quận Đống Đa", wards: [{ name: "Phường Láng Hạ" }, { name: "Phường Ô Chợ Dừa" }, { name: "Phường Cát Linh" }, { name: "Phường Khâm Thiên" }] },
                { name: "Quận Hoàn Kiếm", wards: [{ name: "Phường Hàng Đào" }, { name: "Phường Hàng Trống" }, { name: "Phường Tràng Tiền" }, { name: "Phường Hàng Bài" }] },
                { name: "Quận Nam Từ Liêm", wards: [{ name: "Phường Mỹ Đình 1" }, { name: "Phường Mỹ Đình 2" }, { name: "Phường Cầu Diễn" }, { name: "Phường Mễ Trì" }] },
                { name: "Quận Thanh Xuân", wards: [{ name: "Phường Nhân Chính" }, { name: "Phường Khương Trung" }, { name: "Phường Thanh Xuân Bắc" }] },
                { name: "Quận Hà Đông", wards: [{ name: "Phường Quang Trung" }, { name: "Phường Mộ Lao" }, { name: "Phường Văn Quán" }, { name: "Phường Vạn Phúc" }] }
            ]
        },
        {
            name: "Thành phố Hồ Chí Minh",
            districts: [
                { name: "Quận 1", wards: [{ name: "Phường Bến Nghé" }, { name: "Phường Bến Thành" }, { name: "Phường Đa Kao" }, { name: "Phường Phạm Ngũ Lão" }] },
                { name: "Quận 3", wards: [{ name: "Phường Võ Thị Sáu" }, { name: "Phường 1" }, { name: "Phường 2" }, { name: "Phường 3" }] },
                { name: "Quận 7", wards: [{ name: "Phường Tân Phong" }, { name: "Phường Tân Phú" }, { name: "Phường Tân Quy" }, { name: "Phường Tân Thuận Đông" }] },
                { name: "Thành phố Thủ Đức", wards: [{ name: "Phường Thảo Điền" }, { name: "Phường An Phú" }, { name: "Phường Hiệp Bình Chánh" }, { name: "Phường Linh Trung" }] },
                { name: "Quận Bình Thạnh", wards: [{ name: "Phường 1" }, { name: "Phường 2" }, { name: "Phường 3" }, { name: "Phường 25" }] },
                { name: "Quận Gò Vấp", wards: [{ name: "Phường 1" }, { name: "Phường 3" }, { name: "Phường 5" }, { name: "Phường 7" }] }
            ]
        },
        {
            name: "Thành phố Đà Nẵng",
            districts: [
                { name: "Quận Hải Châu", wards: [{ name: "Phường Hải Châu 1" }, { name: "Phường Thạch Thang" }, { name: "Phường Thuận Phước" }] },
                { name: "Quận Sơn Trà", wards: [{ name: "Phường An Hải Bắc" }, { name: "Phường Phước Mỹ" }, { name: "Phường Thọ Quang" }] },
                { name: "Quận Thanh Khê", wards: [{ name: "Phường Vĩnh Trung" }, { name: "Phường Tân Chính" }, { name: "Phường Thạc Gián" }] }
            ]
        },
        {
            name: "Thành phố Hải Phòng",
            districts: [
                { name: "Quận Hồng Bàng", wards: [{ name: "Phường Minh Khai" }, { name: "Phường Hoàng Văn Thụ" }, { name: "Phường Phan Bội Châu" }] },
                { name: "Quận Lê Chân", wards: [{ name: "Phường An Biên" }, { name: "Phường Cát Dài" }, { name: "Phường Hàng Kênh" }] },
                { name: "Quận Ngô Quyền", wards: [{ name: "Phường Máy Tơ" }, { name: "Phường Lạch Tray" }, { name: "Phường Cầu Đất" }] }
            ]
        },
        {
            name: "Thành phố Cần Thơ",
            districts: [
                { name: "Quận Ninh Kiều", wards: [{ name: "Phường Tân An" }, { name: "Phường An Khánh" }, { name: "Phường Hưng Lợi" }] },
                { name: "Quận Bình Thủy", wards: [{ name: "Phường Bình Thủy" }, { name: "Phường Trà An" }, { name: "Phường An Thới" }] },
                { name: "Quận Cái Răng", wards: [{ name: "Phường Hưng Phú" }, { name: "Phường Lê Bình" }] }
            ]
        },
        {
            name: "Tỉnh Bình Dương",
            districts: [
                { name: "Thành phố Thủ Dầu Một", wards: [{ name: "Phường Phú Cường" }, { name: "Phường Hiệp Thành" }, { name: "Phường Chánh Nghĩa" }] },
                { name: "Thành phố Dĩ An", wards: [{ name: "Phường Dĩ An" }, { name: "Phường An Bình" }, { name: "Phường Tân Đông Hiệp" }] },
                { name: "Thành phố Thuận An", wards: [{ name: "Phường Lái Thiêu" }, { name: "Phường An Phú" }, { name: "Phường Bình Hòa" }] }
            ]
        },
        {
            name: "Tỉnh Đồng Nai",
            districts: [
                { name: "Thành phố Biên Hòa", wards: [{ name: "Phường Quyết Thắng" }, { name: "Phường Thống Nhất" }, { name: "Phường Tân Tiến" }, { name: "Phường Trảng Dài" }] },
                { name: "Thành phố Long Khánh", wards: [{ name: "Phường Xuân Trung" }, { name: "Phường Xuân Thanh" }, { name: "Phường Xuân An" }] }
            ]
        },
        {
            name: "Tỉnh Quảng Ninh",
            districts: [
                { name: "Thành phố Hạ Long", wards: [{ name: "Phường Bạch Đằng" }, { name: "Phường Hồng Gai" }, { name: "Phường Bãi Cháy" }, { name: "Phường Hùng Thắng" }] },
                { name: "Thành phố Cẩm Phả", wards: [{ name: "Phường Cẩm Trung" }, { name: "Phường Cẩm Thành" }] }
            ]
        },
        {
            name: "Tỉnh Khánh Hòa",
            districts: [
                { name: "Thành phố Nha Trang", wards: [{ name: "Phường Lộc Thọ" }, { name: "Phường Phước Tiến" }, { name: "Phường Tân Lập" }, { name: "Phường Vĩnh Nguyên" }] },
                { name: "Thành phố Cam Ranh", wards: [{ name: "Phường Cam Lộc" }, { name: "Phường Cam Lợi" }] }
            ]
        },
        {
            name: "Tỉnh Thừa Thiên Huế",
            districts: [
                { name: "Thành phố Huế", wards: [{ name: "Phường Vĩnh Ninh" }, { name: "Phường Phú Hội" }, { name: "Phường Xuân Phú" }, { name: "Phường Phước Vĩnh" }] }
            ]
        }
    ];

    let cachedProvinces = null;

    function getProvincesData(callback) {
        if (cachedProvinces && cachedProvinces.length > 0) {
            callback(cachedProvinces);
            return;
        }

        try {
            const localData = localStorage.getItem(CACHE_KEY);
            if (localData) {
                const parsed = JSON.parse(localData);
                if (Array.isArray(parsed) && parsed.length > 0) {
                    cachedProvinces = parsed;
                    callback(cachedProvinces);
                    // Vẫn tải ngầm để cập nhật cache mới nhất nếu cần
                    fetch("https://provinces.open-api.vn/api/?depth=3")
                        .then(res => res.json())
                        .then(data => {
                            if (Array.isArray(data) && data.length > 0) {
                                cachedProvinces = data;
                                localStorage.setItem(CACHE_KEY, JSON.stringify(data));
                            }
                        })
                        .catch(() => {});
                    return;
                }
            }
        } catch (e) {
            console.warn("Lỗi đọc cache localStorage:", e);
        }

        fetch("https://provinces.open-api.vn/api/?depth=3")
            .then(res => res.json())
            .then(data => {
                if (Array.isArray(data) && data.length > 0) {
                    cachedProvinces = data;
                    try {
                        localStorage.setItem(CACHE_KEY, JSON.stringify(data));
                    } catch (e) {}
                    callback(cachedProvinces);
                } else {
                    cachedProvinces = fallbackProvinces;
                    callback(cachedProvinces);
                }
            })
            .catch(err => {
                console.warn("API provinces.open-api.vn lỗi hoặc chậm, sử dụng dữ liệu fallback:", err);
                cachedProvinces = fallbackProvinces;
                callback(cachedProvinces);
            });
    }

    /**
     * Khởi tạo cascading select cho 3 ô Tỉnh/Thành - Quận/Huyện - Phường/Xã
     */
    function initCascading(options) {
        const provSelect = typeof options.provId === 'string' ? document.getElementById(options.provId) : options.provId;
        const distSelect = typeof options.distId === 'string' ? document.getElementById(options.distId) : options.distId;
        const wardSelect = typeof options.wardId === 'string' ? document.getElementById(options.wardId) : options.wardId;

        if (!provSelect || !distSelect || !wardSelect) return;

        const useIndexAsValue = !!options.useIndexAsValue;
        const oldProv = options.oldProv || "";
        const oldDist = options.oldDist || "";
        const oldWard = options.oldWard || "";

        getProvincesData(function (data) {
            // Populate provinces
            provSelect.innerHTML = "";
            const defaultProvOpt = document.createElement("option");
            defaultProvOpt.value = "";
            defaultProvOpt.textContent = "-- Chọn Tỉnh/Thành phố --";
            provSelect.appendChild(defaultProvOpt);

            const provFragment = document.createDocumentFragment();
            data.forEach((prov, idx) => {
                const opt = document.createElement("option");
                opt.value = useIndexAsValue ? idx : prov.name;
                opt.textContent = prov.name;

                // Kiểm tra pre-select
                if (oldProv && (
                    (useIndexAsValue && String(oldProv) === String(idx)) ||
                    (!useIndexAsValue && prov.name.toLowerCase().includes(oldProv.toLowerCase()))
                )) {
                    opt.selected = true;
                }
                provFragment.appendChild(opt);
            });
            provSelect.appendChild(provFragment);

            // Trigger change nếu đã có giá trị chọn sẵn
            if (provSelect.value !== "") {
                handleProvChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, oldDist, oldWard);
            } else {
                resetSelect(distSelect, "-- Chọn Quận/Huyện --", true);
                resetSelect(wardSelect, "-- Chọn Phường/Xã/Đặc khu --", true);
            }

            // Gắn event listener
            provSelect.addEventListener("change", function () {
                handleProvChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, "", "");
                if (typeof options.onProvChange === "function") options.onProvChange(provSelect.value);
            });

            distSelect.addEventListener("change", function () {
                handleDistChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, "");
                if (typeof options.onDistChange === "function") options.onDistChange(distSelect.value);
            });
        });
    }

    function resetSelect(selectEl, defaultText, disabled) {
        if (!selectEl) return;
        selectEl.innerHTML = "";
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = defaultText;
        selectEl.appendChild(opt);
        selectEl.disabled = disabled;
    }

    function handleProvChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, oldDist, oldWard) {
        resetSelect(distSelect, "-- Chọn Quận/Huyện --", true);
        resetSelect(wardSelect, "-- Chọn Phường/Xã/Đặc khu --", true);

        const provVal = provSelect.value;
        if (provVal === "") return;

        let provObj = null;
        if (useIndexAsValue) {
            provObj = data[provVal];
        } else {
            provObj = data.find(p => p.name === provVal);
        }

        if (!provObj || !provObj.districts || provObj.districts.length === 0) return;

        distSelect.innerHTML = "";
        const defaultDistOpt = document.createElement("option");
        defaultDistOpt.value = "";
        defaultDistOpt.textContent = "-- Chọn Quận/Huyện --";
        distSelect.appendChild(defaultDistOpt);

        const distFragment = document.createDocumentFragment();
        provObj.districts.forEach((dist, idx) => {
            const opt = document.createElement("option");
            opt.value = useIndexAsValue ? idx : dist.name;
            opt.textContent = dist.name;

            if (oldDist && (
                (useIndexAsValue && String(oldDist) === String(idx)) ||
                (!useIndexAsValue && dist.name.toLowerCase().includes(oldDist.toLowerCase()))
            )) {
                opt.selected = true;
            }
            distFragment.appendChild(opt);
        });
        distSelect.appendChild(distFragment);
        distSelect.disabled = false;

        if (distSelect.value !== "") {
            handleDistChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, oldWard);
        }
    }

    function handleDistChange(provSelect, distSelect, wardSelect, data, useIndexAsValue, oldWard) {
        resetSelect(wardSelect, "-- Chọn Phường/Xã/Đặc khu --", true);

        const provVal = provSelect.value;
        const distVal = distSelect.value;
        if (provVal === "" || distVal === "") return;

        let provObj = null;
        let distObj = null;
        if (useIndexAsValue) {
            provObj = data[provVal];
            if (provObj && provObj.districts) distObj = provObj.districts[distVal];
        } else {
            provObj = data.find(p => p.name === provVal);
            if (provObj && provObj.districts) distObj = provObj.districts.find(d => d.name === distVal);
        }

        if (!distObj || !distObj.wards || distObj.wards.length === 0) return;

        wardSelect.innerHTML = "";
        const defaultWardOpt = document.createElement("option");
        defaultWardOpt.value = "";
        defaultWardOpt.textContent = "-- Chọn Phường/Xã/Đặc khu --";
        wardSelect.appendChild(defaultWardOpt);

        const wardFragment = document.createDocumentFragment();
        distObj.wards.forEach((ward, idx) => {
            const opt = document.createElement("option");
            opt.value = useIndexAsValue ? idx : ward.name;
            opt.textContent = ward.name;

            if (oldWard && (
                (useIndexAsValue && String(oldWard) === String(idx)) ||
                (!useIndexAsValue && ward.name.toLowerCase().includes(oldWard.toLowerCase()))
            )) {
                opt.selected = true;
            }
            wardFragment.appendChild(opt);
        });
        wardSelect.appendChild(wardFragment);
        wardSelect.disabled = false;
    }

    // Tự động khởi tạo cho các trang mẫu trong tai-khoan/... (id="tinhThanhPho", "quanHuyen", "phuongXa")
    document.addEventListener("DOMContentLoaded", function () {
        if (document.getElementById("tinhThanhPho") && document.getElementById("quanHuyen") && document.getElementById("phuongXa")) {
            // Kiểm tra xem trang có oldTinh/oldHuyen/oldXa hay option được pre-selected không
            const provEl = document.getElementById("tinhThanhPho");
            const distEl = document.getElementById("quanHuyen");
            const wardEl = document.getElementById("phuongXa");

            // Lấy giá trị selected ban đầu nếu có (trang chi-tiet.jsp)
            const oldProvText = provEl.options[provEl.selectedIndex] && provEl.value !== "" ? provEl.options[provEl.selectedIndex].text : "";
            const oldDistText = distEl.options[distEl.selectedIndex] && distEl.value !== "" ? distEl.options[distEl.selectedIndex].text : "";
            const oldWardText = wardEl.options[wardEl.selectedIndex] && wardEl.value !== "" ? wardEl.options[wardEl.selectedIndex].text : "";

            initCascading({
                provId: "tinhThanhPho",
                distId: "quanHuyen",
                wardId: "phuongXa",
                oldProv: oldProvText || provEl.getAttribute("data-old-value") || "",
                oldDist: oldDistText || distEl.getAttribute("data-old-value") || "",
                oldWard: oldWardText || wardEl.getAttribute("data-old-value") || "",
                useIndexAsValue: false
            });
        }
    });

    return {
        initCascading: initCascading,
        getProvincesData: getProvincesData
    };
})();
