-- Supply Chain Management Database — Typical Queries
-- These queries represent common operations that users would run on this database.


-- ============================================================
-- INSERT: Populate the database with sample data
-- ============================================================

-- Add suppliers to the system
INSERT INTO suppliers (name, contact_email, location) VALUES
('Supplier A', 'contact@suppliera.com', 'New York'),
('Supplier B', 'info@supplierb.com', 'California'),
('Supplier C', 'sales@supplierc.com', 'Texas');

-- Add products to the product catalog
INSERT INTO products (name, description, category) VALUES
('Laptop', 'High-performance laptop for business use', 'Electronics'),
('Mouse', 'Wireless ergonomic mouse', 'Electronics'),
('Chair', 'Adjustable office chair with lumbar support', 'Furniture'),
('Monitor', '27-inch 4K display', 'Electronics'),
('Desk', 'Standing desk with electric adjustment', 'Furniture');

-- Link suppliers to the products they offer, with pricing and lead times
INSERT INTO supplier_products (supplier_id, product_id, price, lead_time) VALUES
(1, 1, 1000.00, 7),
(1, 2, 25.00, 3),
(2, 3, 150.00, 10),
(2, 4, 350.00, 5),
(3, 1, 950.00, 14),
(3, 5, 500.00, 12);

-- Add warehouse locations
INSERT INTO warehouses (location) VALUES
('East Coast Warehouse'),
('West Coast Warehouse');

-- Set initial inventory levels across warehouses
INSERT INTO inventory (warehouse_id, product_id, quantity) VALUES
(1, 1, 50),
(1, 2, 100),
(1, 4, 8),
(2, 3, 20),
(2, 5, 5);

-- Register customers
INSERT INTO customers (name, contact_email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Acme Corp', 'purchasing@acmecorp.com');

-- Place customer orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-10-01'),
(2, '2024-10-02'),
(3, '2024-10-03');

-- Add line items to each order
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 5),
(2, 3, 1),
(3, 4, 10),
(3, 5, 3);

-- Create shipment records for orders
INSERT INTO shipments (order_id, shipment_date, status) VALUES
(1, '2024-10-03', 'shipped'),
(2, NULL, 'pending'),
(3, '2024-10-04', 'shipped');


-- ============================================================
-- SELECT: Read data from the database
-- ============================================================

-- Find all products along with their supplier names, prices, and lead times
SELECT p.name AS product_name, s.name AS supplier_name, sp.price, sp.lead_time
FROM products p
JOIN supplier_products sp ON p.id = sp.product_id
JOIN suppliers s ON sp.supplier_id = s.id;

-- Check inventory levels for all products across all warehouses
SELECT p.name AS product_name, w.location AS warehouse, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
ORDER BY p.name, w.location;

-- Get a summary of each order: customer name, date, number of items, and total quantity
SELECT o.id, c.name AS customer, o.order_date,
       COUNT(oi.product_id) AS total_items,
       SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, c.name, o.order_date;

-- View shipment status with customer details
SELECT s.id AS shipment_id, o.id AS order_id, c.name AS customer,
       s.shipment_date, s.status
FROM shipments s
JOIN orders o ON s.order_id = o.id
JOIN customers c ON o.customer_id = c.id;

-- Find the cheapest supplier for each product (useful for procurement decisions)
SELECT p.name AS product, s.name AS cheapest_supplier, sp.price, sp.lead_time
FROM products p
JOIN supplier_products sp ON p.id = sp.product_id
JOIN suppliers s ON sp.supplier_id = s.id
WHERE sp.price = (
    SELECT MIN(sp2.price)
    FROM supplier_products sp2
    WHERE sp2.product_id = p.id
);

-- Calculate the total value of inventory across all warehouses
SELECT SUM(i.quantity * sp.price) AS total_inventory_value
FROM inventory i
JOIN supplier_products sp ON i.product_id = sp.product_id;

-- Use the low_inventory view to find products that need restocking
SELECT * FROM low_inventory;

-- Use the order_summaries view for a quick overview of all orders
SELECT * FROM order_summaries;


-- ============================================================
-- UPDATE: Modify existing records
-- ============================================================

-- Receive new stock at a warehouse (increase inventory by 10 units)
UPDATE inventory
SET quantity = quantity + 10
WHERE warehouse_id = 1 AND product_id = 1;

-- Mark a shipment as delivered and record the delivery date
UPDATE shipments
SET status = 'delivered', shipment_date = '2024-10-05'
WHERE id = 1;

-- Update a supplier's contact email
UPDATE suppliers
SET contact_email = 'newemail@suppliera.com'
WHERE id = 1;


-- ============================================================
-- DELETE: Remove records from the database
-- ============================================================

-- Cancel a pending shipment
DELETE FROM shipments
WHERE id = 2 AND status = 'pending';

-- Remove a product from a supplier's catalog
DELETE FROM supplier_products
WHERE supplier_id = 3 AND product_id = 1;