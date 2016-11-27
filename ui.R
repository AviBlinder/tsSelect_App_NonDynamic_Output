library(shiny)
library(dygraphs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
#    titlePanel("Time Series Forecast by Selecting Best Possible Model"),
    titlePanel(""),
    
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            
            helpText("Forecast Time Series based on comparing among around 20 differet models."),
            helpText("The first time the application is executed, a 
                     demo is performed."),
            helpText ("The process may take a few seconds..."),
            
#            helpText("Select the Starting Date of the Time Series"),
            dateInput("date", label = h3("Starting Date"), value = "2014-01-01"),
 
            br(),       
#            helpText("Select how many periods to forecast"),
            sliderInput("Slider", label = h3("Forecasted Periods"), min = 1, 
                        max = 20, value = 10),
            
            br(),
            p("Enter an array of numbers, separated by commas.") ,
            p("Zero values are not allowed."),
 
            textInput("ts_input", label = h3("Time Series input"), 
                      value = "0"),
            
#            helpText("please select whether each number is a Yearly, Quarterly or Monthly observation"),
             helpText("please select whether each number is a  Quarterly or Monthly observation : "),

            radioButtons("Frequency", label = h3("Time Series's Frequency"),
                         choices = list(
#                             "Year" = 1, 
                             "Quarter" = 4, 
                              "Month" = 12),
                         selected = 12)

#                        actionButton("action", label = "SUBMIT")
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(

          dygraphOutput("dygraph_plot"),
          
          verbatimTextOutput("log_title"),
            
          verbatimTextOutput("ts_input_out")
        )
    )
))