package com.runmax.service;

import com.runmax.entity.MauSac;
import com.runmax.repository.MauSacRepository;
import java.util.List;

public class MauSacService {
    private final MauSacRepository repo = new MauSacRepository();

    public List<MauSac> findAll(String keyword, int offset, int limit) {
        return repo.findAll(keyword, offset, limit);
    }
    public List<MauSac> findAll(String keyword) { return repo.findAll(keyword, 0, Integer.MAX_VALUE); }
    public List<MauSac> findAll()               { return repo.findAll(null, 0, Integer.MAX_VALUE); }
    public List<MauSac> getAll(String keyword)  { return repo.findAll(keyword, 0, Integer.MAX_VALUE); }
    public Long countAll(String keyword)        { return repo.countAll(keyword); }

    public MauSac findById(Long id) { return repo.findById(id); }
    public MauSac getById(Long id)  { return repo.findById(id); }

    public boolean save(MauSac e)   { return repo.save(e); }
    public boolean create(String ten) {
        if (ten == null || ten.trim().isEmpty()) return false;
        return repo.save(MauSac.builder().ten(ten.trim()).trangThai(1).build());
    }

    public boolean update(MauSac e) { return repo.update(e); }
    public boolean update(Long id, String ten, Integer trangThai) {
        MauSac e = repo.findById(id);
        if (e == null) return false;
        if (ten != null) e.setTen(ten.trim());
        if (trangThai != null) e.setTrangThai(trangThai);
        return repo.update(e);
    }

    public boolean toggleStatus(Long id) { return repo.toggleStatus(id); }

    public boolean delete(Long id) { return repo.delete(id); }
}
