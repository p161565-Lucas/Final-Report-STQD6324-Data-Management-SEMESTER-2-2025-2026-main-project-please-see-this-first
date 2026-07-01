#(1)Data cleaning by R studio
##########################################################
# # STEP 1: LOAD REQUIRED PACKAGES
# # Install packages if they are not available
# install.packages(c("tidyverse","lubridate","janitor"))
# library(tidyverse)
# library(lubridate)
# library(janitor)
# library(shiny)
# 
# addResourcePath(
#   prefix = "www",
#   directoryPath = "C:/Users/PC 20/Desktop/data_management_2/www"
# )
# 
# # STEP 2: IMPORT DATASET
# # Read the CSV file
# df <- read.csv(
#   "C:/Users/PC 20/Desktop/data_management_2/Bookings.csv",
#   stringsAsFactors = FALSE
# )
# # Check structure
# str(df)
# # Check summary statistics
# summary(df)
# 
# # STEP 3: REMOVE USELESS COLUMNS
# # Column X contains only missing values
# # Vehicle.Images contains invalid values (#NAME?)
# df <- df %>%
#   select(
#     -X,
#     -Vehicle.Images
#   )
# 
# # STEP 4: REPLACE "null" WITH NA
# # Many columns use "null" instead of proper NA
# df[df == "null"] <- NA
# 
# # STEP 5: CONVERT DATE AND TIME VARIABLES
# # Convert Date column into datetime format
# df$Date <- dmy_hm(df$Date)
# # Create additional date features
# df$Year <- year(df$Date)
# df$Month <- month(
#   df$Date,
#   label = TRUE
# )
# df$Day <- day(df$Date)
# df$Weekday <- wday(
#   df$Date,
#   label = TRUE
# )
# df$Hour <- hour(df$Date)
# 
# # STEP 6: CONVERT NUMERIC COLUMNS
# df$Booking_Value <- as.numeric(df$Booking_Value)
# df$Ride_Distance <- as.numeric(df$Ride_Distance)
# df$V_TAT <- as.numeric(df$V_TAT)
# df$C_TAT <- as.numeric(df$C_TAT)
# df$Driver_Ratings <- as.numeric(df$Driver_Ratings)
# df$Customer_Rating <- as.numeric(df$Customer_Rating)
# 
# # STEP 7: REMOVE DUPLICATES
# df <- distinct(df)
# 
# # STEP 8: CREATE ANALYTICAL VARIABLES
# # Cancellation flag
# df$Is_Cancelled <- ifelse(
#   grepl(
#     "Canceled",
#     df$Booking_Status
#   ),
#   1,
#   0
# )
# # Successful booking flag
# df$Is_Success <- ifelse(
#   df$Booking_Status == "Success",
#   1,
#   0
# )
# # Revenue category
# df$Revenue_Category <- case_when(
#   df$Booking_Value < 300 ~ "Low",
#   df$Booking_Value < 700 ~ "Medium",
#   TRUE ~ "High"
# )
# # Distance category
# df$Distance_Category <- case_when(
#   df$Ride_Distance < 10 ~ "Short",
#   df$Ride_Distance < 25 ~ "Medium",
#   TRUE ~ "Long"
# )
# 
# # STEP 9: HANDLE MISSING VALUES
# # Replace missing ratings with median values
# df$Driver_Ratings[
#   is.na(df$Driver_Ratings)
# ] <- median(
#   df$Driver_Ratings,
#   na.rm = TRUE
# )
# df$Customer_Rating[
#   is.na(df$Customer_Rating)
# ] <- median(
#   df$Customer_Rating,
#   na.rm = TRUE
# )
# 
# # STEP 10: SAVE CLEAN DATASET
# write.csv(
#   df,
#   "C:/Users/PC 20/Desktop/data_management_2/Bookings_Cleaned.csv",
#   row.names = FALSE
# )
# # Display final structure
# glimpse(df)
# 
# # Extra Correlation Analysis Code (Run Separately After Cleaning)
# if (!require("corrplot")) {
#   install.packages("corrplot")
#   library(corrplot)
# }
# num_cols <- sapply(df, is.numeric)
# num_df <- df[, num_cols]
# valid_num_df <- num_df[, sapply(num_df, function(x) sd(x, na.rm = TRUE) > 0)]
# cor_matrix <- cor(df[, sapply(df, is.numeric)], use="complete.obs")
# corrplot(cor_matrix, method="color", type="upper", tl.cex=0.8)

# install.packages("DBI")
# install.packages("rJava")
# install.packages("RJDBC")
# 
# library(DBI)
# library(RJDBC)
# 
# library(RJDBC)
# 
# drv <- JDBC(
#   "org.apache.hive.jdbc.HiveDriver",
#   "C:/hive_jdbc/hive-jdbc-2.1.0.2.6.5.0-292-standalone.jar"
# )
# 
# conn <- dbConnect(
#   drv,
#   "jdbc:hive2://sandbox-hdp:10000/default",
#   "maria_dev",
#   "maria_dev"
# )





#(2)Data cleaning by hive and export the claeaned csv file from hive.
##################################################################
# df <- read.csv(
#   "C:/Users/PC 20/Desktop/Bookings_Cleaned_Hive.csv",
#   header = FALSE,
#   stringsAsFactors = FALSE
# )
# 
# colnames(df) <- c(
#   "Date",
#   "Time",
#   "Booking_ID",
#   "Booking_Status",
#   "Customer_ID",
#   "Vehicle_Type",
#   "Pickup_Location",
#   "Drop_Location",
#   "V_TAT",
#   "C_TAT",
#   "Cancelled_Rides_by_Customer",
#   "Cancellation_Reason",
#   "Incomplete_Rides",
#   "Incomplete_Rides_Reason",
#   "Booking_Value",
#   "Payment_Method",
#   "Ride_Distance",
#   "Driver_Ratings",
#   "Customer_Rating"
# )
# 
# df[df == "\\N"] <- NA
# 
# df$Date <- as.POSIXct(
#   df$Date,
#   format = "%m/%d/%Y %H:%M"
# )
# 
# df$Booking_Value <- as.numeric(df$Booking_Value)
# 
# df$Ride_Distance <- as.numeric(df$Ride_Distance)
# 
# df$Driver_Ratings <- as.numeric(df$Driver_Ratings)
# 
# df$Customer_Rating <- as.numeric(df$Customer_Rating)
# 
# df$V_TAT <- as.numeric(df$V_TAT)
# 
# df$C_TAT <- as.numeric(df$C_TAT)
# 
# 
# df$Is_Cancelled <- ifelse(
#   grepl("Canceled", df$Booking_Status),
#   1,
#   0
# )
# 
# df$Is_Success <- ifelse(
#   df$Booking_Status == "Success",
#   1,
#   0
# )
# 
# df$Revenue_Category <- case_when(
#   df$Booking_Value < 300 ~ "Low",
#   df$Booking_Value < 700 ~ "Medium",
#   TRUE ~ "High"
# )
# 
# df$Distance_Category <- case_when(
#   df$Ride_Distance < 10 ~ "Short",
#   df$Ride_Distance < 25 ~ "Medium",
#   TRUE ~ "Long"
# )




#(3)connect hive and read the booking_cleaned csv directly.
################################################################
# ==========================================================
# RIDE BOOKING ANALYTICS DASHBOARD
# STQD6324 DATA MANAGEMENT
# UNIVERSITI KEBANGSAAN MALAYSIA
# ==========================================================
# LOAD REQUIRED LIBRARIES
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

# ==========================================================
# CONNECT TO HIVE AND READ DATA
# ==========================================================

# connect Hive
con <- dbConnect(
  odbc(),
  Driver = "Cloudera ODBC Driver for Apache Hive",
  Host = "localhost",
  Port = 10000,
  Schema = "ride_booking",
  UID = "maria_dev",
  PWD = ""
)

# Read the cleaned data
df <- dbGetQuery(con, "SELECT * FROM bookings_cleaned")

# Disconnect
dbDisconnect(con)

# ==========================================================
# DATA TRANSFORMATION 
# ==========================================================

#Rename column
colnames(df) <- c(
  "booking_date", "booking_time", "booking_id", "booking_status",
  "customer_id", "vehicle_type", "pickup_location", "drop_location",
  "v_tat", "c_tat", "canceled_by_customer", "canceled_by_driver",
  "incomplete_rides", "incomplete_reason", "booking_value",
  "payment_method", "ride_distance", "driver_ratings", "customer_rating"
)

# ===== Critical fix: Directly using booking_date to create Dates =====
df <- df %>%
  mutate(
    # booking_date  #The date and time are already included; convert directly.
    # Format is "1/7/2024 0:00" (MM/DD/YYYY HH:MM)
    Date = as.POSIXct(booking_date, format = "%m/%d/%Y %H:%M", tz = "UTC"),
    
    # If the above fails, try a format including seconds.
    # Date = as.POSIXct(booking_date, format = "%m/%d/%Y %H:%M:%S", tz = "UTC"),
    
    # Create other columns
    Is_Cancelled = ifelse(booking_status == "Success", 0, 1),
    Vehicle_Type = vehicle_type,
    Booking_Status = booking_status,
    Payment_Method = payment_method,
    Pickup_Location = pickup_location,
    Driver_Ratings = as.numeric(driver_ratings),
    Customer_Rating = as.numeric(customer_rating),
    Ride_Distance = as.numeric(ride_distance),
    Booking_Value = as.numeric(booking_value)
  )

# Check if the date conversion was successful.
print("=== Date conversion results ===")
print(paste("Total number of rows:", nrow(df)))
print(paste("Number of rows successfully converted:", sum(!is.na(df$Date))))
print(paste("The Date column contains NA items.:", sum(is.na(df$Date))))
print("The first 10 values ​​in the Date column:")
print(head(df$Date, 10))

# If all results are still NA, try a different format.
if(sum(!is.na(df$Date)) == 0) {
  print("Try alternative formats...")
  df <- df %>%
    mutate(
      Date = as.POSIXct(booking_date, format = "%d/%m/%Y %H:%M", tz = "UTC")
    )
  print(paste("Alternative format - Conversion successful:", sum(!is.na(df$Date))))
}

# Select the desired column
df <- df %>%
  select(
    Date,
    booking_id,
    customer_id,
    Vehicle_Type,
    Booking_Status,
    Payment_Method,
    Pickup_Location,
    drop_location,
    Driver_Ratings,
    Customer_Rating,
    Ride_Distance,
    Booking_Value,
    Is_Cancelled,
    v_tat,
    c_tat,
    canceled_by_driver,
    incomplete_rides
  )

print("=== Final data check ===")
print(paste("Final row number:", nrow(df)))
print(paste("The Date column contains NA items:", sum(is.na(df$Date))))
print("Date column example:")
print(head(df$Date))





#Part2: Full Shiny Dashboard app.R (Complete Integrated, All UI+Server No Broken Split Fragments)
# ==========================================================
# RIDE BOOKING ANALYTICS DASHBOARD
# STQD6324 DATA MANAGEMENT
# UNIVERSITI KEBANGSAAN MALAYSIA
# ==========================================================
# LOAD REQUIRED LIBRARIES
library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(DT)
library(scales)
library(dplyr) 

#LOAD CLEAN DATASET
# df <- read.csv(
#   "C:/Users/PC 20/Desktop/Bookings_Cleaned.csv",
#   stringsAsFactors = FALSE
# )

# df <- read.csv(
#   "Bookings_Cleaned_Hive.csv",
#   stringsAsFactors = FALSE
# )
addResourcePath(
  prefix = "www",
  directoryPath = "C:/Users/PC 20/Desktop/data_management_2/www"
)
# Convert Date again for safety
df$Date <- as.POSIXct(df$Date)
#######################################################
# ==================================
# CANCELLATION PREDICTION MODEL
# ==================================
# cancel_model <- glm(
#   Is_Cancelled ~
#     Driver_Ratings +
#     Ride_Distance +
#     Booking_Value,
#   data = df,
#   family = "binomial"
# )
df$Log_Value <- log(df$Booking_Value + 1)
# Convert Date again for safety
df$Date <- as.POSIXct(df$Date)

# Log Transform Booking Value
df$Log_Value <- log(df$Booking_Value + 1)
df$Payment_Method[is.na(df$Payment_Method)] <- "Unknown"

cancel_model <- glm(
  Is_Cancelled ~
    Ride_Distance +
    Booking_Value +
    Vehicle_Type,
  data = df,
  family = "binomial"
)
summary(cancel_model)
############################################

addResourcePath(
  "images",
  "C:/Users/PC 20/Desktop/data_management_2/www"
)
# USER INTERFACE FULL CODE
ui <- dashboardPage(
    skin = "blue",
  dashboardHeader(
    titleWidth = 350,
    title = tags$div(
      tags$img(
        src = "www/ukm_logo.png",
        height = "40px"
      ),
      
      span(
        "Ride Booking Analytics Dashboard",
        style = "padding-left:10px;"
      )
    )
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = icon("dashboard")
      ),
      hr(),
      selectInput(
        "vehicle",
        "Vehicle Type",
        choices = c(
          "All",
          sort(unique(df$Vehicle_Type))
        ),
        selected = "All"
      ),
      selectInput(
        "status",
        "Booking Status",
        choices = c(
          "All",
          sort(unique(df$Booking_Status))
        ),
        selected = "All"
      ),
      selectInput(
        "payment",
        "Payment Method",
        choices = c(
          "All",
          na.omit(unique(df$Payment_Method))
        ),
        selected = "All"
      ),
      selectInput(
        "pickup",
        "Pickup Location",
        choices = c(
          "All",
          sort(unique(df$Pickup_Location))
        ),
        selected = "All"
      ),
      hr(),
      sliderInput("price_change", "Adjust Price (%)", -30, 30, 0)
    )
  ),
  dashboardBody(
    
    tags$div(
      style = "
      text-align:center;
      padding:25px 0 10px 0;
      background: linear-gradient(to right, #f8f9fa, #ffffff);
      border-bottom: 1px solid #eee;
    ",
      
      tags$img(
        src = "www/ukm_logo.png",
        style = "height:70px; margin-bottom:10px;"
      ),
      
      tags$h2(
        "Ride Booking Analytics Dashboard"
      ),
      
      tags$h4(
        style = "color:gray;",
        "STQD6324 Data Management | UKM"
      )
    ),
    
    tabItems(
      tabItem(
        tabName = "dashboard",
        valueBoxOutput("growthRate"),
        # KPI Cards Row
        fluidRow(
          style = "margin-top:10px;",
          valueBoxOutput("totalBookings"),
          valueBoxOutput("totalRevenue"),
          valueBoxOutput("cancelRate"),
          valueBoxOutput("avgDistance")
        ),
        hr(),
#############################################
        fluidRow(
          
          box(
            width = 12,
            title = "Executive Summary",
            status = "success",
            solidHeader = TRUE,
            
            htmlOutput("executiveSummary")
          )
          
        ),
        
        hr(),
###############################################
        # Booking Trend Plot
        fluidRow(
          box(
            width = 12,
            title = "Booking Trend",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("bookingTrend", height = 350),
            style = "
              background-color: #ffffff;
              border-radius: 8px;
              box-shadow: 0px 2px 8px rgba(0,0,0,0.08);"
          )
        ),
        hr(),
        # Revenue & Payment Chart Row
        fluidRow(
          box(
            width = 6,
            title = "Revenue by Vehicle Type",
            status = "success",
            plotlyOutput("revVehicle")
          ),
          box(
            width = 6,
            title = "Payment Method Distribution",
            status = "info",
            plotlyOutput("paymentChart")
          )
        ),
        hr(),
        # Cancellation & Rating Chart Row
        fluidRow(
          box(
            width = 6,
            title = "Cancellation by Status",
            status = "danger",
            plotlyOutput("cancelStatus")
          ),
          box(
            width = 6,
            title = "Ratings Distribution",
            status = "warning",
            plotlyOutput("ratingDist")
          )
        ),
        hr(),
        # Price Simulation Text Output Box
          box(
            width = 12,
            title = "Price Adjustment Simulation Result",
            status = "success",
            solidHeader = TRUE,
            verbatimTextOutput("revenue")
          ),
#######################################################
# box(
#   width = 12,
#   title = "Cancellation Risk Prediction",
#   status = "danger",
#   solidHeader = TRUE,
#   
#   fluidRow(
#     
#     column(
#       4,
#       numericInput(
#         "pred_rating",
#         "Driver Rating",
#         value = 4.5,
#         min = 1,
#         max = 5
#       )
#     ),
#     
#     column(
#       4,
#       numericInput(
#         "pred_distance",
#         "Ride Distance (km)",
#         value = 15
#       )
#     ),
#     
#     column(
#       4,
#       numericInput(
#         "pred_value",
#         "Booking Value",
#         value = 500
#       )
#     )
#     
#   ),
#   
#   br(),
#   
#   h2(
#     textOutput("cancelPrediction")
#   )
#   
# ),

box(
  width = 12,
  title = "Cancellation Risk Prediction",
  status = "danger",
  solidHeader = TRUE,
  
  fluidRow(
    
    column(
      3,
      numericInput(
        "pred_rating",
        "Driver Rating",
        value = 4.5,
        min = 1,
        max = 5
      )
    ),
    
    column(
      3,
      numericInput(
        "pred_distance",
        "Ride Distance (km)",
        value = 15
      )
    ),
    
    column(
      3,
      numericInput(
        "pred_value",
        "Booking Value",
        value = 500
      )
    ),
    
    column(
      3,
      selectInput(
        "pred_vehicle",
        "Vehicle Type",
        choices = unique(df$Vehicle_Type)
      )
    )
    
  ),
  
  br(),
  
  fluidRow(
    
    column(
      6,
      selectInput(
        "pred_payment",
        "Payment Method",
        choices = na.omit(unique(df$Payment_Method))
      )
    )
    
  ),
  
  br(),
  
  h2(
    textOutput("cancelPrediction")
  )
  
),
##########################################################

box(
  width = 12,
  title = "Data Explorer",
  
  solidHeader = FALSE,
  status = NULL,
  
  style = "
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    padding: 10px;
  ",
  
  DTOutput("table")
),

      )
    )
  )
)

# SERVER FULL BACKEND CODE
baseline_revenue <- mean(df$Booking_Value, na.rm = TRUE)
server <- function(input, output, session) {
  # Reactive Filtered Dataset
  filtered_data <- reactive({
    data <- df
    if(input$vehicle != "All"){
      data <- data %>% filter(Vehicle_Type == input$vehicle)
    }
    if(input$status != "All"){
      data <- data %>% filter(Booking_Status == input$status)
    }
    if(input$payment != "All"){
      data <- data %>% filter(Payment_Method == input$payment)
    }
    if(input$pickup != "All"){
      data <- data %>% filter(Pickup_Location == input$pickup)
    }
    return(data)
  })
##########################################
  # Baseline income after filtering (if a price slider is required).
  baseline_revenue <- reactive({
    mean(filtered_data()$Booking_Value, na.rm = TRUE)
  })
###########################################
  
  # 4 KPI Value Boxes
  output$totalBookings <- renderValueBox({
    valueBox(
      comma(nrow(filtered_data())),
      "Total Bookings",
      icon = icon("car"),
      color = "blue"
    )
  })
  
  output$totalRevenue <- renderValueBox({
    valueBox(
      dollar(sum(filtered_data()$Booking_Value, na.rm = TRUE)),
      "Total Revenue",
      icon = icon("dollar-sign"),
      color = "green"
    )
  })
  
  output$cancelRate <- renderValueBox({
    rate <- mean(filtered_data()$Is_Cancelled) * 100
    valueBox(
      paste0(round(rate,2), "%"),
      "Cancellation Rate",
      icon = icon("ban"),
      color = "red"
    )
  })
  
  output$avgDistance <- renderValueBox({
    valueBox(
      round(mean(filtered_data()$Ride_Distance, na.rm = TRUE),2),
      "Average Distance",
      icon = icon("road"),
      color = "yellow"
    )
  })
#############################################################
  output$executiveSummary <- renderUI({
    data <- filtered_data()
    if(nrow(data) == 0){
      return(HTML("<b>No booking data matches your filter selection.</b>"))
    }
    
    vehicle <- data %>%
      group_by(Vehicle_Type) %>%
      summarise(
        Revenue = sum(Booking_Value, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(desc(Revenue))
    
    top_vehicle <- vehicle$Vehicle_Type[1]
    # Is_Cancelled is already a value of 0/1, so calculate directly and delete any incorrect cancel_num conversion lines.
    cancel_rate <- round(mean(data$Is_Cancelled, na.rm = TRUE) * 100,2)
    
    HTML(
      paste0(
        "<b>Top Revenue Vehicle:</b> ",
        top_vehicle,
        "<br><br>",
        "<b>Current Cancellation Rate:</b> ",
        cancel_rate,
        "%",
        "<br><br>",
        "<b>Recommendation:</b> Focus marketing efforts on ",
        top_vehicle,
        " and reduce cancellations through driver incentives."
      )
    )
  })
########################################################################

  # ⭐ NEW KPI 
  output$growthRate <- renderValueBox({
    data <- filtered_data()
    rev <- sum(data$Booking_Value, na.rm = TRUE)
    base_avg <- baseline_revenue() # Calling the responsive mean function
    
    # Null/zero denominator protection to avoid NaN errors.
    if(is.na(base_avg) || base_avg == 0){
      valueBox(
        "N/A",
        "Revenue Growth vs Avg",
        icon = icon("chart-line"),
        color = "gray"
      )
    } else {
      growth <- (rev / base_avg - 1) * 100
      valueBox(
        paste0(round(growth,2), "%"),
        "Revenue Growth vs Avg",
        icon = icon("chart-line"),
        color = ifelse(growth > 0, "green", "red")
      )
    }
  })
  # Daily Booking Trend Plot
  # Daily Booking Trend Plot
  output$bookingTrend <- renderPlotly({
    # Acquire and process data
    trend <- filtered_data() %>%
      mutate(DateOnly = as.Date(Date)) %>%
      filter(!is.na(DateOnly)) %>%  # Filter out NA dates
      group_by(DateOnly) %>%
      summarise(Total_Bookings = n(), .groups = "drop")
    
    # Check if there is data
    if(nrow(trend) == 0) {
      # Return to empty graph
      p <- ggplot() +
        annotate("text", x = 0.5, y = 0.5, 
                 label = "No data available", 
                 size = 6, hjust = 0.5) +
        theme_void()
      return(ggplotly(p))
    }
    
    # Create a trend chart
    p <- ggplot(trend, aes(x = DateOnly, y = Total_Bookings)) +
      geom_line(linewidth = 1, color = "steelblue") +
      geom_point(size = 0.5, color = "steelblue") +
      labs(title = "Daily Booking Trend", 
           x = "Date", 
           y = "Number of Bookings") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # Revenue By Vehicle Plot
  output$revVehicle <- renderPlotly({
    rev <- filtered_data() %>%
      group_by(Vehicle_Type) %>%
      summarise(Revenue = sum(Booking_Value, na.rm = TRUE))
    p <- ggplot(rev, aes(reorder(Vehicle_Type, Revenue), Revenue)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      theme_minimal() +
      labs(x = "Vehicle Type", y = "Revenue")
    ggplotly(p)
  })
  
  # Payment Distribution Plot
  output$paymentChart <- renderPlotly({
    pay <- filtered_data() %>%
      group_by(Payment_Method) %>%
      summarise(Count = n())
    p <- ggplot(pay, aes(Payment_Method, Count, fill=Payment_Method)) +
      geom_col() +
      theme_minimal()
    ggplotly(p)
  })
  
  # Cancellation Status Plot
  output$cancelStatus <- renderPlotly({
    cancel <- filtered_data() %>%
      count(Booking_Status)
    p <- ggplot(cancel, aes(Booking_Status, n, fill = Booking_Status)) +
      geom_col() +
      theme_minimal() +
      labs(x = "Status", y = "Count")
    ggplotly(p)
  })
  
  # Customer Rating Histogram
  output$ratingDist <- renderPlotly({
    df2 <- filtered_data() %>% filter(!is.na(Customer_Rating))
    p <- ggplot(df2, aes(Customer_Rating)) +
      geom_histogram(bins = 20, fill = "purple") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Price Adjust Simulation Calculation
  output$revenue <- renderText({
    data <- filtered_data()
    base_price <- mean(data$Booking_Value, na.rm = TRUE)
    base_bookings <- nrow(data)
    
    if(base_bookings == 0 || is.na(base_price)){
      return("Simulated Total Revenue After Price Adjustment: No matching booking data")
    }
    
    new_price <- base_price * (1 + input$price_change/100)
    bookings <- base_bookings * (1 - 1.2 * input$price_change/100)
    revenue <- new_price * bookings
    paste("Simulated Total Revenue After Price Adjustment: $", round(revenue,2))
  })
#######################################################################
  # output$cancelPrediction <- renderText({
  #   
  #   newdata <- data.frame(
  #     Driver_Ratings = input$pred_rating,
  #     Ride_Distance = input$pred_distance,
  #     Booking_Value = input$pred_value
  #   )
  output$cancelPrediction <- renderText({
    
    newdata <- data.frame(
      Ride_Distance = input$pred_distance,
      Booking_Value = input$pred_value,
      Vehicle_Type = input$pred_vehicle
    )
    
    risk <- predict(
      cancel_model,
      newdata,
      type = "response"
    )
    
    paste0(
      round(risk * 100,2),
      "% Cancellation Risk"
    )
    
  })
###########################################################################
  
  output$revCatPlot <- renderPlotly({
    d <- filtered_data() %>%
      group_by(Revenue_Category) %>%
      summarise(Revenue = sum(Booking_Value, na.rm=TRUE))
    p <- ggplot(d, aes(Revenue_Category, Revenue, fill=Revenue_Category)) +
      geom_col() +
      theme_minimal()
    ggplotly(p)
  })
  
  # output$table <- renderDT({
  #   datatable(
  #     filtered_data(),
  #     options = list(pageLength = 8, scrollX = TRUE),
  #     filter = "top"
  #   )
  # })
  output$table <- renderDT({
    
    display_df <- filtered_data()
    

    display_df$Date <- as.Date(display_df$Date)
    
    datatable(
      display_df,
      options = list(
        pageLength = 8,
        scrollX = TRUE
      ),
      filter = "top"
    )
    
  })
}

# Run Dashboard
shinyApp(ui = ui, server = server) 

