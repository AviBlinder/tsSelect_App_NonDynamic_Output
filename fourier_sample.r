library(forecast)
gas <- ts(read.csv("http://robjhyndman.com/data/gasoline.csv", header=FALSE)[,1], 
          freq=365.25/7, start=1991+31/7/365.25)
zoo(gas)
bestfit <- list(aicc=Inf)
bestfit
for(i in 1:25)
{
    fit <- auto.arima(gas, xreg=fourier(gas, K=i), seasonal=FALSE)
    if(fit$aicc < bestfit$aicc)
        bestfit <- fit
    else break;
}
fc <- forecast(bestfit, xreg=fourier(gas, K=12, h=104))
plot(fc)
bestfit$coef
