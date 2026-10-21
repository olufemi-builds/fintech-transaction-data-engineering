-- Exercise: Rank customers by completed transaction value.
-- Practice database: fintech_data_platform (PostgreSQL).
-- Note: This query is for the local practice tables, not yet adapted to the CSV files.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(t.amount) AS total_amount
    FROM customers AS c
    INNER JOIN transactions AS t
        ON c.customer_id = t.customer_id
    WHERE t.status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name
),
ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_amount,
        ROW_NUMBER() OVER (
            ORDER BY total_amount DESC, customer_id ASC
        ) AS customer_rank
    FROM customer_summary
)
SELECT
    customer_id,
    customer_name,
    total_amount,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 3
ORDER BY customer_rank;

-- Expected result from the practice dataset:
-- C004 | Sarah Bello  | 1500000.00 | 1
-- C003 | David Mensah |  895000.00 | 2
-- C005 | Daniel Smith |  850000.00 | 3
--
-- Verification status: expected output calculated from the known sample rows;
-- run in pgAdmin and compare before marking this exercise locally verified.
