package com.ecommerce.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Resilient, cloud-compatible JDBC connection provider using a HikariCP connection pool.
 *
 * Supports Railway, Render, Clever Cloud, Heroku, AWS, and local MySQL environments.
 * Dynamically resolves connection parameters from standard environment variables:
 *   - DB_URL / DATABASE_URL / MYSQL_URL / MYSQL_PUBLIC_URL / MYSQL_ADDON_URI
 *   - MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD
 *
 * Uses lazy, self-healing initialization to eliminate JVM NoClassDefFoundError
 * caused by static initializer failures during container startup.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static volatile HikariDataSource dataSource;
    private static final Object INIT_LOCK = new Object();

    // Register MySQL driver cleanly
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                LOGGER.log(Level.WARNING, "MySQL JDBC Driver not found on classpath", ex);
            }
        }
    }

    private DBConnection() {
    }

    /**
     * Resolves the database connection information and returns a singleton HikariDataSource.
     * Uses double-checked locking so failure on one request does not lock out future attempts.
     */
    private static HikariDataSource getDataSource() throws SQLException {
        if (dataSource == null || dataSource.isClosed()) {
            synchronized (INIT_LOCK) {
                if (dataSource == null || dataSource.isClosed()) {
                    dataSource = createDataSource();
                }
            }
        }
        return dataSource;
    }

    private static HikariDataSource createDataSource() throws SQLException {
        ResolvedConfig config = resolveConfiguration();
        LOGGER.info("Initializing HikariCP database pool for: " + maskUrl(config.jdbcUrl));

        try {
            HikariConfig hkConfig = new HikariConfig();
            hkConfig.setJdbcUrl(config.jdbcUrl);
            hkConfig.setUsername(config.username);
            hkConfig.setPassword(config.password);
            hkConfig.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Connection pool sizing and timeouts tuned for cloud micro-instances
            hkConfig.setMaximumPoolSize(10);
            hkConfig.setMinimumIdle(1);
            hkConfig.setConnectionTimeout(15000);   // 15 seconds wait for available connection
            hkConfig.setValidationTimeout(4000);     // 4 seconds validation query timeout
            hkConfig.setIdleTimeout(600000);         // 10 minutes idle timeout
            hkConfig.setMaxLifetime(1800000);        // 30 minutes max lifetime
            
            // Critical for cloud: do not abort pool creation if DB is temporarily starting
            hkConfig.setInitializationFailTimeout(-1);
            hkConfig.setPoolName("EcommerceHikariPool");

            // Performance optimizations for MySQL
            hkConfig.addDataSourceProperty("cachePrepStmts", "true");
            hkConfig.addDataSourceProperty("prepStmtCacheSize", "250");
            hkConfig.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            hkConfig.addDataSourceProperty("useServerPrepStmts", "true");

            return new HikariDataSource(hkConfig);
        } catch (Exception e) {
            String msg = "Failed to initialize database connection pool [" + maskUrl(config.jdbcUrl) + "]: " + e.getMessage();
            LOGGER.log(Level.SEVERE, msg, e);
            throw new SQLException(msg, e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try {
                    r.close();
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Error closing resource", e);
                }
            }
        }
    }

    /**
     * Resolves JDBC URL, username, and password across all supported cloud deployment variables.
     */
    static ResolvedConfig resolveConfiguration() {
        // 1. Check direct URL environment variables
        String rawUrl = getFirstEnv("DB_URL", "DATABASE_URL", "MYSQL_URL", "MYSQL_PUBLIC_URL", "MYSQL_ADDON_URI");
        String user = getFirstEnv("DB_USER", "MYSQLUSER", "MYSQL_USER", "MYSQL_USERNAME");
        String pass = getFirstEnv("DB_PASSWORD", "MYSQLPASSWORD", "MYSQL_PASSWORD");

        // 2. If no direct URL, check separate host/port/database variables (e.g. Railway / AWS)
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            String host = getFirstEnv("MYSQLHOST", "MYSQL_HOST", "DB_HOST");
            String port = getFirstEnv("MYSQLPORT", "MYSQL_PORT", "DB_PORT");
            String db = getFirstEnv("MYSQLDATABASE", "MYSQL_DATABASE", "DB_NAME");

            if (host != null && !host.trim().isEmpty()) {
                if (port == null || port.trim().isEmpty()) port = "3306";
                if (db == null || db.trim().isEmpty()) db = "ecommerce_db";
                rawUrl = "jdbc:mysql://" + host.trim() + ":" + port.trim() + "/" + db.trim();
            }
        }

        // 3. Fallback to local default if still unset
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            rawUrl = "jdbc:mysql://localhost:3306/ecommerce_db";
        }
        if (user == null || user.trim().isEmpty()) {
            user = "root";
        }
        if (pass == null) {
            pass = "123456";
        }

        // 4. Parse URI scheme if in mysql:// format
        String finalUrl = rawUrl.trim();
        if (finalUrl.startsWith("mysql://")) {
            try {
                URI uri = new URI(finalUrl);
                String userInfo = uri.getUserInfo();
                if (userInfo != null && !userInfo.isEmpty()) {
                    String[] parts = userInfo.split(":", 2);
                    if (parts.length >= 1 && (user == null || user.equals("root"))) {
                        user = URLDecoder.decode(parts[0], StandardCharsets.UTF_8.name());
                    }
                    if (parts.length >= 2) {
                        pass = URLDecoder.decode(parts[1], StandardCharsets.UTF_8.name());
                    }
                }
                String host = uri.getHost();
                int port = uri.getPort() != -1 ? uri.getPort() : 3306;
                String path = uri.getPath();
                if (path != null && path.startsWith("/")) {
                    path = path.substring(1);
                }
                finalUrl = "jdbc:mysql://" + host + ":" + port + "/" + path;
                if (uri.getQuery() != null && !uri.getQuery().isEmpty()) {
                    finalUrl += "?" + uri.getQuery();
                }
            } catch (Exception e) {
                // If URI parse fails, fallback to simple string replacement
                finalUrl = "jdbc:" + finalUrl;
            }
        } else if (!finalUrl.startsWith("jdbc:mysql://")) {
            finalUrl = "jdbc:mysql://" + finalUrl;
        }

        // 5. Ensure required parameters exist for modern MySQL 8 compatibility
        if (!finalUrl.contains("serverTimezone")) {
            finalUrl += (finalUrl.contains("?") ? "&" : "?") + "serverTimezone=UTC";
        }
        if (!finalUrl.contains("allowPublicKeyRetrieval")) {
            finalUrl += "&allowPublicKeyRetrieval=true";
        }
        if (!finalUrl.contains("useSSL")) {
            // Default to useSSL=false with allowPublicKeyRetrieval for safe connections unless SSL is explicitly specified
            finalUrl += "&useSSL=false";
        }

        return new ResolvedConfig(finalUrl, user, pass);
    }

    private static String getFirstEnv(String... keys) {
        for (String k : keys) {
            String val = System.getenv(k);
            if (val != null && !val.trim().isEmpty()) {
                return val.trim();
            }
        }
        return null;
    }

    private static String maskUrl(String url) {
        if (url == null) return "null";
        return url.replaceAll("(?i)(password=)[^&;]*", "$1****")
                  .replaceAll("(://[^:]+:)[^@]+(@)", "$1****$2");
    }

    static class ResolvedConfig {
        final String jdbcUrl;
        final String username;
        final String password;

        ResolvedConfig(String jdbcUrl, String username, String password) {
            this.jdbcUrl = jdbcUrl;
            this.username = username;
            this.password = password;
        }
    }
}
