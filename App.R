install.packages(shiny)
install.packages(forecast)
install.packages("epicasting")
install.packages("WaveletArima")
library(shiny)
library(forecast)
library(epicasting)
library(WaveletArima)

ui <- fluidPage(
  titlePanel("GDP Forecasting"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose a CSV file with time series data"),
      selectInput("time_series_column", "Select Time Series Column:", ""),
      selectInput("forecast_model", "Select Forecasting Model:",
                  choices = c("Naive", "ARIMA", "Neural Network", "WARIMA", "EWNET")),
      #choices = c("ARIMA", "ETS", "NNETAR", "Naive")),
      numericInput("forecast_period", "Forecast Period:", 12, min = 1),
      actionButton("run_forecast", "Run Forecast")
    ),
    mainPanel(
      plotOutput("ts_plot"),
      tableOutput("forecast_table")
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  observe({
    req(data())
    updateSelectInput(session, "time_series_column", choices = colnames(data()))
  })
  
  selected_column <- reactive({
    req(data())
    req(input$time_series_column)
    data()[, input$time_series_column]
  })
  
  output$ts_plot <- renderPlot({
    req(selected_column())
    autoplot(ts(selected_column()))
    #plot(selected_column(), main = "Time Series Data", xlab = "Time", ylab = "Value")
  })
  
  forecast_data <- eventReactive(input$run_forecast, {
    req(selected_column())
    ts_data <- ts(selected_column(), frequency = 12)  # Adjust frequency based on your data
    
    # Create and select the forecast model based on user's choice
    forecast_model <- switch(
      input$forecast_model,
      "Naive" = forecast(naive(ts_data), h = input$forecast_period)$mean,
      "ARIMA" = forecast(auto.arima(ts_data), h = input$forecast_period)$mean,
      #"ETS" = forecast(ets(ts_data), h = input$forecast_period),
      "Neural Network" = forecast(nnetar(ts_data), h = input$forecast_period)$mean,
      "WARIMA" = WaveletFittingarma(ts_data, Waveletlevels = floor(log(length(ts_data))), boundary = 'periodic', FastFlag = TRUE, MaxARParam = 5,
                                    MaxMAParam = 5, NForecast = input$forecast_period)$Finalforecast,
      "EWNET" = ewnet(ts_data, NForecast = input$forecast_period)$Forecast
      
    )
    forecast_model
  })
  
  output$forecast_table <- renderTable({
    req(forecast_data())
    forecast_data()
  })
}

shinyApp(ui = ui, server = server)
