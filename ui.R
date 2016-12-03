library(shiny)
library(dygraphs)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
      theme = shinytheme("cerulean"),
#      theme = shinytheme("superhero"),
    
       titlePanel(""),
    
      dygraphOutput("dygraph_plot") ,

      hr(),

    fluidRow(
      column(4,
             h4("Starting Date of Time Series"),
             dateInput("date",  value = "2014-01-01",label=""),
             
             h4("Number of Forecasted Periods"),
             sliderInput("Slider",label="", min = 1, 
                         max = 20, value = 10)
      ),
      column(8,
             h4("Time Series Frequency"),
             radioButtons("Frequency", label = "",
                          choices = list(
                            "Quarterly" = 4, 
                            "Monthly" = 12),
                          selected = 12),
               h4("Time Series Input"),
               p("Enter an array of numbers, separated by commas. 
                 Zero values are not allowed.") ,

               textInput("ts_input",label=""), 
               value = "0"))

))