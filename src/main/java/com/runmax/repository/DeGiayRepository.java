package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.DeGiay;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class DeGiayRepository {

    public List<DeGiay> findAll(String keyword) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "FROM DeGiay d WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(d.ten) LIKE :keyword";
            }
            hql += " ORDER BY d.id DESC";

            Query<DeGiay> query = session.createQuery(hql, DeGiay.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            return query.list();
        }
    }

    public DeGiay findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(DeGiay.class, id);
        }
    }

    public boolean save(DeGiay deGiay) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(deGiay);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(DeGiay deGiay) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(deGiay);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<DeGiay> findAll() {
        return findAll(null);
    }

    public boolean toggleStatus(Long id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            DeGiay d = session.get(DeGiay.class, id);
            if (d != null) {
                d.setTrangThai(d.getTrangThai() == 1 ? 0 : 1);
                session.merge(d);
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
            DeGiay d = session.get(DeGiay.class, id);
            if (d != null) {
                d.setTrangThai(0); // Xóa mềm
                session.merge(d);
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
