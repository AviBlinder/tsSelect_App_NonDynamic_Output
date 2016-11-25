shinyUI(fluidPage(
    titlePanel("Time Series Forecaset"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Forecast Time Series based on the best possible model."),
            
            dateInput("date", label = h3("Starting Date"), value = "2014-01-01"),
            
            sliderInput("Slider", label = h3("Forecasted Periods"), min = 1, 
                        max = 20, value = 10),
            
            textInput("ts_input", label = h3("Time Series input"), 
                      value = "Enter the values, separated by space"),
            
            actionButton("action", label = "SUBMIT")
            
            
            ),
        
        mainPanel(
            
            
            plotOutput("dyplot")
            )
    )
))
