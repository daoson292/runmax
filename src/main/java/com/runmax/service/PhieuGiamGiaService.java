package com.runmax.service;

import com.runmax.entity.PhieuGiamGia;
import com.runmax.repository.PhieuGiamGiaRepository;

import java.time.LocalDateTime;
import java.util.List;

public class PhieuGiamGiaService {
    private final PhieuGiamGiaRepository repo = new PhieuGiamGiaRepository();

    public List<PhieuGiamGia> findAll(String keyword, Integer trangThai,
                                       LocalDateTime tuNgay, LocalDateTime denNgay, int offset, int limit) {
        return repo.findAll(keyword, trangThai, tuNgay, denNgay, offset, limit);
    }

    public Long countAll(String keyword, Integer trangThai,
                         LocalDateTime tuNgay, LocalDateTime denNgay) {
        return repo.countAll(keyword, trangThai, tuNgay, denNgay);
    }

    public List<PhieuGiamGia> findAll(String keyword, Integer trangThai,
                                       LocalDateTime tuNgay, LocalDateTime denNgay) {
        return repo.findAll(keyword, trangThai, tuNgay, denNgay, 0, Integer.MAX_VALUE);
    }

    public List<PhieuGiamGia> findActive() { return repo.findActive(); }
    public PhieuGiamGia findById(Long id)  { return repo.findById(id); }
    public PhieuGiamGia findByMa(String ma) { return repo.findByMa(ma); }
    public String getNextMaPhieu()          { return repo.getNextMaPhieu(); }
    public boolean save(PhieuGiamGia e)     { return repo.save(e); }
    public boolean update(PhieuGiamGia e)   { return repo.update(e); }
    public boolean toggleStatus(Long id)    { return repo.toggleStatus(id); }
}
