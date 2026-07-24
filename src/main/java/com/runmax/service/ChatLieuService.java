package com.runmax.service;

import com.runmax.entity.ChatLieu;
import com.runmax.repository.ChatLieuRepository;

import java.util.List;

public class ChatLieuService {
    private final ChatLieuRepository repository = new ChatLieuRepository();

    public List<ChatLieu> findAll(String keyword) {
        return repository.findAll(keyword);
    }

    public List<ChatLieu> getAll(String keyword) {
        return repository.findAll(keyword);
    }

    public ChatLieu findById(Long id) {
        if (id == null || id <= 0) return null;
        return repository.findById(id);
    }

    public ChatLieu getById(Long id) {
        return findById(id);
    }

    public boolean save(ChatLieu e) {
        return repository.save(e);
    }

    public boolean create(String ten) {
        if (ten == null || ten.trim().isEmpty()) return false;
        return repository.save(ChatLieu.builder().ten(ten.trim()).trangThai(1).build());
    }

    public boolean update(ChatLieu e) {
        return repository.update(e);
    }

    public boolean update(Long id, String ten, Integer trangThai) {
        ChatLieu e = findById(id);
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
