library(shiny)
library(dygraphs)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("cerulean"),
  #      theme = shinytheme("superhero"),
  
  titlePanel(""),
  
        textOutput("date1"),
#        textOutput("time_series_input"),
  
        plotOutput("ggplot_plot2") ,
        plotOutput("ggplot_forecast"),

  hr(),
  
  fluidRow(
    column(4,
           h4("Starting Date of Time Series"),
           dateInput("date",  value = "2014-01-01",label=""),
           
           h4("Number of Forecasted Periods"),
           sliderInput("Forecast_Periods",label="", min = 1, 
                       max = 20, value = 10)
    ),
    column(4,offset = 2,
           h4("Time Series Frequency"),
           radioButtons("Frequency", label = "",
                        choices = list(
                          "Monthly" = 12,
                          "Quarterly" = 4 
                        ),
                        selected = 4),
           h4("Time Series Input"),
           p("Enter an array of numbers, separated by commas.
                   Zero values are not allowed.") ,
           
           textInput("ts_input",label=""), 
           value = "0")),

#Execute Best Forecast
           checkboxInput("forecast_checkbox", label = "Execute Forecast Models", 
                         value = FALSE),
  
           actionButton("Sample_TS", "Sample Time Series Plot"),
           actionButton("go", "Time Series Input Updated")
  
            
  
))