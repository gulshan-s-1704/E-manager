package com.ecommerce;

import com.ecommerce.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {

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
        System.out.println("   DBCONNECTION RESILIENCY & PARSING TESTS       ");
        System.out.println("=================================================");

        // Test 1: Class loads cleanly without NoClassDefFoundError
        boolean classLoadedCleanly = false;
        try {
            Class<?> clazz = Class.forName("com.ecommerce.util.DBConnection");
            classLoadedCleanly = (clazz != null);
        } catch (Throwable t) {
            classLoadedCleanly = false;
        }
        check("1. DBConnection class loads without ExceptionInInitializerError", classLoadedCleanly);

        // Test 2: Local connection works
        boolean localConnWorks = false;
        try (Connection conn = DBConnection.getConnection()) {
            localConnWorks = (conn != null && !conn.isClosed());
        } catch (SQLException e) {
            System.out.println("     Info: " + e.getMessage());
            localConnWorks = false;
        }
        check("2. Local database connection established", localConnWorks);

        System.out.println("=================================================");
        System.out.println("TESTS: " + passed + " / " + (passed + failed) + " passed");
        System.out.println("=================================================");
    }
}
