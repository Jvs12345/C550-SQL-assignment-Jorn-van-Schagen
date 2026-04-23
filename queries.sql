-- Supply Chain Management Database Queries

-- Insert sample data

-- Insert suppliers
INSERT INTO suppliers (name, contact_email, location) VALUES
('Supplier A', 'contact@suppliera.com', 'New York'),
('Supplier B', 'info@supplierb.com', 'California');

-- Insert products
INSERT INTO products (name, description, category) VALUES
('Laptop', 'High-performance laptop', 'Electronics'),
('Mouse', 'Wireless mouse', 'Electronics'),
('Chair', 'Office chair', 'Furniture');

-- Insert supplier products
INSERT INTO supplier_products (supplier_id, product_id, price, lead_time) VALUES
(1, 1, 1000.00, 7),
(1, 2, 25.00, 3),
(2, 3, 150.00, 10);

-- Insert warehouses
INSERT INTO warehouses (location) VALUES
('East Coast Warehouse'),
('West Coast Warehouse');

-- Insert inventory
INSERT INTO inventory (warehouse_id, product_id, quantity) VALUES
(1, 1, 50),
(1, 2, 100),
(2, 3, 20);

-- Insert customers
INSERT INTO customers (name, contact_email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');

-- Insert orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2023-10-01'),
(2, '2023-10-02');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 5),
(2, 3, 1);

-- Insert shipments
INSERT INTO shipments (order_id, shipment_date, status) VALUES
(1, '2023-10-03', 'shipped'),
(2, NULL, 'pending');

-- Select queries

-- Get all products with their suppliers
SELECT p.name AS product_name, s.name AS supplier_name, sp.price, sp.lead_time
FROM products p
JOIN supplier_products sp ON p.id = sp.product_id
JOIN suppliers s ON sp.supplier_id = s.id;

-- Get inventory levels for all products across warehouses
SELECT p.name AS product_name, w.location AS warehouse, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
ORDER BY p.name, w.location;

-- Get orders with customer details and total items
SELECT o.id, c.name AS customer, o.order_date, COUNT(oi.product_id) AS total_items, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, c.name, o.order_date;

-- Get shipments status
SELECT s.id, o.id AS order_id, c.name AS customer, s.shipment_date, s.status
FROM shipments s
JOIN orders o ON s.order_id = o.id
JOIN customers c ON o.customer_id = c.id;

-- Update queries

-- Update inventory after receiving new stock
UPDATE inventory SET quantity = quantity + 10 WHERE warehouse_id = 1 AND product_id = 1;

-- Update shipment status
UPDATE shipments SET status = 'delivered', shipment_date = '2023-10-05' WHERE id = 1;

-- Delete queries

-- Remove a supplier (assuming no dependencies)
DELETE FROM suppliers WHERE id = 2;

-- Advanced queries

-- Find products with low inventory using the view
SELECT * FROM low_inventory;

-- Get order summaries using the view
SELECT * FROM order_summaries;

-- Find suppliers for a specific product
SELECT s.name, sp.price, sp.lead_time
FROM suppliers s
JOIN supplier_products sp ON s.id = sp.supplier_id
WHERE sp.product_id = 1;

-- Calculate total value of inventory
SELECT SUM(i.quantity * sp.price) AS total_inventory_value
FROM inventory i
JOIN supplier_products sp ON i.product_id = sp.product_id
JOIN suppliers s ON sp.supplier_id = s.id;