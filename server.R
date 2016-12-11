library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(shinythemes)

source("helpers.r")

  
input_sample <- c("112","118","132","129","121","135","148","148","136",
                  "119","104","118","115","126","141","135","125",
                  "149","170","170","158", "133","114","140","145","150",
                  "178","163","172","178","199","199","184","162",
                  "146","166","171","180","193","181","183","218", 
                  "230","242","209","191","172","194","196","196","236",
                  "235","229","243","264","272","237","211","180","201",
                  "204","188","235", "227","234","264","302","293")

ggplot_theme <- theme( 
  panel.background = element_rect(fill = '#F3ECE2'), 
  plot.background = element_rect(fill = '#F3ECE2'), 
  panel.grid.major = element_line(color = "#DFDDDA"), 
  panel.grid.minor = element_line(color = "#DFDDDA"),
  axis.title.x = element_text(color = "#B2B0AE"),
  axis.title.y = element_text(color = "#B2B0AE"),
  title = element_text(color = "#606060") )


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
    
    
    
    ts_input_update <- eventReactive(input$TS_Analysis, {
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

    ts_input_w_forecast <- eventReactive(input$TS_Analysis, {
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
    
    
        
    ts_input_sample <- eventReactive(input$Analyze_TS, {
      
      ts_input <- input$ts_input
      if (input$ts_input %in% c("0" , "")){
        input_ts <- input_sample
      } else {
        input_ts <- input$ts_input
      }
      
#      input_ts <- input_sample
      

      #Stript input from comma separators and trim spaces    
      input_vector <- split_input(input_ts)
      
      ts_object <- create_ts(
        input_data = as.numeric(input_vector),
        start_date = as.Date(date_reactive()),
        frequency_date = as.numeric(frequency_reactive()))
      
    })
    

    ts_input_sample_w_forecast <- eventReactive(input$Analyze_TS, {
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
    
    output$Seasonal_ggplot <- renderPlot({
      
      ggseasonplot(ts_input_update()) + ggtitle("Seasonal Plot")
      
    })
    
    output$Seasonal_ggplot <- renderPlot({
      
      ggseasonplot(ts_input_sample()) + ggtitle("Seasonal Plot")
      
    })
    
    #Render Decomposition Plot (Data = Seasonality + Trend + Remainder)
    output$stl_plot <- renderPlot({
      
      autoplot(stl(ts_input_sample(), s.window="periodic", robust=TRUE)) +
        ggplot_theme      
      
      
    })
    
    output$ggplot_forecast <- renderPlot({
      output_model <- ts_input_sample_w_forecast()
      forecasted_periods <- horizon_reactive()
      selected_model_name <- output_model[["selected_model_name"]]
      selected_model <- output_model[["model"]][[1]]
      selected_model_forecast <- forecast(selected_model,h=forecasted_periods)

      if(length(selected_model_name) > 0){
          autoplot(selected_model_forecast) + 
        ggtitle(paste0("Selected Model: ",output_model[["selected_model_name"]])) +
          ggplot_theme
          
      }
    })
    
##
    output$forecast_figures <- renderTable({
      output_model <- ts_input_sample_w_forecast()
      forecasted_periods <- horizon_reactive()
      selected_model_name <- output_model[["selected_model_name"]]
      selected_model <- output_model[["model"]][[1]]
      selected_model_forecast <- forecast(selected_model,h=forecasted_periods)
      
      if(length(selected_model_name) > 0){
        predicted_mts <- as.data.frame(as.xts(cbind(fit = selected_model_forecast[["mean"]],
                                      lwr = selected_model_forecast[["lower"]][,2],
                                      upr = selected_model_forecast[["upper"]][,2])))
        
      }
    })
    
  }
)


