package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.DiaChiKhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class DiaChiKhachHangRepository {

    public List<DiaChiKhachHang> findByKhachHangId(Long khachHangId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM DiaChiKhachHang d WHERE d.khachHang.id = :khId ORDER BY d.trangThai DESC",
                DiaChiKhachHang.class)
                .setParameter("khId", khachHangId)
                .list();
        }
    }

    public DiaChiKhachHang findDefaultByKhachHangId(Long khachHangId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM DiaChiKhachHang d WHERE d.khachHang.id = :khId AND d.trangThai = 1",
                DiaChiKhachHang.class)
                .setParameter("khId", khachHangId)
                .setMaxResults(1)
                .uniqueResult();
        }
    }

    public boolean save(DiaChiKhachHang entity) {
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

    public boolean update(DiaChiKhachHang entity) {
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

    public boolean deleteByKhachHangId(Long khachHangId) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.createMutationQuery("DELETE FROM DiaChiKhachHang d WHERE d.khachHang.id = :khId")
                   .setParameter("khId", khachHangId)
                   .executeUpdate();
            tx.commit();
            return true;
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
            DiaChiKhachHang dc = session.get(DiaChiKhachHang.class, id);
            if (dc != null) {
                session.remove(dc);
            }
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
