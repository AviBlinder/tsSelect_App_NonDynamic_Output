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
                      value = "Enter the values, separated by space"),
            
            actionButton("action", label = "SUBMIT"),
            
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            
            verbatimTextOutput("ts_input_out")
        )
    )
))