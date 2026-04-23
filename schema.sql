-- Supply Chain Management Database Schema
-- Designed for CS50 SQL Final Project by Jorn van Schagen

-- Suppliers: companies that provide products to the supply chain
CREATE TABLE suppliers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    contact_email TEXT,
    location TEXT
);

-- Products: items that flow through the supply chain
CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT
);

-- SupplierProducts: junction table for the many-to-many relationship between suppliers and products.
-- Price and lead_time are stored here because they vary per supplier-product combination.
CREATE TABLE supplier_products (
    supplier_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    price REAL NOT NULL,
    lead_time INTEGER NOT NULL,
    PRIMARY KEY (supplier_id, product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Warehouses: physical storage locations for inventory
CREATE TABLE warehouses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    location TEXT NOT NULL
);

-- Inventory: tracks product quantities in each warehouse.
-- Uses a composite primary key to ensure one record per product per warehouse.
CREATE TABLE inventory (
    warehouse_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Customers: people or businesses that place orders
CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    contact_email TEXT
);

-- Orders: records of customer purchases, linked to the customer who placed them
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- OrderItems: junction table linking orders to products with quantities.
-- Composite key prevents duplicate product entries within the same order.
CREATE TABLE order_items (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Shipments: tracks the delivery status of each order.
-- Status defaults to 'pending' and progresses through 'shipped' and 'delivered'.
CREATE TABLE shipments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    shipment_date DATE,
    status TEXT DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Indexes on all foreign key columns to speed up JOIN operations
CREATE INDEX idx_supplier_products_supplier_id ON supplier_products(supplier_id);
CREATE INDEX idx_supplier_products_product_id ON supplier_products(product_id);
CREATE INDEX idx_inventory_warehouse_id ON inventory(warehouse_id);
CREATE INDEX idx_inventory_product_id ON inventory(product_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_shipments_order_id ON shipments(order_id);

-- View: flags products with fewer than 10 units in any warehouse (restocking alert)
CREATE VIEW low_inventory AS
SELECT p.name AS product_name, w.location AS warehouse_location, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
WHERE i.quantity < 10;

-- View: aggregates order data for quick summaries (item count and total quantity per order)
CREATE VIEW order_summaries AS
SELECT o.id AS order_id, c.name AS customer_name, o.order_date,
       COUNT(oi.product_id) AS item_count,
       SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, c.name, o.order_date;