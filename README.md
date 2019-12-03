# Price Estimation

**Disclaimer: 
I undertook this project in 2015 and chose to predict the selling price of the following :house::
324 N 2nd St East Newark, NJ 07029. The house sold in 2018 for $315,000 (source: [zillow.com](https://www.zillow.com/homes/324-N-2nd-St,-East-Newark,-NJ-07029_rb/38879042_zpid/))**

The purpose of this project was to predict the final selling price of a chosen house based on data obtained from Zillow. 

## Prerequisites

1. Create an API account with Zillow and obtain a _Zillow Web Services ID_.
2. Navigate to Zillow's website and find a house that is on sale. An _already sold_ or _off the market_ property won't do. The chosen house must have a Zillow estimate with a range of high :arrow_up: and low :arrow_down: values. 

## [Code](/Zillow_Code.R) :computer:

### Install the necessary packages
Pretty self-explanatory! I installed and initialized the packages that were required.

### Obtain the data
Using my _Zillow Web Services ID_ and the _Zillow Property ID_ for my chosen :house:, I made a `getComps` request to the Zillow API. 

The response included:
- data on comparable sold homes which is what I used to build a linear regression model. 
- the Zillow estimate, high :arrow_up: and low :arrow_down: values of the property of my choice. I used these estimates to compare my own predictions with. 

:bulb: The selling price of the house, stored in`lastSoldPrice`,  is going to be empty for the chosen house, but fear not, since this is the value I am going to be predicting!

### Data Preprocessing
### 1. Dimensionality Reduction

I subset the dataframe that was going to be used to build the model by choosing attributes that made the most sense in predicting `lastSoldPrice`. 

### 2. Missing Data

I removed all the rows that had missing data. 

:bell: Note that in doing so, I also ended up eliminating the row containing my chosen house since its `lastSoldPrice` was `NA`. That proved to be beneficial since those were the estimates I wanted to predict and compare against. 

### Build the model
I built 2 linear regression models:

- Full Model

Consisted of all the subsetted attributes as predictors. 

- Final Model

I performed variable selection followed by transformation (in the form of `sqrt(bathrooms)`) and then built another linear regression model. 

### Evaluate the model

### 1. Basic Plots

**The figure below consists of the following plots:**
- Residual Plot
- QQ Plot
- Squre Root Absolute Residual Plot
- Leverage Plot

![](https://i.imgur.com/J2ZO5Kh.png)

**Observations from the figure:**

- The residuals were normal as they were along the diagonal line. 
- There was hardly any skewness. 
- The outliers were identified as Property ID: 38626015, 38697121, 38697764. 

### 2. CERES Plots

![](https://i.imgur.com/0E9LDKK.png)

- In case of `bathrooms`, the green dragon line was far away from the straight line. Therefore I transformed the predictor into its square root and used it in my final model. The CERES plot for `sqrt(bathrooms)` improved. 
- For the predictors: `bedrooms`, `taxAssessment` and `score`, the green dragon line was close to the straight line which indicated that no transformations were required and the linear model was a good fit. 

### 3. ANOVA Test

![](https://i.imgur.com/seuF7Ol.png)

- Since the P-value > alpha (0.99 > 0.5), I did **NOT** reject the null hypothesis. 
- Also the F-statistic was small therefore I accepted the smaller fitted model to be the final model. 

### Prediction

![](https://i.imgur.com/PKfEOiE.png)

- The final model predicted a value of $265,284 for the chosen house. This was considerably lesser than the Zillow estimate which was $358,154. 
- Even though the Full Model provided a predicted value which was closer to the Zillow Estimate, its range was very broad. Hence, I considered the Final Model estimates to be better. 

## In retrospect

My linear model's prediction was pretty far off from the Zillow estimate which I'm sure might've seemed like a bummer at the time.

But looking back at the fact that the house sold 3 years after this project was undertaken but for a price that was much lesser than the Zillow estimate (it sold for $315,000), makes one wonder about the accuracy of that estimate in the first place.

A little bit of digging uncovered articles like:

- [Forbes: How Accurate are Zillow Estimates?](https://www.forbes.com/sites/johnwake/2018/06/27/how-accurate-are-online-home-value-estimates/#86209856013a)
- [Investopedia: Zillow Estimates - Not As Accurate As You Think](https://www.investopedia.com/articles/personal-finance/111115/zillow-estimates-not-accurate-you-think.asp)

And a big find was coming across this [Press Release](http://zillow.mediaroom.com/2019-01-30-Zillow-Awards-1-Million-to-Team-that-Built-a-Better-Zestimate) straight from the horse's mouth that talks about an open competition hosted by Zillow where teams were asked to improve the Zestimate. 

**Moral of the story:** The key is to iterate and improve, whether it's for an individual developer or a big organization! :tada: 
