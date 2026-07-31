package com.ecommerce.dao;

import com.ecommerce.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

/** Powers the Sales Analytics section of the admin dashboard. */
public class AnalyticsDAO {

    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount),0) AS total FROM orders WHERE status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal("total");
        }
    }

    public int getTotalOrderCount() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt("cnt");
        }
    }

    public int getTotalCustomerCount() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM customers WHERE role = 'CUSTOMER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt("cnt");
        }
    }

    /** Top-selling products by total quantity sold (best sellers widget). */
    public Map<String, Integer> getTopSellingProducts(int limit) throws SQLException {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT p.name, SUM(oi.quantity) AS total_qty " +
                     "FROM order_items oi JOIN products p ON oi.product_id = p.product_id " +
                     "JOIN orders o ON oi.order_id = o.order_id " +
                     "WHERE o.status != 'CANCELLED' " +
                     "GROUP BY p.product_id, p.name ORDER BY total_qty DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.put(rs.getString("name"), rs.getInt("total_qty"));
            }
        }
        return result;
    }

    /** Daily revenue for the last N days (for a sales trend chart). */
    public Map<String, BigDecimal> getDailyRevenue(int days) throws SQLException {
        Map<String, BigDecimal> result = new LinkedHashMap<>();
        String sql = "SELECT DATE(order_date) AS day, SUM(total_amount) AS revenue " +
                     "FROM orders WHERE status != 'CANCELLED' AND order_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                     "GROUP BY DATE(order_date) ORDER BY day";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getDate("day").toString(), rs.getBigDecimal("revenue"));
                }
            }
        }
        return result;
    }

    /** Order counts grouped by status - feeds the order tracking dashboard summary. */
    public Map<String, Integer> getOrderStatusBreakdown() throws SQLException {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM orders GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) result.put(rs.getString("status"), rs.getInt("cnt"));
        }
        return result;
    }
}
