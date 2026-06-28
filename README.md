# Ride Booking Analytics Dashboard

## STQD6324 Data Management Assignment

### Universiti Kebangsaan Malaysia (UKM)

This project develops an interactive Ride Booking Analytics Dashboard using **R Shiny**, **Apache Hive**, **HDFS**, and **ODBC** integration.

The project demonstrates multiple data management architectures and business analytics workflows, including data cleaning, warehousing, querying, visualization, and predictive analytics.

---

# Table of Contents

* Project Overview
* System Architecture
* Comparison of Three Data Management Architectures
* Dataset
* Technologies Used
* Project Workflow
* Dashboard Features
* Required R Packages
* Running the Dashboard
* R Script Description
* Project Screenshots
* Repository Structure
* Future Improvements
* Conclusion
* Author

---


# Project Overview

The dashboard provides:

* Interactive KPI monitoring
* Booking trend analysis
* Revenue analysis
* Payment method distribution
* Cancellation analysis
* Rating distribution
* Price adjustment simulation
* Cancellation risk prediction
* Interactive data exploration


This project demonstrates three different data management architectures for integrating Apache Hive with an R Shiny dashboard. Each architecture represents a different strategy for data processing, storage, and data access, illustrating the evolution from simple data export to an optimized data warehouse design.

---


# System Architecture

## Approach 1: Hive + WinSCP + R Dashboard

Raw CSV Dataset

↓

HDFS

↓

Apache Hive

↓

Hive Data Cleaning

↓

Export Cleaned Dataset via WinSCP

↓

R Shiny Dashboard

This approach performs data cleaning in Hive and exports the cleaned dataset as a CSV file. The dashboard then reads the local CSV file for visualization.

---

## Approach 2: Hive + ODBC + Single Hive Table + R Dashboard

Raw CSV Dataset

↓

HDFS

↓

Apache Hive

↓

Hive Data Cleaning

↓

Cleaned Hive Table (`bookings_clean`)

↓

ODBC Connection

↓

R Shiny Dashboard

This approach establishes a direct ODBC connection between Hive and R. The dashboard retrieves the entire cleaned Hive table (`bookings_clean`) and performs filtering, aggregation, and visualization within R.

---

## Approach 3: Hive + ODBC + Multiple Hive Analytical Tables + R Dashboard (Final Optimized Data Warehouse Architecture)

Raw CSV Dataset

↓

HDFS

↓

Apache Hive

↓

Hive Data Cleaning

↓

Generate Multiple Analytical Hive Tables

↓

ODBC Connection

↓

R Shiny Dashboard

This approach extends the Hive workflow by generating multiple analytical tables (KPI, booking trends, revenue, payment methods, cancellation analysis, customer ratings, etc.). Each dashboard component retrieves only the required Hive table, reducing unnecessary data transfer and demonstrating a data warehouse architecture.

---


# Comparison of Three Data Management Architectures

This project implements three different approaches for integrating Apache Hive with an R Shiny dashboard. Although all three approaches generate the same dashboard visualizations, they differ significantly in the way data is processed and accessed.

| Feature               | Approach 1           | Approach 2               | Approach 3 (Final Architecture)             |
| --------------------- | -------------------- | ------------------------ | ------------------------------------------- |
| Hive Output           | One cleaned table    | One cleaned table        | Multiple analytical tables                  |
| Data Access           | Export CSV from Hive | Direct ODBC connection   | Direct ODBC connection                      |
| R Processing          | Reads exported CSV   | Reads entire Hive table  | Reads only required Hive tables             |
| Hive Processing       | Data cleaning        | Data cleaning            | Data cleaning + analytical table generation |
| Number of Hive Tables | 1                    | 1                        | 10+                                         |
| Data Transfer         | Manual export        | Entire table transferred | Only required data retrieved                |
| Query Efficiency      | Moderate             | Moderate                 | High                                        |
| Scalability           | Small datasets       | Medium datasets          | Enterprise-scale analytics                  |

### Approach 1 – Hive + Export + R

The dataset is cleaned in Apache Hive and stored as a single cleaned table (`bookings_clean`). The cleaned data is exported from HDFS as a CSV file using WinSCP, and R Shiny reads the local CSV file to generate all dashboard visualizations. This approach demonstrates the traditional workflow of exporting processed data before analysis.

### Approach 2 – Hive + ODBC + R

Instead of exporting a CSV file, R Shiny establishes a direct ODBC connection with Apache Hive and retrieves the entire cleaned table (`bookings_clean`). All filtering, aggregation, and visualization logic are performed within R. This approach eliminates manual file export while maintaining a simple database structure.

### Approach 3 – Hive Data Warehouse + ODBC + R (Final Implementation)

The cleaned dataset is further transformed into multiple analytical Hive tables, each designed for a specific dashboard component, such as KPI metrics, booking trends, payment distribution, revenue analysis, cancellation statistics, customer ratings, and detailed records. R Shiny retrieves only the required Hive table through ODBC, significantly reducing unnecessary data transfer and computation. This architecture follows data warehouse principles and represents the final optimized implementation of the project.

---


# Dataset

The ride-booking dataset used in this project is based on publicly available data from the City of Chicago Data Portal.

Dataset Source

### Dataset Source

The dataset is obtained from the **Chicago Taxi Trips Dataset**, available through the City of Chicago Data Portal.

https://data.cityofchicago.org/Transportation/Taxi-Trips/wrvz-psew

This dataset contains detailed records of taxi trips in Chicago, including trip duration, trip distance, fare amount, payment type, pickup and drop-off locations, and timestamps. It is widely used for transportation analytics, demand forecasting, and urban mobility research.

The dataset is used under the City of Chicago open data policy and is intended for academic and research purposes.

The ride-booking dataset contains information such as:

* Booking ID
* Customer ID
* Vehicle Type
* Booking Status
* Payment Method
* Pickup Location
* Driver Ratings
* Customer Ratings
* Ride Distance
* Booking Value
* Cancellation Status

---


# Technologies Used

## Data Management

* Apache Hadoop
* HDFS
* Apache Hive
* Ambari

## Data Analytics

* R
* RStudio

## Dashboard Development

* Shiny
* shinydashboard
* plotly
* DT

## Data Processing

* dplyr
* tidyverse
* lubridate

## Database Connectivity

* ODBC
* Hive JDBC/ODBC Driver

---


# Development Environment

The project was developed and tested using the following software environment.

| Component        | Version                        |
| ---------------- | ------------------------------ |
| Operating System | Windows 10                     |
| Apache Hadoop    | Hadoop Sandbox (HDP)           |
| Apache Hive      | Hive 2.x                       |
| HDFS             | Hadoop Distributed File System |
| Apache Ambari    | HDP Ambari                     |
| WinSCP           | Latest Version                 |
| R                | 4.x                            |
| RStudio          | Latest Version                 |
| R Shiny          | Latest Version                 |
| Hive ODBC Driver | Apache Hive ODBC Driver        |

The project is recommended to be executed in the above environment to ensure compatibility between Hive, ODBC, and R Shiny.

---


# Project Workflow

The project follows a complete data management workflow from raw data ingestion to dashboard visualization. Three different implementation approaches were developed to demonstrate alternative strategies for integrating Apache Hive with R Shiny.

---

## Step 1: Upload Dataset to HDFS

Create a project directory in HDFS and upload the raw booking dataset.

```bash
hdfs dfs -mkdir /ride_final

hdfs dfs -put Bookings.csv /ride_final
```

Verify the uploaded dataset:

```bash
hdfs dfs -ls /ride_final
```

---

## Step 2: Create Hive Table

Create the raw Hive table for storing the booking dataset.

```sql
CREATE TABLE bookings (
booking_id STRING,
customer_id STRING,
vehicle_type STRING,
booking_status STRING,
payment_method STRING,
pickup_location STRING,
drop_location STRING,
driver_ratings DOUBLE,
customer_rating DOUBLE,
ride_distance DOUBLE,
booking_value DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

---

## Step 3: Load Data into Hive

Load the dataset from HDFS into the Hive table.

```sql
LOAD DATA INPATH '/ride_final/Bookings.csv'
INTO TABLE bookings;
```

Verify the imported records:

```sql
SELECT *
FROM bookings
LIMIT 10;
```

---

## Step 4: Data Cleaning and Transformation

The raw dataset is cleaned and transformed in Apache Hive before being used for dashboard development.

The preprocessing includes:

- Missing value handling
- Data type conversion
- Date and time formatting
- Cancellation indicator creation
- Revenue categorization
- Duplicate removal

Example:

```sql
CREATE TABLE bookings_clean AS
SELECT ...
FROM bookings;
```

---


# Implementation Approaches

After the cleaned Hive dataset is generated, three different implementation approaches are demonstrated.

---

## Approach 1 – Hive → CSV Export → R Shiny

The cleaned Hive table is exported from HDFS using WinSCP.

```text
Bookings_Cleaned_Hive.csv
```

The exported CSV file is then loaded into R.

```r
df <- read.csv(
  "Bookings_Cleaned_Hive.csv",
  stringsAsFactors = FALSE
)
```

**Characteristics**

- Hive performs data cleaning
- Data exported as CSV
- Dashboard reads local CSV
- Simple and suitable for learning Hive workflows

---

## Approach 2 – Hive → ODBC → Single Hive Table → R Shiny

Instead of exporting a CSV file, R connects directly to Apache Hive through ODBC and retrieves the cleaned Hive table.

Install required packages:

```r
install.packages("odbc")
install.packages("DBI")
```

Create the connection:

```r
library(DBI)
library(odbc)

con <- dbConnect(
  odbc(),
  Driver = "Apache Hive",
  Host = "localhost",
  Port = 10000
)
```

Read the cleaned Hive table:

```r
df <- dbReadTable(
  con,
  "bookings_clean"
)
```

**Characteristics**

- Direct Hive connection
- Reads one cleaned Hive table
- All filtering and aggregation performed in R
- Stable implementation and recommended for demonstration

---

## Approach 3 – Hive → Multiple Analytical Tables → ODBC → R Shiny

Instead of reading one large table, Apache Hive generates multiple analytical tables during the data warehousing stage.

Examples include:

- KPI table
- Booking trend table
- Revenue analysis table
- Payment distribution table
- Cancellation analysis table
- Rating analysis table
- Vehicle distribution table
- Customer statistics table
- Detailed booking table
- Other analytical summary tables

Each dashboard component retrieves only the corresponding Hive table through ODBC.

```r
kpi <- dbReadTable(con, "kpi_summary")

booking_trend <- dbReadTable(con, "booking_trend")

payment <- dbReadTable(con, "payment_distribution")
```

**Characteristics**

- Data preprocessing completed in Hive
- Multiple analytical Hive tables
- Dashboard retrieves only required tables
- Reduced data transfer
- Demonstrates an enterprise-style data warehouse architecture
- May occasionally experience Hive ODBC string/schema compatibility issues depending on the execution environment

---


# Dashboard Features

## KPI Dashboard

Displays:

* Total Bookings
* Total Revenue
* Cancellation Rate
* Average Ride Distance

---

## Executive Summary

Automatically generates business insights based on selected filters.
![Task 1](screenshots/summary.png)

---

## Booking Trend Analysis

Interactive daily booking trend visualization.
![Task 2](screenshots/booking.png)

---

## Revenue Analysis

Revenue comparison by vehicle type.
![Task 3](screenshots/revenue.png)

---

## Payment Distribution

Analysis of payment method usage.
![Task 4](screenshots/payment.png)

---

## Cancellation Analysis

Booking cancellation monitoring.
![Task 5](screenshots/cancellation.png)

---

## Rating Distribution

Customer rating histogram.
![Task 6](screenshots/rating.png)

---

## Price Adjustment Simulation

Interactive simulation that estimates revenue impact after changing booking prices.
![Task 7](screenshots/adjustment.png)

---

## Cancellation Risk Prediction

A Logistic Regression model is used to estimate cancellation probability.
![Task 8](screenshots/risk.png)

Predictors include:

* Ride Distance
* Booking Value
* Vehicle Type

Users can input custom values and obtain cancellation risk estimates.

---

## Data Explorer

![Task 9](screenshots/explorer.png)

---

## Vehicle Type Distribution
![Task 10](screenshots/R_screenshot4.png)

---

## Payment Method Distribution
![Task 11](screenshots/R_screenshot5.png)

---


# Required R Packages

Install required packages:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "tidyverse",
  "lubridate",
  "plotly",
  "DT",
  "scales",
  "dplyr",
  "DBI",
  "odbc"
))
```

Load packages:

```r
library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(DT)
library(scales)
library(dplyr)
library(DBI)
library(odbc)
```

---


# Running the Dashboard

Two R implementations are provided in this repository.

## Recommended Version

Run

```r
Data_management_final_connect_hive_one_table_stable.R
```

Characteristics:

* Connects directly to Apache Hive through ODBC
* Reads one cleaned Hive table (`bookings_clean`)
* Performs filtering, aggregation, and visualization in R
* More stable during execution
* Recommended for demonstration and presentation

---

## Alternative Version

Run

```r
Data_management_final_connect_hive_ten_tables_clear.R
```

Characteristics:

* Connects directly to multiple analytical Hive tables
* Reads only the required analytical tables
* Demonstrates a modular Hive data warehouse architecture
* Reduces unnecessary data transfer between Hive and R
* May occasionally experience Hive ODBC string or schema compatibility issues depending on the execution environment

---

After opening either R script in RStudio, click **Run App** or execute:

```r
runApp()
```

---


# Project Screenshots

## Dashboard Homepage

![Task 12](screenshots/homepage.png)

---

## HDFS Upload

![Task 13](screenshots/hdfs.png)

---

## Hive Table Creation

![Task 14](screenshots/hive_table_create.png)

---

## Hive Query Result

![Task 15](screenshots/hive_result.png)

---

## WinSCP Export

![Task 16](screenshots/winSCP.png)

---

## ODBC Connection

![Task 17](screenshots/ODBC.png)

---

## Cancellation Model

![Task 18](screenshots/cancellation_model.png)

---


# R Script Description

Two R implementations are included in this repository for comparison purposes.

### Data_management_final_connect_hive_one_table_stable.R

This implementation connects to Apache Hive through ODBC and retrieves a single cleaned Hive table (`bookings_clean`). All filtering, aggregation, and visualization are performed within R.

**Characteristics**

* Reads one Hive table
* Data processing performed in R
* More stable during execution
* Recommended implementation for demonstration and presentation

---

### Data_management_final_connect_hive_ten_tables_clear.R

This implementation connects directly to multiple analytical Hive tables generated during the Hive data warehousing process. Each dashboard component retrieves only its corresponding Hive table.

**Characteristics**

* Reads multiple Hive analytical tables
* Most preprocessing completed in Hive
* Demonstrates a data warehouse architecture
* More efficient in theory because only the required data is retrieved
* May occasionally experience string or schema compatibility issues during ODBC communication, depending on the Hive driver and environment configuration

This implementation is included to demonstrate an optimized enterprise-style data management architecture and to compare different data access strategies.

---


# Repository Structure

```text
Ride-Booking-Analytics/
│
├── data/
│   ├── Bookings.csv
│   │   Original ride booking dataset
│   │
│   └── Bookings_Cleaned_Hive.csv
│       Cleaned dataset exported from Apache Hive
│       (Used in Approach 1)
│
├── screenshots/
│   ├── homepage.png
│   ├── summary.png
│   ├── booking.png
│   ├── revenue.png
│   ├── payment.png
│   ├── cancellation.png
│   ├── rating.png
│   ├── adjustment.png
│   ├── risk.png
│   ├── explorer.png
│   ├── R_screenshot4.png
│   ├── R_screenshot5.png
│   ├── hdfs.png
│   ├── hive_table_create.png
│   ├── hive_result.png
│   ├── winSCP.png
│   ├── ODBC.png
│   └── cancellation_model.png
│
├── hive_commands/
│   ├── Hive_Command.pdf
│   └── Hive_Data_Cleaning_Command.pdf
│
├── reports/
│   └── Report.pdf
│
├── Data_management_final_connect_hive_one_table_stable.R
│
│   Recommended implementation
│
│   • Connects directly to Apache Hive through ODBC
│   • Reads one cleaned Hive table (bookings_clean)
│   • Performs filtering, aggregation, and visualization in R
│   • More stable and recommended for presentation
│
├── Data_management_final_connect_hive_ten_tables_clear.R
│
│   Alternative implementation
│
│   • Connects directly to multiple analytical Hive tables
│   • Demonstrates Hive data warehouse architecture
│   • Retrieves only required analytical tables
│   • Reduces unnecessary data transfer
│   • May occasionally experience Hive ODBC
│     string/schema compatibility issues
│     depending on the execution environment
│
├── README.md
│   Project documentation
│
└── LICENSE (Optional)
```

---


# Future Improvements

Although the current system successfully demonstrates three different data management architectures, several enhancements could be implemented in future work.

* Deploy the dashboard to Shiny Server for web-based access.
* Replace manual ETL with an automated workflow using Apache Airflow.
* Integrate Apache Spark SQL for distributed query processing.
* Support real-time ride booking analytics using Apache Kafka.
* Optimize Hive partitioning and indexing for large-scale datasets.
* Extend the predictive analytics module with additional machine learning models such as Random Forest and XGBoost.
* Improve ODBC stability when accessing multiple analytical Hive tables simultaneously.
* Develop role-based dashboards for managers, analysts, and administrators.

---


# Conclusion

This project demonstrates a complete data management and business analytics pipeline using Apache Hadoop, HDFS, Apache Hive, and R Shiny.

Three different implementation architectures were developed and evaluated:

1. **Hive → CSV Export → R Shiny**
2. **Hive → ODBC → R Shiny**
3. **Hive Analytical Tables → ODBC → R Shiny (Final Architecture)**

The final architecture adopts a data warehouse design by creating multiple analytical Hive tables that correspond to different dashboard components. Instead of transferring an entire cleaned dataset, the dashboard retrieves only the required analytical tables, improving query efficiency, reducing unnecessary data processing in R, and providing a more scalable solution for business intelligence applications.

This progression demonstrates the evolution from basic data export, to direct database connectivity, and finally to an optimized enterprise-style analytical architecture.

Among the three implementations, the single-table ODBC approach is recommended for practical demonstration because it provides a more stable execution environment. Nevertheless, the multiple analytical-table architecture more closely reflects real-world enterprise data warehouse design, where pre-computed analytical tables improve query efficiency, reduce unnecessary data transfer, and simplify downstream business intelligence applications.

---

## Author

**REN SHINENG**

STQD6324 Data Management

Universiti Kebangsaan Malaysia (UKM)

Semester 2, Academic Session 2025/2026
