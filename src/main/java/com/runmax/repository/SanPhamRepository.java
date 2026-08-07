package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.SanPham;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class SanPhamRepository {

    public List<SanPham> findAll(String keyword, Long thuongHieuId) {
        return findAll(keyword, thuongHieuId, null, null, 0, Integer.MAX_VALUE);
    }

    public List<SanPham> findAll(String keyword, Long thuongHieuId, Long chatLieuId, Integer trangThai, int offset, int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM SanPham sp WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(sp.tenSp) LIKE :keyword OR LOWER(sp.maSp) LIKE :keyword OR LOWER(sp.thuongHieu.ten) LIKE :keyword OR LOWER(sp.chatLieu.ten) LIKE :keyword)");
            }
            if (thuongHieuId != null && thuongHieuId > 0) {
                hql.append(" AND sp.thuongHieu.id = :thId");
            }
            if (chatLieuId != null && chatLieuId > 0) {
                hql.append(" AND sp.chatLieu.id = :clId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND sp.trangThai = :tt");
            }
            hql.append(" ORDER BY sp.id DESC");

            Query<SanPham> query = session.createQuery(hql.toString(), SanPham.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (thuongHieuId != null && thuongHieuId > 0) {
                query.setParameter("thId", thuongHieuId);
            }
            if (chatLieuId != null && chatLieuId > 0) {
                query.setParameter("clId", chatLieuId);
            }
            if (trangThai != null && trangThai >= 0) {
                query.setParameter("tt", trangThai);
            }
            
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            
            return query.list();
        }
    }

    public Long countAll(String keyword, Long thuongHieuId, Long chatLieuId, Integer trangThai) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT COUNT(sp) FROM SanPham sp WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(sp.tenSp) LIKE :keyword OR LOWER(sp.maSp) LIKE :keyword OR LOWER(sp.thuongHieu.ten) LIKE :keyword OR LOWER(sp.chatLieu.ten) LIKE :keyword)");
            }
            if (thuongHieuId != null && thuongHieuId > 0) {
                hql.append(" AND sp.thuongHieu.id = :thId");
            }
            if (chatLieuId != null && chatLieuId > 0) {
                hql.append(" AND sp.chatLieu.id = :clId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND sp.trangThai = :tt");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (thuongHieuId != null && thuongHieuId > 0) {
                query.setParameter("thId", thuongHieuId);
            }
            if (chatLieuId != null && chatLieuId > 0) {
                query.setParameter("clId", chatLieuId);
            }
            if (trangThai != null && trangThai >= 0) {
                query.setParameter("tt", trangThai);
            }
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        }
    }

    public SanPham findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(SanPham.class, id);
        }
    }

    public boolean save(SanPham sanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(sanPham);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(SanPham sanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(sanPham);
            transaction.commit();
            return true;
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
            SanPham sp = session.get(SanPham.class, id);
            if (sp != null) {
                sp.setTrangThai(0); // Xóa mềm: cập nhật trạng thái = 0
                session.merge(sp);
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
