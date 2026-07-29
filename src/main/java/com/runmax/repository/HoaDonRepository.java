package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.HoaDon;
import com.runmax.entity.HoaDonChiTiet;
import com.runmax.entity.LichSuHoaDon;
import com.runmax.entity.NhanVien;
import com.runmax.entity.KhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

// Hóa Đơn Repository (DAO Layer - Data Access Object).
// Keyword search GG: "Hibernate HQL Query", "Hibernate merge vs persist"
// Anh em lưu ý: Hàm save dùng session.merge(entity) chứ KHÔNG dùng session.persist để tránh lỗi Detached Entity khi bấm thêm cùng 1 giày 2 lần ở quầy POS nhé!
public class HoaDonRepository {

    public List<HoaDon> findAll(String maHd, Integer trangThai,
                                LocalDateTime tuNgay, LocalDateTime denNgay) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM HoaDon h WHERE 1=1");
            if (maHd != null && !maHd.trim().isEmpty()) {
                hql.append(" AND LOWER(h.maHd) LIKE :ma");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND h.trangThai = :tt");
            }
            if (tuNgay != null) {
                hql.append(" AND h.ngayTao >= :tn");
            }
            if (denNgay != null) {
                hql.append(" AND h.ngayTao <= :dn");
            }
            hql.append(" ORDER BY h.ngayTao DESC");

            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);
            if (maHd != null && !maHd.trim().isEmpty()) {
                query.setParameter("ma", "%" + maHd.trim().toLowerCase() + "%");
            }
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            if (tuNgay != null) query.setParameter("tn", tuNgay);
            if (denNgay != null) query.setParameter("dn", denNgay);
            return query.list();
        }
    }

    public HoaDon findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            HoaDon hd = session.createQuery(
                "SELECT DISTINCT h FROM HoaDon h " +
                "LEFT JOIN FETCH h.khachHang " +
                "LEFT JOIN FETCH h.nhanVien " +
                "LEFT JOIN FETCH h.phieuGiamGia " +
                "LEFT JOIN FETCH h.lichSuHoaDons " +
                "WHERE h.id = :id", HoaDon.class)
                .setParameter("id", id)
                .uniqueResult();
            return hd != null ? hd : session.get(HoaDon.class, id);
        }
    }

    public HoaDon findByMaHd(String maHd) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery("FROM HoaDon h WHERE h.maHd = :ma", HoaDon.class)
                .setParameter("ma", maHd).uniqueResult();
        }
    }

    /** Lấy các hóa đơn chưa thanh toán (POS) của 1 nhân viên */
    public List<HoaDon> findPendingByNhanVien(Long nhanVienId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM HoaDon h WHERE h.trangThai = 0 AND h.nhanVien.id = :nvId ORDER BY h.ngayTao DESC",
                HoaDon.class)
                .setParameter("nvId", nhanVienId)
                .list();
        }
    }

    /** Lấy TẤT CẢ hóa đơn chưa thanh toán (POS) – dùng cho Quản lý */
    public List<HoaDon> findAllPending() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM HoaDon h WHERE h.trangThai = 0 ORDER BY h.ngayTao DESC",
                HoaDon.class)
                .list();
        }
    }

    public List<HoaDonChiTiet> findChiTietByHoaDonId(Long hoaDonId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            List<HoaDonChiTiet> chiTiets = session.createQuery(
                "SELECT ct FROM HoaDonChiTiet ct " +
                "LEFT JOIN FETCH ct.sanPhamChiTiet spct " +
                "LEFT JOIN FETCH spct.sanPham " +
                "LEFT JOIN FETCH spct.mauSac " +
                "LEFT JOIN FETCH spct.kichCo " +
                "WHERE ct.hoaDon.id = :hdId ORDER BY ct.id",
                HoaDonChiTiet.class)
                .setParameter("hdId", hoaDonId)
                .list();
                
            if (chiTiets != null && !chiTiets.isEmpty()) {
                // No longer needed
            }
            
            return chiTiets;
        }
    }

    public List<LichSuHoaDon> findLichSuByHoaDonId(Long hoaDonId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM LichSuHoaDon l WHERE l.hoaDon.id = :hdId ORDER BY l.thoiGian DESC",
                LichSuHoaDon.class)
                .setParameter("hdId", hoaDonId)
                .list();
        }
    }

    public String getNextMaHd() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            Long maxId = session.createQuery("SELECT MAX(h.id) FROM HoaDon h", Long.class).uniqueResult();
            long next = (maxId == null ? 0 : maxId) + 1;
            while (true) {
                String ma = String.format("HD%05d", next);
                Long count = session.createQuery("SELECT COUNT(h) FROM HoaDon h WHERE h.maHd = :ma", Long.class)
                    .setParameter("ma", ma)
                    .uniqueResult();
                if (count != null && count == 0) {
                    return ma;
                }
                next++;
            }
        }
    }

    public HoaDon save(HoaDon entity) {
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateConfig.getSessionFactory().openSession();
            tx = session.beginTransaction();
            if (entity.getNhanVien() != null && entity.getNhanVien().getId() != null) {
                entity.setNhanVien(session.get(NhanVien.class, entity.getNhanVien().getId()));
            }
            if (entity.getKhachHang() != null && entity.getKhachHang().getId() != null) {
                entity.setKhachHang(session.get(KhachHang.class, entity.getKhachHang().getId()));
            }
            if (entity.getId() == null) {
                session.persist(entity);
            } else {
                entity = session.merge(entity);
            }
            tx.commit();
            return entity;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try { tx.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public boolean update(HoaDon entity) {
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateConfig.getSessionFactory().openSession();
            tx = session.beginTransaction();
            session.merge(entity);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try { tx.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public boolean saveChiTiet(HoaDonChiTiet entity) {
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

    public HoaDonChiTiet findChiTietById(Long chiTietId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(HoaDonChiTiet.class, chiTietId);
        }
    }

    public boolean deleteChiTiet(Long chiTietId) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            HoaDonChiTiet ct = session.get(HoaDonChiTiet.class, chiTietId);
            if (ct != null) {
                session.remove(ct);
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

    public boolean deleteHoaDon(Long id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, id);
            if (hd != null) {
                session.createQuery("DELETE FROM LichSuThanhToan l WHERE l.hoaDon.id = :id").setParameter("id", id).executeUpdate();
                session.createQuery("DELETE FROM LichSuHoaDon l WHERE l.hoaDon.id = :id").setParameter("id", id).executeUpdate();
                session.createQuery("DELETE FROM HoaDonChiTiet c WHERE c.hoaDon.id = :id").setParameter("id", id).executeUpdate();
                session.remove(hd);
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

    public boolean saveLichSu(LichSuHoaDon entity) {
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
}
