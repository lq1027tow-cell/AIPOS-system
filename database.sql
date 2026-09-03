CREATE DATABASE IF NOT EXISTS ai_pos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ai_pos;

CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(120) NOT NULL, email VARCHAR(190) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL, role ENUM('admin','cashier') NOT NULL DEFAULT 'cashier', active TINYINT(1) NOT NULL DEFAULT 1,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE categories (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE products (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(160) NOT NULL, sku VARCHAR(80) NOT NULL UNIQUE, category_id INT UNSIGNED NULL,
 price DECIMAL(10,2) NOT NULL DEFAULT 0, stock INT NOT NULL DEFAULT 0, image VARCHAR(255) NULL, status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);
CREATE TABLE orders (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, receipt_no VARCHAR(40) NOT NULL UNIQUE, cashier_id INT UNSIGNED NOT NULL,
 subtotal DECIMAL(10,2) NOT NULL, discount DECIMAL(10,2) NOT NULL DEFAULT 0, total DECIMAL(10,2) NOT NULL,
 payment_method ENUM('cash','card','qr','tng_ewallet') NOT NULL, amount_paid DECIMAL(10,2) NOT NULL, change_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (cashier_id) REFERENCES users(id)
);
CREATE TABLE order_items (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, order_id BIGINT UNSIGNED NOT NULL, product_id INT UNSIGNED NOT NULL,
 product_name VARCHAR(160) NOT NULL, sku VARCHAR(80) NOT NULL, price DECIMAL(10,2) NOT NULL, quantity INT NOT NULL, line_total DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE TABLE settings (`key` VARCHAR(80) PRIMARY KEY, `value` TEXT NULL);
CREATE TABLE audit_logs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, user_id INT UNSIGNED NULL, action VARCHAR(160) NOT NULL, details TEXT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL);
INSERT INTO categories (name) VALUES
 ('Desktops'), ('Laptops'), ('Gaming Laptops'), ('Graphics Cards'), ('CPUs'),
 ('RAM'), ('Hard Drives/SSDs'), ('Motherboards'), ('Power Supplies'), ('Coolers');
INSERT INTO settings (`key`, `value`) VALUES ('gemini_api_key',''), ('gemini_model','gemini-3.7-flash');
INSERT INTO users (name,email,password_hash,role) VALUES
 ('Administrator','admin','$2y$12$0QvqAAKYURFvf1wgiUwKpum6UR26bEAlTH3J0uN8eta6kkLMwspVu','admin'),
 ('Cashier','cashier','$2y$12$0QvqAAKYURFvf1wgiUwKpum6UR26bEAlTH3J0uN8eta6kkLMwspVu','cashier');
INSERT INTO products (name,sku,category_id,price,stock) VALUES
 ('Coca Cola 325ml','DRK-001',1,2.50,40),
 ('Mineral Water 500ml','DRK-002',1,1.50,60),
 ('Fresh Bread','BAK-001',2,3.00,18),
 ('Chocolate Biscuit','GRO-001',3,2.80,25);
