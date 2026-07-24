package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity HoaDon – ánh xạ bảng hoa_don.
 * Trạng thái: 0=Chờ thanh toán, 1=Đã thanh toán, 2=Đã hủy
 */
@Entity
@Table(name = "hoa_don")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class HoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "khach_hang_id", nullable = true)
    private KhachHang khachHang;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "nhan_vien_id", nullable = false)
    private NhanVien nhanVien;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "phieu_giam_gia_id", nullable = true)
    private PhieuGiamGia phieuGiamGia;

    @Column(name = "ma_hd", nullable = false, unique = true, length = 50)
    private String maHd;

    @Column(name = "ten_khach_hang", length = 100)
    private String tenKhachHang;

    @Column(name = "sdt", length = 20)
    private String sdt;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "tien_hang", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal tienHang = BigDecimal.ZERO;

    @Column(name = "so_tien_giam", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal soTienGiam = BigDecimal.ZERO;

    @Column(name = "tong_tien", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal tongTien = BigDecimal.ZERO;

    @Column(name = "ghi_chu", length = 500)
    private String ghiChu;

    @Column(name = "ngay_tao", nullable = false)
    @Builder.Default
    private LocalDateTime ngayTao = LocalDateTime.now();

    /**
     * 0: Đang chờ
     * 1: Đã hoàn thành
     * 2: Đã hủy
     */
    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 0;

    @OneToMany(mappedBy = "hoaDon", fetch = FetchType.LAZY)
    private java.util.List<LichSuHoaDon> lichSuHoaDons;

    // ==========================================
    // CÁC HÀM HELPER FORMAT TRONG ENTITY (MVC)
    // Phục vụ cho View (JSP), Xuất PDF và Excel
    // ==========================================

    /**
     * Lấy tên trạng thái hóa đơn dạng text rõ ràng.
     */
    @Transient
    public String getTenTrangThai() {
        if (trangThai == null) return "Không xác định";
        return switch (trangThai) {
            case 0 -> "Đang chờ";
            case 1, 3 -> "Đã hoàn thành";
            case 2, 4, 5, 6 -> "Đã hủy";
            default -> "Khác (" + trangThai + ")";
        };
    }

    /**
     * Lấy class CSS / Badge chuẩn cho giao diện JSP theo trạng thái.
     */
    @Transient
    public String getBadgeClass() {
        if (trangThai == null) return "status-badge badge-cancel";
        return switch (trangThai) {
            case 0 -> "status-badge badge-wait";
            case 1, 3 -> "status-badge badge-done";
            case 2, 4, 5, 6 -> "status-badge badge-cancel";
            default -> "status-badge badge-cancel";
        };
    }

    /**
     * Format định dạng tiền tổng (VD: 1,500,000 đ) phục vụ hiển thị JSP, in PDF, xuất Excel.
     */
    @Transient
    public String getTongTienFormatted() {
        if (tongTien == null) return "0 đ";
        return String.format("%,d đ", tongTien.longValue());
    }

    /**
     * Format định dạng tiền hàng (VD: 1,500,000 đ).
     */
    @Transient
    public String getTienHangFormatted() {
        if (tienHang == null) return "0 đ";
        return String.format("%,d đ", tienHang.longValue());
    }

    /**
     * Format định dạng số tiền giảm (VD: 100,000 đ).
     */
    @Transient
    public String getSoTienGiamFormatted() {
        if (soTienGiam == null) return "0 đ";
        return String.format("%,d đ", soTienGiam.longValue());
    }

    /**
     * Format định dạng ngày tạo (VD: 14:30 15/07/2026).
     */
    @Transient
    public String getNgayTaoFormatted() {
        if (ngayTao == null) return "";
        return ngayTao.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
    }

    /**
     * Lấy tên khách hàng hiển thị (ưu tiên tên lưu trên hóa đơn, sau đó đến object Khách Hàng, nếu null thì là Khách lẻ).
     */
    @Transient
    public String getTenKhachHangHienThi() {
        if (tenKhachHang != null && !tenKhachHang.trim().isEmpty()) {
            return tenKhachHang;
        }
        if (khachHang != null && khachHang.getHoTen() != null && !khachHang.getHoTen().trim().isEmpty()) {
            return khachHang.getHoTen();
        }
        return "Khách lẻ";
    }

    /**
     * Lấy số điện thoại hiển thị.
     */
    @Transient
    public String getSdtHienThi() {
        if (sdt != null && !sdt.trim().isEmpty()) {
            return sdt;
        }
        if (khachHang != null && khachHang.getSdt() != null && !khachHang.getSdt().trim().isEmpty()) {
            return khachHang.getSdt();
        }
        return "--";
    }
}
