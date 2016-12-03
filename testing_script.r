library(shiny)
library(lubridate)
library(forecast)
library(xts)
library(dygraphs)

source("helpers.r")

input1 <- c("112,118,132,129,121,135,148,148,136,119,104,118,115,126,141,135,125,149,170,170,158, 133,114,140,145,150,178,163,172,178,199,199,184,162,146,166,171,180,193,181,183,218, 230,242,209,191,172,194,196,196,236,235,229,243,264,272,237,211,180,201,204,188,235, 227,234,264,302,293,259,229,203,229,242,233,267,269,270,315,364,347,312,274,237,278, 284,277,317,313,318,374,413,405,355,306,271,306,315,301,356,348,355,422,465,467,404, 347,305,336,340,318,362,348,363,435,491,505,404,359,310,337,360,342,406,396,420,472, 548,559,463,407,362,405,417,391,419,461,472,535,622,606,508,461,390,432")

input_vector <- unlist(strsplit(input1,","))

input_vector  <- trimws(input_vector,which = "both")   
input_vector
freq = 12

ts_object <- create_ts(as.numeric(input_vector),as.Date("2000-01-01"),
                            frequency_date = freq)

ts_object
ts1 <- ts_object

print(ts(as.numeric(input_vector),
   start=c(2010,4),
   frequency = 1),calendar = T)




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

