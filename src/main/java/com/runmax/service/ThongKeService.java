package com.runmax.service;

import com.runmax.config.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// Thống Kê Service Layer (Xử lý số liệu Dashboard & Chart.js).
// Keyword search GG: "Hibernate HQL count aggregate", "Hibernate createNativeQuery SQL Server"
// Nhiệm vụ: Gom tổng doanh thu, đếm số đơn (chờ/hoàn tất/hủy) và bóc Top 5 giày bán chạy nhất.
public class ThongKeService {

    /** Tổng đơn hàng theo khoảng thời gian */
    public long tongDonHang(LocalDateTime tuNgay, LocalDateTime denNgay) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai = 1";
            if (tuNgay != null) hql += " AND h.ngayTao >= :tn";
            if (denNgay != null) hql += " AND h.ngayTao <= :dn";
            var query = session.createQuery(hql, Long.class);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);
            Long r = query.uniqueResult();
            return r == null ? 0 : r;
        }
    }

    /** Tổng doanh thu theo khoảng thời gian */
    public BigDecimal tongDoanhThu(LocalDateTime tuNgay, LocalDateTime denNgay) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "SELECT COALESCE(SUM(h.tongTien), 0) FROM HoaDon h WHERE h.trangThai = 1";
            if (tuNgay != null) hql += " AND h.ngayTao >= :tn";
            if (denNgay != null) hql += " AND h.ngayTao <= :dn";
            var query = session.createQuery(hql, BigDecimal.class);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);
            BigDecimal r = query.uniqueResult();
            return r == null ? BigDecimal.ZERO : r;
        }
    }

    /** Doanh thu hôm nay */
    public BigDecimal doanhThuHomNay() {
        LocalDateTime start = LocalDate.now().atStartOfDay();
        LocalDateTime end   = start.plusDays(1).minusNanos(1);
        return tongDoanhThu(start, end);
    }

    /** Doanh thu tuần này */
    public BigDecimal doanhThuTuanNay() {
        LocalDate today = LocalDate.now();
        LocalDateTime start = today.with(java.time.DayOfWeek.MONDAY).atStartOfDay();
        LocalDateTime end   = today.with(java.time.DayOfWeek.SUNDAY).atTime(23, 59, 59);
        return tongDoanhThu(start, end);
    }

    /** Doanh thu tháng này */
    public BigDecimal doanhThuThangNay() {
        LocalDate today = LocalDate.now();
        LocalDateTime start = today.withDayOfMonth(1).atStartOfDay();
        LocalDateTime end   = today.withDayOfMonth(today.lengthOfMonth()).atTime(23, 59, 59);
        return tongDoanhThu(start, end);
    }

    /** Doanh thu năm nay */
    public BigDecimal doanhThuNamNay() {
        LocalDate today = LocalDate.now();
        LocalDateTime start = today.withDayOfYear(1).atStartOfDay();
        LocalDateTime end   = today.withDayOfYear(today.lengthOfYear()).atTime(23, 59, 59);
        return tongDoanhThu(start, end);
    }

    /**
     * Doanh thu theo từng ngày trong khoảng thời gian.
     * Trả về Map<"yyyy-MM-dd", BigDecimal>.
     */
    @SuppressWarnings("unchecked")
    public Map<String, BigDecimal> doanhThuTheoNgay(LocalDateTime tuNgay, LocalDateTime denNgay) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String sql =
                "SELECT CONVERT(VARCHAR(10), h.ngay_tao, 120) AS ngay, SUM(h.tong_tien) AS dt " +
                "FROM hoa_don h WHERE h.trang_thai = 1 " +
                (tuNgay != null ? " AND h.ngay_tao >= :tn " : "") +
                (denNgay != null ? " AND h.ngay_tao <= :dn " : "") +
                "GROUP BY CONVERT(VARCHAR(10), h.ngay_tao, 120) ORDER BY ngay";

            var query = session.createNativeQuery(sql);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);

            List<Object[]> rows = query.list();
            Map<String, BigDecimal> result = new LinkedHashMap<>();
            for (Object[] row : rows) {
                String ngay = String.valueOf(row[0]);
                BigDecimal dt = BigDecimal.ZERO;
                if (row[1] instanceof BigDecimal bd) {
                    dt = bd;
                } else if (row[1] instanceof Number num) {
                    dt = BigDecimal.valueOf(num.doubleValue());
                }
                result.put(ngay, dt);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return new LinkedHashMap<>();
        }
    }

    /** Top 5 sản phẩm bán chạy */
    @SuppressWarnings("unchecked")
    public List<Object[]> topSanPham(int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String sql =
                "SELECT TOP(:limit) sp.ten_sp, SUM(ct.so_luong) AS sl " +
                "FROM hoa_don_chi_tiet ct " +
                "JOIN san_pham_chi_tiet spct ON ct.spct_id = spct.id " +
                "JOIN san_pham sp ON spct.san_pham_id = sp.id " +
                "JOIN hoa_don hd ON ct.hoa_don_id = hd.id " +
                "WHERE hd.trang_thai = 1 " +
                "GROUP BY sp.ten_sp ORDER BY sl DESC";
            return session.createNativeQuery(sql)
                .setParameter("limit", limit)
                .list();
        }
    }

    /** Đếm số lượng đơn hàng theo trạng thái (0: chờ, 1: hoàn tất, 2: đã hủy) */
    public long demDonTheoTrangThai(int trangThai) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            Long count = session.createQuery("SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai = :tt", Long.class)
                .setParameter("tt", trangThai)
                .uniqueResult();
            return count == null ? 0 : count;
        }
    }
}
