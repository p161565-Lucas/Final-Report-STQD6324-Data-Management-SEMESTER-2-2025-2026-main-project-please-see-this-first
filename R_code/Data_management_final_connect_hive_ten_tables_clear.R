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
print("Hive Connected Successfully")
# ==========================================================
# READ DASHBOARD TABLES FROM HIVE
# ==========================================================

kpi_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_kpi"
)

trend_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_trend"
)

vehicle_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_vehicle"
)

payment_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_payment"
)

cancel_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_cancel"
)

rating_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_rating"
)

detail_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_detail"
)
names(detail_df) <- sub("^dashboard_detail\\.", "", names(detail_df))
names(detail_df)

pickup_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_pickup"
)

names(pickup_df) <- sub("^dashboard_pickup\\.", "", names(pickup_df))


customer_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_customer"
)

revenue_df <- dbGetQuery(
  con,
  "SELECT * FROM dashboard_revenue"
)

dbDisconnect(con)

# ==========================================================
# DATA CLEANING
# ==========================================================

names(detail_df) <- tolower(names(detail_df))

detail_df <- detail_df %>%
  mutate(
    
    booking_value = as.numeric(booking_value),
    
    ride_distance = as.numeric(ride_distance),
    
    driver_ratings = as.numeric(driver_ratings),
    
    customer_rating = as.numeric(customer_rating),
    
    booking_status = as.character(booking_status),
    
    vehicle_type = as.character(vehicle_type),
    
    payment_method = as.character(payment_method),
    
    pickup_location = as.character(pickup_location)
    
  )

detail_df <- detail_df %>%
  mutate(
    
    Date = as.POSIXct(
      booking_date,
      format="%m/%d/%Y %H:%M",
      tz="UTC"
    )
    
  )

if(sum(!is.na(detail_df$Date))==0){
  
  detail_df <- detail_df %>%
    
    mutate(
      
      Date = as.POSIXct(
        booking_date,
        format="%d/%m/%Y %H:%M",
        tz="UTC"
      )
      
    )
  
}

detail_df <- detail_df %>%
  
  mutate(
    
    Is_Cancelled = ifelse(
      
      tolower(booking_status)=="success",
      
      0,
      
      1
      
    ),
    
    Vehicle_Type = vehicle_type,
    
    Booking_Status = booking_status,
    
    Payment_Method = payment_method,
    
    Pickup_Location = pickup_location,
    
    Booking_Value = booking_value,
    
    Ride_Distance = ride_distance,
    
    Driver_Ratings = driver_ratings,
    
    Customer_Rating = customer_rating
    
  )

detail_df$Payment_Method[is.na(detail_df$Payment_Method)] <- "Unknown"

df <- detail_df

df$Log_Value <- log(df$Booking_Value + 1)


# ==========================================================
# HIVE TABLE VISUALIZATION
# Pickup Location Distribution
# ==========================================================
head(kpi_df)

head(vehicle_df)

head(payment_df)

head(cancel_df)

head(pickup_df)

head(customer_df)

head(revenue_df)

summary(vehicle_df)

summary(payment_df)

summary(cancel_df)

summary(customer_df)


ggplot(
  pickup_df,
  aes(
    reorder(pickup_location, count),
    count
  )
) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Bookings by Pickup Location",
    x = "Pickup Location",
    y = "Bookings"
  ) +
  theme_minimal()

#####dashboard_customer
customer_top <- customer_df %>%
  arrange(desc(`dashboard_customer.total_bookings`)) %>%
  slice(1:10)

ggplot(
  customer_top,
  aes(
    reorder(
      `dashboard_customer.customer_id`,
      `dashboard_customer.total_bookings`
    ),
    `dashboard_customer.total_bookings`
  )
) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Top 10 Customers by Booking Count",
    x = "Customer ID",
    y = "Total Bookings"
  ) +
  theme_minimal()

####dashboard_revenue
ggplot(
  revenue_df,
  aes(
    reorder(
      `dashboard_revenue.vehicle_type`,
      `dashboard_revenue.revenue`
    ),
    `dashboard_revenue.revenue`
  )
) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(
    title = "Revenue by Vehicle Type",
    x = "Vehicle Type",
    y = "Revenue"
  ) +
  theme_minimal()

####detail_df
vehicle_count <-
  detail_df %>%
  count(Vehicle_Type)

ggplot(
  vehicle_count,
  aes(
    "",
    n,
    fill=Vehicle_Type
  )
)+
  geom_col(width=1)+
  coord_polar("y")+
  theme_void()+
  labs(
    title="Vehicle Type Distribution"
  )


####Payment
ggplot(
  payment_df,
  aes(
    x = "",
    y = `dashboard_payment.count`,
    fill = `dashboard_payment.payment_method`
  )
) +
  geom_col(width = 1) +
  coord_polar("y") +
  theme_void() +
  labs(
    title = "Payment Method Distribution"
  )


# ==========================================================
# CANCELLATION PREDICTION MODEL
# ==========================================================

# newdata <- data.frame(
#   Ride_Distance = input$pred_distance,
#   Booking_Value = input$pred_value,
#   Vehicle_Type = factor(input$pred_vehicle, levels = levels(df$Vehicle_Type))
# )

cancel_model <- glm(
  
  Is_Cancelled ~
    
    Ride_Distance +
    
    Booking_Value +
    
    Vehicle_Type,
  
  data = df,
  
  family = binomial()
  
)

summary(cancel_model)

addResourcePath(
  prefix = "www",
  directoryPath = "C:/Users/PC 20/Desktop/data_management_2/www"
)

#Part2: Full Shiny Dashboard app.R (Complete Integrated, All UI+Server No Broken Split Fragments)
# ==========================================================
# RIDE BOOKING ANALYTICS DASHBOARD
# STQD6324 DATA MANAGEMENT
# UNIVERSITI KEBANGSAAN MALAYSIA
# ==========================================================
# LOAD REQUIRED LIBRARIES
install.packages("shinycssloaders")
library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(DT)
library(scales)
library(dplyr) 
library(shinycssloaders)

addResourcePath("img", "C:/Users/PC 20/Desktop/data_management_2/www")

tags$img(src = "img/ukm_logo.png", height = "40px")


# baseline_revenue <- mean(df$Booking_Value, na.rm = TRUE)
baseline_revenue <- reactive({
  sum(detail_df$Booking_Value, na.rm = TRUE)
})

# USER INTERFACE FULL CODE
ui <- tagList(
#####################################
# ===============================
# POWER BI STYLE GLOBAL UI CSS
# ===============================
tags$head(tags$style(HTML("
  .box {
    border-radius: 14px;
    box-shadow: 0px 2px 10px rgba(0,0,0,0.08);
  }

  body {
    background-color: #f4f6f9;
  }

  .content-wrapper {
    background-color: #f4f6f9;
  }

  h2, h3 {
    font-weight: 600;
  }
"))),
#######################################
dashboardPage(
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

box(
  width = 12,
  title = "Cancellation Risk Prediction",
  status = "danger",
  solidHeader = TRUE,
  
  textOutput("cancelPrediction"),
  
  fluidRow(
    column(3, numericInput("pred_distance", "Ride Distance (km)", value = 15)),
    column(3, numericInput("pred_value", "Booking Value", value = 500)),
    column(3, selectInput("pred_vehicle", "Vehicle Type", choices = unique(df$Vehicle_Type)))
  )
),
  
  br(),
  
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
)


# SERVER FULL BACKEND CODE
server <- function(input, output, session) {
  # ===============================
  # FILTER MEMORY (SESSION PERSIST)
  # ===============================
  # Reactive Filtered Dataset
  filtered_data <- reactive({
    data <- detail_df
    
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
    
    data
  })

  
  library(lubridate)

  trend_data <- reactive({
    
    df <- filtered_data()
    
    validate(need(nrow(df) > 0, "No data"))
    
    # ⭐ 不再解析 booking_date
    df$dateonly <- as.Date(df$Date)
    
    df <- df %>%
      filter(!is.na(dateonly)) %>%
      group_by(dateonly) %>%
      summarise(total_bookings = n(), .groups = "drop")
    
    df
  })

  
  current_revenue <- reactive({
    sum(filtered_data()$Booking_Value, na.rm = TRUE)
  })

  
  # Baseline income after filtering (if a price slider is required).
  baseline_revenue <- reactive({
    sum(df$Booking_Value, na.rm = TRUE)
  })

  
  growth <- reactive({
    if(baseline_revenue()==0)
      return(0)
    (current_revenue() - baseline_revenue()) / baseline_revenue()
  })

  
  output$bookingTrend <- renderPlot({
    
    df <- trend_data()
    
    validate(
      need(nrow(df) > 0, "No data after cleaning"),
      need(all(is.finite(df$total_bookings)), "Invalid values")
    )
    
    ggplot(df, aes(dateonly, total_bookings)) +
      geom_line(linewidth = 1, color = "steelblue") +
      geom_point() +
      theme_minimal()
    
  })
  
  
  # 4 KPI Value Boxes
  output$totalBookings <- renderValueBox({
    
    valueBox(
      nrow(filtered_data()),
      "Total Bookings (Filtered)",
      icon = icon("car"),
      color = "blue"
    )
  })
  
  
  output$totalRevenue <- renderValueBox({
    
    revenue <- sum(filtered_data()$Booking_Value, na.rm = TRUE)
    
    valueBox(
      scales::dollar(revenue),
      "Total Revenue (Live)",
      icon = icon("dollar-sign"),
      color = "green"
    )
  })
 
   
  output$cancelRate <- renderValueBox({
    
    data <- filtered_data()
    
    cancel_rate <- mean(data$Is_Cancelled, na.rm = TRUE)
    
    valueBox(
      paste0(round(cancel_rate * 100, 2), "%"),
      "Cancellation Rate",
      icon = icon("ban"),
      color = "red"
    )
  })
  
  
  output$avgDistance <- renderValueBox({
    
    data <- filtered_data()
    
    valueBox(
      round(mean(data$Ride_Distance, na.rm = TRUE), 2),
      "Average Distance",
      icon = icon("road"),
      color = "yellow"
    )
  })
  
  
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

  
  # ⭐ NEW KPI 
  output$growthRate <- renderValueBox({
    g <- growth()
    
    valueBox(
      paste0(round(g, 2), "%"),
      "Revenue Growth vs Avg",
      icon = icon("chart-line"),
      color = ifelse(g > 0, "green", "red")
    )
  })
  

  
  # Revenue By Vehicle Plot
  output$revVehicle <- renderPlotly({
    
    data <- filtered_data()
    
    rev <- data %>%
      group_by(Vehicle_Type) %>%
      summarise(revenue = sum(Booking_Value, na.rm = TRUE), .groups = "drop")
    
    p <- ggplot(rev,
                aes(reorder(Vehicle_Type, revenue), revenue)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      theme_minimal()
    
    ggplotly(p, source = "revVehicle")
  })


  # ===============================
  # PLOTLY CLICK INTERACTION
  # ===============================
  observeEvent({
    event_data("plotly_click", source = "revVehicle")
  }, {
    clicked <- event_data("plotly_click", source = "revVehicle")
    
    req(clicked)
    
    updateSelectInput(session, "vehicle",
                      selected = as.character(clicked$x))
  })
  
  
  # Payment Distribution Plot
  output$paymentChart <- renderPlotly({
    
    pay <- filtered_data() %>%
      group_by(Payment_Method) %>%
      summarise(count = n(), .groups = "drop")
    
    p <- ggplot(
      pay,
      aes(
        Payment_Method,
        count,
        fill = Payment_Method
      )
    ) +
      geom_col() +
      theme_minimal() +
      labs(x = "Payment Method", y = "Count")
    
    ggplotly(p)
  })
  
  # Cancellation Status Plot
  output$cancelStatus <- renderPlotly({
    
    cancel <- filtered_data() %>%
      group_by(Booking_Status) %>%
      summarise(count = n(), .groups = "drop")
    
    p <- ggplot(
      cancel,
      aes(
        Booking_Status,
        count,
        fill = Booking_Status
      )
    ) +
      geom_col() +
      theme_minimal() +
      labs(x = "Status", y = "Count")
    
    ggplotly(p)
  })
  
  # Customer Rating Histogram
  output$ratingDist <- renderPlotly({
    
    p <- ggplot(
      filtered_data(),
      aes(Customer_Rating)
    ) +
      geom_histogram(
        bins = 20,
        fill = "purple"
      ) +
      theme_minimal() +
      labs(x = "Customer Rating", y = "Frequency")
    
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
  
  output$debugTable <- renderTable({
    head(filtered_data())
  })

  output$debug_trend <- renderPrint({
    df <- trend_data()
    
    list(
      nrow = nrow(df),
      na_date = sum(is.na(df$dateonly)),
      na_value = sum(is.na(df$total_bookings)),
      head = head(df)
    )
  })
}

# Run Dashboard
shinyApp(ui = ui, server = server) 

