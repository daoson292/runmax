package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.ThuongHieu;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

/**
 * Lớp ThuongHieuRepository: Thao tác trực tiếp với cơ sở dữ liệu qua Hibernate Session.
 * Dành cho người mới học:
 * - Session: Đóng vai trò cầu nối với DB.
 * - Transaction: Đảm bảo tính toàn vẹn (commit thành công hoặc rollback khi lỗi).
 */
public class ThuongHieuRepository {

    /**
     * Lấy danh sách thương hiệu (có hỗ trợ tìm kiếm theo từ khóa)
     */
    public List<ThuongHieu> findAll(String keyword, int offset, int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "FROM ThuongHieu t WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(t.ten) LIKE :keyword";
            }
            hql += " ORDER BY t.id DESC";

            Query<ThuongHieu> query = session.createQuery(hql, ThuongHieu.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.list();
        }
    }

    public Long countAll(String keyword) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(t) FROM ThuongHieu t WHERE 1=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql += " AND LOWER(t.ten) LIKE :keyword";
            }
            Query<Long> query = session.createQuery(hql, Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        }
    }

    /**
     * Tìm thương hiệu theo ID
     */
    public ThuongHieu findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(ThuongHieu.class, id);
        }
    }

    /**
     * Thêm mới thương hiệu
     */
    public boolean save(ThuongHieu thuongHieu) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(thuongHieu);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật thương hiệu
     */
    public boolean update(ThuongHieu thuongHieu) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(thuongHieu);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<ThuongHieu> findAll() {
        return findAll(null, 0, Integer.MAX_VALUE);
    }

    public boolean toggleStatus(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            ThuongHieu th = session.get(ThuongHieu.class, id);
            if (th != null) {
                th.setTrangThai(th.getTrangThai() == 1 ? 0 : 1);
                session.merge(th);
                transaction.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            ThuongHieu th = session.get(ThuongHieu.class, id);
            if (th != null) {
                th.setTrangThai(0); // Xóa mềm: giữ lại trong DB với trạng thái 0
                session.merge(th);
                transaction.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
