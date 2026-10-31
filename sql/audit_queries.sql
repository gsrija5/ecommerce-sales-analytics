SELECT COUNT(*) AS total_rows
FROM online_retail_raw;

SELECT *
FROM online_retail_raw
LIMIT 10;

SELECT *
FROM online_retail_raw
LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE invoiceno IS NULL OR invoiceno = '') AS missing_invoice,
    COUNT(*) FILTER (WHERE description IS NULL OR description = '') AS missing_description,
    COUNT(*) FILTER (WHERE customerid IS NULL OR customerid = '') AS missing_customer
FROM online_retail_raw;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE invoiceno LIKE 'C%'
          AND invoiceno <> 'InvoiceNo'
    ) AS cancelled_transactions,
    COUNT(*) FILTER (
        WHERE invoiceno <> 'InvoiceNo'
          AND quantity ~ '^-?[0-9]+$'
          AND quantity::INTEGER <= 0
    ) AS zero_or_negative_quantity,
    COUNT(*) FILTER (
        WHERE invoiceno <> 'InvoiceNo'
          AND unitprice ~ '^-?[0-9]+(\.[0-9]+)?$'
          AND unitprice::NUMERIC <= 0
    ) AS zero_or_negative_price
FROM online_retail_raw
WHERE invoiceno <> 'InvoiceNo';

CREATE TABLE online_retail_clean AS
SELECT
    TRIM(invoiceno) AS invoiceno,
    TRIM(stockcode) AS stockcode,
    NULLIF(TRIM(description), '') AS description,
    quantity::INTEGER AS quantity,
    TO_TIMESTAMP(invoicedate, 'DD-MM-YYYY HH24:MI') AS invoicedate,
    unitprice::NUMERIC(10,2) AS unitprice,
    NULLIF(TRIM(customerid), '') AS customerid,
    TRIM(country) AS country
FROM online_retail_raw
WHERE TRIM(invoiceno) <> 'InvoiceNo'
  AND TRIM(invoiceno) NOT LIKE 'C%'
  AND quantity ~ '^-?[0-9]+$'
  AND quantity::INTEGER > 0
  AND unitprice ~ '^-?[0-9]+(\.[0-9]+)?$'
  AND unitprice::NUMERIC > 0;

  DROP TABLE IF EXISTS online_retail_clean;

  CREATE TABLE online_retail_clean AS
SELECT
    TRIM(invoiceno) AS invoiceno,
    TRIM(stockcode) AS stockcode,
    NULLIF(TRIM(description), '') AS description,
    quantity::INTEGER AS quantity,
    TO_TIMESTAMP(TRIM(invoicedate), 'DD-MM-YYYY HH24:MI') AS invoicedate,
    unitprice::NUMERIC(10,2) AS unitprice,
    NULLIF(TRIM(customerid), '') AS customerid,
    TRIM(country) AS country
FROM online_retail_raw
WHERE TRIM(invoiceno) <> 'InvoiceNo'
  AND TRIM(invoiceno) NOT LIKE 'C%'
  AND quantity ~ '^-?[0-9]+$'
  AND quantity::INTEGER > 0
  AND unitprice ~ '^-?[0-9]+(\.[0-9]+)?$'
  AND unitprice::NUMERIC > 0;

  SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT invoiceno) AS unique_invoices,
    COUNT(DISTINCT customerid) AS unique_customers,
    COUNT(*) FILTER (WHERE customerid IS NULL) AS missing_customer_ids,
    MIN(invoicedate) AS first_invoice_date,
    MAX(invoicedate) AS last_invoice_date
FROM online_retail_clean;

SELECT
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue,
    ROUND(AVG(quantity * unitprice), 2) AS average_line_revenue,
    COUNT(DISTINCT country) AS total_countries
FROM online_retail_clean;

SELECT
    country,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
GROUP BY country
ORDER BY SUM(quantity * unitprice) DESC
LIMIT 10;

SELECT
    country,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
GROUP BY country
ORDER BY SUM(quantity * unitprice) DESC
LIMIT 10;

SELECT
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean;

SELECT
    country,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
WHERE country = 'United Kingdom'
GROUP BY country;

SELECT
    country,
    MIN(quantity * unitprice) AS smallest_line_value,
    MAX(quantity * unitprice) AS largest_line_value,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue,
    ROUND(SUM(
        CASE
            WHEN country = 'United Kingdom'
            THEN quantity * unitprice
            ELSE 0
        END
    ), 2) AS uk_revenue
FROM online_retail_clean;

SELECT
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue,
    ROUND(SUM(quantity * unitprice) FILTER (
        WHERE country = 'United Kingdom'
    ), 2) AS uk_revenue
FROM online_retail_clean;

SELECT
    stockcode,
    MAX(description) AS product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
GROUP BY stockcode
ORDER BY SUM(quantity * unitprice) DESC
LIMIT 10;

SELECT
    stockcode,
    MAX(description) AS product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue
FROM online_retail_clean
WHERE stockcode <> '.'
  AND description IS NOT NULL
  AND UPPER(description) NOT LIKE '%POSTAGE%'
  AND UPPER(description) NOT LIKE '%CARRIAGE%'
GROUP BY stockcode
ORDER BY SUM(quantity * unitprice) DESC
LIMIT 10;

SELECT
    DATE_TRUNC('month', invoicedate)::DATE AS sales_month,
    ROUND(SUM(quantity * unitprice), 2) AS monthly_revenue,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoiceno) AS invoice_count
FROM online_retail_clean
GROUP BY DATE_TRUNC('month', invoicedate)
ORDER BY sales_month;

SELECT
    customerid,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(quantity * unitprice), 2) AS total_spent,
    MIN(invoicedate)::DATE AS first_purchase,
    MAX(invoicedate)::DATE AS last_purchase
FROM online_retail_clean
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_spent DESC
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue,
    ROUND(SUM(quantity * unitprice) FILTER (
        WHERE country = 'United Kingdom'
    ), 2) AS uk_revenue,
    ROUND(SUM(quantity * unitprice) FILTER (
        WHERE DATE_TRUNC('month', invoicedate) =
              DATE '2010-12-01'
    ), 2) AS december_2010_revenue
FROM online_retail_clean;
