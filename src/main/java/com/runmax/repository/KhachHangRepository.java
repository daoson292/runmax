package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.KhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class KhachHangRepository {

    public List<KhachHang> findAll(String keyword, Integer trangThai) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM KhachHang kh WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(kh.maKh) LIKE :kw OR LOWER(kh.hoTen) LIKE :kw OR LOWER(kh.sdt) LIKE :kw OR LOWER(kh.email) LIKE :kw OR EXISTS (FROM DiaChiKhachHang dc WHERE dc.khachHang = kh AND (LOWER(dc.tinhThanhPho) LIKE :kw OR LOWER(dc.quanHuyen) LIKE :kw OR LOWER(dc.phuongXa) LIKE :kw OR LOWER(dc.diaChiChiTiet) LIKE :kw)))");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND kh.trangThai = :tt");
            }
            hql.append(" ORDER BY kh.id DESC");
            Query<KhachHang> query = session.createQuery(hql.toString(), KhachHang.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            return query.list();
        }
    }

    public KhachHang findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(KhachHang.class, id);
        }
    }

    public KhachHang findBySdt(String sdt) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery("FROM KhachHang kh WHERE kh.sdt = :sdt", KhachHang.class)
                .setParameter("sdt", sdt).uniqueResult();
        }
    }

    public String getNextMaKh() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            Long maxId = session.createQuery("SELECT MAX(kh.id) FROM KhachHang kh", Long.class).uniqueResult();
            long next = (maxId == null ? 0 : maxId) + 1;
            while (true) {
                String ma = String.format("KH%05d", next);
                Long count = session.createQuery("SELECT COUNT(kh) FROM KhachHang kh WHERE kh.maKh = :ma", Long.class)
                    .setParameter("ma", ma)
                    .uniqueResult();
                if (count != null && count == 0) {
                    return ma;
                }
                next++;
            }
        }
    }

    public boolean save(KhachHang entity) {
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

    public KhachHang saveAndReturn(KhachHang entity) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            KhachHang saved = session.merge(entity);
            tx.commit();
            return saved;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }
    }

    public boolean update(KhachHang entity) {
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
            KhachHang kh = session.get(KhachHang.class, id);
            if (kh != null) {
                kh.setTrangThai(kh.getTrangThai() == 1 ? 0 : 1);
                session.merge(kh);
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

    public boolean delete(Long id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            KhachHang kh = session.get(KhachHang.class, id);
            if (kh != null) {
                kh.setTrangThai(0); // Xóa mềm
                session.merge(kh);
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
