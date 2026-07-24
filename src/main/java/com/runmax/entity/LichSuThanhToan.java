package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity LichSuThanhToan – ánh xạ bảng lich_su_thanh_toan.
 * Ghi lại các lần thanh toán của 1 hóa đơn (có thể thanh toán nhiều lần).
 */
@Entity
@Table(name = "lich_su_thanh_toan")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LichSuThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "pttt_id", nullable = false)
    private PhuongThucThanhToan phuongThucThanhToan;

    @Column(name = "so_tien", nullable = false, precision = 18, scale = 2)
    private BigDecimal soTien;

    @Column(name = "ma_giao_dich", length = 100)
    private String maGiaoDich;

    @Column(name = "ngay_thanh_toan", nullable = false)
    @Builder.Default
    private LocalDateTime ngayThanhToan = LocalDateTime.now();

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
