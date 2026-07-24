package com.runmax.service;

import com.runmax.entity.VaiTro;
import com.runmax.repository.VaiTroRepository;

import java.util.List;

public class VaiTroService {
    private final VaiTroRepository repo = new VaiTroRepository();

    public List<VaiTro> findAll() { return repo.findAll(); }
    public VaiTro findById(Long id) { return repo.findById(id); }
}
