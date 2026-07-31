package com.ecommerce.dao;

import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Places an order: inserts the order + order_items, decrements inventory,
     * and records a payment - all inside a single DB transaction.
     * Throws SQLException with a descriptive message if any product is out of stock,
     * causing the entire transaction to roll back.
     */
    public int placeOrder(int customerId, List<CartItem> cartItems, String shippingAddress,
                           String paymentMethod) throws SQLException {
        String orderSql = "INSERT INTO orders (customer_id, status, total_amount, shipping_address) VALUES (?, 'PENDING', ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            total = total.add(item.getSubtotal());
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, customerId);
                    ps.setBigDecimal(2, total);
                    ps.setString(3, shippingAddress);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        orderId = keys.getInt(1);
                    }
                }

                for (CartItem item : cartItems) {
                    // Reduce inventory first; fail fast if insufficient stock
                    boolean ok = inventoryDAO.reduceStock(conn, item.getProductId(), item.getQuantity());
                    if (!ok) {
                        throw new SQLException("Insufficient stock for product: " + item.getProductName());
                    }
                    try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getProductId());
                        ps.setInt(3, item.getQuantity());
                        ps.setBigDecimal(4, item.getUnitPrice());
                        ps.executeUpdate();
                    }
                }

                // Record payment (simulated gateway - see PaymentDAO)
                paymentDAO.recordPayment(conn, orderId, paymentMethod, total);

                // Mark order confirmed once payment + stock succeed
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE orders SET status = 'CONFIRMED' WHERE order_id = ?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                conn.commit();
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public List<Order> getOrdersByCustomer(int customerId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, customer_id, order_date, status, total_amount, shipping_address " +
                     "FROM orders WHERE customer_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapOrderRow(rs));
            }
        }
        return orders;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.customer_id, o.order_date, o.status, o.total_amount, " +
                     "o.shipping_address, c.full_name AS customer_name " +
                     "FROM orders o JOIN customers c ON o.customer_id = c.customer_id " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = mapOrderRow(rs);
                o.setCustomerName(rs.getString("customer_name"));
                orders.add(o);
            }
        }
        return orders;
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.order_id, o.customer_id, o.order_date, o.status, o.total_amount, " +
                     "o.shipping_address, c.full_name AS customer_name " +
                     "FROM orders o JOIN customers c ON o.customer_id = c.customer_id " +
                     "WHERE o.order_id = ?";
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapOrderRow(rs);
                    order.setCustomerName(rs.getString("customer_name"));
                }
            }
        }
        if (order != null) {
            order.setItems(getOrderItems(orderId));
        }
        return order;
    }

    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price, p.name AS product_name " +
                     "FROM order_items oi JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setOrderItemId(rs.getInt("order_item_id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setProductId(rs.getInt("product_id"));
                    oi.setProductName(rs.getString("product_name"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    items.add(oi);
                }
            }
        }
        return items;
    }

    /** Updates order status - used by the Order Tracking Dashboard (admin). */
    public void updateStatus(int orderId, String newStatus) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    private Order mapOrderRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setCustomerId(rs.getInt("customer_id"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setStatus(rs.getString("status"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setShippingAddress(rs.getString("shipping_address"));
        return o;
    }
}
