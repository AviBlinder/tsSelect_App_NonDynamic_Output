library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.r")

input_sample <- c("2787", "3891", "3179", "2011", "1636", "1580" ,"1489", 
            "1300" ,"1356", "1653" ,"2013", "2823", 
            "2933", "2889", "2938", "2497", "1870", 
            "1726", "1607", "1545", "1396", "1787", "2076" ,"2837")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    predicted <-reactive({
        print (input$ts_input)
        
        if (input$ts_input %in% c("0" , "")){
            input_ts <- input_sample
        } else {
            input_ts <- input$ts_input
        }
        
        print (input_ts)
#Stript input from comma separators and trim spaces        
        input_vector <- unlist(strsplit(input_ts,","))
        input_vector  <- trimws(input_vector,which = "both")        



print ("Date : ")
print (as.Date(input$date))
print ("Frequency  ")
print (as.numeric(input$Frequency))
#Convert numbers into time series        
        if (length(input_vector) > 1){
            ts_object <- create_ts(
                           input_data = as.numeric(input_vector),
                           start_date = as.Date(input$date),
                           frequency_date = as.numeric(input$Frequency))
        
        print(ts_object)
        
        out_model <- run_models(ts1 = ts_object,
                            accuracy_measure = NULL)
        selected_model <- out_model[["selected_model_name"]]
        
        plot_dygraph(ts_object,out_model,input$Slider)
        }    
        
    })

    predicted_preps <-reactive({
        if (input$ts_input %in% c("0" , "")){
            input_ts <- input_sample
        } else {
            input_ts <- input$ts_input
        }
        
        input_vector <- unlist(strsplit(input_ts,","))
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
    
    output$log_title <- renderText({
        "Below is the log of the last execution"
    })
            
    output$ts_input_out <- renderPrint({ 
        predicted_preps()
        })
    
    output$dygraph_plot <- renderDygraph({

        dygraph(predicted(), main = "Actual and Predicted Results") %>%
            dyAxis("x", drawGrid = FALSE) %>%
            dySeries("original", label = "Actual") %>%
            dySeries(c("lwr", "fit", "upr"),
                     label = "Predictions") %>%
            dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1")) %>%
            dyRangeSelector()
        


    })
})