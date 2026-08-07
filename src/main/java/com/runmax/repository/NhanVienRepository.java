package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.NhanVien;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class NhanVienRepository {

    public List<NhanVien> findAll(String keyword, Long vaiTroId, Integer trangThai, int offset, int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM NhanVien nv WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(nv.maNv) LIKE :kw OR LOWER(nv.hoTen) LIKE :kw OR LOWER(nv.sdt) LIKE :kw OR LOWER(nv.email) LIKE :kw)");
            }
            if (vaiTroId != null && vaiTroId > 0) {
                hql.append(" AND nv.vaiTro.id = :vtId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND nv.trangThai = :tt");
            }
            hql.append(" ORDER BY nv.id DESC");

            Query<NhanVien> query = session.createQuery(hql.toString(), NhanVien.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (vaiTroId != null && vaiTroId > 0) query.setParameter("vtId", vaiTroId);
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            
            return query.list();
        }
    }

    public Long countAll(String keyword, Long vaiTroId, Integer trangThai) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT COUNT(nv) FROM NhanVien nv WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (LOWER(nv.maNv) LIKE :kw OR LOWER(nv.hoTen) LIKE :kw OR LOWER(nv.sdt) LIKE :kw OR LOWER(nv.email) LIKE :kw)");
            }
            if (vaiTroId != null && vaiTroId > 0) {
                hql.append(" AND nv.vaiTro.id = :vtId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND nv.trangThai = :tt");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (vaiTroId != null && vaiTroId > 0) query.setParameter("vtId", vaiTroId);
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        }
    }

    public NhanVien findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(NhanVien.class, id);
        }
    }

    public NhanVien findByTenDangNhap(String tenDangNhap) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM NhanVien nv WHERE nv.tenDangNhap = :tdnhap AND nv.trangThai = 1",
                NhanVien.class)
                .setParameter("tdnhap", tenDangNhap)
                .uniqueResult();
        }
    }

    public NhanVien findByMaNv(String maNv) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery("FROM NhanVien nv WHERE nv.maNv = :ma", NhanVien.class)
                .setParameter("ma", maNv).uniqueResult();
        }
    }

    /** Tìm theo email (dùng cho đăng nhập bằng email) */
    public NhanVien findByEmail(String email) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM NhanVien nv WHERE LOWER(nv.email) = :email AND nv.trangThai = 1",
                NhanVien.class)
                .setParameter("email", email.trim().toLowerCase())
                .uniqueResult();
        }
    }

    /** Tìm theo tên đăng nhập hoặc email – dùng khi xác thực đăng nhập */
    public NhanVien findByTenDangNhapOrEmail(String input) {
        if (input == null || input.trim().isEmpty()) return null;
        String val = input.trim();
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            // Ưu tiên tenDangNhap trước
            NhanVien nv = session.createQuery(
                "FROM NhanVien nv WHERE nv.tenDangNhap = :val AND nv.trangThai = 1",
                NhanVien.class)
                .setParameter("val", val)
                .uniqueResult();
            if (nv != null) return nv;
            // Fallback: tìm theo email
            return session.createQuery(
                "FROM NhanVien nv WHERE LOWER(nv.email) = :email AND nv.trangThai = 1",
                NhanVien.class)
                .setParameter("email", val.toLowerCase())
                .uniqueResult();
        }
    }

    public String getNextMaNv() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            Long count = session.createQuery("SELECT COUNT(nv) FROM NhanVien nv", Long.class).uniqueResult();
            return String.format("NV%05d", count + 1);
        }
    }

    public boolean save(NhanVien entity) {
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

    public boolean update(NhanVien entity) {
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
            NhanVien nv = session.get(NhanVien.class, id);
            if (nv != null) {
                nv.setTrangThai(nv.getTrangThai() == 1 ? 0 : 1);
                session.merge(nv);
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
