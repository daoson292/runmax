package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entity SanPhamChiTiet – ánh xạ bảng san_pham_chi_tiet (SKU biến thể).
 * Mỗi SKU = 1 tổ hợp (SanPham + MauSac + KichCo + DeGiay).
 */
@Entity
@Table(name = "san_pham_chi_tiet")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class SanPhamChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "san_pham_id", nullable = false)
    private SanPham sanPham;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "mau_sac_id", nullable = false)
    private MauSac mauSac;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "kich_co_id", nullable = false)
    private KichCo kichCo;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "de_giay_id", nullable = false)
    private DeGiay deGiay;

    @Column(name = "gia_goc", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal giaGoc = BigDecimal.ZERO;

    @Column(name = "gia_ban", nullable = false, precision = 18, scale = 2)
    @Builder.Default
    private BigDecimal giaBan = BigDecimal.ZERO;

    @Column(name = "so_luong_ton", nullable = false)
    @Builder.Default
    private Integer soLuongTon = 0;

    @Column(name = "anh_dai_dien", length = 255)
    private String anhDaiDien;

    @Column(name = "ngay_tao", nullable = false)
    @Builder.Default
    private LocalDate ngayTao = LocalDate.now();

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    public Integer getSoLuongKhaDung() {
        return this.soLuongTon;
    }

    @Transient
    public String getMaSpct() {
        return "SPCT" + String.format("%05d", id != null ? id : 0);
    }
}
