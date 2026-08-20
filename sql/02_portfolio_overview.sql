-- =====================================================
-- 02 - Portfolio Overview
-- =====================================================

SELECT
    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = TRUE
    ) AS defaults,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE loan_status = TRUE
        ) / COUNT(*),
        2
    ) AS default_rate

FROM customers;
