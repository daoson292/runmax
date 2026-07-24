package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity VaiTro – ánh xạ bảng vai_tro (phân quyền nhân viên).
 */
@Entity
@Table(name = "vai_tro")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class VaiTro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_vai_tro", nullable = false, unique = true, length = 50)
    private String maVaiTro;

    @Column(name = "ten_vai_tro", nullable = false, length = 100)
    private String tenVaiTro;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
