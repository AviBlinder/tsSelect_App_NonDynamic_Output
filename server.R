library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(shinythemes)

source("helpers.r")

input_sample <- c("2787", "3891", "3179", "2011", "1636", "1580" ,"1489", 
            "1300" ,"1356", "1653" ,"2013", "2823", 
            "2933", "2889", "2938", "2497", "1870", 
            "1726", "1607", "1545", "1396", "1787", "2076" ,"2837")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

##Reactive Functions    
    frequency_reactive <- reactive({
      forecast_horizon <- input$Frequency
      
    })  
  
    horizon_reactive <- reactive({
      forecast_horizon <- input$Forecast_Periods
      
    })  
    
    date_reactive <- reactive({
      input_date <- input$date
      
    })  
    
    forecast_checkbox <- reactive({
      forecast_checkbox_input <- input$forecast_checkbox  
    })
    
    
    
    ts_input_update <- eventReactive(input$go, {
      ts_input <- input$ts_input
      if (input$ts_input %in% c("0" , "")){
        input_ts <- input_sample
      } else {
        input_ts <- input$ts_input
      }
      
      #Stript input from comma separators and trim spaces    
      input_vector <- split_input(input_ts)
      
      ts_object <- create_ts(
        input_data = as.numeric(input_vector),
        start_date = as.Date(date_reactive()),
        frequency_date = as.numeric(frequency_reactive()))
      
      
    })
    
    ts_input_sample <- eventReactive(input$Sample_TS, {
      input_ts <- input_sample

      #Stript input from comma separators and trim spaces    
      input_vector <- split_input(input_ts)
      
      ts_object <- create_ts(
        input_data = as.numeric(input_vector),
        start_date = as.Date(date_reactive()),
        frequency_date = as.numeric(frequency_reactive()))
      
    })
    

    ts_input_sample_w_forecast <- eventReactive(input$Sample_TS, {
      input_ts <- input_sample
      
      #Stript input from comma separators and trim spaces    
      input_vector <- split_input(input_ts)
      
      ts_object <- create_ts(
        input_data = as.numeric(input_vector),
        start_date = as.Date(date_reactive()),
        frequency_date = as.numeric(frequency_reactive()))
      
      if(forecast_checkbox()){
        out_model <- run_models(ts1 = ts_object,
                                accuracy_measure = NULL)
#        selected_model <- out_model[["selected_model_name"]]
        
        
      }
    })
    

#Render Outputs        
    output$text1 <- renderText({ 
#      paste("You have selected ", frequency_reactive())
      paste("You have selected ", forecast_checkbox())
      
    })
    
    output$text2 <- renderText({ 
      paste(ts_input_sample_w_forecast())
    })
    
    output$date1 <- renderText({ 
      paste("Starting Date ", date_reactive())
    })
    
    output$time_series_input <- renderText({ 
      paste("Time Series Objest =  ", ts_input_update())
    })
    
    output$ggplot_plot2 <- renderPlot({
      
      ggseasonplot(ts_input_sample()) + ggtitle("Seasonal Plot")
      
    })
    
    output$ggplot_forecast <- renderPlot({
      output_model <- ts_input_sample_w_forecast()
      forecasted_periods <- horizon_reactive()
      selected_model <- output_model[["model"]][[1]]
      selected_model <- forecast(selected_model,h=forecasted_periods)

      
      autoplot(selected_model) + 
        ggtitle(paste0("Selected Model: ",output_model[["selected_model_name"]]))
    })
    
    
  }
)


