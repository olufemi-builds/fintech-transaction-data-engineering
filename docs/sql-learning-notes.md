# SQL Learning Notes

These notes summarise concepts practised in the local PostgreSQL database `fintech_data_platform`. The sample customer and transaction tables are separate from the repository CSV files; schemas must be checked before reusing queries against those files.

## Concepts practised

- `SELECT`: choose the columns to return.
- `WHERE`: filter source rows before grouping.
- `JOIN`: combine related rows, such as customers and their transactions.
- `GROUP BY`: aggregate multiple transaction rows into customer-level results.
- `HAVING`: filter groups after aggregation.
- `CASE`: classify results using business rules.
- CTEs (`WITH`): name intermediate query results to make multi-step SQL easier to read.
- Window functions: calculate values across related rows without collapsing the detail rows.
- `ROW_NUMBER()`: assign sequential row numbers according to an ordering.
- `RANK()` and `DENSE_RANK()`: support rankings with different tie behaviour.
- `LAG()`: access a value from a previous row according to the window ordering.

## Top-three customer exercise

File: [`sql/07_top_3_customers.sql`](../sql/07_top_3_customers.sql)

The query:
1. Filters transactions to status `Completed`.
2. Groups transactions by customer and sums their amounts.
3. Uses `ROW_NUMBER()` to rank customers by total amount, descending.
4. Adds `customer_id` as a tie-breaker for deterministic ordering.
5. Filters to ranks 1 through 3 in the outer query.

### Expected output for the known practice rows

| Customer ID | Customer | Completed total | Rank |
|---|---|---:|---:|
| C004 | Sarah Bello | 1,500,000.00 | 1 |
| C003 | David Mensah | 895,000.00 | 2 |
| C005 | Daniel Smith | 850,000.00 | 3 |

**Status:** expected output is calculated from the known sample rows; local execution in pgAdmin still needs to be confirmed.

## Important lessons
- Repeated customer IDs in a transaction table are expected when one customer has many transactions; duplicate transaction primary keys are a different issue.
- Filter completed transactions before summing if the business question is specifically about completed value.
- `ROW_NUMBER()` always assigns distinct sequential numbers. If the business requirement is to include every customer tied at third place, use a tie-aware ranking function and define the expected behaviour.
- CTEs improve query structure and readability; they do not automatically guarantee better performance.
- The SQL logical processing order is a teaching model, not a literal description of the database execution plan.

## Before reusing this SQL on the project CSVs
Inspect the actual `transactions.csv` header and confirm the column names, types, status values, and customer key. Do not assume the local practice schema exactly matches the repository data.
