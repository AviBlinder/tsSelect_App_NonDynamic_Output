library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.r")

input1 <- c("2787, 3891, 3179, 2011, 1636, 1580 ,1489, 1300 ,1356, 1653 ,2013, 2823,
            2933, 2889, 2938, 2497, 1870, 1726, 1607, 1545, 1396, 1787, 2076 ,2837")


input1 <- c("160.35 ,161.64, 159.00, 155.69, 158.29 ,155.81, 154.05, 155.66 ,153.84, 154.87, 154.45 ,155.53, 156.11, 154.98, 153.98 ,156.77, 158.29, 158.11, 158.85, 157.61 ,156.46 ,157.08, 156.88, 155.67, 157.02, 154.79, 154.29, 153.72, 154.45, 154.77, 150.72, 151.26, 151.52, 149.63, 150.57, 150.88, 151.81, 153.35, 152.61, 153.69, 152.79, 151.95")

input_vector <- unlist(strsplit(input1,","))

input_vector  <- trimws(input_vector,which = "both")   
freq = 1

ts_object <- create_ts(as.numeric(input_vector),as.Date("2010-10-10"),
                            frequency_date = 52)

ts_object

print(ts(as.numeric(input_vector),
   start=c(2010,4),
   frequency = 1),calendar = T)


p1 <- year(as.Date("2010-01-01"))
#p2 <- week(as.Date("2010-10-10"))
p2 <- 1
p1;p2

rm(ts_object)
ts_object <- ts(input_vector,
   start=c(p1,p2),frequency = 1)
ts_object

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

