-- SQLite-compatible ecommerce schema
-- 1. category table: product categories (e.g., clothing, electronics, food)
CREATE TABLE category (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE
);

-- 2. product table: product information
CREATE TABLE product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    price REAL NOT NULL, -- price (up to 2 decimal places)
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- 3. customer table: member information
CREATE TABLE customer (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL, -- store hashed password for security
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone_number TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. address table: shipping address information (linked to customer)
CREATE TABLE address (
    address_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    zip_code TEXT NOT NULL,
    is_default BOOLEAN DEFAULT 0, -- default shipping address flag
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 5. orders table: order information (order header)
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount REAL NOT NULL,
    order_status TEXT NOT NULL DEFAULT 'PENDING' CHECK (order_status IN ('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    shipping_address_id INTEGER, -- shipping address FK
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id)
);

-- 6. order_item table: order detail information (what products and quantities were ordered)
CREATE TABLE order_item (
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL, -- product price at time of order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    UNIQUE (order_id, product_id) -- only one line per product per order
);

-- 7. payment table: payment information
CREATE TABLE payment (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL UNIQUE, -- one payment per order
    payment_method TEXT NOT NULL, -- e.g., CARD, TRANSFER, PAYCO
    payment_amount REAL NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id TEXT UNIQUE,
    payment_status TEXT NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED')),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
