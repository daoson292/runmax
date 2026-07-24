package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity PhieuGiamGia – ánh xạ bảng phieu_giam_gia.
 * loai_giam: 1 = Giảm %, 2 = Giảm số tiền cố định.
 */
@Entity
@Table(name = "phieu_giam_gia")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class PhieuGiamGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_phieu", nullable = false, unique = true, length = 50)
    private String maPhieu;

    @Column(name = "ten_phieu", nullable = false, length = 200)
    private String tenPhieu;

    @Column(name = "loai_phieu", nullable = false)
    @Builder.Default
    private Integer loaiPhieu = 1;  // 1: Công khai, 2: Cá nhân

    @Column(name = "loai_giam", nullable = false)
    @Builder.Default
    private Integer loaiGiam = 1;  // 1: %, 2: Số tiền

    @Column(name = "gia_tri_giam", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaTrigiam;

    @Column(name = "giam_toi_da", precision = 18, scale = 2)
    private BigDecimal giamToiDa;

    @Column(name = "dieu_kien_giam", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal dieuKienGiam = BigDecimal.ZERO;

    @Column(name = "so_luong", nullable = false)
    @Builder.Default
    private Integer soLuong = 0;

    @Column(name = "mo_ta", length = 500)
    private String moTa;

    @Column(name = "ngay_bat_dau", nullable = false)
    private LocalDateTime ngayBatDau;

    @Column(name = "ngay_ket_thuc", nullable = false)
    private LocalDateTime ngayKetThuc;

    /**
     * Trạng thái tự động dựa theo thời gian:
     *  0: Sắp diễn ra (chưa tới ngày bắt đầu)
     *  1: Đang áp dụng (trong khoảng thời gian hiệu lực)
     *  2: Đã hết hạn (quá ngày kết thúc)
     *  3: Vô hiệu hóa thủ công
     */
    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 0;

    /**
     * Tính toán trạng thái hiện tại dựa theo thời gian thực.
     * Dùng khi hiển thị UI – không persist vào DB.
     */
    @Transient
    public int getTrangThaiDong() {
        if (trangThai == 3) return 3; // Bị vô hiệu hóa thủ công
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (ngayBatDau != null && now.isBefore(ngayBatDau)) return 0; // Sắp diễn ra
        if (ngayKetThuc != null && now.isAfter(ngayKetThuc)) return 2; // Hết hạn
        if (soLuong != null && soLuong <= 0) return 2; // Hết lượt
        return 1; // Đang áp dụng
    }
}
