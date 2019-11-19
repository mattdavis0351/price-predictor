# Price Estimation

**Disclaimer: 
I undertook this project in 2015 and chose to predict the selling price of the following :house::
324 N 2nd St East Newark, NJ 07029. The house sold in 2018 for $315,000 (source: [zillow.com](https://www.zillow.com/homes/324-N-2nd-St,-East-Newark,-NJ-07029_rb/38879042_zpid/))**

The purpose of this project is to predict the final selling price of a chosen house based on data obtained from Zillow. 

## Prerequisites

1. Create an API account with Zillow and obtain a _Zillow Web Services ID_.
2. Navigate to Zillow's website and find a house that is on sale. An _already sold_ or _off the market_ property won't do. The chosen house must have a Zillow estimate with a range of low and high values. 

## [Code](/Zillow_Code.R)

### Install the necessary packages

### Obtain the data

### Data Preprocessing

### Build the model

### Evaluate the model

### 1. Basic Plots

**The figure below consists of the folllowing plots:**
- Residual Plot
- QQ Plot
- Squre Root Absolute Residual Plot
- Leverage Plot

![](https://i.imgur.com/J2ZO5Kh.png)

**Observations from the figure:**

- The residuals are normal as they are along the diagonal line. 
- There is hardly any skewness. 
- The outliers are identified as Property ID: 38626015, 38697121, 38697764. 

### 2. CERES Plots

![](https://i.imgur.com/0E9LDKK.png)


- In case of `bathrooms`, the green dragon line was far away from the straight line. Therefore we transform our predictor into its square root and use it in our final model. The CERES plot for `sqrt(bathrooms)` improves. 
- For the predictors: `bedrooms`, `taxAssessment` and `score`, the green dragon line is close to the straight line which indicates that no transformations are required and the linear model is a good fit. 

### 3. ANOVA Test

![](https://i.imgur.com/seuF7Ol.png)

- Since the P-value > alpha (0.99 > 0.5), we do **NOT** reject the null hypothesis. 
- Also the F-statistic is small therefore we accept the smaller fitted model to be the final model. 

### 4. Cross Validation Plot using 4 Folds

![](https://i.imgur.com/ktPOh7L.png)

### 5. Estimates Table

![](https://i.imgur.com/PKfEOiE.png)

- The final model predicts a value of $265,284 for the chosen house. This is much lesser than the Zillow Estimate. 
- Even though the Full Model provides a predicted value which is closer to the Zillow Estimate, its range is very broad. Hence, we consider the Final Model estimates to be better. 
