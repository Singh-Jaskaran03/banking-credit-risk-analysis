-- =====================================================
-- Banking Credit Risk & Portfolio Analysis
-- 01 - Data Validation
-- =====================================================

-- Check total number of records
SELECT COUNT(*) AS total_rows
FROM customers;


-- Preview the data
SELECT *
FROM customers
LIMIT 5;


-- Check table structure
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'customers'
ORDER BY ordinal_position;
