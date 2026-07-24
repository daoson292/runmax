package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity ChatLieu ánh xạ bảng chat_lieu trong SQL Server.
 */
@Entity
@Table(name = "chat_lieu")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatLieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_cl", unique = true, length = 50)
    private String maCl;

    @Column(name = "ten", nullable = false, length = 100)
    private String ten;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    public String getMa() { return maCl; }

    @Transient
    public void setMa(String ma) { this.maCl = ma; }
}
