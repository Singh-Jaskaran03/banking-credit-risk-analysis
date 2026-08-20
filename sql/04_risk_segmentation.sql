SELECT
    CASE
        WHEN loan_percent_income < 0.10 THEN '<10%'
        WHEN loan_percent_income < 0.20 THEN '10-20%'
        WHEN loan_percent_income < 0.30 THEN '20-30%'
        ELSE '30%+'
    END AS loan_income_group,

    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = TRUE
    ) AS defaults,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE loan_status = TRUE
        ) / COUNT(*),
        2
    ) AS default_rate,

    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount

FROM customers

GROUP BY
    CASE
        WHEN loan_percent_income < 0.10 THEN '<10%'
        WHEN loan_percent_income < 0.20 THEN '10-20%'
        WHEN loan_percent_income < 0.30 THEN '20-30%'
        ELSE '30%+'
    END

ORDER BY
    MIN(loan_percent_income);

SELECT
    cb_person_default_on_file AS previous_default,

    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = TRUE
    ) AS defaults,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE loan_status = TRUE
        ) / COUNT(*),
        2
    ) AS default_rate,

    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,

    ROUND(AVG(loan_percent_income), 3) AS avg_loan_income_ratio

FROM customers

GROUP BY cb_person_default_on_file

ORDER BY default_rate DESC;

SELECT
    loan_grade,

    CASE
        WHEN loan_percent_income < 0.10 THEN '<10%'
        WHEN loan_percent_income < 0.20 THEN '10-20%'
        WHEN loan_percent_income < 0.30 THEN '20-30%'
        ELSE '30%+'
    END AS loan_income_group,

    cb_person_default_on_file AS previous_default,

    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = TRUE
    ) AS defaults,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE loan_status = TRUE
        ) / COUNT(*),
        2
    ) AS default_rate

FROM customers

GROUP BY
    loan_grade,
    CASE
        WHEN loan_percent_income < 0.10 THEN '<10%'
        WHEN loan_percent_income < 0.20 THEN '10-20%'
        WHEN loan_percent_income < 0.30 THEN '20-30%'
        ELSE '30%+'
    END,
    cb_person_default_on_file

ORDER BY default_rate DESC;
