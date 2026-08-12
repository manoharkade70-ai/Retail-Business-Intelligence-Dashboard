USE retail_intelligence;

LOAD DATA LOCAL INFILE 'M:/Down/Retail-Business-Intelligence-System/data/processed/cleaned_retail_data.csv'
INTO TABLE retail_sales 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
     row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    postal_code,
    city,
    state,
    country,
    region,
    market,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    shipping_cost,
    order_priority,
    shipping_days,
    sales_per_unit
);