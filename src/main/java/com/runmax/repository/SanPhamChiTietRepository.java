package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.SanPhamChiTiet;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class SanPhamChiTietRepository {

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                        Long deGiayId, Integer trangThai,
                                        BigDecimal giaMin, BigDecimal giaMax) {
        return findAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, null, 0, Integer.MAX_VALUE);
    }

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                        Long deGiayId, Integer trangThai,
                                        BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId) {
        return findAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, sanPhamId, 0, Integer.MAX_VALUE);
    }

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                        Long deGiayId, Integer trangThai,
                                        BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId, int offset, int limit) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                "FROM SanPhamChiTiet s WHERE 1=1");

            Long kwId = null;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim();
                hql.append(" AND (LOWER(s.sanPham.tenSp) LIKE :kw" +
                            " OR LOWER(s.sanPham.maSp) LIKE :kw" +
                            " OR LOWER(s.mauSac.ten) LIKE :kw" +
                            " OR LOWER(s.kichCo.ten) LIKE :kw" +
                            " OR LOWER(s.deGiay.ten) LIKE :kw" +
                            " OR LOWER(s.sanPham.thuongHieu.ten) LIKE :kw");
                try {
                    kwId = Long.parseLong(kw);
                    hql.append(" OR s.id = :kwId");
                } catch (Exception ignored) {}
                hql.append(")");
            }
            if (sanPhamId != null && sanPhamId > 0) {
                hql.append(" AND s.sanPham.id = :spId");
            }
            if (mauSacId != null && mauSacId > 0) {
                hql.append(" AND s.mauSac.id = :msId");
            }
            if (kichCoId != null && kichCoId > 0) {
                hql.append(" AND s.kichCo.id = :kcId");
            }
            if (deGiayId != null && deGiayId > 0) {
                hql.append(" AND s.deGiay.id = :dgId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND s.trangThai = :tt");
            }
            if (giaMin != null) {
                hql.append(" AND s.giaBan >= :gMin");
            }
            if (giaMax != null) {
                hql.append(" AND s.giaBan <= :gMax");
            }
            hql.append(" ORDER BY s.id DESC");

            Query<SanPhamChiTiet> query = session.createQuery(hql.toString(), SanPhamChiTiet.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (kwId != null) {
                    query.setParameter("kwId", kwId);
                }
            }
            if (sanPhamId != null && sanPhamId > 0) query.setParameter("spId", sanPhamId);
            if (mauSacId != null && mauSacId > 0)  query.setParameter("msId", mauSacId);
            if (kichCoId != null && kichCoId > 0)  query.setParameter("kcId", kichCoId);
            if (deGiayId != null && deGiayId > 0)  query.setParameter("dgId", deGiayId);
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            if (giaMin != null) query.setParameter("gMin", giaMin);
            if (giaMax != null) query.setParameter("gMax", giaMax);

            query.setFirstResult(offset);
            query.setMaxResults(limit);

            List<SanPhamChiTiet> list = query.list();
            return list;
        }
    }

    public Long countAll(String keyword, Long mauSacId, Long kichCoId,
                         Long deGiayId, Integer trangThai,
                         BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                "SELECT COUNT(s) FROM SanPhamChiTiet s WHERE 1=1");

            Long kwId = null;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim();
                hql.append(" AND (LOWER(s.sanPham.tenSp) LIKE :kw" +
                            " OR LOWER(s.sanPham.maSp) LIKE :kw" +
                            " OR LOWER(s.mauSac.ten) LIKE :kw" +
                            " OR LOWER(s.kichCo.ten) LIKE :kw" +
                            " OR LOWER(s.deGiay.ten) LIKE :kw" +
                            " OR LOWER(s.sanPham.thuongHieu.ten) LIKE :kw");
                try {
                    kwId = Long.parseLong(kw);
                    hql.append(" OR s.id = :kwId");
                } catch (Exception ignored) {}
                hql.append(")");
            }
            if (sanPhamId != null && sanPhamId > 0) {
                hql.append(" AND s.sanPham.id = :spId");
            }
            if (mauSacId != null && mauSacId > 0) {
                hql.append(" AND s.mauSac.id = :msId");
            }
            if (kichCoId != null && kichCoId > 0) {
                hql.append(" AND s.kichCo.id = :kcId");
            }
            if (deGiayId != null && deGiayId > 0) {
                hql.append(" AND s.deGiay.id = :dgId");
            }
            if (trangThai != null && trangThai >= 0) {
                hql.append(" AND s.trangThai = :tt");
            }
            if (giaMin != null) {
                hql.append(" AND s.giaBan >= :gMin");
            }
            if (giaMax != null) {
                hql.append(" AND s.giaBan <= :gMax");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (kwId != null) {
                    query.setParameter("kwId", kwId);
                }
            }
            if (sanPhamId != null && sanPhamId > 0) query.setParameter("spId", sanPhamId);
            if (mauSacId != null && mauSacId > 0)  query.setParameter("msId", mauSacId);
            if (kichCoId != null && kichCoId > 0)  query.setParameter("kcId", kichCoId);
            if (deGiayId != null && deGiayId > 0)  query.setParameter("dgId", deGiayId);
            if (trangThai != null && trangThai >= 0) query.setParameter("tt", trangThai);
            if (giaMin != null) query.setParameter("gMin", giaMin);
            if (giaMax != null) query.setParameter("gMax", giaMax);

            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        }
    }


    public List<SanPhamChiTiet> findBySanPhamId(Long sanPhamId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            List<SanPhamChiTiet> list = session.createQuery(
                "FROM SanPhamChiTiet s WHERE s.sanPham.id = :spId ORDER BY s.id",
                SanPhamChiTiet.class)
                .setParameter("spId", sanPhamId)
                .list();
            return list;
        }
    }

    public BigDecimal findMaxPrice(Long sanPhamId) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT MAX(s.giaBan) FROM SanPhamChiTiet s WHERE 1=1");
            if (sanPhamId != null && sanPhamId > 0) {
                hql.append(" AND s.sanPham.id = :spId");
            }
            Query<BigDecimal> query = session.createQuery(hql.toString(), BigDecimal.class);
            if (sanPhamId != null && sanPhamId > 0) {
                query.setParameter("spId", sanPhamId);
            }
            BigDecimal max = query.uniqueResult();
            if (max == null || max.compareTo(BigDecimal.ZERO) <= 0) {
                return new BigDecimal("10000000");
            }
            return max;
        } catch (Exception e) {
            e.printStackTrace();
            return new BigDecimal("10000000");
        }
    }

    public SanPhamChiTiet findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            SanPhamChiTiet spct = session.get(SanPhamChiTiet.class, id);
            return spct;
        }
    }

    public boolean save(SanPhamChiTiet entity) {
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

    public boolean update(SanPhamChiTiet entity) {
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
            SanPhamChiTiet s = session.get(SanPhamChiTiet.class, id);
            if (s != null) {
                s.setTrangThai(s.getTrangThai() == 1 ? 0 : 1);
                session.merge(s);
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

    /** Cập nhật tồn kho sau khi bán */
    public boolean updateSoLuong(Long id, int delta) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            SanPhamChiTiet s = session.get(SanPhamChiTiet.class, id);
            if (s != null) {
                s.setSoLuongTon(s.getSoLuongTon() + delta);
                session.merge(s);
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
