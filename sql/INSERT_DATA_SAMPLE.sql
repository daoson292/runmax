-- =============================================================================
-- SCRIPT INSERT DỮ LIỆU MẪU AN TOÀN CHO RUNMAX
-- Tự động kiểm tra và thêm cột nếu Database cũ chưa có
-- =============================================================================

USE RunMaxDB;
GO

-- 0. Kiểm tra và bổ sung cột cho các bảng nếu DB cũ chưa có
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'phuong_xa')
    ALTER TABLE nhan_vien ADD phuong_xa NVARCHAR(100) NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'tinh_thanh_pho')
    ALTER TABLE nhan_vien ADD tinh_thanh_pho NVARCHAR(100) NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'dia_chi_chi_tiet')
    ALTER TABLE nhan_vien ADD dia_chi_chi_tiet NVARCHAR(255) NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'anh_dai_dien')
    ALTER TABLE nhan_vien ADD anh_dai_dien VARCHAR(255) NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham_chi_tiet') AND name = 'ngay_tao')
    ALTER TABLE san_pham_chi_tiet ADD ngay_tao DATE NULL DEFAULT GETDATE();
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham_chi_tiet') AND name = 'anh_dai_dien')
    ALTER TABLE san_pham_chi_tiet ADD anh_dai_dien VARCHAR(255) NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('hoa_don') AND name = 'email')
    ALTER TABLE hoa_don ADD email VARCHAR(100) NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('hoa_don') AND name = 'so_tien_giam')
    ALTER TABLE hoa_don ADD so_tien_giam DECIMAL(18,2) NOT NULL DEFAULT 0;
GO

-- 1. Vai trò
IF NOT EXISTS (SELECT 1 FROM vai_tro WHERE id = 1)
BEGIN
    INSERT INTO vai_tro (ma_vai_tro, ten_vai_tro) VALUES
        ('ADMIN',     N'Quản lý'),
        ('NHAN_VIEN', N'Nhân viên');
END

-- 2. Nhân viên thuộc nhóm thực hiện dự án RunMax
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'daoson')
BEGIN
    INSERT INTO nhan_vien (vai_tro_id, ma_nv, ho_ten, gioi_tinh, ngay_sinh, sdt, email,
                           phuong_xa, tinh_thanh_pho, dia_chi_chi_tiet,
                           ten_dang_nhap, mat_khau, trang_thai)
    VALUES
        (1, 'NV00001', N'Đào Sơn',   1, '2003-01-15', '0988111222', 'daoson@runmax.vn',
         N'Láng Hạ', N'Đống Đa, Hà Nội', N'Số 1 Láng Hạ',
         'daoson', '123456', 1),
        (1, 'NV00002', N'Kiều Anh',  0, '2003-05-20', '0988222333', 'kieuanh@runmax.vn',
         N'Dịch Vọng', N'Cầu Giấy, Hà Nội', N'Số 2 Dịch Vọng',
         'kieuanh', '123456', 1),
        (2, 'NV00003', N'Khánh',     1, '2003-08-10', '0988333444', 'khanh@runmax.vn',
         N'Hoàng Mai', N'Hoàng Mai, Hà Nội', N'Số 3 Hoàng Mai',
         'khanh', '123456', 1),
        (2, 'NV00004', N'Thu Hằng',  0, '2003-10-12', '0988444555', 'thuhang@runmax.vn',
         N'Thanh Xuân', N'Thanh Xuân, Hà Nội', N'Số 4 Thanh Xuân',
         'thuhang', '123456', 1);
END

-- 3. Khách hàng
IF NOT EXISTS (SELECT 1 FROM khach_hang WHERE ma_kh = 'KH00001')
BEGIN
    INSERT INTO khach_hang (ma_kh, ho_ten, sdt, email, trang_thai) VALUES
        ('KH00001', N'Nguyễn Văn A',  '0911111111', 'kha.a@gmail.com', 1),
        ('KH00002', N'Trần Văn B',    '0922222222', 'khb.b@gmail.com', 1),
        ('KH00003', N'Lê Thị C',      '0933333333', 'khc.c@gmail.com', 1),
        ('KH00004', N'Phạm Văn D',    '0944444444', 'khd.d@gmail.com', 1);
END

-- 4. Thương hiệu & thuộc tính
IF NOT EXISTS (SELECT 1 FROM thuong_hieu WHERE id = 1)
BEGIN
    INSERT INTO thuong_hieu (ten, trang_thai) VALUES
        (N'Nike', 1), (N'Adidas', 1), (N'Puma', 1), (N'New Balance', 1), (N'Kamito', 1);

    INSERT INTO chat_lieu (ten, trang_thai) VALUES
        (N'Da tổng hợp', 1), (N'Vải lưới', 1), (N'Da thật', 1), (N'Canvas', 1), (N'Knit sợi đan', 1);

    INSERT INTO mau_sac (ten, trang_thai) VALUES
        (N'Đen', 1), (N'Trắng', 1), (N'Đỏ', 1), (N'Xanh dương', 1), (N'Xám', 1), (N'Vàng', 1);

    INSERT INTO kich_co (ten, trang_thai) VALUES
        (N'38', 1), (N'39', 1), (N'40', 1), (N'41', 1), (N'42', 1), (N'43', 1);

    INSERT INTO de_giay (ten, trang_thai) VALUES
        (N'Đế cao su FG', 1), (N'Đế EVA TF', 1), (N'Đế PU', 1), (N'Đế Phylon', 1), (N'Đế AG', 1);
END

-- 5. Phương thức thanh toán
IF NOT EXISTS (SELECT 1 FROM phuong_thuc_thanh_toan WHERE id = 1)
BEGIN
    INSERT INTO phuong_thuc_thanh_toan (ma_pt, ten_pt, trang_thai) VALUES
        ('TIEN_MAT', N'Tiền mặt', 1),
        ('CHUYEN_KHOAN', N'Chuyển khoản / QR Code', 1),
        ('THE_ATM', N'Quẹt thẻ ATM/POS', 1);
END

-- 6. Phiếu giảm giá
IF NOT EXISTS (SELECT 1 FROM phieu_giam_gia WHERE id = 1)
BEGIN
    INSERT INTO phieu_giam_gia (ma_phieu, loai_giam, gia_tri_giam, giam_toi_da, dieu_kien_giam, so_luong, ngay_bat_dau, ngay_ket_thuc, trang_thai)
    VALUES
        ('PGG00001', 1, 10,     200000, 500000,  9999, '2026-04-28', '2026-12-31', 1),
        ('PGG00002', 2, 100000, NULL,   300000,  9999, '2026-04-28', '2026-12-31', 1),
        ('PGG00003', 1, 15,     300000, 800000,  100,  '2026-04-28', '2026-12-31', 1);
END

PRINT N'Kiểm tra cấu trúc và Insert dữ liệu mẫu thành công!';
GO
