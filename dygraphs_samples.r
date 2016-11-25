#http://rstudio.github.io/dygraphs/

dygraph(predicted_mts, main = title_name) %>%
    dyAxis("x", drawGrid = FALSE) %>%
    dySeries("ldeaths", label = "Actual") %>%
    dySeries(c("lwr", "fit", "upr"), label = "predictions") %>%
    dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"))
# dyShading(from = mn - std, to = mn + std, axis = "y")
#   dyOptions(fillGraph = TRUE, fillAlpha = 0.4)
#   dyOptions(drawPoints = TRUE, pointSize = 2)

##
hw <- HoltWinters(ldeaths)
p <- predict(hw, n.ahead = 36, prediction.interval = TRUE)
all <- cbind(ldeaths, p)

dygraph(all, "Deaths from Lung Disease (UK)") %>%
    dySeries("ldeaths", label = "Actual") %>%
    dySeries(c("p.lwr", "p.fit", "p.upr"), label = "Predicted")
ldeaths
start(ldeaths)
frequency(ldeaths)
##
#Series Highligh
# lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)
# dygraph(lungDeaths, main = "Deaths from Lung Disease (UK)") %>%
#     dyHighlight(highlightCircleSize = 5, 
#                 highlightSeriesBackgroundAlpha = 0.2,
#                 hideOnMouseOut = FALSE)
#
#dygraph(lungDeaths, main = "Deaths from Lung Disease (UK)") %>%
#dyHighlight(highlightSeriesOpts = list(strokeWidth = 3))

#Range Selector
#dyRangeSelector()
# dyRangeSelector(height = 20, strokeColor = "")
#

##
#Shiny Date Input
#
#Shiny applications can respond to changes in the dateWindow via a special 
# date_window input value. 
# For example, if the output id of a dygraph is series then the current 
# date window can be read from 
# input$series_date_window as an array of two date values (from and to).

#Note that when using the data window input variable you should always check for NULL before accessing it, for example:

output$from <- renderText({
    if (!is.null(input$dygraph_date_window))
        strftime(input$dygraph_date_window[[1]], "%d %b %Y")      
})


#Shading
dygraph(nhtemp, main = "New Haven Temperatures") %>% 
    dyShading(from = "1920-1-1", to = "1930-1-1") %>%
    dyShading(from = "1940-1-1", to = "1950-1-1")

dygraph(nhtemp, main = "New Haven Temperatures") %>% 
    dySeries(label = "Temp (F)", color = "black") %>%
    dyShading(from = "1920-1-1", to = "1930-1-1", color = "#FFE6E6") %>%
    dyShading(from = "1940-1-1", to = "1950-1-1", color = "#CCEBD6")