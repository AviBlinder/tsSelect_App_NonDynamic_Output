library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.R")

input1 <- c(2787, 3891, 3179, 2011, 1636, 1580 ,1489, 1300 ,1356, 1653 ,2013, 2823,
            2933, 2889, 2938, 2497, 1870, 1726, 1607, 1545, 1396, 1787, 2076 ,2837)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    
    output$ts_input_out <- renderPrint({ 
        input_vector <- unlist(strsplit(input$ts_input,","))
        input_vector  <- trimws(input_vector,which = "both")   
        
        if (length(input_vector) > 10){
            ts_object <- create_ts(as.numeric(input_vector))            
        }

        ts_object
#        time_series <- create_ts(input_vector,input$date,input$Slider)
        
#        input_vector 
        })
    
    output$distPlot <- renderPlot({
        x    <- faithful[, 2]  # Old Faithful Geyser data
        bins <- seq(min(x), max(x), length.out = input$Slider + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
})