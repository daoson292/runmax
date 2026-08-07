package com.runmax.service;

import com.runmax.entity.ThuongHieu;
import com.runmax.repository.ThuongHieuRepository;
import java.util.List;

public class ThuongHieuService {
    private final ThuongHieuRepository repo = new ThuongHieuRepository();

    public List<ThuongHieu> findAll(String keyword, Long id, int offset, int limit) {
        List<ThuongHieu> list = repo.findAll(keyword, offset, limit);
        if (id != null) {
            return list.stream().filter(e -> e.getId().equals(id)).toList();
        }
        return list;
    }

    /** Backward-compat overload: lấy toàn bộ, lọc theo id nếu có */
    public List<ThuongHieu> findAll(String keyword, Long id) {
        return findAll(keyword, id, 0, Integer.MAX_VALUE);
    }

    public List<ThuongHieu> findAll(String keyword, int offset, int limit) {
        return repo.findAll(keyword, offset, limit);
    }

    public List<ThuongHieu> findAll(String keyword) {
        return repo.findAll(keyword, 0, Integer.MAX_VALUE);
    }

    public List<ThuongHieu> getAll(String keyword) {
        return repo.findAll(keyword, 0, Integer.MAX_VALUE);
    }

    public Long countAll(String keyword) {
        return repo.countAll(keyword);
    }

    public ThuongHieu findById(Long id) { return repo.findById(id); }
    public ThuongHieu getById(Long id)  { return repo.findById(id); }

    public boolean save(ThuongHieu e)   { return repo.save(e); }
    public boolean create(String ten) {
        if (ten == null || ten.trim().isEmpty()) return false;
        return repo.save(ThuongHieu.builder().ten(ten.trim()).trangThai(1).build());
    }

    public boolean update(ThuongHieu e) { return repo.update(e); }
    public boolean update(Long id, String ten, Integer trangThai) {
        ThuongHieu e = repo.findById(id);
        if (e == null) return false;
        if (ten != null) e.setTen(ten.trim());
        if (trangThai != null) e.setTrangThai(trangThai);
        return repo.update(e);
    }

    public boolean toggleStatus(Long id) {
        return repo.toggleStatus(id);
    }

    public boolean delete(Long id) {
        return repo.delete(id);
    }
}
