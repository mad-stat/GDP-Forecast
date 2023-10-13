# GDP-Forecast

This GitHub repository provides a demonstration of the implementation of different forecasting models used to predict the future trends in Saudi Arabia's GDP percentage growth. The real quarterly GDP series of SAUDI ARABIA is extracted from [FRED Data](https://fred.stlouisfed.org/series/NGDPRNSAXDCSAQ}) also available at [Saudi Arabia GDP](https://github.com/mad-stat/GDP-Forecast/blob/main/Saudi_Arabia_GDP.csv). 

* To compute the GDP Percent Change we use the following formula: $(𝐺𝐷𝑃_{Current} − 𝐺𝐷𝑃_{Previous})/(𝐺𝐷𝑃_{Previous})∗100$ and the time series is available at [Saudi Arabia GDP Percent Change](https://github.com/mad-stat/GDP-Forecast/blob/main/Saudi_Arabia_GDP.csv). A visualization of the GDP data (left) and GDP percent change data (right) is provided below:

  ![GDP Data](https://github.com/mad-stat/GDP-Forecast/blob/main/Images/GDP_Values.png) ![Percent Change](https://github.com/mad-stat/GDP-Forecast/blob/main/Images/Percent_Change.png)

* Various statistical features of the dataset are analyzed and summarized below:

  ![Features](https://github.com/mad-stat/GDP-Forecast/blob/main/Images/Features.png)

* To evaluate the performance of the forecasting techniques we split our dataset into training and test sets (6 observations) as follows:

  ![Train test](https://github.com/mad-stat/GDP-Forecast/blob/main/Images/Train_Test.png)

* We consider various statistical models - Naive, Autoregressive integrated moving average (ARIMA), machine learning models neural networks, support vector regression (SVR), Long long-term memory network (LSTM), and hybrid models Wavelet ARIMA (WARIMA) and Ensemble Wavelet Neural Network (EWNet) for forecasting the GDP percent change series. The performance of various models is provided below:

![Forecast](https://github.com/mad-stat/GDP-Forecast/blob/main/Images/Forecast.png)

* The overall performance of the models indicates that the hybrid transformation-based models are most suitable for handling the structural breaks in the dataset. The linearity of the series is best modeled using the WARIMA framework, which is evident from the plot.

The GDP of Saudi Arabia depends on a large number of economic and financial factors which demand the cointegration modeling approaches for generating an accurate forecast. However, in the lack of additional information, using the wavelet-based forecasting frameworks for modeling the historical GDP growth series can be considered as a suitable starting point.
  
