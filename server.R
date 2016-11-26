library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.R")

input1 <- c(2787, 3891, 3179, 2011, 1636, 1580 ,1489, 
            1300 ,1356, 1653 ,2013, 2823,
            2933, 2889, 2938, 2497, 1870, 
            1726, 1607, 1545, 1396, 1787, 2076 ,2837)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    output$ts_input_out <- renderPrint({ 
        input_vector <- unlist(strsplit(input$ts_input,","))
        input_vector  <- trimws(input_vector,which = "both")        

        if (length(input_vector) > 1){
            ts_object <- create_ts(input_data = as.numeric(input_vector),
                           start_date = as.Date(input$date),
                           frequency_date = as.numeric(input$Frequency))
        
        print(ts_object)
        out_model <- run_models(ts1 = ts_object,
                            accuracy_measure = NULL)
        selected_model <- out_model[["selected_model_name"]]
        
    
        }    
        })
    
    
    output$dygraph_plot <- renderDygraph({

        input_vector <- unlist(strsplit(input$ts_input,","))
        input_vector  <- trimws(input_vector,which = "both")

        if (length(input_vector) > 1){
            ts_object <- create_ts(input_data = as.numeric(input_vector),
                                   start_date = as.Date(input$date),
                                   frequency_date = as.numeric(input$Frequency))
        }
        out_model <- run_models(ts1 = ts_object,
                                accuracy_measure = NULL)

        selected_model <- out_model[["model"]][[1]]

        all <- plot_dygraph(ts_object,out_model,input$Slider)

        dygraph(all, main = title_name) %>%
            dyAxis("x", drawGrid = FALSE) %>%
            dySeries("original", label = "Actual") %>%
            dySeries(c("lwr", "fit", "upr"),
                     label = "predictions") %>%
            dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1")) %>%
            dyRangeSelector()


    })
})