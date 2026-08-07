package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.PhieuGiamGia;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class PhieuGiamGiaRepository {

    public List<PhieuGiamGia> findAll(String keyword, Integer trangThai,
                                       LocalDateTime tuNgay, LocalDateTime denNgay, int offset, int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM PhieuGiamGia p WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(p.maPhieu) LIKE :kw)");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND p.trangThai = :tt");
            }
            if (tuNgay != null) {
                hql.append(" AND p.ngayBatDau >= :tn");
            }
            if (denNgay != null) {
                hql.append(" AND p.ngayKetThuc <= :dn");
            }
            hql.append(" ORDER BY p.id DESC");

            Query<PhieuGiamGia> query = session.createQuery(hql.toString(), PhieuGiamGia.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.list();
        }
    }

    public Long countAll(String keyword, Integer trangThai,
                         LocalDateTime tuNgay, LocalDateTime denNgay) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT COUNT(p) FROM PhieuGiamGia p WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(p.maPhieu) LIKE :kw)");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND p.trangThai = :tt");
            }
            if (tuNgay != null) {
                hql.append(" AND p.ngayBatDau >= :tn");
            }
            if (denNgay != null) {
                hql.append(" AND p.ngayKetThuc <= :dn");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);
            return query.uniqueResult();
        }
    }

    public PhieuGiamGia findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(PhieuGiamGia.class, id);
        }
    }

    public PhieuGiamGia findByMa(String ma) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery("FROM PhieuGiamGia p WHERE p.maPhieu = :ma", PhieuGiamGia.class)
                .setParameter("ma", ma).uniqueResult();
        }
    }

    /** Lấy danh sách phiếu đang hoạt động và còn hạn */
    public List<PhieuGiamGia> findActive() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM PhieuGiamGia p WHERE p.trangThai = 1 AND p.soLuong > 0" +
                " AND p.ngayBatDau <= :now AND p.ngayKetThuc >= :now ORDER BY p.id",
                PhieuGiamGia.class)
                .setParameter("now", LocalDateTime.now())
                .list();
        }
    }

    public String getNextMaPhieu() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            Long count = session.createQuery("SELECT COUNT(p) FROM PhieuGiamGia p", Long.class).uniqueResult();
            return String.format("PGG%05d", count + 1);
        }
    }

    public boolean save(PhieuGiamGia entity) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(entity);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(PhieuGiamGia entity) {
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

    public boolean toggleStatus(Long id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PhieuGiamGia p = session.get(PhieuGiamGia.class, id);
            if (p != null) {
                p.setTrangThai(p.getTrangThai() == 3 ? 1 : 3);
                session.merge(p);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
