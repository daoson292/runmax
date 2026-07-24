package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Entity HoaDonChiTiet – ánh xạ bảng hoa_don_chi_tiet.
 * FK spct_id trỏ tới SanPhamChiTiet (đúng theo ERD).
 */
@Entity
@Table(name = "hoa_don_chi_tiet")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class HoaDonChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "spct_id", nullable = false)
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "so_luong", nullable = false)
    @Builder.Default
    private Integer soLuong = 1;

    @Column(name = "don_gia", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal donGia = BigDecimal.ZERO;

    @Column(name = "thanh_tien", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal thanhTien = BigDecimal.ZERO;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
