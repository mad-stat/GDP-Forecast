library(readr)
data <- read_csv("Saudi_Arabia_GDP.csv")
library(zoo)
quarters <- as.yearqtr(data$DATE, format = "%d/%m/%Y")
data_quarter <- data.frame("Quarter" = quarters, "GDP" = data$GDP)
plot(data_quarter, type="l", col="blue")

change <- diff(data$GDP)
percent_change = change/data$GDP[-length(data$GDP)]*100
pch_data = data.frame("Date" = quarters[-1], "GDP_Change" = percent_change)
plot(pch_data, type="l", col="blue")

library(forecast)

# Data Features
acf(pch_data$GDP_Change, type = c("correlation"), main = "ACF for GDP Percent Change")
pacf(pch_data$GDP_Change, main = "PACF for GDP Percent Change")
seastests::isSeasonal(pch_data$GDP_Change, freq = 4)
tseries::kpss.test(pch_data$GDP_Change, null = "Level")
tseries::kpss.test(pch_data$GDP_Change, null = "Trend")
nonlinearTseries::nonlinearityTest(pch_data$GDP_Change)
nortest::ad.test(pch_data$GDP_Change)

# Forecasting
n = 6
datats = ts(pch_data$GDP_Change)
train = subset(datats, end = length(datats) - n)
test = subset(datats, start = length(datats) - n + 1)

#################################
library(Metrics)
model_evaluate = data.frame()
evaluate = function(test, pred, model){
  blnn_RMSE = rmse(pred, test)
  evaluation = data.frame(Model = model, RMSE = blnn_RMSE)
  return(evaluation)
}

########### ARIMA
mod_ar = auto.arima(train)
pred_ar = forecast(mod_ar, h = n)
model_evaluate = rbind(model_evaluate, evaluate(test, pred_ar$mean, model = "ARIMA"))

########### RWF
mod_rw = rwf(train, h = n)
model_evaluate = rbind(model_evaluate, evaluate(test, mod_rw$mean, model = "RWF"))

set.seed(100)

###################################### ARNN ######################################
fit_ARNN = nnetar(train)
predARNN=forecast::forecast(fit_ARNN, h= n)
plot(predARNN)
model_evaluate = rbind(model_evaluate, evaluate(ts(test), ts(predARNN$mean),
                                                model = "ARNN"))

###################################### Wavelet ARIMA ######################################
library(WaveletArima)
fit_wa <- WaveletFittingarma(train, Waveletlevels = floor(log(length(train))), boundary = 'periodic', FastFlag = TRUE, MaxARParam = 5,
                             MaxMAParam = 5, NForecast = n)
model_evaluate = rbind(model_evaluate, evaluate(ts(test), ts(fit_wa$Finalforecast),
                                                model = "Wavelet ARIMA"))

autoplot(ts(data.frame(test, fit_wa$Finalforecast)))

library(epicasting)
pred_ewnet = ewnet(train, NForecast = n)
model_evaluate = rbind(model_evaluate, evaluate(test, pred_ewnet$Forecast, model = "EWNet"))
model_evaluate

svr = read_csv("GDP_SVR.csv")
model_evaluate = rbind(model_evaluate, evaluate(test, svr$GDP_Change, model = "SVR"))
model_evaluate

lstm = read_csv("GDP_6_LSTM.csv")
model_evaluate = rbind(model_evaluate, evaluate(test, lstm$GDP_Change, model = "LSTM"))
model_evaluate

