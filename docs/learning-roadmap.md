# Data Engineering Learning Roadmap

## Project
[FinTech Transaction Data Engineering](https://github.com/olufemi-builds/fintech-transaction-data-engineering)

## Learning approach
Learn a concept, practise it, verify the result, document the evidence, and share a concise lesson on LinkedIn, X, and TikTok. Clearly label mockups and planned components; do not present planned work as completed.

## Progress

### 1. SQL foundations — in progress
Practised in PostgreSQL with a small local practice database:
- SELECT, WHERE, JOIN, GROUP BY, HAVING, and CASE
- Aggregating completed transaction values by customer
- Common table expressions (CTEs) for readable multi-step queries
- Window functions, including ROW_NUMBER, RANK, DENSE_RANK, and LAG
- Ranking customers and filtering the ranking in an outer query

**Next verification:** run `sql/07_top_3_customers.sql` in pgAdmin and compare the output with its expected result.

### 2. Requirements and data understanding — next
- Describe the business questions and expected outputs
- Inspect the actual headers and data types of every CSV
- Create a data dictionary and document table relationships
- Define quality rules for required fields, unique IDs, valid values, dates, amounts, and foreign keys

### 3. Python ingestion and data quality — planned
- Learn Python basics needed for files and data processing
- Read CSV files with pandas
- Validate columns, types, missing values, duplicate keys, and relationships
- Produce a simple quality report and clear error messages
- Keep raw inputs unchanged and record run metadata

### 4. Microsoft Fabric implementation — planned
- Load source files to a Lakehouse Bronze layer
- Clean and standardise data into Silver
- Create curated analytical tables in Gold
- Use SQL and/or PySpark where appropriate
- Build a dimensional model for reporting

### 5. Orchestration and reliability — planned
- Orchestrate ingestion and transformation with a Fabric pipeline
- Log run status, timestamps, row counts, and errors
- Add failure handling and safe rerun behaviour
- Document monitoring and troubleshooting

### 6. Analytics and portfolio evidence — planned
- Connect Power BI to curated data
- Validate metrics against SQL results
- Explain business findings and design decisions
- Update the README with verified implementation evidence

## Working rules
1. Do not claim a query or pipeline was executed unless it was actually run.
2. Record expected results separately from verified results.
3. Use synthetic or appropriately licensed data.
4. Prefer a small, working, documented end-to-end pipeline over adding tools without a project need.
5. After each meaningful milestone, update GitHub and prepare platform-appropriate learning content.

## Certification milestone
DP-700 (Microsoft Fabric Data Engineer Associate) has been passed. The certification is a milestone; this roadmap focuses on demonstrating practical skills through the project.
