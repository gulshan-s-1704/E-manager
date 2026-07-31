package com.ecommerce.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Central JDBC connection provider using a HikariCP connection pool.
 *
 * Reads DB_URL / DB_USER / DB_PASSWORD from environment variables so the
 * same code works locally AND on a host like Render, where you set these
 * as Environment Variables in the dashboard. If the env vars are not set
 * (e.g. running locally without configuring them), it falls back to
 * localhost defaults for convenience.
 */
public class DBConnection {

    private static final String DB_URL = getEnvOrDefault(
            "DB_URL",
            "jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
    private static final String DB_USER = getEnvOrDefault("DB_USER", "root");
    private static final String DB_PASSWORD = getEnvOrDefault("DB_PASSWORD", "root");

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(DB_URL);
            config.setUsername(DB_USER);
            config.setPassword(DB_PASSWORD);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            config.setMaximumPoolSize(15);
            config.setMinimumIdle(3);
            config.setPoolName("EcommercePool");
            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize DB connection pool", e);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try {
                    r.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
