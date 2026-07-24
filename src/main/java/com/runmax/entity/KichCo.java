package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity KichCo – ánh xạ bảng kich_co.
 */
@Entity
@Table(name = "kich_co")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class KichCo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_kc", unique = true, length = 50)
    private String maKc;

    @Column(name = "ten", nullable = false, length = 100)
    private String ten;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    public String getMa() { return maKc; }

    @Transient
    public void setMa(String ma) { this.maKc = ma; }
}
