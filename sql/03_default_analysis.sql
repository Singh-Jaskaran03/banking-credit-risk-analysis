SELECT
    loan_grade,
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
FROM customers
GROUP BY loan_grade
ORDER BY loan_grade;
