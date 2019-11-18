install.packages("RCurl", repos = "http://cran.us.r-project.org", type = "source")
install.packages("bitops", repos = "http://cran.us.r-project.org", type = "source")
install.packages("xml2", repos = "http://cran.us.r-project.org", type = "source")
install.packages("XML", repos = "http://cran.us.r-project.org", type = "source")
install.packages("Zillow", type = "source", repos = "http://www.omegahat.org/R")

library(bitops)
library(RCurl)
library(xml2)
library(XML)
library(Zillow)
library(car)

## Set Zillow ID
myZillowId <- MY_ZILLOW_WEB_SERVICES_ID
## Set Zillow Home ID
myZillowHomeID <- c("38879042")
## Set Home Address
myAddress <- c("324 N 2nd St, East Newark, NJ 07029")
## Set Home Zip Code
myZipcode <- c("07029")
## Set Home Asking Price
myHomePrice <- c(319000)
## Get comps
comps_original <- getComps(myZillowHomeID, count = 25, myZillowId)
## Make a copy and preserve the original
comps <- comps_original
## Let's see the names of the variables
names(comps)
head(comps)

# ELIMINATING ATTRIBUTES
comps <- subset(comps, select=c("amount", "taxAssessment", "yearBuilt", "lotSizeSqFt",  "finishedSqFt", "bathrooms", "bedrooms", "lastSoldPrice", "score"))
head(comps)
summary(comps)

# ELIMINATING NA'S
comps <- na.omit(comps)
summary(comps)

# FULL MODEL
g <- lm(lastSoldPrice ~ ., data = comps)
summary(g)

# SHAPIRO WILK NORMALITY TEST FOR FULL MODEL
shapiro.test(residuals(g)) 
# Since 0.3 > 0.05, we accept the null hypothesis of normality

# FITTED MODEL
# First we perform variable selection
select_variables <- step(g)

g_fit <- lm(lastSoldPrice ~ bathrooms + bedrooms + taxAssessment + score, data = comps)
summary(g_fit)

# Next, we take sqrt(bathrooms) and find that the model improves
g_fit <- lm(lastSoldPrice ~ sqrt(bathrooms) + bedrooms + taxAssessment + score, data = comps)
summary(g_fit)

# SHAPIRO WILK NORMALITY TEST FOR FINAL MODEL
shapiro.test(residuals(g_fit)) 
# Since 0.8 > 0.05, we accept the null hypothesis of normality

# 1. PLOTS
par(mfrow = c(2,2))
plot(g_fit)

# 2. CERES PLOTS
ceresPlots(g_fit, terms = ~.)

# 3. ANOVA
anova(g_fit, g)

# 4. CROSS VALIDATION PLOT
install.packages("DAAG", repos = "http://cran.us.r-project.org", type = "source")
library(DAAG)
par(mfrow = c(1,1))
cv.lm(data = comps, g_fit, m=4)

# 5. ESTIMATES 
# a) Z estimate
head(comps_original)

# b) Final model 90% prediction interval
names(comps_original)
mean(comps_original[,18],na.rm = TRUE) # score
x0 <- data.frame(bathrooms = 2.0, bedrooms = 4, taxAssessment = 207073, score = 14)
predict(g_fit, x0, interval="prediction", level = 0.90)

# c) Final model 90% confidence interval
predict(g_fit, x0, interval="confidence", level = 0.90) 

# d) Full model 90% prediction interval
mean(comps_original[,11],na.rm = TRUE) # yearBuilt
mean(comps_original[,13],na.rm = TRUE) # finishedSqFt
x1 <- data.frame(amount = 357795, taxAssessment = 207073, yearBuilt = 1937, lotSizeSqFt = 2426, bathrooms = 2.0, bedrooms = 4, score = 14, finishedSqFt = 3006.56)
predict(g, x1, interval="prediction", level = 0.90)

# e) Full model 90% confidence interval
predict(g, x1, interval="confidence", level = 0.90)
