package com.runmax.service;

import com.runmax.entity.KhachHang;
import com.runmax.entity.DiaChiKhachHang;
import com.runmax.repository.KhachHangRepository;
import com.runmax.repository.DiaChiKhachHangRepository;

import java.util.List;

public class KhachHangService {
    private final KhachHangRepository khRepo = new KhachHangRepository();
    private final DiaChiKhachHangRepository dcRepo = new DiaChiKhachHangRepository();

    public List<KhachHang> findAll(String keyword, Integer trangThai) {
        List<KhachHang> list = khRepo.findAll(keyword, trangThai);
        for (KhachHang kh : list) {
            if (kh.getId() != null) {
                DiaChiKhachHang dc = dcRepo.findDefaultByKhachHangId(kh.getId());
                if (dc == null) {
                    List<DiaChiKhachHang> allDc = dcRepo.findByKhachHangId(kh.getId());
                    if (!allDc.isEmpty()) dc = allDc.get(0);
                }
                if (dc != null) {
                    kh.setDiaChiMacDinh(dc.getDiaChiDayDu());
                } else {
                    kh.setDiaChiMacDinh("Chưa cập nhật");
                }
            }
        }
        return list;
    }

    public List<KhachHang> getAll(String keyword, Integer trangThai) {
        return findAll(keyword, trangThai);
    }

    public KhachHang findById(Long id) { return khRepo.findById(id); }
    public KhachHang getById(Long id)  { return khRepo.findById(id); }
    public KhachHang findBySdt(String sdt) { return khRepo.findBySdt(sdt); }
    public String getNextMaKh() { return khRepo.getNextMaKh(); }
    public boolean save(KhachHang e)   { return khRepo.save(e); }
    public boolean update(KhachHang e) { return khRepo.update(e); }
    public boolean toggleStatus(Long id) { return khRepo.toggleStatus(id); }
    public boolean delete(Long id)       { return khRepo.delete(id); }

    public List<DiaChiKhachHang> findDiaChi(Long khachHangId) {
        return dcRepo.findByKhachHangId(khachHangId);
    }

    public DiaChiKhachHang findDiaChiMacDinh(Long khachHangId) {
        return dcRepo.findDefaultByKhachHangId(khachHangId);
    }

    public boolean saveDiaChi(DiaChiKhachHang dc) { return dcRepo.save(dc); }
    public boolean updateDiaChi(DiaChiKhachHang dc) { return dcRepo.update(dc); }
    public boolean deleteDiaChiByKhachHangId(Long khachHangId) { return dcRepo.deleteByKhachHangId(khachHangId); }
    public boolean deleteDiaChi(Long id) { return dcRepo.delete(id); }
}
