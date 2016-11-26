create_ts <- function(input_data,start_date = "2000-01-01",frequency_date = 12){
    if(!is.numeric(input_data)){
        stop ("invalid input")
    }
    
    if(!frequency_date %in% c(1,4,12)){
        stop ("invalid frequency")
    }
    
    start_date_formatted <- ymd(start_date)
    
    start_date_part1 <- year(start_date_formatted) 
    
    start_date_part2 <- switch(as.character(frequency_date), 
                               "1" = 1,
                               "4" = lubridate::quarter(start_date),
                               "12" = lubridate::month(start_date)
    )
    
    ts(input_data,
       start=c(start_date_part1,
               start_date_part2),
       frequency = frequency_date)
}
###################################################################################################
run_models <- function(ts1,accuracy_measure = NULL){
    
#    check_object(ts1)
    
    ##Check Auto-Correlations
    acf <- Acf(ts1)
    acf_max <- sort(acf$acf,decreasing = T)[2]
    acf_treshold <- 0.25
    #filter 'white noise" series
    if (acf_max < acf_treshold){
        
        stop("white noise !! Please review the input numbers")
    }
    
    ##################################################################################
    #Step 1: Fit models
    
    ##Check if the time series has a seassonality component. If not, do not check 
    #  "seassonal" models
    fit_tbats <- tbats(ts1)
    seasonal <- !is.null(fit_tbats$seasonal)
    
    print ('running model 1 ')
    print(fit_tbats[["fitted.values"]])
    
    
    fit_benchm1 <- meanf(ts1,6)  # Mean forecast (x, h) h = horizon
    print ("running model 2 ")
    print(fit_benchm1[["fitted"]])
    
    fit_benchm2 <- naive(ts1,6)  # Navive forecast (all forecasts = last observation)
    print ("running model 3 ")
    print(fit_benchm2[["fitted"]])
    
    if(seasonal){
        fit_benchm3 <- snaive(ts1,1) # Seassonal Naive
        print ("running model 4 ")
        print(fit_benchm3[["fitted"]])
        
        fit_lm2 <- tslm(ts1 ~ trend + season)
        print ("running model 5 ")
        print(fit_lm2[["fitted.values"]])
        
        fit_hw1    <- hw(ts1,seasonal="additive")
        print ("running model 6 ")
        print(fit_hw1[["fitted"]])
        
        fit_hw2    <- hw(ts1,seasonal="multiplicative")
        print ("running model 7 ")
        print(fit_hw2[["fitted"]])
    }

    fit_benchm4 <- rwf(ts1,6,drift = TRUE) #Drift method - adds a "trend" over time to the naive method
    print ("running model 8 ")
    print(fit_benchm4[["fitted"]])
    
    fit_lm1 <- tslm(ts1 ~ trend)
    print ("running model 9" )
    print(fit_lm1[["fitted.values"]])
    
    fit_ses <- ses(ts1)
    print ("running model 10 ")
    print(fit_ses[["fitted"]])
    
    fit_ets <- ets(ts1)
    print ("running model 11 ")
    print(fit_ets[["fitted"]])
    
    fit_holt1 <- holt(ts1)
    print ("running model 12 ")
    print(fit_holt1[["fitted"]])
    
    fit_holt2 <- holt(ts1,exponental=TRUE)
    print ("running model 13 ")
    print(fit_holt2[["fitted"]])
    
    fit_holt3 <- holt(ts1,damped=TRUE)
    print ("running model 14 ")
    print(fit_holt3[["fitted"]])
    
    fit_holt4 <- holt(ts1,exponential=TRUE,damped=TRUE)
    print ("running model 15 ")
    print(fit_holt4[["fitted"]])
    
    fit_auto_arima1 <- auto.arima(ts1,stepwise=TRUE)
    print ("running model 16 ")
    print(fit_auto_arima1[["x"]]-fit_auto_arima1[["residuals"]])
    
    fit_auto_arima2 <-  auto.arima(ts1, stepwise=FALSE, approximation=FALSE)
    print ("running model 17 ")
    print(fit_auto_arima2[["fitted"]])
    ##################################################################################
    #Step 2: Measure accuracies
    
    ac_benchm1 <- data.frame(accuracy(fit_benchm1))
    ac_benchm1$model <- "meanf"
    row.names(ac_benchm1) <- NULL
    #
    ac_benchm2 <- data.frame(accuracy(fit_benchm2))
    ac_benchm2$model <- "naive"
    row.names(ac_benchm2) <- NULL
    #
    ac_benchm4 <- data.frame(accuracy(fit_benchm4))
    ac_benchm4$model <- "rwf"
    row.names(ac_benchm4) <- NULL
    #
    ac_lm1     <- data.frame(accuracy(fit_lm1))
    ac_lm1$ACF1 <- NA
    ac_lm1$model <- "lm_with_trend"
    row.names(ac_lm1) <- NULL
    
    ac_tbats <- data.frame(accuracy(fit_tbats))
    ac_tbats$model <- "tbats"
    row.names(ac_tbats) <- NULL
    
    #
    ac_ets     <- data.frame(accuracy(fit_ets))
    ac_ets$model <- "ets"
    row.names(ac_ets) <- NULL
    #
    ac_ses     <- data.frame(accuracy(fit_ses))
    ac_ses$model <- "ses"
    row.names(ac_ses) <- NULL
    
    #
    if (seasonal){
        ac_benchm3 <- data.frame(accuracy(fit_benchm3))
        ac_benchm3$model <- "snaive"
        row.names(ac_benchm3) <- NULL
        
        ac_lm2     <- data.frame(accuracy(fit_lm2))
        ac_lm2$ACF1 <- NA
        ac_lm2$model <- "lm_with_trend_and_season"
        row.names(ac_lm2) <- NULL
        
        #
        ac_hw1     <- data.frame(accuracy(fit_hw1))
        ac_hw1$model <- "Holt-Winters_additive"
        row.names(ac_hw1) <- NULL
        
        ac_hw2     <- data.frame(accuracy(fit_hw2))
        ac_hw2$model <- "Holt-Winters_multiplicative"
        row.names(ac_hw2) <- NULL
        
    }
    #
    
    ac_holt1   <- data.frame(accuracy(fit_holt1))
    ac_holt1$model <- "Holt_simple"
    row.names(ac_holt1) <- NULL
    #
    ac_holt2   <- data.frame(accuracy(fit_holt2))
    ac_holt2$model <- "Holt_exponential"
    row.names(ac_holt2) <- NULL
    #
    ac_holt3   <- data.frame(accuracy(fit_holt3))
    ac_holt3$model <- "Holt_damped"
    row.names(ac_holt3) <- NULL
    #
    ac_holt4   <- data.frame(accuracy(fit_holt4))
    ac_holt4$model <- "Holt_exponential_damped"
    row.names(ac_holt4) <- NULL
    
    ac_auto_arima1     <- data.frame(accuracy(fit_auto_arima1))
    ac_auto_arima1$model <- "Auto_Arima"
    row.names(ac_auto_arima1) <- NULL
    
    ac_auto_arima2     <- data.frame(accuracy(fit_auto_arima2))
    ac_auto_arima2$model <- "Auto_Arima_No_Stepwise"
    row.names(ac_auto_arima2) <- NULL
    
    print ("end of step 2 (calculating accuracy of models")
    ##################################################################################
    #Step 3: Combine models and pick best one
    
    if (seasonal){
        
        accuracies <- rbind(ac_benchm1,ac_benchm2,ac_benchm3,ac_benchm4,
                            ac_lm1,ac_lm2,ac_ets,ac_ses,
                            ac_holt1,ac_holt2,ac_holt3,ac_holt4,ac_hw1,ac_hw2,
                            ac_auto_arima1,ac_auto_arima2,ac_tbats)
        all_models <-   list("meanf"    =    fit_benchm1 ,
                             "naive"         =    fit_benchm2 ,
                             "snaive"        =    fit_benchm3 ,
                             "rwf"           =    fit_benchm4 ,
                             "lm_with_trend" =    fit_lm1     ,
                             "lm_with_trend_and_season" = fit_lm2 ,
                             "ses"           =    fit_ses ,
                             "ets"           =    fit_ets ,
                             "Holt-Winters_additive" =  fit_hw1 ,
                             "Holt-Winters_multiplicative" = fit_hw2 ,
                             "Holt_simple"   =    fit_holt1 ,
                             "Holt_exponential"  =    fit_holt2 ,
                             "Holt_damped"       =    fit_holt3 ,
                             "Holt_exponential_damped" =    fit_holt4 ,
                             "Auto_Arima"        =    fit_auto_arima1 ,
                             "Auto_Arima_No_Stepwise" =    fit_auto_arima2,
                             "tbats" = fit_tbats)
        
    } else {
        accuracies <- rbind(ac_benchm1,ac_benchm2,ac_benchm4,
                            ac_lm1,
                            ac_holt1,ac_holt2,ac_holt3,ac_holt4,
                            ac_auto_arima1,ac_auto_arima2,ac_tbats)
        all_models <-   list("meanf"    =    fit_benchm1 ,
                             "naive"         =    fit_benchm2 ,
                             "rwf"           =    fit_benchm4 ,
                             "lm_with_trend" =    fit_lm1     ,
                             "Holt_simple"   =    fit_holt1 ,
                             "Holt_exponential"  =    fit_holt2 ,
                             "Holt_damped"       =    fit_holt3 ,
                             "Holt_exponential_damped" =    fit_holt4 ,
                             "Auto_Arima"        =    fit_auto_arima1 ,
                             "Auto_Arima_No_Stepwise" =    fit_auto_arima2,
                             "tbats" = fit_tbats)
        
    }
    
    print ("all_models created")
    
    if(is.null(accuracy_measure)){
        x2 <- c()
        for (i in 1:ncol(accuracies)){
            x1 <- accuracies[accuracies[,i] == min(accuracies[,i],na.rm = TRUE),"model"]
            x2 <- c(x2,x1)
        }
        selected_model <- sort(table(x2),decreasing = TRUE)[1]
    } else {
        col <- which(names(accuracies) == accuracy_measure )
        selected_model <- accuracies[accuracies[,col] == min(accuracies[,col],na.rm = TRUE),"model"]
        if (length(selected_model) > 1) {
            selected_model <- selected_model[3]
        }
    }
    
    print ("accuracies : ")
    print (accuracies)
    print ("end of step 3 - selected model = ")
    print (names(selected_model))
    list(selected_model_name = names(selected_model),
                      model=all_models[names(all_models) == names(selected_model)])
}
###################################################################################################
check_object <- function(x){
    
    if (!exists(x) ) {
        stop("missing input variable !")
    }
}
##################################################################################################
plot_dygraph <- function(ts1,output_model,forecasted_periods){
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
 
}