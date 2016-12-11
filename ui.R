library(shiny)
library(dygraphs)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  includeCSS("styles.css"),
  
  theme = shinytheme("journal"),
  #      theme = shinytheme("superhero"),
  
sidebarLayout(sidebarPanel(
  hr(),
  
           h4("Starting Date of Time Series"),
           dateInput("date",  value = "2014-01-01",label=""),
           
           h4("Number of Forecasted Periods"),
           sliderInput("Forecast_Periods",label="", min = 1, 
                       max = 20, value = 10),

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
           
           textInput("ts_input",label="",value = "0"),

#Execute Best Forecast
           checkboxInput("forecast_checkbox", label = "Execute Forecast Models", 
                         value = FALSE),
  
           actionButton("Analyze_TS", "Time Series Plots")
            
    ),
mainPanel(
  
  tabsetPanel(position=c("right"),
              tabPanel(strong("Plots"), 
                       br(),
                       plotOutput("ggplot_plot2") ,
                       br()),
              
              tabPanel(strong("Data"), 
                       br(),
                       plotOutput("stl_plot"),
                       p("..."),
                       br(),
                       plotOutput("ggplot_forecast"),
                       p("Please be patient, more that 16 models are being executed in the background"),
                       br()),
              
              tabPanel(strong("Annualized data"),
                       br(),
                       textOutput("date1"),
                       br())
              )
    )
  ))
)

