package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity MauSac – ánh xạ bảng mau_sac.
 */
@Entity
@Table(name = "mau_sac")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class MauSac {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_ms", unique = true, length = 50)
    private String maMs;

    @Column(name = "ten", nullable = false, length = 100)
    private String ten;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    public String getMa() { return maMs; }

    @Transient
    public void setMa(String ma) { this.maMs = ma; }
}
