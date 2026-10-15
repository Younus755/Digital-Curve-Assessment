-- Run as MySQL admin: sudo mysql < setup.sql
CREATE DATABASE IF NOT EXISTS testapp_db CHARACTER SET utf8mb4;

-- Dedicated app user (change the password!)
CREATE USER IF NOT EXISTS 'testapp_user'@'localhost' IDENTIFIED BY 'StrongPass#2026';

-- Least privilege: the app only needs to read this DB
GRANT SELECT ON testapp_db.* TO 'testapp_user'@'localhost';
FLUSH PRIVILEGES;

USE testapp_db;
CREATE TABLE IF NOT EXISTS test_records (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO test_records (message) VALUES ('Hello from MySQL! Database connectivity works.');
