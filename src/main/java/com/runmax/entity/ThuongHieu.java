package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entity ThuongHieu ánh xạ bảng thuong_hieu trong SQL Server.
 * Dành cho người mới học:
 * - @Entity: Báo cho Hibernate biết đây là 1 bảng trong CSDL.
 * - @Table(name = "thuong_hieu"): Tên bảng tương ứng trong DB.
 * - @Id + @GeneratedValue: Khóa chính tự tăng (IDENTITY).
 */
@Entity
@Table(name = "thuong_hieu")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThuongHieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_th", unique = true, length = 50)
    private String maTh;

    @Column(name = "ten", nullable = false, length = 100)
    private String ten;

    /**
     * Trạng thái hoạt động:
     * 1: Hoạt động
     * 0: Ngừng hoạt động
     */
    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    public String getMa() { return maTh; }

    @Transient
    public void setMa(String ma) { this.maTh = ma; }
}
