# Supply Chain Management Database - PowerPoint Slides

## Slide 1: Title Slide
**Title:** Supply Chain Management Database  
**Subtitle:** CS50 SQL Final Project  
**Your Name:** Jorn van Schagen  
**GitHub:** Jvs12345  
**edX:** [Your edX Username]  
**Location:** [Your City, Country]  
**Date:** April 23, 2026  

*Visual Suggestion: Use a professional template with supply chain icons (boxes, arrows, trucks)*

---

## Slide 2: Project Overview
**Title:** Project Overview  

**Purpose:**  
- Efficiently manage supply chain operations  
- Track suppliers, products, inventory, orders, and shipments  
- Optimize procurement and reduce stockouts  

**Scope:**  
- Supplier management  
- Product catalog  
- Inventory across warehouses  
- Order processing  
- Shipment tracking  

**Impact:**  
- Improved delivery times  
- Better decision-making  
- Cost reduction  

*Visual Suggestion: Flowchart diagram of supply chain process*

---

## Slide 3: Database Entities
**Title:** Database Entities  

**Core Entities:**  
- **Suppliers:** id, name, contact_email, location  
- **Products:** id, name, description, category  
- **Warehouses:** id, location  
- **Inventory:** warehouse_id, product_id, quantity  
- **Customers:** id, name, contact_email  
- **Orders:** id, customer_id, order_date  
- **OrderItems:** order_id, product_id, quantity  
- **Shipments:** id, order_id, shipment_date, status  

**Junction Tables:**  
- **SupplierProducts:** supplier_id, product_id, price, lead_time  

*Visual Suggestion: Icons or boxes for each entity type*

---

## Slide 4: Relationships & ER Diagram
**Title:** Entity Relationships  

**Key Relationships:**  
- Suppliers ↔ Products (many-to-many via SupplierProducts)  
- Products ↔ Warehouses (many-to-many via Inventory)  
- Customers → Orders → OrderItems  
- Orders → Shipments  

**ER Diagram:**  
```
SUPPLIERS ||--o{ SUPPLIER_PRODUCTS : supplies
PRODUCTS ||--o{ SUPPLIER_PRODUCTS : supplied_by
PRODUCTS ||--o{ INVENTORY : stored_in
WAREHOUSES ||--o{ INVENTORY : stores
CUSTOMERS ||--o{ ORDERS : places
ORDERS ||--o{ ORDER_ITEMS : contains
PRODUCTS ||--o{ ORDER_ITEMS : in
ORDERS ||--o{ SHIPMENTS : shipped_via
```

*Visual Suggestion: Embed the Mermaid diagram or create a clean ER diagram*

---

## Slide 5: Schema & Optimizations
**Title:** Database Schema & Optimizations  

**Schema Features:**  
- Primary keys and foreign key constraints  
- Composite primary keys for junction tables  
- Appropriate data types (INTEGER, TEXT, REAL, DATE)  

**Optimizations:**  
- Indexes on all foreign keys  
- Views: low_inventory, order_summaries  
- Normalized design for data integrity  

**Sample Tables:**  
- Suppliers: id (PK), name, contact_email, location  
- Inventory: warehouse_id (FK), product_id (FK), quantity  

*Visual Suggestion: Screenshots of schema.sql code*

---

## Slide 6: Sample Queries
**Title:** Sample Queries  

**Common Operations:**  
- **Insert:** Add new suppliers, products, orders  
- **Select:** Get inventory levels, order details  
- **Update:** Modify shipment status, update stock  
- **Delete:** Remove obsolete records  

**Example Queries:**  
```sql
-- Get products with suppliers
SELECT p.name, s.name, sp.price
FROM products p
JOIN supplier_products sp ON p.id = sp.product_id
JOIN suppliers s ON sp.supplier_id = s.id;

-- Check low inventory
SELECT * FROM low_inventory;
```

*Visual Suggestion: Code snippets with syntax highlighting*

---

## Slide 7: Limitations & Future Improvements
**Title:** Limitations & Future Enhancements  

**Current Limitations:**  
- Single currency support  
- No real-time inventory updates  
- Simple location storage (no coordinates)  
- No user authentication  

**Potential Improvements:**  
- Multi-currency transactions  
- Automated reorder triggers  
- Geographic mapping for locations  
- API integrations  

*Visual Suggestion: Pros/cons icons or comparison table*

---

## Slide 8: Conclusion
**Title:** Conclusion  

**Project Summary:**  
- Comprehensive supply chain database  
- Demonstrates SQL design and querying skills  
- Solves real-world inventory management problems  

**Key Achievements:**  
- 9 entities with proper relationships  
- Optimized schema with indexes and views  
- Practical queries for operations  

**Thank You!**  
Questions?  

*Visual Suggestion: Project logo or summary graphic*

---

## Presentation Notes
- **Timing:** Aim for 2-3 minutes total (20-30 seconds per slide)  
- **Voiceover:** Speak clearly, explain technical terms  
- **Visuals:** Use consistent theme, minimal text per slide  
- **Demo:** Show code snippets or database diagrams  
- **Tools:** Create in PowerPoint, Google Slides, or Keynote  

Copy this content into PowerPoint by creating slides and pasting the bullet points. Use the visual suggestions to enhance each slide.