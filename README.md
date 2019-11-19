# Price Estimation

**Disclaimer: 
I undertook this project in 2015 and chose to predict the selling price of the following :house::
324 N 2nd St East Newark, NJ 07029. The house sold in 2018 for $315,000 (source: [zillow.com](https://www.zillow.com/homes/324-N-2nd-St,-East-Newark,-NJ-07029_rb/38879042_zpid/))**

The purpose of this project is to predict the final selling price of a chosen house based on data obtained from Zillow. 

## Prerequisites

1. Create an API account with Zillow and obtain a _Zillow Web Services ID_.
2. Navigate to Zillow's website and find a house that is on sale. An _already sold_ or _off the market_ property won't do. The chosen house must have a Zillow estimate with a range of high :arrow_up: and low :arrow_down: values. 

## [Code](/Zillow_Code.R)

### Install the necessary packages
Pretty self-explanatory! Install and initialize the packages that will be required.

### Obtain the data
Using your _Zillow Web Services ID_ and the _Zillow Property ID_ for your chosen :house:, make a `getComps` request to the Zillow API. 

The response includes:
- data on comparable sold homes which is what we're going to use to build a linear regression model. 
- the Zillow estimate, high :arrow_up: and low :arrow_down: values of the property of our choice. We will use these estimates to compare our own predictions with. 

:bulb: The selling price of the house, stored in`lastSoldPrice`,  is going to be empty for the chosen house, but fear not, since this is the value we are going to be predicting!

### Data Preprocessing
### 1. Dimensionality Reduction

We subset the dataframe that will be used to build the model by choosing attributes that make the most sense in predicting `lastSoldPrice`. 

### 2. Missing Data

We remove all the rows that have missing data. 

:bell: Note that in doing so, we also end up eliminating the row containing our chosen house since its `lastSoldPrice` is `NA`. This is good since those are the estimates we want to predict and compare against. 

### Build the model
We're going to build 2 linear regression models:

- Full Model

Consists of all the subsetted attributes as predictors. 

- Final Model

We perform variable selection followed by transformation (in the form of `sqrt(bathrooms)`) and then build another linear regression model. 

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

### Prediction

![](https://i.imgur.com/PKfEOiE.png)

- The final model predicts a value of $265,284 for the chosen house. This is considerably lesser than the Zillow estimate which is $358,154. 
- Even though the Full Model provides a predicted value which is closer to the Zillow Estimate, its range is very broad. Hence, we consider the Final Model estimates to be better. 

## In retrospect

My linear model's prediction was pretty far off from the Zillow estimate which I'm sure might've seemed like a bummer at the time.

But looking back at the fact that the house sold 3 years after this project was undertaken but for a price that was much lesser than the Zillow estimate (it sold for $315,000), makes one wonder about the accuracy of that estimate in the first place.

A little bit of digging uncovered articles like:

- [Forbes: How Accurate are Zillow Estimates?](https://www.forbes.com/sites/johnwake/2018/06/27/how-accurate-are-online-home-value-estimates/#86209856013a)
- [Investopedia: Zillow Estimates - Not As Accurate As You Think](https://www.investopedia.com/articles/personal-finance/111115/zillow-estimates-not-accurate-you-think.asp)

And a big find was coming across this [Press Release](http://zillow.mediaroom.com/2019-01-30-Zillow-Awards-1-Million-to-Team-that-Built-a-Better-Zestimate) straight from the horse's mouth that talks about an open competition hosted by Zillow where teams were asked to improve the Zestimate. 

**Moral of the story:** Even big organizations aren't perfect when it comes to this stuff. The key is to iterate and improve! :tada: 
