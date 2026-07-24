package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Entity LichSuHoaDon – ánh xạ bảng lich_su_hoa_don.
 * Ghi lại mọi thao tác trên hóa đơn (tạo, sửa, hủy, thanh toán...).
 */
@Entity
@Table(name = "lich_su_hoa_don")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LichSuHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    @Column(name = "nguoi_thao_tac", nullable = false, length = 100)
    private String nguoiThaoTac;

    @Column(name = "hanh_dong", nullable = false, length = 255)
    private String hanhDong;

    @Column(name = "thoi_gian", nullable = false)
    @Builder.Default
    private LocalDateTime thoiGian = LocalDateTime.now();
}
