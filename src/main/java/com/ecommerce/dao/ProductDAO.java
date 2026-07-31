package com.ecommerce.dao;

import com.ecommerce.model.Product;
import com.ecommerce.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access object for Product Catalog Management.
 * Joins with inventory to expose current stock levels.
 */
public class ProductDAO {

    private static final String BASE_SELECT =
            "SELECT p.product_id, p.sku, p.name, p.description, p.price, p.category_id, " +
            "       c.name AS category_name, p.image_url, p.active, " +
            "       COALESCE(i.quantity, 0) AS stock_quantity " +
            "FROM products p " +
            "LEFT JOIN categories c ON p.category_id = c.category_id " +
            "LEFT JOIN inventory i ON p.product_id = i.product_id ";

    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.active = TRUE ORDER BY p.product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapRow(rs));
            }
        }
        return products;
    }

    public List<Product> getProductsByCategory(int categoryId) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.active = TRUE AND p.category_id = ? ORDER BY p.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) products.add(mapRow(rs));
            }
        }
        return products;
    }

    public List<Product> searchProducts(String keyword) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.active = TRUE AND (p.name LIKE ? OR p.description LIKE ?) ORDER BY p.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) products.add(mapRow(rs));
            }
        }
        return products;
    }

    public Product getProductById(int productId) throws SQLException {
        String sql = BASE_SELECT + "WHERE p.product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Insert new product and matching zero-stock inventory row. Returns generated ID. */
    public int addProduct(Product p, int initialStock) throws SQLException {
        String sql = "INSERT INTO products (sku, name, description, price, category_id, image_url, active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, TRUE)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            int newId;
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, p.getSku());
                ps.setString(2, p.getName());
                ps.setString(3, p.getDescription());
                ps.setBigDecimal(4, p.getPrice());
                ps.setInt(5, p.getCategoryId());
                ps.setString(6, p.getImageUrl());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    newId = keys.getInt(1);
                }
            }
            try (PreparedStatement invPs = conn.prepareStatement(
                    "INSERT INTO inventory (product_id, quantity, reorder_level) VALUES (?, ?, 10)")) {
                invPs.setInt(1, newId);
                invPs.setInt(2, initialStock);
                invPs.executeUpdate();
            }
            conn.commit();
            return newId;
        }
    }

    public void updateProduct(Product p) throws SQLException {
        String sql = "UPDATE products SET name=?, description=?, price=?, category_id=?, image_url=? WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setBigDecimal(3, p.getPrice());
            ps.setInt(4, p.getCategoryId());
            ps.setString(5, p.getImageUrl());
            ps.setInt(6, p.getProductId());
            ps.executeUpdate();
        }
    }

    /** Soft delete - keeps historical order data intact. */
    public void deactivateProduct(int productId) throws SQLException {
        String sql = "UPDATE products SET active = FALSE WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setSku(rs.getString("sku"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setImageUrl(rs.getString("image_url"));
        p.setActive(rs.getBoolean("active"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        return p;
    }
}
