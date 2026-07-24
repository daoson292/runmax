package com.runmax.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

/**
 * Entity SanPham ánh xạ bảng san_pham trong SQL Server.
 * Dành cho người mới học:
 * - @ManyToOne: Liên kết nhiều Sản phẩm thuộc về 1 Thương hiệu / 1 Chất liệu.
 * - @JoinColumn: Chỉ định tên cột khóa ngoại (thuong_hieu_id, chat_lieu_id) trong bảng san_pham.
 */
@Entity
@Table(name = "san_pham")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_sp", nullable = false, unique = true, length = 50)
    private String maSp;

    @Column(name = "ten_sp", nullable = false, length = 200)
    private String tenSp;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "thuong_hieu_id", nullable = false)
    private ThuongHieu thuongHieu;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "chat_lieu_id", nullable = false)
    private ChatLieu chatLieu;

    @Column(name = "mo_ta", length = 2000)
    private String moTa;

    @Column(name = "trang_thai", nullable = false)
    @Builder.Default
    private Integer trangThai = 1;

    @Transient
    @Builder.Default
    private Integer tongHangTon = 0;

    @Transient
    private BigDecimal giaMin;

    @Transient
    private BigDecimal giaMax;

    @Transient
    public String getKhoangGiaFormatted() {
        if (giaMin == null || giaMax == null || (giaMin.compareTo(BigDecimal.ZERO) <= 0 && giaMax.compareTo(BigDecimal.ZERO) <= 0)) {
            return "Chưa có biến thể";
        }
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
        if (giaMin.compareTo(giaMax) == 0) {
            return nf.format(giaMin) + " đ";
        }
        return nf.format(giaMin) + " đ - " + nf.format(giaMax) + " đ";
    }
}
