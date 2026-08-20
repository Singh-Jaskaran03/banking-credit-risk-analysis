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
),

category_summary AS (

    SELECT
        CASE
            WHEN risk_score <= 4 THEN 'Lower Risk'
            WHEN risk_score = 5 THEN 'Moderate Risk'
            WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
            ELSE 'Very High Risk'
        END AS risk_category,

        SUM(loan_amnt) AS total_exposure,

        SUM(loan_amnt) FILTER (
            WHERE loan_status = TRUE
        ) AS defaulted_exposure

    FROM risk_scored

    GROUP BY
        CASE
            WHEN risk_score <= 4 THEN 'Lower Risk'
            WHEN risk_score = 5 THEN 'Moderate Risk'
            WHEN risk_score BETWEEN 6 AND 8 THEN 'High Risk'
            ELSE 'Very High Risk'
        END
)

SELECT
    risk_category,

    total_exposure,

    ROUND(
        100.0 * total_exposure /
        SUM(total_exposure) OVER (),
        2
    ) AS exposure_share,

    defaulted_exposure,

    ROUND(
        100.0 * defaulted_exposure /
        SUM(defaulted_exposure) OVER (),
        2
    ) AS defaulted_exposure_share

FROM category_summary

ORDER BY
    MIN(total_exposure) OVER ();
