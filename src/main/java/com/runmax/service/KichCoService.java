package com.runmax.service;

import com.runmax.entity.KichCo;
import com.runmax.repository.KichCoRepository;
import java.util.List;

public class KichCoService {
    private final KichCoRepository repo = new KichCoRepository();

    public List<KichCo> findAll(String keyword) { return repo.findAll(keyword); }
    public List<KichCo> getAll(String keyword)  { return repo.findAll(keyword); }

    public KichCo findById(Long id) { return repo.findById(id); }
    public KichCo getById(Long id)  { return repo.findById(id); }

    public boolean save(KichCo e)   { return repo.save(e); }
    public boolean create(String ten) {
        if (ten == null || ten.trim().isEmpty()) return false;
        return repo.save(KichCo.builder().ten(ten.trim()).trangThai(1).build());
    }

    public boolean update(KichCo e) { return repo.update(e); }
    public boolean update(Long id, String ten, Integer trangThai) {
        KichCo e = repo.findById(id);
        if (e == null) return false;
        if (ten != null) e.setTen(ten.trim());
        if (trangThai != null) e.setTrangThai(trangThai);
        return repo.update(e);
    }

    public boolean toggleStatus(Long id) { return repo.toggleStatus(id); }

    public boolean delete(Long id) { return repo.delete(id); }
}
