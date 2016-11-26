library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.r")

input1 <- c("2787, 3891, 3179, 2011, 1636, 1580 ,1489, 1300 ,1356, 1653 ,2013, 2823,
            2933, 2889, 2938, 2497, 1870, 1726, 1607, 1545, 1396, 1787, 2076 ,2837")



input_vector <- unlist(strsplit(input1,","))

input_vector  <- trimws(input_vector,which = "both")   

ts_object <- create_ts(as.numeric(input_vector,"2010-10-10",frequency_date = 4))
print(ts_object)

out_model <- run_models(ts1 = ts_object,
                        accuracy_measure = NULL)
out_model[["selected_model_name"]]
selected_model <- out_model[["model"]][[1]]

###
output_model <- out_model
forecasted_periods <- 10
selected_model <- output_model[["model"]][[1]]
selected_model <- forecast(selected_model,h=forecasted_periods)

model_name <- output_model[["selected_model_name"]]

title_name <- paste0("Predicted Time Series using ", model_name , " model ")
title_name

predicted_mts <- as.xts(cbind(fit = selected_model[["mean"]],
                              lwr = selected_model[["lower"]][,2],
                              upr = selected_model[["upper"]][,2]))

ts1_xts <- as.xts(ts1)
ts1_xts
colnames(ts1_xts) <- "original"
ts1_xts;predicted_mts
all <- cbind(ts1_xts, predicted_mts)
all
#####
dygraph(all, main = title_name) %>%
    dyAxis("x", drawGrid = FALSE) %>%
    dySeries("original", label = "Actual") %>%
    dySeries(c("lwr", "fit", "upr"),
             label = "predictions") %>%
    dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1")) %>%
    dyRangeSelector()

