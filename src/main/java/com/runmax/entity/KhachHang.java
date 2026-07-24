package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity KhachHang – ánh xạ bảng khach_hang.
 */
@Entity
@Table(name = "khach_hang")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class KhachHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_kh", nullable = false, unique = true, length = 50)
    private String maKh;

    @Column(name = "ho_ten", nullable = false, length = 100)
    private String hoTen;

    @Column(name = "sdt", length = 20)
    private String sdt;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "ngay_sinh")
    private java.time.LocalDate ngaySinh;

    @Column(name = "gioi_tinh", nullable = false)
    @Builder.Default
    private Integer gioiTinh = 1; // 1: Nam, 0: Nữ

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    private String diaChiMacDinh;

    @Transient
    public String getNgaySinhFormatted() {
        if (ngaySinh == null) return "";
        return ngaySinh.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    @Transient
    public String getGioiTinhHienThi() {
        if (gioiTinh == null) return "Nam";
        return gioiTinh == 1 ? "Nam" : "Nữ";
    }

    @Transient
    public String getDiaChi() {
        return diaChiMacDinh != null ? diaChiMacDinh : "Chưa cập nhật";
    }
}
