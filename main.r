
# one could use a value of 7 for frequency when the data are sampled daily, 
# and the natural time period is a week, 
# or 12 when the data are sampled monthly and the natural time period is a year. 
# Values of 4 and 12 are assumed in (e.g.) print methods to imply a quarterly and monthly series respectively.

rm(list=ls())

source("helpers.r")

input1 <- c(2787, 3891, 3179, 2011, 1636, 1580 ,1489, 1300 ,1356, 1653 ,2013, 2823,
            2933, 2889, 2938, 2497, 1870, 1726, 1607, 1545, 1396, 1787, 2076 ,2837)


t1 <- create_ts(input1,"2010-05-20",frequency_date = 4)
t1

out1 <- run_models(t1)
out1
plot_dygraph(t1,out1,10)


start_date <- "2010-05-20"
frequency_date <- 4
