# server.R

library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.R")


shinyServer(
    function(input, output) {

#        ts_object <- create_ts(renderPrint({ input$ts_input }))
                
#        output$value <- renderPrint({ input$action })
        
#        output$value <- renderPrint({ input$date })
        
        
#        output$value <- renderPrint({ input$Slider })
#######
#######
        output$map <- renderPlot({ 
            input1 <- c(2787, 3891, 3179, 2011, 1636, 1580 ,1489, 1300 ,1356, 1653 ,2013, 2823,
                        2933, 2889, 2938, 2497, 1870, 1726, 1607, 1545, 1396, 1787, 2076 ,2837)
            
            
            t1 <- create_ts(input1,"2010-05-20",frequency_date = 4)
            t1       
            out1 <- run_models(t1)
            out1
            
            plot_dygraph(t1,out1,10)

            
        })
        
    }
)

