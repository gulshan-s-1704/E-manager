package com.ecommerce.dao;

import com.ecommerce.model.Customer;
import com.ecommerce.util.DBConnection;

import java.security.MessageDigest;
import java.sql.*;

public class CustomerDAO {

    /** Registers a new customer. Returns generated customer_id, or -1 if email already exists. */
    public int register(Customer c, String plainPassword) throws SQLException {
        if (emailExists(c.getEmail())) return -1;
        String sql = "INSERT INTO customers (full_name, email, password_hash, phone, address, role) " +
                     "VALUES (?, ?, ?, ?, ?, 'CUSTOMER')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, hash(plainPassword));
            ps.setString(4, c.getPhone());
            ps.setString(5, c.getAddress());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Validates credentials and returns the Customer object on success, or null on failure. */
    public Customer login(String email, String plainPassword) throws SQLException {
        String sql = "SELECT customer_id, full_name, email, password_hash, phone, address, role " +
                     "FROM customers WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    if (storedHash.equals(hash(plainPassword))) {
                        Customer c = new Customer();
                        c.setCustomerId(rs.getInt("customer_id"));
                        c.setFullName(rs.getString("full_name"));
                        c.setEmail(rs.getString("email"));
                        c.setPhone(rs.getString("phone"));
                        c.setAddress(rs.getString("address"));
                        c.setRole(rs.getString("role"));
                        return c;
                    }
                }
            }
        }
        return null;
    }

    public Customer getById(int customerId) throws SQLException {
        String sql = "SELECT customer_id, full_name, email, phone, address, role FROM customers WHERE customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setFullName(rs.getString("full_name"));
                    c.setEmail(rs.getString("email"));
                    c.setPhone(rs.getString("phone"));
                    c.setAddress(rs.getString("address"));
                    c.setRole(rs.getString("role"));
                    return c;
                }
            }
        }
        return null;
    }

    /** Simple SHA-256 password hashing (use BCrypt in production). */
    public static String hash(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Hashing error", e);
        }
    }
}
