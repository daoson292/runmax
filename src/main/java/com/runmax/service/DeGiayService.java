package com.runmax.service;

import com.runmax.entity.DeGiay;
import com.runmax.repository.DeGiayRepository;

import java.util.List;

public class DeGiayService {
    private final DeGiayRepository repository = new DeGiayRepository();

    public List<DeGiay> findAll(String keyword) {
        return repository.findAll(keyword);
    }

    public List<DeGiay> findAll() {
        return repository.findAll();
    }

    public List<DeGiay> getAll(String keyword) {
        return repository.findAll(keyword);
    }

    public DeGiay findById(Long id) {
        if (id == null || id <= 0) return null;
        return repository.findById(id);
    }

    public DeGiay getById(Long id) {
        return findById(id);
    }

    public boolean save(DeGiay e) {
        return repository.save(e);
    }

    public boolean create(String ten) {
        if (ten == null || ten.trim().isEmpty()) return false;
        return repository.save(DeGiay.builder().ten(ten.trim()).trangThai(1).build());
    }

    public boolean update(DeGiay e) {
        return repository.update(e);
    }

    public boolean update(Long id, String ten, Integer trangThai) {
        DeGiay e = findById(id);
        if (e == null) return false;
        e.setTen(ten.trim());
        if (trangThai != null) e.setTrangThai(trangThai);
        return repository.update(e);
    }

    public boolean toggleStatus(Long id) {
        return repository.toggleStatus(id);
    }

    public boolean delete(Long id) {
        return repository.delete(id);
    }
}
