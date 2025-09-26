-- Sample data for ecommerce database

-- Categories
INSERT INTO category (category_name) VALUES
('Electronics'),
('Clothing'),
('Books'),
('Home & Garden'),
('Sports');

-- Products
INSERT INTO product (category_id, product_name, price, stock_quantity, description) VALUES
(1, 'iPhone 15 Pro', 999.99, 50, 'Latest iPhone with advanced camera system'),
(1, 'Samsung Galaxy S24', 899.99, 30, 'Premium Android smartphone'),
(1, 'MacBook Air M3', 1299.99, 25, 'Lightweight laptop with M3 chip'),
(2, 'Nike Air Max', 120.00, 100, 'Comfortable running shoes'),
(2, 'Levi''s 501 Jeans', 89.99, 75, 'Classic blue denim jeans'),
(2, 'Adidas T-Shirt', 29.99, 200, 'Comfortable cotton t-shirt'),
(3, 'The Great Gatsby', 12.99, 150, 'Classic American novel'),
(3, 'Python Programming', 49.99, 80, 'Learn Python programming'),
(4, 'Coffee Maker', 79.99, 40, 'Automatic drip coffee maker'),
(4, 'Garden Hose', 39.99, 60, '50ft expandable garden hose'),
(5, 'Yoga Mat', 25.99, 90, 'Non-slip yoga mat'),
(5, 'Tennis Racket', 89.99, 35, 'Professional tennis racket');

-- Customers
INSERT INTO customer (email, password_hash, first_name, last_name, phone_number) VALUES
('john.doe@email.com', 'hashed_password_1', 'John', 'Doe', '555-0101'),
('jane.smith@email.com', 'hashed_password_2', 'Jane', 'Smith', '555-0102'),
('bob.johnson@email.com', 'hashed_password_3', 'Bob', 'Johnson', '555-0103'),
('alice.brown@email.com', 'hashed_password_4', 'Alice', 'Brown', '555-0104'),
('charlie.wilson@email.com', 'hashed_password_5', 'Charlie', 'Wilson', '555-0105');

-- Addresses
INSERT INTO address (customer_id, street, city, zip_code, is_default) VALUES
(1, '123 Main St', 'New York', '10001', 1),
(1, '456 Oak Ave', 'New York', '10002', 0),
(2, '789 Pine Rd', 'Los Angeles', '90210', 1),
(3, '321 Elm St', 'Chicago', '60601', 1),
(4, '654 Maple Dr', 'Houston', '77001', 1),
(5, '987 Cedar Ln', 'Phoenix', '85001', 1);

-- Orders (with realistic dates)
INSERT INTO orders (customer_id, order_date, total_amount, order_status, shipping_address_id) VALUES
(1, '2024-01-15 10:30:00', 999.99, 'DELIVERED', 1),
(2, '2024-01-20 14:15:00', 209.98, 'SHIPPED', 3),
(3, '2024-01-25 09:45:00', 1299.99, 'PROCESSING', 4),
(1, '2024-02-01 16:20:00', 89.99, 'DELIVERED', 1),
(4, '2024-02-05 11:10:00', 79.99, 'PENDING', 5),
(5, '2024-02-10 13:30:00', 115.98, 'DELIVERED', 6);

-- Order Items
INSERT INTO order_item (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),  -- iPhone 15 Pro
(2, 4, 1, 120.00),  -- Nike Air Max
(2, 6, 3, 29.99),   -- Adidas T-Shirt (3x)
(3, 3, 1, 1299.99), -- MacBook Air M3
(4, 5, 1, 89.99),   -- Levi's 501 Jeans
(5, 9, 1, 79.99),   -- Coffee Maker
(6, 11, 1, 25.99),  -- Yoga Mat
(6, 12, 1, 89.99);  -- Tennis Racket

-- Payments
INSERT INTO payment (order_id, payment_method, payment_amount, payment_date, transaction_id, payment_status) VALUES
(1, 'CARD', 999.99, '2024-01-15 10:35:00', 'TXN001', 'PAID'),
(2, 'CARD', 209.98, '2024-01-20 14:20:00', 'TXN002', 'PAID'),
(3, 'TRANSFER', 1299.99, '2024-01-25 09:50:00', 'TXN003', 'PAID'),
(4, 'CARD', 89.99, '2024-02-01 16:25:00', 'TXN004', 'PAID'),
(5, 'CARD', 79.99, '2024-02-05 11:15:00', 'TXN005', 'PENDING'),
(6, 'CARD', 115.98, '2024-02-10 13:35:00', 'TXN006', 'PAID');
