package com.runmax.repository;

import com.runmax.config.HibernateConfig;
import com.runmax.entity.VaiTro;
import org.hibernate.Session;

import java.util.List;

public class VaiTroRepository {

    public List<VaiTro> findAll() {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.createQuery("FROM VaiTro ORDER BY id", VaiTro.class).list();
        }
    }

    public VaiTro findById(Long id) {
        try (Session session = HibernateConfig.getSessionFactory().openSession()) {
            return session.get(VaiTro.class, id);
        }
    }
}
