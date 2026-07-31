package com.ecommerce.dao;

import com.ecommerce.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.UUID;

/**
 * Handles payment records. In production this would call out to a real
 * gateway (Razorpay/Stripe/PayPal) via their SDK/REST API; here we simulate
 * a successful transaction and persist the result, keeping the same
 * Connection so it participates in the caller's transaction.
 */
public class PaymentDAO {

    public void recordPayment(Connection conn, int orderId, String method, BigDecimal amount) throws SQLException {
        String transactionRef = "TXN-" + UUID.randomUUID().toString().substring(0, 12).toUpperCase();
        String sql = "INSERT INTO payments (order_id, payment_method, amount, status, transaction_ref) " +
                     "VALUES (?, ?, ?, 'SUCCESS', ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, method);
            ps.setBigDecimal(3, amount);
            ps.setString(4, transactionRef);
            ps.executeUpdate();
        }
    }

    public String getStatusForOrder(int orderId) throws SQLException {
        String sql = "SELECT status FROM payments WHERE order_id = ? ORDER BY payment_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("status") : "N/A";
            }
        }
    }
}
