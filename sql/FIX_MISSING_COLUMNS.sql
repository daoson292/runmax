-- =============================================================================
-- SCRIPT BỔ SUNG CỘT CÒN THIẾU CHO DATABASE CŨ (RUNMAXDB)
-- Chạy script này trong SQL Server Management Studio (SSMS) để fix ngay lỗi JDBC
-- =============================================================================

USE RunMaxDB;
GO

-- 1. Bổ sung cột cho bảng san_pham_chi_tiet
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham_chi_tiet') AND name = 'ngay_tao')
BEGIN
    ALTER TABLE san_pham_chi_tiet ADD ngay_tao DATE NULL DEFAULT GETDATE();
    PRINT N'Đã thêm cột ngay_tao vào bảng san_pham_chi_tiet';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('san_pham_chi_tiet') AND name = 'anh_dai_dien')
BEGIN
    ALTER TABLE san_pham_chi_tiet ADD anh_dai_dien VARCHAR(255) NULL;
    PRINT N'Đã thêm cột anh_dai_dien vào bảng san_pham_chi_tiet';
END

-- 2. Bổ sung cột cho bảng nhan_vien
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'phuong_xa')
BEGIN
    ALTER TABLE nhan_vien ADD phuong_xa NVARCHAR(100) NULL;
    PRINT N'Đã thêm cột phuong_xa vào bảng nhan_vien';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'tinh_thanh_pho')
BEGIN
    ALTER TABLE nhan_vien ADD tinh_thanh_pho NVARCHAR(100) NULL;
    PRINT N'Đã thêm cột tinh_thanh_pho vào bảng nhan_vien';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'dia_chi_chi_tiet')
BEGIN
    ALTER TABLE nhan_vien ADD dia_chi_chi_tiet NVARCHAR(255) NULL;
    PRINT N'Đã thêm cột dia_chi_chi_tiet vào bảng nhan_vien';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('nhan_vien') AND name = 'anh_dai_dien')
BEGIN
    ALTER TABLE nhan_vien ADD anh_dai_dien VARCHAR(255) NULL;
    PRINT N'Đã thêm cột anh_dai_dien vào bảng nhan_vien';
END

-- 3. Bổ sung cột cho bảng hoa_don
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('hoa_don') AND name = 'email')
BEGIN
    ALTER TABLE hoa_don ADD email VARCHAR(100) NULL;
    PRINT N'Đã thêm cột email vào bảng hoa_don';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('hoa_don') AND name = 'so_tien_giam')
BEGIN
    ALTER TABLE hoa_don ADD so_tien_giam DECIMAL(18,2) NOT NULL DEFAULT 0;
    PRINT N'Đã thêm cột so_tien_giam vào bảng hoa_don';
END

-- Cập nhật giá trị mặc định cho cột ngay_tao nếu bị NULL
UPDATE san_pham_chi_tiet SET ngay_tao = GETDATE() WHERE ngay_tao IS NULL;

PRINT N'Hoàn tất bổ sung toàn bộ cột thiếu! Bạn có thể Refresh trang web để chạy bình thường.';
GO
