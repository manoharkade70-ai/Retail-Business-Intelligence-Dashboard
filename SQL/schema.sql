Create DATABASE retail_intelligence;

USE retail_intelligence;

CREATE TABLE retail_sales(
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    postal_code VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    region VARCHAR(100),
    market VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(15,4),
    quantity INT,
    discount DECIMAL(6,4),
    profit DECIMAL(15,4),
    shipping_cost DECIMAL(15,4),
    order_priority VARCHAR(30),
    shipping_days INT,
    sales_per_unit DECIMAL(15,4)
);
