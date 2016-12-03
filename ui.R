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
             h4("Starting Date"),
             dateInput("date",  value = "2014-01-01",label="")
      ),
      column(4, offset = 0,
             h4("Forecasted Periods"),
             sliderInput("Slider",label="", min = 1, 
                         max = 20, value = 10)
      ),
    column(4,
           h4("T.S. Frequency"),
           radioButtons("Frequency", label = "",
                        choices = list(
#                         "Year" = 1, 
                          "Quarter" = 4, 
                          "Month" = 12),
#                         "Weekly" = 7),
                        selected = 12)
           
           ),
    column(12,
           h4("Time Series Input"),
           p("Enter an array of numbers, separated by commas.") ,
           p("Zero values are not allowed."),
           textInput("ts_input",label=""), 
           value = "0")
    
        )

    

))