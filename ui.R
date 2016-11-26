library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Hello Shiny!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            
            helpText("Forecast Time Series based on the best possible model."),
            
            dateInput("date", label = h3("Starting Date"), value = "2014-01-01"),
            
            sliderInput("Slider", label = h3("Forecasted Periods"), min = 1, 
                        max = 20, value = 10),
            
            textInput("ts_input", label = h3("Time Series input"), 
                      value = ""),
            
            helpText("please select whether each number is a Yearly, Quarterly or Monthly observation"),
            

            radioButtons("Frequency", label = h3("Time Series's Frequency"),
                         choices = list("Year" = 1, "Quarter" = 4, 
                                        "Month" = 12),
                         selected = 12),

                        actionButton("action", label = "SUBMIT")
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("dygraph_plot"),
            
           verbatimTextOutput("ts_input_out")
        )
    )
))