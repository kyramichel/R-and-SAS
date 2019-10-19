# MULTIPLE LINEAR REGRESSION WITH R  
## Supervised Learning

#As statistical consultants we are often asked to develop data-driven solutions to help generate sales
##Here we use multiple regression on advertising data to suggest a marketing plan that can help increase sales

#Data available:
##consists of sales of a product (in thousands of units) in 200 markets along with the advertising budgets of that product for 3 different media

#To solve this business problem, we adopt an analytical approach.



### LOAD DATA ####################################

df <- read.csv("C:/Users/uknow/Desktop/R/Advertising.csv", header=T)

fix(df) # there is an extra index col - delete first col
df <- df[, c(2:5)]
fix(df)

names(df) 
dim(df)

# Define X, y variables
X <- as.matrix(df[, c(2:4)]) # 3 predictors
y <- df[, 4] # sales

### QUESTION #############################################

##Is there a relationship between product sales and advertising budget?
#We first must check if the data provide evidence of an association between advertising expenditure and sales.

# This question can be answered by fitting a multiple regression model and testing
#H0: all coefficients=0 using F-statistic to determine whether or not we should reject H0.

## Multiple linear regression  #######################

# Using lm(y~X) or short-hand ~. 
lm.fit = lm(y ~.,data=df) #to fit a regression model of y with all predictors X

lm.fit # to view the regression coeficients

## Statistical summary #######################
#Provides info on: residuals, coefficients, p-value for t-stats for each Xi, RSE, multiple R2 and p-value for F stats
summary(lm.fit) 


summary(lm.fit)$fstatistic #F-statistic > 1 provides compelling evidence against H0
#The p-value corresponding to the F-statistic is very low (p-value: < 2.2e-16) 
#This shows strong evidence of a relationship between advertising and sales
#More exactly, that at least one of the media is associated with increased sales

# After we concluded that there is a strong evidence of a relationship between then it is natural to ask  advertising and sales, 

#### QUESTION: How strong is the relationship? ###############################

#Is it strong enough to make reliable prediction of sales based on advertising expenditure?

#We use two common numerical measures of model fit RSE and R2.

#We can access these individual components of a summary object by name:

summary(lm.fit)$sigma # gives us RSE of 1.69
summary(lm.fit)$r.sq #gives us R2 statistics close to 1 (0.8972) 

#That means that advertising explain almost 90% of the variance in sales


#Since we concluded on the basis of that p-value that at least one of the
predictors is related to the response, it is natural to ask:


#### QUESTION: Which media contribute to sales? #########################

##To answer this question, we can examine the p-values associated with
#each predictor’s t-statistic (see Pr(>|t|) in the summary(lm.fit)).

# The p-values for TV and radio are low, but the p-value for newspaper is not.
#This suggests that only TV and radio are related to sales

#### QUESTION: How large is the effect of each medium on sales? ############

##That is, for every dollar spent on advertising in a particular medium, by what amount will sales increase?

coef(lm.fit) #coefficients (same as summary())

confint(lm.fit) #95% confidence intervals for coefficients

#The confidence intervals for TV and radio are narrow and far from zero that shows
evidence that these media are related to sales

#Confidence interval for newspaper includes zero, that shows newspaper is not statistically
significant given the values of TV and radio.


################# FURTHER INVESTIGATION ##############

#Could collinearity be the reason that the confidence interval for newspaper is so wide?

#One way to assess multi- collinearity is to compute the variance inflation factor using vif() from the "car" package:

install.packages("car")
library (car)
vif(lm.fit)

#The VIF scores are 1.005,1.145, and 1.145 for TV, radio, newspaper 
#VIF < 5 suggests no evidence of collinearity

##########################

#To assess the association of each medium individually on sales we perform 3 simple linear regressions separately.

reg1=lm(sales ~ TV, df)
reg2=lm(sales ~ radio, df)
reg3=lm(sales ~ newspaper, df)

#The summary statistics for each simple regression model: 
summary(reg1)
summary(reg2)
summary(reg3)


#The summary statisitcs shows:
#There is evidence of an extremely strong association between TV and sales and between radio and sales and
#When TV and radio are ignored, there is evidence of a mild association between newspaper and sales


confint(reg1) #95% confidence intervals for coefficients
# The 95% confidence interval for intercept for TV is [6.130, 7.935] translates as:
#in the absence of any advertising, sales will fall  on average, somewhere between 6130 and 7940 units.

#The 95% confidence interval for slope is [0.042, 0.053] translates as:
#for each $1,000 increase in TV advertising, there will be an average increase in sales of between 42 and 53 units.


##### QUESTION: How accurately can we can predict future sales using our model? ###############################

##What is the accuracy of our predictions?  

# If we wish to predict an individual response, we compute a prediction interval (includes error terms)
# If we wish to predict an average response, we compute a confidence interval

# To produce both confidence intervals & prediction intervals use:
predict(lm.fit, interval = "confidence")

##### QUESTION: Is the relationship linear? ###############################

##If the relationships are linear, then the residual plots should display no pattern.

#Compute the residuals
resid(lm.fit)            # Residuals 
hist(residuals(lm.fit))  # Histogram of residuals


#### Interaction Terms ################################

#Linear regression: if we increase Xi by one unit, then Y will increase by an average of ßi units.

#Additivity means that the effect of each predictor on response is independent 

#Residual plot suggests a synergy or interaction effect between the advertising media, whereby combining the media
together results in a bigger boost to sales than using any single medium

#To assess if there is any interaction between radio and TV we fit a regression of sales onto TV and radio with an interaction term

reg4=lm(sales ~ TV*radio, df) # use radio, TV and an interaction term TV x radio 
reg4

#The coefficients that result from fitting the model with interaction term
summary(reg4)

#The p-value for the interaction term is very low that shows clear that
the original linear regression model is not additive.

# Moreover, if we fit a regression model using only TV and radio
lm.fit1=update (lm.fit , ~. -newspaper)
lm.fit1

#The coefficients that result from fitting the model without an interaction term
summary(lm.fit1)

#And compare the R2, reg 4 is is superior to lm.f1
anova(reg4, lm.fit1)
 

#### Non-linear terms ########################

plot(predict(lm.fit1), residuals(lm.fit1)) #plot the residuals against the fitted values.

plot(predict (lm.fit1), rstudent (lm.fit1))#studentized residuals against the fitted values

#There is a clear pattern of negative residuals followed by positive residuals followed by negative residuals

# We can use lm() to accommodate non-linear transformations of the predictors
reg5=lm(sales ~ radio + I(TV^2), df)

#compare R2 for the models
anova(reg4, lm.fit1)

#Check a log transformation
summary(lm(sales ~ radio + log(TV), df))


##More numeric statistics ###############

#from psych gives a more detailed statistics 
describe() 

###################

#Interpretation of the multiple least squares regression coefficients:

#In simple model, the coefficient estimate for newspaper is 12.351

#In the multiple regression setting, the coefficient estimate for newspaper is close to 0 and small p-value=0.89
#which represents the average effect of increasing newspaper spending


#### Correlation ###################

#Correlation matrix
cor(df)

#This is due to the high correlation between radio and newspaper is 0.054
#newspaper will no longer show as a significant predictor after we adjust for radio


### ADDITIONAL MODELS ########################################

install.packages("lars")
library(lars)

# Conventional stepwise regression
stepwise <- lars(X, y, type = "stepwise")

# Stagewise: Like stepwise but with better generalizability
forward <- lars(X, y, type = "forward.stagewise")

# LAR: Least Angle Regression
lar <- lars(X, y, type = "lar")

install.packages("lasso2")
library(lasso2)

# LASSO: Least Absolute Shrinkage and Selection Operator
lasso <- lars(X, y, type = "lasso")


install.packages("dplyr")
library(dplyr)

# Comparing the models using R^2 
r2 <- c(stepwise$R2, forward$R2, lar$R2, lasso$R2) %>% round(2)

names(r2) <- c("stepwise", "forward", "lar", "lasso")
r2



### LIMITATIONS ### High-dimensional setting #######

#Using F-statistic to test for any association between predictors & response works for small number of predictors,p

# When p > n number of observations we cannot even fit the multiple linear regression model using least squares.

