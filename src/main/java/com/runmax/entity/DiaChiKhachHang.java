package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity DiaChiKhachHang – ánh xạ bảng dia_chi_khach_hang.
 */
@Entity
@Table(name = "dia_chi_khach_hang")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class DiaChiKhachHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "khach_hang_id", nullable = false)
    private KhachHang khachHang;

    @Column(name = "dia_chi_chi_tiet", nullable = false, length = 255)
    private String diaChiChiTiet;

    @Column(name = "phuong_xa", nullable = false, length = 100)
    private String phuongXa;

    @Column(name = "quan_huyen", length = 100)
    private String quanHuyen;

    @Column(name = "tinh_thanh_pho", nullable = false, length = 100)
    private String tinhThanhPho;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;  // 1: Mặc định, 0: Thường

    @Transient
    public String getDiaChiDayDu() {
        StringBuilder sb = new StringBuilder();
        if (diaChiChiTiet != null && !diaChiChiTiet.isEmpty()) sb.append(diaChiChiTiet);
        if (phuongXa != null && !phuongXa.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(phuongXa);
        }
        if (quanHuyen != null && !quanHuyen.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(quanHuyen);
        }
        if (tinhThanhPho != null && !tinhThanhPho.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(tinhThanhPho);
        }
        return sb.toString();
    }
}
