-- =====================================================
-- Allegro Sales - Tables
-- =====================================================

CREATE TABLE orders (
    order_id        INTEGER,
    order_date      DATE,
    category        VARCHAR(20),
    product_name    VARCHAR(40),
    unit_price_pln  NUMERIC(10,2),
    quantity        INTEGER,
    customer_city   VARCHAR(30),
    region          VARCHAR(20),
    payment_method  VARCHAR(30),
    delivery_method VARCHAR(30),
    order_status    VARCHAR(30),
    revenue_pln     NUMERIC(10,2)
);

CREATE TABLE targets (
    month      DATE,
    target_pln NUMERIC(12,2)
);
