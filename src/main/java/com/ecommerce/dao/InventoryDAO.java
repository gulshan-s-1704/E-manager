package com.ecommerce.dao;

import com.ecommerce.util.DBConnection;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class InventoryDAO {

    public int getStock(int productId) throws SQLException {
        String sql = "SELECT quantity FROM inventory WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        }
    }

    /** Reduce stock after an order is placed. Must be called within same connection/transaction ideally,
     *  but exposed standalone for simplicity; OrderDAO calls the transactional version internally. */
    public boolean reduceStock(Connection conn, int productId, int quantity) throws SQLException {
        String sql = "UPDATE inventory SET quantity = quantity - ? WHERE product_id = ? AND quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        }
    }

    public void restock(int productId, int quantity) throws SQLException {
        String sql = "UPDATE inventory SET quantity = quantity + ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    /** Returns productId -> quantity map for products at/below reorder level (low-stock alert). */
    public Map<String, Integer> getLowStockProducts() throws SQLException {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT p.name, i.quantity FROM inventory i " +
                     "JOIN products p ON p.product_id = i.product_id " +
                     "WHERE i.quantity <= i.reorder_level ORDER BY i.quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getString("name"), rs.getInt("quantity"));
            }
        }
        return result;
    }
}
