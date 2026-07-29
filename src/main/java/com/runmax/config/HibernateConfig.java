package com.runmax.config;

import com.runmax.entity.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;

import java.util.Properties;

// Singleton SessionFactory Config (Cấu hình Hibernate ORM).
// Keyword search GG nếu chưa rõ: "Hibernate SessionFactory Singleton", "JPA addAnnotatedClass"
// Nhiệm vụ: Tạo 1 đường ống kết nối SQL Server duy nhất cho cả app, đăng ký đủ 15 Entity DB.
public class HibernateConfig {
    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                Configuration configuration = new Configuration();

                Properties settings = new Properties();
                settings.put(Environment.DRIVER,   "com.microsoft.sqlserver.jdbc.SQLServerDriver");
                settings.put(Environment.URL,
                        "jdbc:sqlserver://localhost:1433;databaseName=RunMaxDB;encrypt=true;trustServerCertificate=true");
                settings.put(Environment.USER, "sa");
                settings.put(Environment.PASS, "123456789");

                settings.put(Environment.DIALECT,                    "org.hibernate.dialect.SQLServerDialect");
                settings.put(Environment.SHOW_SQL,                   "true");
                settings.put(Environment.FORMAT_SQL,                 "true");
                settings.put(Environment.HBM2DDL_AUTO,               "update");
                settings.put(Environment.CURRENT_SESSION_CONTEXT_CLASS, "thread");

                configuration.setProperties(settings);

                // === MODULE 1: THUỘC TÍNH SẢN PHẨM ===
                configuration.addAnnotatedClass(ThuongHieu.class);
                configuration.addAnnotatedClass(ChatLieu.class);
                configuration.addAnnotatedClass(MauSac.class);
                configuration.addAnnotatedClass(KichCo.class);
                configuration.addAnnotatedClass(DeGiay.class);

                // === MODULE 2: NGƯỜI DÙNG & PHÂN QUYỀN ===
                configuration.addAnnotatedClass(VaiTro.class);
                configuration.addAnnotatedClass(NhanVien.class);
                configuration.addAnnotatedClass(KhachHang.class);
                configuration.addAnnotatedClass(DiaChiKhachHang.class);

                // === MODULE 3: SẢN PHẨM & SKU ===
                configuration.addAnnotatedClass(SanPham.class);
                configuration.addAnnotatedClass(SanPhamChiTiet.class);

                // === MODULE 4: KHUYẾN MÃI & THANH TOÁN ===
                configuration.addAnnotatedClass(PhieuGiamGia.class);
                configuration.addAnnotatedClass(PhuongThucThanhToan.class);

                // === MODULE 5: HÓA ĐƠN ===
                configuration.addAnnotatedClass(HoaDon.class);
                configuration.addAnnotatedClass(HoaDonChiTiet.class);

                // === MODULE 6: LỊCH SỬ ===
                configuration.addAnnotatedClass(LichSuThanhToan.class);
                configuration.addAnnotatedClass(LichSuHoaDon.class);

                ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(configuration.getProperties()).build();

                sessionFactory = configuration.buildSessionFactory(serviceRegistry);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
