package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.KichCo;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KichCoRepository {

    public List<KichCo> findAll(String keyword) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "FROM KichCo k WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(k.ten) LIKE :kw";
            }
            hql += " ORDER BY k.id DESC";
            var query = session.createQuery(hql, KichCo.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            return query.list();
        }
    }

    public List<KichCo> findAll() {
        return findAll(null);
    }

    public KichCo findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(KichCo.class, id);
        }
    }

    public boolean save(KichCo entity) {
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

    public boolean update(KichCo entity) {
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
            KichCo k = session.get(KichCo.class, id);
            if (k != null) {
                k.setTrangThai(k.getTrangThai() == 1 ? 0 : 1);
                session.merge(k);
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
            KichCo k = session.get(KichCo.class, id);
            if (k != null) {
                k.setTrangThai(0); // Xóa mềm
                session.merge(k);
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
