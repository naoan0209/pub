-- データベースの作成
CREATE DATABASE IF NOT EXISTS sample_database;
USE sample_database;

-- usersテーブルの作成
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- productsテーブルの作成
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- usersテーブルにサンプルデータを挿入
INSERT INTO users (username, email) VALUES
('user1', 'user1@example.com'),
('user2', 'user2@example.com'),
('user3', 'user3@example.com');

-- productsテーブルにサンプルデータを挿入
INSERT INTO products (name, description, price) VALUES
('Product 1', 'Description for product 1', 99.99),
('Product 2', 'Description for product 2', 199.99),
('Product 3', 'Description for product 3', 299.99);
