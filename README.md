
# FinTech Transaction Data Engineering Platform

An end-to-end data engineering portfolio project demonstrating how synthetic financial transaction data can be ingested, transformed, validated, modeled, and prepared for analytics.

The project simulates a financial services environment containing customers, accounts, merchants, transactions, and payment events.

The solution uses Microsoft Fabric Lakehouse, Fabric Data Pipelines, PySpark, SQL, and Power BI.

> This is an independent portfolio project using synthetic data. It is not affiliated with or developed for any bank, fintech, financial institution, or consulting company.

## Project Objective

Financial organizations process large volumes of transactional data from multiple operational systems.

Raw data can contain:

- Duplicate transactions
- Missing customer information
- Invalid transaction amounts
- Failed payments
- Inconsistent dates
- Invalid account references
- Duplicate customer records
- Unmatched merchant records
- Different source-system formats

The objective of this project is to build a data platform that transforms raw source data into trusted, analytics-ready datasets.

The platform supports:

- Transaction analytics
- Payment performance monitoring
- Customer activity analysis
- Merchant performance analysis
- Revenue analysis
- Failed transaction analysis
- Data quality monitoring
- Daily financial reporting

## Architecture

```text
SOURCE SYSTEMS
      |
      +------------------+
      |                  |
 Customers           Accounts
      |                  |
      +--------+---------+
               |
         Transactions
               |
               v
     Microsoft Fabric
       Data Pipeline
               |
               v
      BRONZE / RAW LAYER
               |
               v
       PySpark Cleaning
               |
               v
      SILVER / CLEAN LAYER
               |
               v
      Data Quality Checks
               |
               v
       GOLD / CURATED
          /          \
         /            \
        v              v
 SQL Analytics      Power BI
 Endpoint           Reporting

Medallion Architecture
Bronze Layer
The Bronze layer stores raw data as received from source systems.
Example tables:
* bronze_customers
* bronze_accounts
* bronze_transactions
* bronze_merchants
* bronze_payment_events
The raw layer preserves source data before major business transformations.
This supports traceability and reprocessing.
Silver Layer
The Silver layer contains cleaned and validated data.
Typical transformations include:
* Removing duplicate records
* Standardizing column names
* Converting data types
* Handling missing values
* Validating foreign keys
* Standardizing transaction statuses
* Removing invalid transaction amounts
* Standardizing timestamps
Example tables:
* silver_customers
* silver_accounts
* silver_transactions
* silver_merchants
* silver_payment_events
Gold Layer
The Gold layer contains analytics-ready business models.
Example tables:
* fact_transactions
* fact_payment_events
* dim_customer
* dim_account
* dim_merchant
* dim_date
The Gold layer is designed for reporting and downstream analytics.
Data Model
The project uses a dimensional model.

                    dim_customer
                         |
                         |
                    dim_account
                         |
                         |
dim_date ---- fact_transactions ---- dim_merchant
                         |
                         |
                 fact_payment_events

Fact Transactions
Column	Description
transaction_id	Unique transaction identifier
customer_id	Customer identifier
account_id	Account identifier
merchant_id	Merchant identifier
transaction_date	Transaction date
transaction_type	Transfer, payment, withdrawal, deposit
amount	Transaction amount
currency	Transaction currency
status	Completed, failed, pending
channel	Mobile, Web, ATM, POS
created_at	Source timestamp
Dimension Customer
Column	Description
customer_id	Unique customer identifier
customer_name	Customer name
customer_segment	Customer segment
customer_state	Customer location
registration_date	Customer registration date
status	Active or inactive
Dimension Account
Column	Description
account_id	Unique account identifier
customer_id	Account owner
account_type	Savings, Current, Wallet
currency	Account currency
account_status	Active, Suspended, Closed
opened_date	Account opening date
Dimension Merchant
Column	Description
merchant_id	Unique merchant identifier
merchant_name	Merchant name
merchant_category	Merchant category
state	Merchant location
status	Active or inactive
Technology Stack
* Microsoft Fabric
* Fabric Lakehouse
* Fabric Data Pipelines
* PySpark
* SQL
* Power BI
* Python
* Git
* GitHub
Why These Technologies?
Microsoft Fabric
Microsoft Fabric provides the main data platform for the project.
Fabric Lakehouse
The Lakehouse stores the Bronze, Silver, and Gold data layers.
PySpark
PySpark is used for data transformation, cleaning, and validation.
SQL
SQL is used for data exploration, validation, aggregation, and analytical queries.
Power BI
Power BI provides the reporting and visualization layer.
GitHub
GitHub provides source control and project documentation.
Project Structure

fintech-transaction-data-engineering-platform/

├── README.md
│
├── data/
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── accounts.csv
│   │   ├── transactions.csv
│   │   ├── merchants.csv
│   │   └── payment_events.csv
│   │
│   └── sample/
│       └── sample_transactions.csv
│
├── notebooks/
│   ├── 01_bronze_ingestion.ipynb
│   ├── 02_silver_transformation.ipynb
│   ├── 03_data_quality_checks.ipynb
│   └── 04_gold_model.ipynb
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_transaction_analysis.sql
│   └── 03_gold_views.sql
│
├── pipelines/
│   └── transaction_ingestion_pipeline.md
│
├── docs/
│   ├── architecture.md
│   ├── data_dictionary.md
│   └── data_quality.md
│
└── powerbi/
    └── dashboard_description.md

Source Data
The project uses synthetic data.
No real customer, financial, banking, or personally identifiable information is used.
The simulated source systems contain:
* Customers
* Accounts
* Transactions
* Merchants
* Payment Events
The data represents transactions across multiple channels.
Example channels:
* Mobile
* Web
* POS
* ATM
Example transaction types:
* Transfer
* Payment
* Deposit
* Withdrawal
Example statuses:
* Completed
* Failed
* Pending
Data Engineering Pipeline
Step 1: Ingest Source Data
Source files are loaded into the Bronze layer.
Example PySpark ingestion:

from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

transactions = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/lakehouse/default/Files/raw/transactions.csv")
)

transactions.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("bronze_transactions")

The raw source is preserved before transformation.
Step 2: Clean Transaction Data
Transaction records are cleaned using PySpark.

from pyspark.sql.functions import col, trim, upper

transactions_clean = (
    transactions
    .dropDuplicates(["transaction_id"])
    .withColumn(
        "transaction_type",
        upper(trim(col("transaction_type")))
    )
    .withColumn(
        "status",
        upper(trim(col("status")))
    )
    .withColumn(
        "channel",
        upper(trim(col("channel")))
    )
)

transactions_clean = transactions_clean.withColumn(
    "amount",
    col("amount").cast("decimal(18,2)")
)

Step 3: Validate Transactions
Invalid records are identified before loading the Silver layer.

invalid_amounts = transactions_clean.filter(
    col("amount") <= 0
)

missing_transaction_ids = transactions_clean.filter(
    col("transaction_id").isNull()
)

invalid_status = transactions_clean.filter(
    ~col("status").isin(
        ["COMPLETED", "FAILED", "PENDING"]
    )
)

These checks prevent invalid records from entering the analytics layer.
Step 4: Referential Integrity
Transactions must reference valid customers, accounts, and merchants.
Example:

invalid_accounts = transactions_clean.join(
    accounts,
    transactions_clean.account_id == accounts.account_id,
    "left_anti"
)

Records returned from this check represent transactions that reference an account that does not exist in the account master data.
Step 5: Load Silver Layer
Validated records are written to Silver Delta tables.

valid_transactions = transactions_clean.filter(
    (col("amount") > 0) &
    col("transaction_id").isNotNull()
)

valid_transactions.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("silver_transactions")

Step 6: Create Gold Fact Table
The Silver data is transformed into an analytics-ready fact table.

CREATE OR REPLACE TABLE fact_transactions AS

SELECT
    transaction_id,
    customer_id,
    account_id,
    merchant_id,
    transaction_date,
    transaction_type,
    amount,
    currency,
    status,
    channel,
    created_at
FROM silver_transactions
WHERE status IN ('COMPLETED', 'FAILED', 'PENDING');

Data Quality Framework
The pipeline checks the following areas:
Check	Purpose
Duplicate check	Prevent duplicate transactions
Null check	Identify missing critical fields
Amount check	Detect invalid transaction values
Status check	Validate transaction statuses
Date check	Detect invalid dates
Account check	Validate account references
Customer check	Validate customer references
Merchant check	Validate merchant references
Example SQL:

SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    SUM(
        CASE
            WHEN transaction_id IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_ids,
    SUM(
        CASE
            WHEN amount <= 0 THEN 1
            ELSE 0
        END
    ) AS invalid_amounts
FROM silver_transactions;

Data Quality Metrics
The project tracks:
* Record Count
* Duplicate Count
* Null Count
* Invalid Amount Count
* Invalid Status Count
* Invalid Foreign Key Count
* Valid Record Percentage
Example:

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN transaction_id IS NOT NULL
             AND amount > 0
            THEN 1
            ELSE 0
        END
    ) AS valid_records,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_id IS NOT NULL
                 AND amount > 0
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS data_quality_percentage

FROM silver_transactions;

Incremental Processing
The platform can process newly arrived transactions without reprocessing the entire dataset.
Example:

SELECT *
FROM silver_transactions
WHERE transaction_date >= DATEADD(day, -1, CURRENT_DATE);

This supports daily processing of newly arrived transaction data.
Transaction Analytics
The Gold layer supports questions such as:
* How much transaction value was processed today?
* What percentage of transactions failed?
* Which channels process the most transactions?
* Which merchants generate the highest transaction value?
* Which customer segments have the highest transaction activity?
* Which regions have the highest transaction volume?
* Are failed transactions increasing?
* Which payment channels have the highest failure rate?
Example:

SELECT
    channel,
    COUNT(*) AS transaction_count,
    SUM(amount) AS transaction_value
FROM fact_transactions
WHERE status = 'COMPLETED'
GROUP BY channel
ORDER BY transaction_value DESC;

Failed Transaction Analysis

SELECT
    transaction_date,
    channel,
    COUNT(*) AS failed_transactions
FROM fact_transactions
WHERE status = 'FAILED'
GROUP BY
    transaction_date,
    channel
ORDER BY
    transaction_date,
    failed_transactions DESC;

This analysis can help identify payment channels or periods experiencing higher failure rates.
Merchant Analysis

SELECT
    merchant_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS transaction_value
FROM fact_transactions
WHERE status = 'COMPLETED'
GROUP BY merchant_id
ORDER BY transaction_value DESC;

Customer Activity

SELECT
    customer_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value
FROM fact_transactions
WHERE status = 'COMPLETED'
GROUP BY customer_id
ORDER BY total_transaction_value DESC;

Power BI Reporting Layer
Power BI connects to the Gold layer to provide business reporting.
Executive KPIs
* Total Transaction Value
* Total Transactions
* Successful Transactions
* Failed Transactions
* Success Rate
* Failure Rate
* Active Customers
* Active Merchants
Transaction Trends
* Daily transaction value
* Daily transaction volume
* Successful versus failed transactions
* Transaction volume by channel
Customer Analytics
* Transaction value by customer segment
* Active customers
* Customer transaction frequency
Merchant Analytics
* Top merchants
* Transaction value by merchant category
* Merchant transaction volume
Data Quality
* Total records
* Valid records
* Invalid records
* Duplicate records
* Data quality percentage
Example Business Metrics
Transaction Value

SUM(completed transaction amounts)

Transaction Volume

COUNT(transaction_id)

Success Rate

Successful Transactions / Total Transactions

Failure Rate

Failed Transactions / Total Transactions

Average Transaction Value

Transaction Value / Transaction Volume

Data Engineering Skills Demonstrated
This project demonstrates practical experience with:
* Data ingestion
* ETL and ELT concepts
* Medallion architecture
* Lakehouse architecture
* Delta tables
* PySpark transformations
* SQL development
* Data validation
* Data quality checks
* Referential integrity
* Dimensional modeling
* Fact and dimension tables
* Incremental processing
* Pipeline orchestration
* Analytics-ready data modeling
* Power BI consumption
* Git version control
Engineering Design Decisions
Why Bronze, Silver, and Gold?
The architecture separates raw source data from cleaned and business-ready data.
This makes it easier to:
* Trace data back to the source
* Identify transformation issues
* Reprocess data
* Maintain clean analytical tables
* Separate engineering workloads from reporting workloads
Why Delta Tables?
Delta tables provide a reliable table format for the Lakehouse and support transactional data workloads.
Why PySpark?
PySpark provides a scalable approach to transforming larger datasets and is suitable for data engineering workloads within Microsoft Fabric.
Why SQL?
SQL provides a familiar way to validate, aggregate, model, and analyze structured data.
Future Improvements
Possible extensions include:
* Real-time transaction ingestion
* Streaming payment events
* REST API ingestion
* Customer 360 model
* Fraud detection features
* Machine learning scoring
* Slowly changing dimensions
* Metadata-driven pipelines
* Pipeline monitoring
* Automated data quality alerts
* Role-based access controls
* CI/CD using Git integration
Portfolio Value
This project demonstrates the engineering layer behind business intelligence and analytics.
My other portfolio projects focus mainly on extracting insights from data.
This project focuses on building the data platform that makes those insights possible.
The workflow is:

Source Data
    |
    v
Ingestion
    |
    v
Fabric Lakehouse
    |
    v
PySpark Transformation
    |
    v
Data Quality
    |
    v
SQL
    |
    v
Dimensional Model
    |
    v
Power BI

Disclaimer
This is an independent portfolio project using synthetic financial data.
It is not affiliated with or developed for any bank, fintech, financial institution, or consulting company.
The project is designed to demonstrate data engineering concepts and Microsoft Fabric capabilities.
