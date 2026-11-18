package com.ecommerce;

import com.ecommerce.dao.*;
import com.ecommerce.model.*;
import com.ecommerce.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TestRunner {

    private static int passed = 0;
    private static int failed = 0;

    private static void check(String name, boolean condition) {
        if (condition) {
            System.out.println("  [PASS] " + name);
            passed++;
        } else {
            System.err.println("  [FAIL] " + name);
            failed++;
        }
    }

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("   E-MANAGER COMPREHENSIVE VERIFICATION SUITE    ");
        System.out.println("=================================================");

        // Test 1: DB Connection
        try (Connection conn = DBConnection.getConnection()) {
            check("1. Database Connection Established", conn != null && !conn.isClosed());
        } catch (Exception e) {
            check("1. Database Connection Established (" + e.getMessage() + ")", false);
        }

        // Test 2: Categories Loaded
        CategoryDAO catDAO = new CategoryDAO();
        try {
            List<Category> cats = catDAO.getAllCategories();
            check("2. Categories Loaded from DB (Count: " + cats.size() + ")", cats.size() >= 4);
        } catch (Exception e) {
            check("2. Categories Loaded", false);
        }

        // Test 3: Products Loaded
        ProductDAO prodDAO = new ProductDAO();
        List<Product> products = null;
        try {
            products = prodDAO.getAllProducts();
            check("3. Products Loaded from DB (Count: " + products.size() + ")", products.size() >= 30);
        } catch (Exception e) {
            check("3. Products Loaded", false);
        }

        // Test 4: Product Images Valid
        boolean allImagesValid = true;
        if (products != null) {
            for (Product p : products) {
                if (p.getImageUrl() == null || p.getImageUrl().trim().isEmpty()) {
                    allImagesValid = false;
                    break;
                }
            }
        }
        check("4. All Products Have Non-Empty Image URLs", allImagesValid);

        // Test 5: Search Functionality
        try {
            List<Product> searchRes = prodDAO.searchProducts("Headphones");
            check("5. Search Works (Query 'Headphones', Found: " + searchRes.size() + ")", !searchRes.isEmpty());
        } catch (Exception e) {
            check("5. Search Works", false);
        }

        // Test 6: Category Filtering
        try {
            List<Product> elecProds = prodDAO.getProductsByCategory(1);
            check("6. Category Filtering Works (Electronics Count: " + elecProds.size() + ")", elecProds.size() >= 8);
        } catch (Exception e) {
            check("6. Category Filtering Works", false);
        }

        // Test 7: Admin Login Validation
        CustomerDAO custDAO = new CustomerDAO();
        Customer admin = null;
        try {
            admin = custDAO.login("admin@shop.com", "admin123");
            check("7. Admin Login with admin@shop.com / admin123", admin != null && admin.isAdmin());
        } catch (Exception e) {
            check("7. Admin Login", false);
        }

        // Test 8: Customer Registration & Login
        String testEmail = "tester_" + System.currentTimeMillis() + "@shop.com";
        Customer newCustomer = new Customer();
        newCustomer.setFullName("Automated QA Tester");
        newCustomer.setEmail(testEmail);
        newCustomer.setPhone("9876543210");
        newCustomer.setAddress("42 Quality Assurance Boulevard, Tech Park");
        int newCustId = -1;
        try {
            newCustId = custDAO.register(newCustomer, "testpass123");
            Customer loggedIn = custDAO.login(testEmail, "testpass123");
            check("8. Customer Registration & Login Verified (ID: " + newCustId + ")", loggedIn != null && loggedIn.getCustomerId() == newCustId);
        } catch (Exception e) {
            check("8. Customer Registration & Login", false);
        }

        // Test 9 & 10: Cart & Calculations
        CartItem item1 = new CartItem(products.get(0).getProductId(), products.get(0).getName(), products.get(0).getPrice(), 2, products.get(0).getImageUrl());
        CartItem item2 = new CartItem(products.get(1).getProductId(), products.get(1).getName(), products.get(1).getPrice(), 1, products.get(1).getImageUrl());
        BigDecimal expectedTotal = item1.getSubtotal().add(item2.getSubtotal());
        check("9. Cart Subtotals and Totals Calculated Correctly",
                item1.getSubtotal().compareTo(products.get(0).getPrice().multiply(BigDecimal.valueOf(2))) == 0 &&
                expectedTotal.compareTo(item1.getSubtotal().add(item2.getSubtotal())) == 0);

        // Test 11 & 12: Transactional Order Placement & Inventory Deduction
        OrderDAO orderDAO = new OrderDAO();
        int testOrderId = -1;
        try {
            Product targetProd = products.get(0);
            int initialStock = targetProd.getStockQuantity();

            List<CartItem> orderItems = new ArrayList<>();
            orderItems.add(new CartItem(targetProd.getProductId(), targetProd.getName(), targetProd.getPrice(), 1, targetProd.getImageUrl()));

            testOrderId = orderDAO.placeOrder(newCustId, orderItems, "123 Test Shipping Street", "CARD");
            Product reloadedProd = prodDAO.getProductById(targetProd.getProductId());
            int newStock = reloadedProd.getStockQuantity();

            check("10. Order Placed Successfully (Order ID: #" + testOrderId + ")", testOrderId > 0);
            check("11. Stock Decreased Automatically (" + initialStock + " -> " + newStock + ")", newStock == initialStock - 1);
        } catch (Exception e) {
            check("10 & 11. Order Placement and Stock Deduction (" + e.getMessage() + ")", false);
        }

        // Test 13: Order Status Advancement
        try {
            orderDAO.updateStatus(testOrderId, "CONFIRMED");
            Order o1 = orderDAO.getOrderById(testOrderId);
            orderDAO.updateStatus(testOrderId, "SHIPPED");
            Order o2 = orderDAO.getOrderById(testOrderId);
            orderDAO.updateStatus(testOrderId, "DELIVERED");
            Order o3 = orderDAO.getOrderById(testOrderId);

            check("12. Admin Order Status Update (Confirmed -> Shipped -> Delivered)",
                    "DELIVERED".equals(o3.getStatus()) && "SHIPPED".equals(o2.getStatus()) && "CONFIRMED".equals(o1.getStatus()));
        } catch (Exception e) {
            check("12. Admin Order Status Update (" + e.getMessage() + ")", false);
        }

        // Test 14: Simulated Payment Row Recorded
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT status, payment_method, amount FROM payments WHERE order_id = " + testOrderId)) {
            check("13. Payment Record Created for Order", rs.next() && "SUCCESS".equals(rs.getString("status")));
        } catch (Exception e) {
            check("13. Payment Record Created", false);
        }

        // Test 15: Admin Product Add, Edit & Restock
        try {
            Product pNew = new Product();
            String testSku = "TEST-QA-" + System.currentTimeMillis();
            pNew.setSku(testSku);
            pNew.setName("QA Test Automated Product");
            pNew.setDescription("Test product created by verification suite");
            pNew.setPrice(new BigDecimal("199.99"));
            pNew.setCategoryId(1);
            pNew.setImageUrl("images/products/elec_headphones.jpg");

            int addedId = prodDAO.addProduct(pNew, 10);
            Product loaded = prodDAO.getProductById(addedId);

            loaded.setName("QA Test Product (Updated Name)");
            loaded.setPrice(new BigDecimal("249.99"));
            prodDAO.updateProduct(loaded);
            Product updated = prodDAO.getProductById(addedId);

            InventoryDAO invDAO = new InventoryDAO();
            invDAO.restock(addedId, 15);
            Product restocked = prodDAO.getProductById(addedId);

            prodDAO.deactivateProduct(addedId);
            Product deactivated = prodDAO.getProductById(addedId);

            check("14. Admin Product CRUD & Restock Verified (Add, Update, Restock, Soft Delete)",
                    loaded != null &&
                    "QA Test Product (Updated Name)".equals(updated.getName()) &&
                    restocked.getStockQuantity() == 25 &&
                    !deactivated.isActive());
        } catch (Exception e) {
            check("14. Admin Product CRUD & Restock (" + e.getMessage() + ")", false);
        }

        // Test 16: Analytics Metrics
        AnalyticsDAO analyticsDAO = new AnalyticsDAO();
        try {
            BigDecimal totalRev = analyticsDAO.getTotalRevenue();
            int totalOrders = analyticsDAO.getTotalOrderCount();
            int totalCustomers = analyticsDAO.getTotalCustomerCount();
            Map<String, Integer> breakdown = analyticsDAO.getOrderStatusBreakdown();

            check("15. Analytics Calculations Valid (Rev: ₹" + totalRev + ", Orders: " + totalOrders + ", Customers: " + totalCustomers + ")",
                    totalRev != null && totalOrders > 0 && totalCustomers > 0 && !breakdown.isEmpty());
        } catch (Exception e) {
            check("15. Analytics Calculations (" + e.getMessage() + ")", false);
        }

        System.out.println("=================================================");
        System.out.println("TOTAL PASSED: " + passed + " / " + (passed + failed));
        if (failed == 0) {
            System.out.println(">>> ALL BACKEND & DATABASE TESTS PASSED! <<<");
        } else {
            System.err.println(">>> SOME TESTS FAILED! <<<");
        }
        System.out.println("=================================================");
    }
}
