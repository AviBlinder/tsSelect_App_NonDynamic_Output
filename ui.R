library(shiny)
library(dygraphs)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  includeCSS("styles.css"),
  
#  theme = shinytheme("journal"),
#   theme = shinytheme("superhero"),
  theme = shinytheme("united"),
  
sidebarLayout(sidebarPanel(
  hr(),
  
           h4("Starting Date of Time Series"),
           dateInput("date",  value = "2014-01-01",label=""),
  
           br(),
  
           h4("Number of Forecasted Periods"),
           sliderInput("Forecast_Periods",label="", min = 1, 
                       max = 20, value = 10),
            
           br(),

           h4("Time Series Frequency"),
           radioButtons("Frequency", label = "",
                        choices = list(
                          "Monthly" = 12,
                          "Quarterly" = 4 
                        ),
                        selected = 12),
           br(),
           h4("Time Series Input"),
           p("Enter an array of numbers, separated by commas.
                   Zero values are not allowed.") ,
           
           textInput("ts_input",label="",value = "0"),

           br(),
#Execute Best Forecast
           checkboxInput("forecast_checkbox", label = "Execute Forecast Models", 
                         value = FALSE),
  
           actionButton("Analyze_TS", "Time Series Plots"),
           p("If no input is entered, a sample TS input will be executed")
            
    ),
mainPanel(
  
  tabsetPanel(position=c("right"),
              
              tabPanel(strong("Seasonal Decomposition Plot"), 
                       br(),
                       plotOutput("stl_plot"),
                       br(),
                       p("Decomposition of Time Series data into seasonal, trend and irregular components")
                       ),
              
              tabPanel(strong("Seasonal Plot"), 
                       br(),
                       plotOutput("Seasonal_ggplot") ,
                       br()
                      ),
              

              tabPanel(strong("Forecast Plot"),
                       br(),
                       p("This panel displays a plot only if the 'Execute Forecast Model' button is marked."),
                       br(),
                       p("Please be patient, more that 16 models are being executed in the background"),
                       plotOutput("ggplot_forecast"),
                       br()
                      ),
              tabPanel(strong("Forecast Data"),
                       p("This panel displays a plot only if the 'Execute Forecast Model' button is marked."),
                       br(),
                       p("Please be patient, more that 16 models are being executed in the background"),
                       tableOutput("forecast_figures"),
                       br()
                       )
              )
    )
  ))
)

