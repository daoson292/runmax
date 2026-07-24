package com.runmax.config;

import com.runmax.service.HoaDonService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

@WebListener
public class JobManagerListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(JobManagerListener.class.getName());
    private ScheduledExecutorService scheduler;
    private final HoaDonService hoaDonService = new HoaDonService();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        
        // Chạy job dọn dẹp hóa đơn mỗi 1 giờ
        scheduler.scheduleAtFixedRate(() -> {
            try {
                int count = hoaDonService.cancelExpiredPendingInvoices();
                if (count > 0) {
                    LOGGER.info("Đã tự động hủy " + count + " hóa đơn chờ quá hạn 24h.");
                }
            } catch (Exception e) {
                LOGGER.severe("Lỗi khi chạy job hủy hóa đơn tự động: " + e.getMessage());
                e.printStackTrace();
            }
        }, 0, 1, TimeUnit.HOURS);
        
        LOGGER.info("JobManagerListener đã khởi chạy schedule dọn dẹp Hóa Đơn.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            LOGGER.info("JobManagerListener đã tắt schedule.");
        }
    }
}
