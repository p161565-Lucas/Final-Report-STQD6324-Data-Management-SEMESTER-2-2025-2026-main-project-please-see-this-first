# Ride Booking Analytics Dashboard

## STQD6324 Data Management Assignment

### Universiti Kebangsaan Malaysia (UKM)

This project develops an interactive Ride Booking Analytics Dashboard using **R Shiny**, **Apache Hive**, **HDFS**, and **ODBC** integration.

The project demonstrates multiple data management architectures and business analytics workflows, including data cleaning, warehousing, querying, visualization, and predictive analytics.

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

The project also demonstrates three different approaches for processing and accessing data.

---

# System Architecture

## Approach 1: Direct R Processing

Raw CSV Dataset

↓

Data Cleaning in R

↓

R Shiny Dashboard

This approach processes the dataset entirely within RStudio.

---

## Approach 2: Hive + WinSCP + R Dashboard

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

This approach uses Hive as a data warehouse and exports the processed dataset for visualization.

---

## Approach 3: Hive + ODBC + R Dashboard (Final Architecture)

Raw CSV Dataset

↓

HDFS

↓

Apache Hive

↓

Hive Query Processing

↓

ODBC Connection

↓

R Shiny Dashboard

This architecture enables direct communication between Hive and R without manual export.

---

# Dataset

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

# Project Workflow

## Step 1: Upload Dataset to HDFS

Example:

```bash
hdfs dfs -mkdir /ride_final

hdfs dfs -put Bookings.csv /ride_final
```

Verify upload:

```bash
hdfs dfs -ls /ride_final
```

---

## Step 2: Create Hive Table

Example:

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

```sql
LOAD DATA INPATH '/ride_final/Bookings.csv'
INTO TABLE bookings;
```

Verify:

```sql
SELECT *
FROM bookings
LIMIT 10;
```

---

## Step 4: Data Cleaning

Data preprocessing included:

* Missing value handling
* Date conversion
* Cancellation indicator creation
* Revenue categorization
* Data type conversion

Example:

```r
df$Date <- as.POSIXct(df$Date)

df$Is_Cancelled <- ifelse(
  df$Booking_Status == "Cancelled",
  1,
  0
)
```

---

## Step 5: Export Hive Data (Approach 2)

Hive output was exported through WinSCP:

```text
Bookings_Cleaned_Hive.csv
```

and loaded into R:

```r
df <- read.csv(
  "Bookings_Cleaned_Hive.csv",
  stringsAsFactors = FALSE
)
```

---

## Step 6: Connect Hive Directly Using ODBC (Approach 3)

Install package:

```r
install.packages("odbc")
install.packages("DBI")
```

Connection example:

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

Read Hive table:

```r
df <- dbReadTable(
  con,
  "bookings"
)
```

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

Interactive searchable table using DT.

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

Open RStudio and run:

```r
shinyApp(
  ui = ui,
  server = server
)
```

or

```r
runApp()
```

---

# Project Screenshots

## Dashboard Homepage

![Task 9](screenshots/homepage.png)

---

## HDFS Upload

![Task 10](screenshots/hdfs.png)

---

## Hive Table Creation

![Task 11](screenshots/hive_table_create.png)

---

## Hive Query Result

![Task 12](screenshots/hive_result.png)

---

## WinSCP Export

![Task 13](screenshots/winSCP.png)

---

## ODBC Connection

![Task 14](screenshots/ODBC.png)

---

## Cancellation Model

![Task 15](screenshots/cancellation_model.png)

---

# Repository Structure

```text
Ride-Booking-Analytics/
│
├── data/
│   ├── Bookings.csv
│   └── Bookings_Cleaned_Hive.csv
│
├── screenshots/
│   ├── dashboard.png
│   ├── hdfs_upload.png
│   ├── hive_table.png
│   ├── hive_query.png
│   ├── winscp_export.png
│   └── odbc_connection.png
│
├── app.R
├── README.md
└── Report.pdf
```

---

# Conclusion

This project demonstrates a complete Data Management and Analytics pipeline using Hadoop, Hive, and R Shiny.

Three different architectures were implemented:

1. Direct R Processing
2. Hive + WinSCP + R
3. Hive + ODBC + R

The final solution successfully integrates data warehousing, data processing, dashboard visualization, and predictive analytics into a single platform.

