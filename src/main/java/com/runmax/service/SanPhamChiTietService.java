package com.runmax.service;

import com.runmax.entity.SanPhamChiTiet;
import com.runmax.repository.SanPhamChiTietRepository;

import java.math.BigDecimal;
import java.util.List;

public class SanPhamChiTietService {
    private final SanPhamChiTietRepository repo = new SanPhamChiTietRepository();

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                         Long deGiayId, Integer trangThai,
                                         BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId, int offset, int limit) {
        return repo.findAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, sanPhamId, offset, limit);
    }

    public Long countAll(String keyword, Long mauSacId, Long kichCoId,
                         Long deGiayId, Integer trangThai,
                         BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId) {
        return repo.countAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, sanPhamId);
    }

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                         Long deGiayId, Integer trangThai,
                                         BigDecimal giaMin, BigDecimal giaMax) {
        return repo.findAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, null, 0, Integer.MAX_VALUE);
    }

    public List<SanPhamChiTiet> findAll(String keyword, Long mauSacId, Long kichCoId,
                                         Long deGiayId, Integer trangThai,
                                         BigDecimal giaMin, BigDecimal giaMax, Long sanPhamId) {
        return repo.findAll(keyword, mauSacId, kichCoId, deGiayId, trangThai, giaMin, giaMax, sanPhamId, 0, Integer.MAX_VALUE);
    }

    public List<SanPhamChiTiet> findBySanPhamId(Long sanPhamId) {
        return repo.findBySanPhamId(sanPhamId);
    }

    public BigDecimal findMaxPrice(Long sanPhamId) {
        return repo.findMaxPrice(sanPhamId);
    }

    public SanPhamChiTiet findById(Long id) { return repo.findById(id); }
    public boolean save(SanPhamChiTiet e)   { return repo.save(e); }
    public boolean update(SanPhamChiTiet e) { return repo.update(e); }
    public boolean toggleStatus(Long id)    { return repo.toggleStatus(id); }
    public boolean updateSoLuong(Long id, int delta) { return repo.updateSoLuong(id, delta); }
}
