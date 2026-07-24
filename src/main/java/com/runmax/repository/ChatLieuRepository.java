package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.ChatLieu;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ChatLieuRepository {

    public List<ChatLieu> findAll(String keyword) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "FROM ChatLieu c WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(c.ten) LIKE :keyword";
            }
            hql += " ORDER BY c.id DESC";

            Query<ChatLieu> query = session.createQuery(hql, ChatLieu.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            return query.list();
        }
    }

    public List<ChatLieu> findAll() {
        return findAll(null);
    }

    public ChatLieu findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(ChatLieu.class, id);
        }
    }

    public boolean save(ChatLieu chatLieu) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(chatLieu);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ChatLieu chatLieu) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(chatLieu);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleStatus(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            ChatLieu e = session.get(ChatLieu.class, id);
            if (e != null) {
                e.setTrangThai(e.getTrangThai() == 1 ? 0 : 1);
                session.merge(e);
                transaction.commit();
                return true;
            }
            return false;
        } catch (Exception ex) {
            if (transaction != null) transaction.rollback();
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            ChatLieu e = session.get(ChatLieu.class, id);
            if (e != null) {
                e.setTrangThai(0); // Xóa mềm
                session.merge(e);
                transaction.commit();
                return true;
            }
            return false;
        } catch (Exception ex) {
            if (transaction != null) transaction.rollback();
            ex.printStackTrace();
            return false;
        }
    }
}
