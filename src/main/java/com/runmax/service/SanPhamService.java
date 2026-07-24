package com.runmax.service;

import com.runmax.entity.ChatLieu;
import com.runmax.entity.SanPham;
import com.runmax.entity.SanPhamChiTiet;
import com.runmax.entity.ThuongHieu;
import com.runmax.repository.ChatLieuRepository;
import com.runmax.repository.SanPhamChiTietRepository;
import com.runmax.repository.SanPhamRepository;
import com.runmax.repository.ThuongHieuRepository;

import java.math.BigDecimal;
import java.util.List;

public class SanPhamService {
    private final SanPhamRepository repository = new SanPhamRepository();
    private final ThuongHieuRepository thuongHieuRepository = new ThuongHieuRepository();
    private final ChatLieuRepository chatLieuRepository = new ChatLieuRepository();
    private final SanPhamChiTietRepository spctRepository = new SanPhamChiTietRepository();

    private void populateStats(List<SanPham> list) {
        if (list == null) return;
        for (SanPham sp : list) {
            populateStats(sp);
        }
    }

    private void populateStats(SanPham sp) {
        if (sp == null || sp.getId() == null) return;
        List<SanPhamChiTiet> spcts = spctRepository.findBySanPhamId(sp.getId());
        int totalStock = 0;
        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        for (SanPhamChiTiet ct : spcts) {
            if (ct.getSoLuongTon() != null) {
                totalStock += ct.getSoLuongTon();
            }
            if (ct.getGiaBan() != null) {
                if (minPrice == null || ct.getGiaBan().compareTo(minPrice) < 0) {
                    minPrice = ct.getGiaBan();
                }
                if (maxPrice == null || ct.getGiaBan().compareTo(maxPrice) > 0) {
                    maxPrice = ct.getGiaBan();
                }
            }
        }
        sp.setTongHangTon(totalStock);
        sp.setGiaMin(minPrice);
        sp.setGiaMax(maxPrice);
    }

    public List<SanPham> findAll(String keyword, Long thuongHieuId, Long chatLieuId, Integer trangThai) {
        List<SanPham> list = repository.findAll(keyword, thuongHieuId, chatLieuId, trangThai);
        populateStats(list);
        return list;
    }

    public List<SanPham> findAll(String keyword, Long thuongHieuId) {
        List<SanPham> list = repository.findAll(keyword, thuongHieuId);
        populateStats(list);
        return list;
    }

    public List<SanPham> getAll(String keyword, Long thuongHieuId, Long chatLieuId, Integer trangThai) {
        return findAll(keyword, thuongHieuId, chatLieuId, trangThai);
    }

    public List<SanPham> getAll(String keyword, Long thuongHieuId) {
        return findAll(keyword, thuongHieuId);
    }

    public SanPham findById(Long id) {
        if (id == null || id <= 0) return null;
        SanPham sp = repository.findById(id);
        populateStats(sp);
        return sp;
    }

    public SanPham getById(Long id) {
        return findById(id);
    }

    public boolean save(SanPham sp) {
        return repository.save(sp);
    }

    public boolean update(SanPham sp) {
        return repository.update(sp);
    }

    public boolean toggleStatus(Long id) {
        SanPham sp = findById(id);
        if (sp == null) return false;
        sp.setTrangThai(sp.getTrangThai() == 1 ? 0 : 1);
        return repository.update(sp);
    }

    public List<SanPham> findAll() {
        return findAll(null, null);
    }

    public boolean delete(Long id) {
        SanPham sp = findById(id);
        if (sp == null) return false;
        sp.setTrangThai(0); // Xóa mềm: cập nhật trạng thái = 0
        return repository.update(sp);
    }

    /** Kiểm tra mã sản phẩm đã tồn tại chưa (cho validate) */
    public boolean isMaSPExists(String maSp) {
        return repository.findAll(null, null, null, null).stream()
            .anyMatch(sp -> maSp.equalsIgnoreCase(sp.getMaSp()));
    }

    /** Kiểm tra tên sản phẩm đã tồn tại chưa (cho validate) */
    public boolean isTenSPExists(String tenSp) {
        return repository.findAll(null, null, null, null).stream()
            .anyMatch(sp -> tenSp.equalsIgnoreCase(sp.getTenSp()));
    }

    public String getNextMaSp() {
        long count = repository.findAll(null, null, null, null).size();
        return String.format("SP%05d", count + 1);
    }
}
