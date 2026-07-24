package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity PhuongThucThanhToan – ánh xạ bảng phuong_thuc_thanh_toan.
 */
@Entity
@Table(name = "phuong_thuc_thanh_toan")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class PhuongThucThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_pt", nullable = false, unique = true, length = 50)
    private String maPt;

    @Column(name = "ten_pt", nullable = false, length = 100)
    private String tenPhuongThuc;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
