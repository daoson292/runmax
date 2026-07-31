package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.LichSuThanhToan;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class LichSuThanhToanRepository {

    public List<LichSuThanhToan> findByHoaDonId(Long hoaDonId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "SELECT ls FROM LichSuThanhToan ls LEFT JOIN FETCH ls.phuongThucThanhToan WHERE ls.hoaDon.id = :hdId ORDER BY ls.ngayThanhToan",
                LichSuThanhToan.class)
                .setParameter("hdId", hoaDonId)
                .list();
        }
    }

    public boolean save(LichSuThanhToan entity) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(entity);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public java.math.BigDecimal tinhTongTienDaTra(Long hoaDonId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            java.math.BigDecimal sum = session.createQuery(
                "SELECT SUM(ls.soTien) FROM LichSuThanhToan ls WHERE ls.hoaDon.id = :hdId AND ls.trangThai = 1",
                java.math.BigDecimal.class)
                .setParameter("hdId", hoaDonId)
                .uniqueResult();
            return sum != null ? sum : java.math.BigDecimal.ZERO;
        }
    }
}
