package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.PhuongThucThanhToan;
import org.hibernate.Session;

import java.util.List;

public class PhuongThucThanhToanRepository {

    public List<PhuongThucThanhToan> findAll() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM PhuongThucThanhToan p WHERE p.trangThai = 1 ORDER BY p.id",
                PhuongThucThanhToan.class).list();
        }
    }

    public PhuongThucThanhToan findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(PhuongThucThanhToan.class, id);
        }
    }
}
