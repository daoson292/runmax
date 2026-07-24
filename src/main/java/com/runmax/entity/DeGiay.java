package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity DeGiay ánh xạ bảng de_giay trong SQL Server.
 */
@Entity
@Table(name = "de_giay")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeGiay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma", unique = true, length = 50)
    private String ma;

    @Column(name = "ten", nullable = false, length = 100)
    private String ten;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;
}
