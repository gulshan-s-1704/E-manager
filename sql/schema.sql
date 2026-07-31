-- ============================================================
-- E-Commerce Product and Order Management Platform - Schema
-- ============================================================
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- ---------------- Categories ----------------
CREATE TABLE categories (
    category_id     INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    description     VARCHAR(255)
);

-- ---------------- Products ----------------
CREATE TABLE products (
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    sku             VARCHAR(50) UNIQUE NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    price           DECIMAL(10,2) NOT NULL,
    category_id     INT,
    image_url       VARCHAR(255),
    active          BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- ---------------- Inventory ----------------
CREATE TABLE inventory (
    inventory_id    INT AUTO_INCREMENT PRIMARY KEY,
    product_id      INT NOT NULL UNIQUE,
    quantity        INT NOT NULL DEFAULT 0,
    reorder_level   INT NOT NULL DEFAULT 10,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------- Customers ----------------
CREATE TABLE customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    role            ENUM('CUSTOMER','ADMIN') DEFAULT 'CUSTOMER',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------- Orders ----------------
CREATE TABLE orders (
    order_id         INT AUTO_INCREMENT PRIMARY KEY,
    customer_id      INT NOT NULL,
    order_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    total_amount     DECIMAL(10,2) NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ---------------- Order Items ----------------
CREATE TABLE order_items (
    order_item_id   INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ---------------- Payments ----------------
CREATE TABLE payments (
    payment_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT NOT NULL,
    payment_method   ENUM('CARD','UPI','COD','NET_BANKING') NOT NULL,
    amount           DECIMAL(10,2) NOT NULL,
    status           ENUM('PENDING','SUCCESS','FAILED','REFUNDED') DEFAULT 'PENDING',
    transaction_ref  VARCHAR(100),
    payment_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- ---------------- Sample Data ----------------
INSERT INTO categories (name, description) VALUES
('Electronics', 'Gadgets, devices and accessories'),
('Clothing', 'Apparel for men and women'),
('Books', 'Fiction and non-fiction books'),
('Home & Kitchen', 'Home essentials and kitchenware');

INSERT INTO products (sku, name, description, price, category_id, image_url) VALUES
('ELEC-001', 'Wireless Headphones', 'Bluetooth over-ear headphones with noise cancellation', 2499.00, 1, 'headphones.jpg'),
('ELEC-002', 'Smartwatch', 'Fitness tracking smartwatch with heart rate monitor', 3999.00, 1, 'smartwatch.jpg'),
('CLOTH-001', 'Cotton T-Shirt', 'Premium cotton round neck t-shirt', 599.00, 2, 'tshirt.jpg'),
('BOOK-001', 'The Pragmatic Programmer', 'A classic book on software craftsmanship', 899.00, 3, 'book1.jpg'),
('HOME-001', 'Non-stick Pan Set', '3-piece non-stick cookware set', 1499.00, 4, 'panset.jpg');

INSERT INTO inventory (product_id, quantity, reorder_level) VALUES
(1, 50, 10), (2, 30, 5), (3, 100, 20), (4, 40, 10), (5, 25, 5);

-- Default admin (password: admin123 -> store hash in app; see CustomerDAO for hashing)
INSERT INTO customers (full_name, email, password_hash, phone, address, role) VALUES
('Admin User', 'admin@shop.com', 'SHA256HASH_PLACEHOLDER', '9999999999', 'HQ Office', 'ADMIN');
