package com.runmax.service;

import com.runmax.entity.*;
import com.runmax.repository.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Hóa Đơn Service Layer (Business Logic xử lý Hóa Đơn & Thanh toán).
// Keyword search GG: "Java Service Layer Business Logic", "Hibernate Transaction Management"
// Nhiệm vụ: Tính tổng tiền hàng, áp dụng voucher giảm %, cập nhật trạng thái đã thanh toán (1) và tự động TRỪ KHO giày tương ứng.
public class HoaDonService {
    private final HoaDonRepository hdRepo       = new HoaDonRepository();
    private final LichSuThanhToanRepository lsttRepo = new LichSuThanhToanRepository();
    private final SanPhamChiTietRepository  spctRepo = new SanPhamChiTietRepository();
    private final KhachHangRepository       khRepo   = new KhachHangRepository();

    public List<HoaDon> findAll(String maHd, Integer trangThai,
                                 LocalDateTime tuNgay, LocalDateTime denNgay) {
        return hdRepo.findAll(maHd, trangThai, tuNgay, denNgay);
    }

    public List<HoaDon> getAll(String keyword, Integer trangThai) {
        return hdRepo.findAll(keyword, trangThai, null, null);
    }

    public HoaDon findById(Long id)        { return hdRepo.findById(id); }
    public HoaDon getById(Long id)         { return hdRepo.findById(id); }
    public HoaDon findByMaHd(String maHd)  { return hdRepo.findByMaHd(maHd); }

    public boolean create(String maHd, BigDecimal tongTien, String ghiChu) {
        HoaDon hd = HoaDon.builder()
            .maHd(maHd)
            .tongTien(tongTien)
            .ghiChu(ghiChu)
            .trangThai(1)
            .ngayTao(LocalDateTime.now())
            .build();
        return hdRepo.save(hd) != null;
    }

    public boolean updateStatus(Long id, Integer status) {
        return updateStatus(id, status, "Hệ thống", null);
    }

    public boolean updateStatus(Long id, Integer status, String nguoiThaoTac, String ghiChu) {
        HoaDon hd = hdRepo.findById(id);
        if (hd == null) return false;
        hd.setTrangThai(status);
        if (ghiChu != null && !ghiChu.trim().isEmpty()) {
            hd.setGhiChu(ghiChu.trim());
        }
        boolean ok = hdRepo.update(hd);
        if (ok) {
            LichSuHoaDon lshd = LichSuHoaDon.builder()
                .hoaDon(hd)
                .nguoiThaoTac(nguoiThaoTac != null ? nguoiThaoTac : "Quản lý")
                .hanhDong("Chuyển trạng thái sang " + hd.getTenTrangThai() + (ghiChu != null && !ghiChu.trim().isEmpty() ? " - Lý do: " + ghiChu.trim() : ""))
                .build();
            hdRepo.saveLichSu(lshd);
        }
        return ok;
    }

    public List<HoaDon> findPendingByNhanVien(Long nvId) {
        return hdRepo.findPendingByNhanVien(nvId);
    }

    public List<HoaDon> findAllPending() {
        return hdRepo.findAllPending();
    }

    public List<HoaDonChiTiet> findChiTiet(Long hoaDonId) {
        return hdRepo.findChiTietByHoaDonId(hoaDonId);
    }

    public List<LichSuThanhToan> findLichSuTT(Long hoaDonId) {
        return lsttRepo.findByHoaDonId(hoaDonId);
    }

    public List<LichSuHoaDon> findLichSuHD(Long hoaDonId) {
        return hdRepo.findLichSuByHoaDonId(hoaDonId);
    }

    /** Tạo hóa đơn trống (POS) */
    public HoaDon taoHoaDon(NhanVien nhanVien) {
        HoaDon hd = HoaDon.builder()
            .nhanVien(nhanVien)
            .maHd(hdRepo.getNextMaHd())
            .trangThai(0)
            .ngayTao(java.time.LocalDateTime.now())
            .tienHang(java.math.BigDecimal.ZERO)
            .soTienGiam(java.math.BigDecimal.ZERO)
            .tongTien(java.math.BigDecimal.ZERO)
            .build();
        return hdRepo.save(hd);
    }

    /** Thêm nhiều sản phẩm cùng lúc từ giỏ hàng nháp */
    public boolean themNhieuSanPham(Long hoaDonId, java.util.List<Long> spctIds, java.util.List<Integer> soLuongs) {
        if (spctIds == null || soLuongs == null || spctIds.size() != soLuongs.size()) return false;
        boolean anySuccess = false;
        for (int i = 0; i < spctIds.size(); i++) {
            boolean ok = themSanPham(hoaDonId, spctIds.get(i), soLuongs.get(i));
            if (ok) anySuccess = true;
        }
        return anySuccess;
    }

    /** Thêm sản phẩm vào giỏ (hóa đơn) */
    public boolean themSanPham(Long hoaDonId, Long spctId, int soLuong) {
        HoaDon hd = hdRepo.findById(hoaDonId);
        SanPhamChiTiet spct = spctRepo.findById(spctId);
        if (hd == null || spct == null || spct.getSoLuongKhaDung() < soLuong) return false;

        // Tìm xem đã có trong giỏ chưa
        List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
        for (HoaDonChiTiet ct : chiTiets) {
            if (ct.getSanPhamChiTiet().getId().equals(spctId)) {
                int moi = ct.getSoLuong() + soLuong;
                ct.setSoLuong(moi);
                ct.setThanhTien(spct.getGiaBan().multiply(BigDecimal.valueOf(moi)));
                hdRepo.saveChiTiet(ct);
                spctRepo.updateSoLuong(spctId, -soLuong); // Update real stock
                recalculateTotal(hd, chiTiets);
                return true;
            }
        }

        HoaDonChiTiet ct = HoaDonChiTiet.builder()
            .hoaDon(hd)
            .sanPhamChiTiet(spct)
            .soLuong(soLuong)
            .donGia(spct.getGiaBan())
            .thanhTien(spct.getGiaBan().multiply(BigDecimal.valueOf(soLuong)))
            .build();
        hdRepo.saveChiTiet(ct);
        spctRepo.updateSoLuong(spctId, -soLuong); // Update real stock
        chiTiets.add(ct);
        recalculateTotal(hd, chiTiets);
        return true;
    }

    /** Xóa sản phẩm khỏi giỏ */
    public boolean xoaSanPham(Long chiTietId) {
        HoaDonChiTiet ct = hdRepo.findChiTietById(chiTietId);
        if (ct == null) return false;
        Long hoaDonId = ct.getHoaDon().getId();
        boolean ok = hdRepo.deleteChiTiet(chiTietId);
        if (ok) {
            spctRepo.updateSoLuong(ct.getSanPhamChiTiet().getId(), ct.getSoLuong()); // Restore stock
            HoaDon hd = hdRepo.findById(hoaDonId);
            if (hd != null) {
                List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
                recalculateTotal(hd, chiTiets);
            }
        }
        return ok;
    }

    /** Cập nhật số lượng sản phẩm trong giỏ POS */
    public boolean capNhatSoLuong(Long chiTietId, int soLuongMoi) {
        if (soLuongMoi <= 0) {
            return xoaSanPham(chiTietId);
        }
        HoaDonChiTiet ct = hdRepo.findChiTietById(chiTietId);
        if (ct == null || ct.getSanPhamChiTiet() == null) return false;
        
        SanPhamChiTiet spct = spctRepo.findById(ct.getSanPhamChiTiet().getId());
        if (spct == null) return false;
        
        int oldSoLuong = ct.getSoLuong();
        int maxAllowed = spct.getSoLuongKhaDung() + oldSoLuong;
        
        if (soLuongMoi > maxAllowed) {
            return false;
        }
        int diff = soLuongMoi - oldSoLuong;
        spctRepo.updateSoLuong(spct.getId(), -diff); // Update real stock
        ct.setSoLuong(soLuongMoi);
        ct.setThanhTien(ct.getDonGia().multiply(BigDecimal.valueOf(soLuongMoi)));
        hdRepo.saveChiTiet(ct);
        HoaDon hd = ct.getHoaDon();
        if (hd != null) {
            List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hd.getId());
            recalculateTotal(hd, chiTiets);
        }
        return true;
    }

    /** Xóa hoàn toàn hóa đơn */
    public boolean deleteHoaDon(Long hoaDonId) {
        HoaDon hd = hdRepo.findById(hoaDonId);
        if (hd == null) return false;
        // Hoàn lại kho nếu chưa bị hủy (0 hoặc 1)
        if (hd.getTrangThai() == 0 || hd.getTrangThai() == 1) {
            List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
            for (HoaDonChiTiet ct : chiTiets) {
                if (ct.getSanPhamChiTiet() != null) {
                    spctRepo.updateSoLuong(ct.getSanPhamChiTiet().getId(), ct.getSoLuong());
                }
            }
        }
        return hdRepo.deleteHoaDon(hoaDonId);
    }

    /** Áp dụng phiếu giảm giá vào hóa đơn POS */
    public boolean apDungPhieuGiamGia(Long hoaDonId, Long phieuGiamGiaId) {
        HoaDon hd = hdRepo.findById(hoaDonId);
        if (hd == null) return false;

        if (phieuGiamGiaId == null || phieuGiamGiaId <= 0) {
            hd.setPhieuGiamGia(null);
            hd.setSoTienGiam(BigDecimal.ZERO);
        } else {
            PhieuGiamGia phieu = new PhieuGiamGiaRepository().findById(phieuGiamGiaId);
            if (phieu == null) return false;

            List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
            BigDecimal total = chiTiets.stream()
                .map(HoaDonChiTiet::getThanhTien)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            if (phieu.getDieuKienGiam() != null && total.compareTo(phieu.getDieuKienGiam()) < 0) {
                return false;
            }

            hd.setPhieuGiamGia(phieu);
        }
        List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
        recalculateTotal(hd, chiTiets);
        return true;
    }

    /** Thanh toán hóa đơn */
    public boolean thanhToan(Long hoaDonId, Long ptttId, Long phieuGiamGiaId,
                              Long khachHangId,
                              PhuongThucThanhToan pttt, PhieuGiamGia phieu,
                              String nguoiThaoTac) {
        HoaDon hd = hdRepo.findById(hoaDonId);
        if (hd == null || hd.getTrangThai() != 0) return false;

        List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
        if (chiTiets.isEmpty()) return false;

        // Tính tổng
        BigDecimal tienHang = chiTiets.stream()
            .map(HoaDonChiTiet::getThanhTien)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (phieu == null && phieuGiamGiaId != null && phieuGiamGiaId > 0) {
            phieu = new PhieuGiamGiaRepository().findById(phieuGiamGiaId);
        }
        if (phieu == null && hd.getPhieuGiamGia() != null) {
            phieu = hd.getPhieuGiamGia();
        }

        BigDecimal soTienGiam = BigDecimal.ZERO;
        if (phieu != null) {
            if (phieu.getDieuKienGiam() != null && tienHang.compareTo(phieu.getDieuKienGiam()) >= 0) {
                if (phieu.getLoaiGiam() == 1) {
                    // Giảm %
                    soTienGiam = tienHang.multiply(phieu.getGiaTrigiam()).divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
                    if (phieu.getGiamToiDa() != null && soTienGiam.compareTo(phieu.getGiamToiDa()) > 0) {
                        soTienGiam = phieu.getGiamToiDa();
                    }
                } else {
                    soTienGiam = phieu.getGiaTrigiam();
                }
                hd.setPhieuGiamGia(phieu);
            } else {
                hd.setPhieuGiamGia(null);
                soTienGiam = BigDecimal.ZERO;
            }
        }

        BigDecimal tongTien = tienHang.subtract(soTienGiam);
        if (tongTien.compareTo(BigDecimal.ZERO) < 0) tongTien = BigDecimal.ZERO;

        hd.setTienHang(tienHang);
        hd.setSoTienGiam(soTienGiam);
        hd.setTongTien(tongTien);
        hd.setTrangThai(1);

        // Gắn Khách Hàng vào hóa đơn nếu có ID (từ API hoặc form truyền lên)
        if (khachHangId != null) {
            KhachHang kh = khRepo.findById(khachHangId);
            if (kh != null) {
                hd.setKhachHang(kh);
            }
        }
        // FIX BUG: KHÔNG force setKhachHang(null) nếu khachHangId == null ở bước này.
        // Vì bên BanHangServlet đã xử lý logic Khách Lẻ (khi sdt rỗng) và Khách Quen (map qua sdt) 
        // rồi gọi repository.update() trước khi vào hàm thanhToan() này.
        
        hdRepo.update(hd);

        // Trừ kho đã thực hiện khi thêm sản phẩm vào giỏ hàng

        // Ghi lịch sử thanh toán
        LichSuThanhToan lstt = LichSuThanhToan.builder()
            .hoaDon(hd)
            .phuongThucThanhToan(pttt)
            .soTien(tongTien)
            .build();
        lsttRepo.save(lstt);

        // Ghi lịch sử hóa đơn
        LichSuHoaDon lshd = LichSuHoaDon.builder()
            .hoaDon(hd)
            .nguoiThaoTac(nguoiThaoTac)
            .hanhDong("Thanh toán hóa đơn " + hd.getMaHd() + " - " + tongTien + "đ")
            .build();
        hdRepo.saveLichSu(lshd);

        return true;
    }

    /** Hủy hóa đơn */
    public boolean huyHoaDon(Long hoaDonId, String nguoiThaoTac, String lyDo) {
        HoaDon hd = hdRepo.findById(hoaDonId);
        if (hd == null) return false;
        hd.setTrangThai(2);
        hd.setGhiChu(lyDo);
        hdRepo.update(hd);

        // Hoàn lại kho cho các sản phẩm
        List<HoaDonChiTiet> chiTiets = hdRepo.findChiTietByHoaDonId(hoaDonId);
        for (HoaDonChiTiet ct : chiTiets) {
            if (ct.getSanPhamChiTiet() != null) {
                spctRepo.updateSoLuong(ct.getSanPhamChiTiet().getId(), ct.getSoLuong());
            }
        }

        LichSuHoaDon lshd = LichSuHoaDon.builder()
            .hoaDon(hd)
            .nguoiThaoTac(nguoiThaoTac)
            .hanhDong("Hủy hóa đơn: " + lyDo)
            .build();
        hdRepo.saveLichSu(lshd);
        return true;
    }

    /** Tự động hủy hóa đơn chờ quá hạn 24h */
    public int cancelExpiredPendingInvoices() {
        List<HoaDon> pendingList = hdRepo.findAllPending();
        LocalDateTime twentyFourHoursAgo = LocalDateTime.now().minusHours(24);
        int count = 0;
        for (HoaDon hd : pendingList) {
            if (hd.getNgayTao() != null && hd.getNgayTao().isBefore(twentyFourHoursAgo)) {
                // Kiểm tra lịch sử thanh toán, nếu đã có tiền trả thì KHÔNG hủy
                BigDecimal tongDaTra = lsttRepo.tinhTongTienDaTra(hd.getId());
                if (tongDaTra != null && tongDaTra.compareTo(BigDecimal.ZERO) > 0) {
                    continue; // Bỏ qua, không hủy
                }
                
                huyHoaDon(hd.getId(), "Hệ Thống", "Tự động hủy hóa đơn chờ quá 24h");
                count++;
            }
        }
        return count;
    }

    private void recalculateTotal(HoaDon hd, List<HoaDonChiTiet> chiTiets) {
        BigDecimal total = chiTiets.stream()
            .map(HoaDonChiTiet::getThanhTien)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        hd.setTienHang(total);

        BigDecimal soTienGiam = BigDecimal.ZERO;
        PhieuGiamGia phieu = hd.getPhieuGiamGia();
        if (phieu != null) {
            if (phieu.getDieuKienGiam() != null && total.compareTo(phieu.getDieuKienGiam()) >= 0) {
                if (phieu.getLoaiGiam() == 1) {
                    soTienGiam = total.multiply(phieu.getGiaTrigiam()).divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
                    if (phieu.getGiamToiDa() != null && soTienGiam.compareTo(phieu.getGiamToiDa()) > 0) {
                        soTienGiam = phieu.getGiamToiDa();
                    }
                } else {
                    soTienGiam = phieu.getGiaTrigiam();
                }
            } else {
                hd.setPhieuGiamGia(null);
            }
        } else if (hd.getSoTienGiam() != null) {
            soTienGiam = hd.getSoTienGiam();
        }
        hd.setSoTienGiam(soTienGiam);

        BigDecimal tongTien = total.subtract(soTienGiam);
        if (tongTien.compareTo(BigDecimal.ZERO) < 0) tongTien = BigDecimal.ZERO;
        hd.setTongTien(tongTien);

        hdRepo.update(hd);
    }
}
