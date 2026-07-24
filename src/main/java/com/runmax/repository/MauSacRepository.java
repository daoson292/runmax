package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.MauSac;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class MauSacRepository {

    public List<MauSac> findAll(String keyword) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "FROM MauSac m WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(m.ten) LIKE :kw";
            }
            hql += " ORDER BY m.id DESC";
            var query = session.createQuery(hql, MauSac.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            return query.list();
        }
    }

    public List<MauSac> findAll() {
        return findAll(null);
    }

    public MauSac findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(MauSac.class, id);
        }
    }

    public boolean save(MauSac entity) {
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

    public boolean update(MauSac entity) {
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
            MauSac m = session.get(MauSac.class, id);
            if (m != null) {
                m.setTrangThai(m.getTrangThai() == 1 ? 0 : 1);
                session.merge(m);
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
            MauSac m = session.get(MauSac.class, id);
            if (m != null) {
                m.setTrangThai(0); // Xóa mềm
                session.merge(m);
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
