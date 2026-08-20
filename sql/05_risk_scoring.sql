SELECT
    loan_status,
    COUNT(*) AS total_loans,
    ROUND(AVG(person_age), 2) AS avg_age,
    ROUND(AVG(person_income), 2) AS avg_income,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_percent_income), 3) AS avg_loan_income_ratio
FROM customers
GROUP BY loan_status
ORDER BY loan_status;

SELECT
    CASE loan_grade
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
        WHEN 'D' THEN 4
        WHEN 'E' THEN 5
        WHEN 'F' THEN 6
        WHEN 'G' THEN 7
    END
    +
    CASE
        WHEN loan_percent_income < 0.10 THEN 1
        WHEN loan_percent_income < 0.20 THEN 2
        WHEN loan_percent_income < 0.30 THEN 3
        ELSE 4
    END
    +
    CASE
        WHEN cb_person_default_on_file = 'Y' THEN 2
        ELSE 0
    END AS risk_score,

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
    CASE loan_grade
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
        WHEN 'D' THEN 4
        WHEN 'E' THEN 5
        WHEN 'F' THEN 6
        WHEN 'G' THEN 7
    END
    +
    CASE
        WHEN loan_percent_income < 0.10 THEN 1
        WHEN loan_percent_income < 0.20 THEN 2
        WHEN loan_percent_income < 0.30 THEN 3
        ELSE 4
    END
    +
    CASE
        WHEN cb_person_default_on_file = 'Y' THEN 2
        ELSE 0
    END

ORDER BY risk_score;

WITH risk_scored AS (

    SELECT
        *,
        
        CASE loan_grade
            WHEN 'A' THEN 1
            WHEN 'B' THEN 2
            WHEN 'C' THEN 3
            WHEN 'D' THEN 4
            WHEN 'E' THEN 5
            WHEN 'F' THEN 6
            WHEN 'G' THEN 7
        END
        +
        CASE
            WHEN loan_percent_income < 0.10 THEN 1
            WHEN loan_percent_income < 0.20 THEN 2
            WHEN loan_percent_income < 0.30 THEN 3
            ELSE 4
        END
        +
        CASE
            WHEN cb_person_default_on_file = 'Y' THEN 2
            ELSE 0
        END AS risk_score

    FROM customers
)

SELECT
    risk_score,

    CASE
        WHEN risk_score <= 4 THEN 'Lower Risk'
        WHEN risk_score = 5 THEN 'Moderate Risk'
        WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
        ELSE 'Very High Risk'
    END AS risk_category,

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

FROM risk_scored

GROUP BY
    risk_score,
    CASE
        WHEN risk_score <= 4 THEN 'Lower Risk'
        WHEN risk_score = 5 THEN 'Moderate Risk'
        WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
        ELSE 'Very High Risk'
    END

ORDER BY risk_score;

WITH risk_scored AS (

    SELECT
        CASE loan_grade
            WHEN 'A' THEN 1
            WHEN 'B' THEN 2
            WHEN 'C' THEN 3
            WHEN 'D' THEN 4
            WHEN 'E' THEN 5
            WHEN 'F' THEN 6
            WHEN 'G' THEN 7
        END
        +
        CASE
            WHEN loan_percent_income < 0.10 THEN 1
            WHEN loan_percent_income < 0.20 THEN 2
            WHEN loan_percent_income < 0.30 THEN 3
            ELSE 4
        END
        +
        CASE
            WHEN cb_person_default_on_file = 'Y' THEN 2
            ELSE 0
        END AS risk_score,

        loan_amnt,
        loan_status

    FROM customers
)

SELECT
    CASE
        WHEN risk_score <= 4 THEN 'Lower Risk'
        WHEN risk_score = 5 THEN 'Moderate Risk'
        WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
        ELSE 'Very High Risk'
    END AS risk_category,

    COUNT(*) AS total_loans,

    SUM(loan_amnt) AS total_exposure,

    COUNT(*) FILTER (
        WHERE loan_status = TRUE
    ) AS defaults,

    SUM(loan_amnt) FILTER (
        WHERE loan_status = TRUE
    ) AS defaulted_exposure,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE loan_status = TRUE
        ) / COUNT(*),
        2
    ) AS default_rate

FROM risk_scored

GROUP BY
    CASE
        WHEN risk_score <= 4 THEN 'Lower Risk'
        WHEN risk_score = 5 THEN 'Moderate Risk'
        WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
        ELSE 'Very High Risk'
    END

ORDER BY MIN(risk_score);

