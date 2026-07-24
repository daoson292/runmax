package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

/**
 * Entity NhanVien – ánh xạ bảng nhan_vien.
 * Dùng cho đăng nhập, quản lý nhân viên, và liên kết hóa đơn.
 */
@Entity
@Table(name = "nhan_vien")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class NhanVien {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "vai_tro_id", nullable = false)
    private VaiTro vaiTro;

    @Column(name = "ma_nv", nullable = false, unique = true, length = 50)
    private String maNv;

    @Column(name = "ho_ten", nullable = false, length = 100)
    private String hoTen;

    @Column(name = "gioi_tinh")
    @Builder.Default
    private Boolean gioiTinh = true;  // true = Nam, false = Nữ

    @Column(name = "ngay_sinh")
    private LocalDate ngaySinh;

    @Column(name = "sdt", length = 20)
    private String sdt;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "phuong_xa", length = 100)
    private String phuongXa;

    @Column(name = "quan_huyen", length = 100)
    private String quanHuyen;

    @Column(name = "tinh_thanh_pho", length = 100)
    private String tinhThanhPho;

    @Column(name = "dia_chi_chi_tiet", length = 255)
    private String diaChiChiTiet;

    @Transient
    public String getDiaChiDayDu() {
        StringBuilder sb = new StringBuilder();
        if (diaChiChiTiet != null && !diaChiChiTiet.trim().isEmpty()) sb.append(diaChiChiTiet.trim());
        if (phuongXa != null && !phuongXa.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(phuongXa.trim());
        }
        if (quanHuyen != null && !quanHuyen.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(quanHuyen.trim());
        }
        if (tinhThanhPho != null && !tinhThanhPho.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(tinhThanhPho.trim());
        }
        return sb.length() > 0 ? sb.toString() : "Chưa cập nhật";
    }

    @Transient
    public String getDiaChi() {
        return getDiaChiDayDu();
    }

    @Column(name = "anh_dai_dien", length = 255)
    private String anhDaiDien;

    @Column(name = "ten_dang_nhap", nullable = false, unique = true, length = 50)
    private String tenDangNhap;

    @Column(name = "mat_khau", nullable = false, length = 255)
    private String matKhau;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
