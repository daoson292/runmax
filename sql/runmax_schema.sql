-- =============================================================================
-- RUNMAX DATABASE SCHEMA
-- Phiên bản: 2.0 – Khớp 100% với ERD
-- Database: SQL Server
-- =============================================================================

-- Tạo database (chạy lần đầu)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'RunMaxDB')
BEGIN
    CREATE DATABASE RunMaxDB;
END
GO

USE RunMaxDB;
GO

-- =============================================================================
-- XÓA BẢNG CŨ (theo thứ tự FK ngược)
-- =============================================================================
IF OBJECT_ID('lich_su_hoa_don',       'U') IS NOT NULL DROP TABLE lich_su_hoa_don;
IF OBJECT_ID('lich_su_thanh_toan',    'U') IS NOT NULL DROP TABLE lich_su_thanh_toan;
IF OBJECT_ID('hoa_don_chi_tiet',      'U') IS NOT NULL DROP TABLE hoa_don_chi_tiet;
IF OBJECT_ID('hoa_don',               'U') IS NOT NULL DROP TABLE hoa_don;
IF OBJECT_ID('san_pham_chi_tiet',     'U') IS NOT NULL DROP TABLE san_pham_chi_tiet;
IF OBJECT_ID('san_pham',              'U') IS NOT NULL DROP TABLE san_pham;
IF OBJECT_ID('dia_chi_khach_hang',    'U') IS NOT NULL DROP TABLE dia_chi_khach_hang;
IF OBJECT_ID('khach_hang',            'U') IS NOT NULL DROP TABLE khach_hang;
IF OBJECT_ID('nhan_vien',             'U') IS NOT NULL DROP TABLE nhan_vien;
IF OBJECT_ID('vai_tro',               'U') IS NOT NULL DROP TABLE vai_tro;
IF OBJECT_ID('phieu_giam_gia',        'U') IS NOT NULL DROP TABLE phieu_giam_gia;
IF OBJECT_ID('phuong_thuc_thanh_toan','U') IS NOT NULL DROP TABLE phuong_thuc_thanh_toan;
IF OBJECT_ID('mau_sac',               'U') IS NOT NULL DROP TABLE mau_sac;
IF OBJECT_ID('kich_co',               'U') IS NOT NULL DROP TABLE kich_co;
IF OBJECT_ID('de_giay',               'U') IS NOT NULL DROP TABLE de_giay;
IF OBJECT_ID('chat_lieu',             'U') IS NOT NULL DROP TABLE chat_lieu;
IF OBJECT_ID('thuong_hieu',           'U') IS NOT NULL DROP TABLE thuong_hieu;
GO

-- =============================================================================
-- MODULE 1: THUỘC TÍNH SẢN PHẨM (DANH MỤC NỀN TẢNG)
-- =============================================================================

CREATE TABLE thuong_hieu (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_th      VARCHAR(50)   NULL UNIQUE,
    ten        NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1  -- 1: Hoạt động, 0: Ngừng hoạt động
);

CREATE TABLE chat_lieu (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_cl      VARCHAR(50)   NULL UNIQUE,
    ten        NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

CREATE TABLE mau_sac (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_ms      VARCHAR(50)   NULL UNIQUE,
    ten        NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

CREATE TABLE kich_co (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_kc      VARCHAR(50)   NULL UNIQUE,
    ten        NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

CREATE TABLE de_giay (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma         VARCHAR(50)   NULL UNIQUE,
    ten        NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

-- =============================================================================
-- MODULE 2: NGƯỜI DÙNG & PHÂN QUYỀN (VAI TRÒ, NHÂN VIÊN, KHÁCH HÀNG)
-- =============================================================================

CREATE TABLE vai_tro (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_vai_tro VARCHAR(50)    NOT NULL UNIQUE,
    ten_vai_tro NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

CREATE TABLE nhan_vien (
    id                BIGINT IDENTITY(1,1) PRIMARY KEY,
    vai_tro_id        BIGINT NOT NULL,
    ma_nv             VARCHAR(50)    NOT NULL UNIQUE,
    ho_ten            NVARCHAR(100)  NOT NULL,
    gioi_tinh         BIT DEFAULT 1,              -- 1: Nam, 0: Nữ
    ngay_sinh         DATE NULL,
    sdt               VARCHAR(20)    NULL,
    email             VARCHAR(100)   NULL,
    phuong_xa         NVARCHAR(100)  NULL,
    quan_huyen        NVARCHAR(100)  NULL,
    tinh_thanh_pho    NVARCHAR(100)  NULL,
    dia_chi_chi_tiet  NVARCHAR(255)  NULL,
    anh_dai_dien      VARCHAR(255)   NULL,
    ten_dang_nhap     VARCHAR(50)    NOT NULL UNIQUE,
    mat_khau          VARCHAR(255)   NOT NULL,
    trang_thai        INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_nhan_vien_vai_tro FOREIGN KEY (vai_tro_id) REFERENCES vai_tro(id)
);

CREATE TABLE khach_hang (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_kh      VARCHAR(50)   NOT NULL UNIQUE,
    ho_ten     NVARCHAR(100) NOT NULL,
    sdt        VARCHAR(20)   NULL,
    email      VARCHAR(100)  NULL,
    ngay_sinh  DATE          NULL,
    gioi_tinh  INT NOT NULL  DEFAULT 1,
    trang_thai INT NOT NULL  DEFAULT 1
);

CREATE TABLE dia_chi_khach_hang (
    id               BIGINT IDENTITY(1,1) PRIMARY KEY,
    khach_hang_id    BIGINT NOT NULL,
    dia_chi_chi_tiet NVARCHAR(255) NOT NULL,
    phuong_xa        NVARCHAR(100) NOT NULL,
    quan_huyen       NVARCHAR(100) NULL,
    tinh_thanh_pho   NVARCHAR(100) NOT NULL,
    trang_thai       INT NOT NULL DEFAULT 1,  -- 1: Mặc định, 0: Thường
    CONSTRAINT FK_dia_chi_khach_hang FOREIGN KEY (khach_hang_id) REFERENCES khach_hang(id)
);

-- =============================================================================
-- MODULE 3: SẢN PHẨM & BIẾN THỂ SKU (SAN_PHAM, SAN_PHAM_CHI_TIET)
-- =============================================================================

CREATE TABLE san_pham (
    id            BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_sp         VARCHAR(50)    NOT NULL UNIQUE,
    ten_sp        NVARCHAR(200)  NOT NULL,
    thuong_hieu_id BIGINT NOT NULL,
    chat_lieu_id   BIGINT NOT NULL,
    mo_ta         NVARCHAR(MAX)  NULL,
    trang_thai    INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_san_pham_thuong_hieu FOREIGN KEY (thuong_hieu_id) REFERENCES thuong_hieu(id),
    CONSTRAINT FK_san_pham_chat_lieu   FOREIGN KEY (chat_lieu_id)   REFERENCES chat_lieu(id)
);

CREATE TABLE san_pham_chi_tiet (
    id             BIGINT IDENTITY(1,1) PRIMARY KEY,
    san_pham_id    BIGINT NOT NULL,
    mau_sac_id     BIGINT NOT NULL,
    kich_co_id     BIGINT NOT NULL,
    de_giay_id     BIGINT NOT NULL,
    gia_goc        DECIMAL(18, 2) NOT NULL DEFAULT 0,
    gia_ban        DECIMAL(18, 2) NOT NULL DEFAULT 0,
    so_luong_ton   INT NOT NULL DEFAULT 0,
    anh_dai_dien   VARCHAR(255)   NULL,
    ngay_tao       DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    trang_thai     INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_spct_san_pham FOREIGN KEY (san_pham_id) REFERENCES san_pham(id),
    CONSTRAINT FK_spct_mau_sac  FOREIGN KEY (mau_sac_id)  REFERENCES mau_sac(id),
    CONSTRAINT FK_spct_kich_co  FOREIGN KEY (kich_co_id)  REFERENCES kich_co(id),
    CONSTRAINT FK_spct_de_giay  FOREIGN KEY (de_giay_id)  REFERENCES de_giay(id)
);

-- =============================================================================
-- MODULE 4: KHUYẾN MÃI & PHƯƠNG THỨC THANH TOÁN
-- =============================================================================

CREATE TABLE phieu_giam_gia (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_phieu        VARCHAR(50)    NOT NULL UNIQUE,
    ten_phieu       NVARCHAR(200)  NOT NULL,
    loai_phieu      INT NOT NULL DEFAULT 1,          -- 1: Công khai, 2: Cá nhân
    loai_giam       INT NOT NULL DEFAULT 1,          -- 1: Giảm %, 2: Giảm số tiền
    gia_tri_giam    DECIMAL(18, 2) NOT NULL,
    giam_toi_da     DECIMAL(18, 2) NULL,
    dieu_kien_giam  DECIMAL(18, 2) NOT NULL DEFAULT 0,  -- Giá trị đơn tối thiểu
    so_luong        INT NOT NULL DEFAULT 0,
    mo_ta           NVARCHAR(500)  NULL,
    ngay_bat_dau    DATETIME NOT NULL,
    ngay_ket_thuc   DATETIME NOT NULL,
    trang_thai      INT NOT NULL DEFAULT 0   -- 0: Sắp diễn ra, 1: Đang áp dụng, 2: Hết hạn, 3: Vô hiệu hóa
);

CREATE TABLE phuong_thuc_thanh_toan (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    ma_pt      VARCHAR(50)   NOT NULL UNIQUE,
    ten_pt     NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);

-- =============================================================================
-- MODULE 5: HÓA ĐƠN & CHI TIẾT HÓA ĐƠN (BÁN HÀNG POS)
-- =============================================================================

CREATE TABLE hoa_don (
    id                 BIGINT IDENTITY(1,1) PRIMARY KEY,
    khach_hang_id      BIGINT NULL,          -- NULL khi khách vãng lai
    nhan_vien_id       BIGINT NOT NULL,
    phieu_giam_gia_id  BIGINT NULL,          -- NULL khi không áp dụng voucher
    ma_hd              VARCHAR(50)    NOT NULL UNIQUE,
    tien_hang          DECIMAL(18, 2) NOT NULL DEFAULT 0,
    so_tien_giam       DECIMAL(18, 2) NOT NULL DEFAULT 0,
    tong_tien          DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ghi_chu            NVARCHAR(500)  NULL,
    ngay_tao           DATETIME NOT NULL DEFAULT GETDATE(),
    trang_thai         INT NOT NULL DEFAULT 0,
    -- 0: Chờ thanh toán, 1: Đã thanh toán, 2: Đã hủy
    CONSTRAINT FK_hoa_don_khach_hang      FOREIGN KEY (khach_hang_id)     REFERENCES khach_hang(id),
    CONSTRAINT FK_hoa_don_nhan_vien       FOREIGN KEY (nhan_vien_id)      REFERENCES nhan_vien(id),
    CONSTRAINT FK_hoa_don_phieu_giam_gia  FOREIGN KEY (phieu_giam_gia_id) REFERENCES phieu_giam_gia(id)
);

CREATE TABLE hoa_don_chi_tiet (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    hoa_don_id BIGINT NOT NULL,
    spct_id    BIGINT NOT NULL,
    so_luong   INT NOT NULL DEFAULT 1,
    don_gia    DECIMAL(18, 2) NOT NULL DEFAULT 0,
    thanh_tien DECIMAL(18, 2) NOT NULL DEFAULT 0,
    trang_thai INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_hdct_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES hoa_don(id),
    CONSTRAINT FK_hdct_spct    FOREIGN KEY (spct_id)    REFERENCES san_pham_chi_tiet(id)
);

-- =============================================================================
-- MODULE 6: LỊCH SỬ THANH TOÁN & LỊCH SỬ THAO TÁC HÓA ĐƠN
-- =============================================================================

CREATE TABLE lich_su_thanh_toan (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    hoa_don_id      BIGINT NOT NULL,
    pttt_id         BIGINT NOT NULL,
    so_tien         DECIMAL(18, 2) NOT NULL,
    ma_giao_dich    VARCHAR(100)   NULL,
    ngay_thanh_toan DATETIME NOT NULL DEFAULT GETDATE(),
    trang_thai      INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_lstt_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES hoa_don(id),
    CONSTRAINT FK_lstt_pttt    FOREIGN KEY (pttt_id)    REFERENCES phuong_thuc_thanh_toan(id)
);

CREATE TABLE lich_su_hoa_don (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    hoa_don_id      BIGINT NOT NULL,
    nguoi_thao_tac  NVARCHAR(100)  NOT NULL,
    hanh_dong       NVARCHAR(255)  NOT NULL,
    thoi_gian       DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_lshd_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES hoa_don(id)
);
GO

-- =============================================================================
-- SEED DATA MẪU
-- =============================================================================

-- Vai trò
INSERT INTO vai_tro (ma_vai_tro, ten_vai_tro) VALUES
    ('ADMIN',     N'Quản lý'),
    ('NHAN_VIEN', N'Nhân viên');

-- Nhân viên thuộc nhóm thực hiện dự án RunMax (Mật khẩu chuẩn: 123456)
INSERT INTO nhan_vien (vai_tro_id, ma_nv, ho_ten, gioi_tinh, ngay_sinh, sdt, email,
                       phuong_xa, tinh_thanh_pho, dia_chi_chi_tiet,
                       ten_dang_nhap, mat_khau, trang_thai)
VALUES
    -- 2 Admin Quản lý
    (1, 'NV00001', N'Đào Sơn',   1, '2003-01-15', '0988111222', 'daoson@runmax.vn',
     N'Láng Hạ', N'Đống Đa, Hà Nội', N'Số 1 Láng Hạ',
     'daoson', '123456', 1),
    (1, 'NV00002', N'Kiều Anh',  0, '2003-05-20', '0988222333', 'kieuanh@runmax.vn',
     N'Dịch Vọng', N'Cầu Giấy, Hà Nội', N'Số 2 Dịch Vọng',
     'kieuanh', '123456', 1),
    -- 2 Nhân viên Bán hàng POS
    (2, 'NV00003', N'Khánh',     1, '2003-08-10', '0988333444', 'khanh@runmax.vn',
     N'Hoàng Mai', N'Hoàng Mai, Hà Nội', N'Số 3 Hoàng Mai',
     'khanh', '123456', 1),
    (2, 'NV00004', N'Thu Hằng',  0, '2003-10-12', '0988444555', 'thuhang@runmax.vn',
     N'Thanh Xuân', N'Thanh Xuân, Hà Nội', N'Số 4 Thanh Xuân',
     'thuhang', '123456', 1);

-- Thương hiệu Giày chạy bộ & Sneaker
INSERT INTO thuong_hieu (ma_th, ten, trang_thai) VALUES
    ('TH001', N'RunMax Official', 1),
    ('TH002', N'Nike Running',    1),
    ('TH003', N'Adidas Running',  1),
    ('TH004', N'New Balance',     1),
    ('TH005', N'Asics Performance', 1);

-- Chất liệu chuyên dụng cho giày chạy bộ
INSERT INTO chat_lieu (ma_cl, ten, trang_thai) VALUES
    ('CL001', N'Vải Engineered Mesh thoáng khí', 1),
    ('CL002', N'Sợi đan Primeknit đàn hồi',      1),
    ('CL003', N'Vải Flyknit siêu nhẹ',            1),
    ('CL004', N'Da tổng hợp Microfiber cao cấp', 1),
    ('CL005', N'Sợi Monomesh chuyên Marathon',    1);

-- Màu sắc nam tính, thể thao
INSERT INTO mau_sac (ma_ms, ten, trang_thai) VALUES
    ('MS001', N'Đen Tuyền (Core Black)', 1),
    ('MS002', N'Trắng Sứ (Pure White)',  1),
    ('MS003', N'Đỏ Cam Năng Lượng',     1),
    ('MS004', N'Xanh Navy Thể Thao',     1),
    ('MS005', N'Xám Xi Măng (Grey)',     1),
    ('MS006', N'Vàng Neon Nổi Bật',      1);

-- Kích cỡ giày nam chuẩn runner (39 - 44)
INSERT INTO kich_co (ma_kc, ten, trang_thai) VALUES
    ('KC39', N'39', 1),
    ('KC40', N'40', 1),
    ('KC41', N'41', 1),
    ('KC42', N'42', 1),
    ('KC43', N'43', 1),
    ('KC44', N'44', 1);

-- Đế giày chạy bộ công nghệ cao
INSERT INTO de_giay (ma, ten, trang_thai) VALUES
    ('DG001', N'Đế Carbon Đệm Foam Siêu Nhẹ', 1),
    ('DG002', N'Đế Boost Phản Hồi Năng Lượng', 1),
    ('DG003', N'Đế ZoomX Cao Su Chống Mài Mòn', 1),
    ('DG004', N'Đế Fresh Foam X Êm Ái',        1),
    ('DG005', N'Đế EVA Siêu Nhẹ Chạy Bộ',      1);

-- Phương thức thanh toán
INSERT INTO phuong_thuc_thanh_toan (ma_pt, ten_pt, trang_thai) VALUES
    ('TIEN_MAT', N'Tiền mặt',  1),
    ('CHUYEN_KHOAN', N'Chuyển khoản', 1),
    ('THE_ATM',  N'Thẻ ATM',   1),
    ('MOMO',     N'Ví MoMo',   1),
    ('VNPAY',    N'VNPay',     1);

-- Phiếu giảm giá
INSERT INTO phieu_giam_gia (ma_phieu, ten_phieu, loai_phieu, loai_giam, gia_tri_giam, giam_toi_da, dieu_kien_giam, so_luong, mo_ta, ngay_bat_dau, ngay_ket_thuc, trang_thai)
VALUES
    ('PGG00001', N'Sale chào mùa hè 2026',       1, 1, 10,     200000, 500000,  9999, N'Giảm 10% tối đa 200k cho đơn từ 500k', '2026-04-28', '2026-05-29', 0),
    ('PGG00002', N'Giảm 100k cho runner mới', 1, 2, 100000, NULL,   300000,  9999, N'Giảm thẳng 100k cho đơn từ 300k',          '2026-04-28', '2026-05-29', 0),
    ('PGG00003', N'Flash Sale cuối tuần',          1, 1, 15,     300000, 800000,  3,    N'Giảm 15% tối đa 300k, chỉ 3 suất',     '2026-04-28', '2026-05-14', 0);

-- Khách hàng
INSERT INTO khach_hang (ma_kh, ho_ten, sdt, email, trang_thai) VALUES
    ('KH00001', N'Nguyễn Văn A',  '0911111111', 'kha.a@gmail.com', 1),
    ('KH00002', N'Trần Văn B',    '0922222222', 'khb.b@gmail.com', 1),
    ('KH00003', N'Lê Thị C',      '0933333333', 'khc.c@gmail.com', 1),
    ('KH00004', N'Phạm Văn D',    '0944444444', 'khd.d@gmail.com', 1);

-- Địa chỉ khách hàng
INSERT INTO dia_chi_khach_hang (khach_hang_id, dia_chi_chi_tiet, phuong_xa, tinh_thanh_pho, trang_thai) VALUES
    (1, N'Số 10 Demo', N'Láng Hạ',     N'Đống Đa, Hà Nội',   1),
    (2, N'Số 20 Demo', N'Dịch Vọng',   N'Cầu Giấy, Hà Nội',  1),
    (3, N'Số 30 Demo', N'Khương Đình', N'Thanh Xuân, Hà Nội', 1),
    (4, N'Số 40 Demo', N'Đại Kim',     N'Hoàng Mai, Hà Nội',  1);

-- Sản phẩm Giày chạy bộ nam cao cấp RunMax
INSERT INTO san_pham (ma_sp, ten_sp, thuong_hieu_id, chat_lieu_id, mo_ta, trang_thai) VALUES
    ('SP00001', N'RunMax AeroGlide Carbon Pro Men',   1, 1, N'Giày chạy bộ nam marathon đế đệm Carbon trợ lực tối đa', 1),
    ('SP00002', N'Nike Air Zoom Pegasus 40 Men',       2, 3, N'Giày chạy bộ nam đa năng hàng ngày, đệm Air Zoom đàn hồi',  1),
    ('SP00003', N'Adidas Ultraboost Light Running Men', 3, 2, N'Giày sneaker chạy bộ nam đệm Boost nhẹ nhất lịch sử',          1),
    ('SP00004', N'New Balance Fresh Foam X 1080v13',  4, 1, N'Giày chạy bộ đường dài êm ái tối đa cho runner nam',     1);

-- San phẩm chi tiết (SKU biến thể theo Size/Màu/Đế)
INSERT INTO san_pham_chi_tiet (san_pham_id, mau_sac_id, kich_co_id, de_giay_id, gia_goc, gia_ban, so_luong_ton, trang_thai)
VALUES
    -- SP00001 RunMax AeroGlide Carbon - Đen, sz 40, 41, 42
    (1, 1, 2, 1, 2200000, 2490000, 25, 1),
    (1, 1, 3, 1, 2200000, 2490000, 30, 1),
    (1, 1, 4, 1, 2200000, 2490000, 18, 1),
    -- SP00001 RunMax AeroGlide Carbon - Trắng Sứ, sz 41, 42
    (1, 2, 3, 1, 2200000, 2590000, 15, 1),
    (1, 2, 4, 1, 2200000, 2590000, 12, 1),
    -- SP00002 Nike Pegasus 40 - Đen, sz 40, 41, 42, 43
    (2, 1, 2, 3, 2800000, 3190000, 20, 1),
    (2, 1, 3, 3, 2800000, 3190000, 45, 1),
    (2, 1, 4, 3, 2800000, 3190000, 22, 1),
    -- SP00002 Nike Pegasus 40 - Đỏ Cam, sz 41
    (2, 3, 3, 3, 2800000, 3290000, 14, 1),
    -- SP00003 Adidas Ultraboost Light - Trắng, sz 40, 41, 42
    (3, 2, 2, 2, 3500000, 3990000, 20, 1),
    (3, 2, 3, 2, 3500000, 3990000, 18, 1),
    (3, 2, 4, 2, 3500000, 3990000, 14, 1),
    -- SP00004 New Balance Fresh Foam - Xanh Navy, sz 41, 42
    (4, 4, 3, 4, 3100000, 3490000, 16, 1),
    (4, 4, 4, 4, 3100000, 3490000,  9, 1);

-- Hóa đơn mẫu
INSERT INTO hoa_don (khach_hang_id, nhan_vien_id, phieu_giam_gia_id, ma_hd,
                     tien_hang, so_tien_giam, tong_tien, trang_thai, ngay_tao)
VALUES
    (1,    2, NULL, 'HD00001', 2200000, 0,      2200000, 1, '2026-04-29 10:30:00'),
    (2,    2, 1,    'HD00002', 2300000, 230000, 2070000, 1, '2026-04-29 14:15:00'),
    (NULL, 2, NULL, 'HD00003', 4700000, 0,      4700000, 1, '2026-04-29 16:00:00');

-- Chi tiết hóa đơn mẫu
INSERT INTO hoa_don_chi_tiet (hoa_don_id, spct_id, so_luong, don_gia, thanh_tien, trang_thai)
VALUES
    (1, 1, 1, 2200000, 2200000, 1),
    (2, 7, 1, 2400000, 2400000, 1),
    (3, 1, 1, 2200000, 2200000, 1),
    (3, 9, 1, 2500000, 2500000, 1);

-- Lịch sử thanh toán mẫu
INSERT INTO lich_su_thanh_toan (hoa_don_id, pttt_id, so_tien, ngay_thanh_toan, trang_thai)
VALUES
    (1, 1, 2200000, '2026-04-29 10:31:00', 1),
    (2, 2, 2070000, '2026-04-29 14:16:00', 1),
    (3, 1, 4700000, '2026-04-29 16:01:00', 1);

-- Lịch sử hóa đơn mẫu
INSERT INTO lich_su_hoa_don (hoa_don_id, nguoi_thao_tac, hanh_dong, thoi_gian)
VALUES
    (1, N'admin', N'Tạo hóa đơn HD00001', '2026-04-29 10:30:00'),
    (1, N'admin', N'Thanh toán hóa đơn HD00001', '2026-04-29 10:31:00'),
    (2, N'banhang', N'Tạo hóa đơn HD00002', '2026-04-29 14:15:00'),
    (2, N'banhang', N'Thanh toán hóa đơn HD00002', '2026-04-29 14:16:00'),
    (3, N'banhang', N'Tạo hóa đơn HD00003', '2026-04-29 16:00:00'),
    (3, N'banhang', N'Thanh toán hóa đơn HD00003', '2026-04-29 16:01:00');

-- Bổ sung thêm Sản phẩm giày bóng đá đa dạng cho RunMax
INSERT INTO san_pham (ma_sp, ten_sp, thuong_hieu_id, chat_lieu_id, mo_ta, trang_thai) VALUES
    ('SP00005', N'Nike Phantom GX 2 Elite',  1, 5, N'Giày bóng đá upper sợi đan Gripknit cho khả năng kiểm soát bóng tối đa', 1),
    ('SP00006', N'Nike Tiempo Legend 10 Pro', 1, 1, N'Giày bóng đá da tổng hợp FlyTouch Plus siêu mềm mại', 1),
    ('SP00007', N'Adidas Predator 24 Elite',  2, 5, N'Huyền thoại Predator trở lại với lưỡi gà gập cổ điển', 1),
    ('SP00008', N'Adidas Copa Pure 2.1',     2, 3, N'Giày bóng đá da bò thật êm ái, chạm bóng tinh tế', 1),
    ('SP00009', N'Puma King Ultimate FG/AG', 3, 1, N'Giày bóng đá upper K-BETTER thân thiện môi trường', 1),
    ('SP00010', N'Kamito TA11 Pro TF',       5, 1, N'Giày bóng đá sân cỏ nhân tạo Tuấn Anh thiết kế riêng cho sân Việt Nam', 1);

-- Bổ sung SPCT cho các sản phẩm mới
INSERT INTO san_pham_chi_tiet (san_pham_id, mau_sac_id, kich_co_id, de_giay_id, gia_goc, gia_ban, so_luong_ton, trang_thai)
VALUES
    (5, 3, 3, 1, 2800000, 3190000, 15, 1),
    (5, 3, 4, 1, 2800000, 3190000, 20, 1),
    (6, 2, 3, 2, 1750000, 2050000, 25, 1),
    (6, 2, 4, 2, 1750000, 2050000, 18, 1),
    (7, 1, 4, 5, 3200000, 3600000, 12, 1),
    (7, 3, 4, 5, 3200000, 3600000, 10, 1),
    (8, 2, 4, 2, 2100000, 2450000, 14, 1),
    (9, 1, 4, 1, 2300000, 2690000,  9, 1),
    (10, 4, 3, 1, 680000, 850000,  50, 1),
    (10, 4, 4, 1, 680000, 850000,  45, 1);

-- Bổ sung Hóa đơn chờ thanh toán (trang_thai = 0) phục vụ ngay cho quầy POS Bán hàng
INSERT INTO hoa_don (khach_hang_id, nhan_vien_id, phieu_giam_gia_id, ma_hd,
                     tien_hang, so_tien_giam, tong_tien, trang_thai, ngay_tao)
VALUES
    (3,    2, NULL, 'HD00004', 3190000, 0,    3190000, 0, GETDATE()),
    (NULL, 3, NULL, 'HD00005',  850000, 0,     850000, 0, GETDATE()),
    (NULL, 3, NULL, 'HD00006', 2050000, 0,    2050000, 0, GETDATE());

INSERT INTO hoa_don_chi_tiet (hoa_don_id, spct_id, so_luong, don_gia, thanh_tien, trang_thai)
VALUES
    (4, 16, 1, 3190000, 3190000, 1),
    (5, 24, 1, 850000,  850000,  1),
    (6, 18, 1, 2050000, 2050000, 1);
GO

PRINT N'RunMaxDB schema created and seeded successfully!';
GO