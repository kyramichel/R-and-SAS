#  DATA VISUALIZAION & MODELING with R 
## Unsupervised Learning

### 1. Data visualization
### 2. Statistical summary
### 3. Hierarchical clustering 
### 4. Principal Component Analysis


####################################

# LOAD DATASETS PACKAGES 

# load built-in datasets
library(datasets)

# install other packages (pacman)
install.packages("pacman")

# load pacman
library(pacman) 

# Or load using pacman::p_load
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, 
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny, 
               stringr, tidyr) 

# LOAD DATA 

fix(mtcars) # view data in a spreadsheet-like window
dim(mtcars) # 32 observations or rows and 11 variables or columns
names(mtcars) # get variable names

# DATA VISUALIZATION 

# Graphical summaries

#plot() produce scatterplots of the quantitative variables

plot(mtcars$cyl, mtcars$mpg)

# alternatively
attach(mtcars)
plot(cyl,mpg)

# plot entire dataframe
plot(mtcars)

# barplot() - first need a table with frequencies for each category
cylinders <- table(mtcars$cyl)  # Create table
barplot(cylinders)              # Bar chart

# CONVERT VARIABLE TYPE

#Since there are only 3 possible values for cyl,
#we convert quantitative variable cyl into qualitative variable cylinder
cylinder = as.factor(cyl)

# Now cylinder is a categorial so plot() outputs a boxplot 
plot(cylinder , mpg)

#specify options
plot(cylinder , mpg , col ="orange", xlab=" cylinder ", ylab ="MPG ")


#hist() can be used to plot a histogram
hist(mtcars$mpg)

# alternattively

attach(mtcars) # only need to be specified one time
hist(mpg)


#add options
hist(mpg ,col =2, breaks =15) # number of bins is 15


hist(mpg ,col = "orange", breaks =10) # number of bins is 110

# Superimpose on previous graph kernel density estimator
lines(density(mpg), col = "red", add = TRUE)
rug(mpg, lwd = 2, col = "grey") # Add a rug plot

# Selection criteria

#based on Category
hist(mpg[cylinder == 8])

# based on value: 
hist(mpg[hp < 200])

#based on multiple section criteria
hist(mpg[hp < 200 & cylinder == 8])

#pairs() creates a scatterplot for every pair of variables
pairs(mtcars)

#scatterplots for a subset of the variables
pairs(~ mpg + hp + wt, mtcars)

#NUMERICAL SUMMARY 

#summary of each variable
summary(mtcars) 

#summary of a single variable
summary (mpg)

#describe() from psych gives a more detailed statistics 

# Load pysych from pacman
#use p_help(psych) to get info on the package

pacman::p_load(pacman, psych) 
describe(mtcars)  
describe(mtcars$mpg)   

# DATA MODELING 

#Unsupervised Learning

# We use hierarchical clustering to partition the observations into homogeneous subgroups 

#Define dissimilarity measure: Euclidean distance

#There are 32 models of cars in mtcars
dim(mtcars)


# We are going to see how they group - which one are similar

#there are 11 variables - not all influential
head(mtcars)

# Select fewer variables - create a new dataframe
Auto <- mtcars[, c(1:4, 6:7, 9:11)] #skip 5th and 8th variable
dim(Auto)
head(Auto)


# PIPING

#to streamline the workflows to fit a HC model including an arbitrary number of transformation steps

# Use piping %>% from dplyr 

# read the Auto data, get the distance and then feed that in the hierarchical cluster routine

hc <- Auto %>%  dist %>% hclust      

# plot the dendrogram
plot(hc)          

#To highlight the groups put some boxes

rect.hclust(hc, k = 2, border = "red")
rect.hclust(hc, k = 3, border = "blue")
rect.hclust(hc, k = 4, border = "violet")
rect.hclust(hc, k = 5, border = "green")


# Extra: Validating the clusters

# by assigning a p-value to a cluster to assess whether there is more
#evidence for the cluster than one would expect due to chance

# Further simplifying the data

# Dimensionality reduction - when correlated variables to select a smaller number 

# Principal Components Analysis (PCA) is an unsupervised approach

# While HC seeks to find homogeneous subgroups among the observations

# PCA seeks to find a low-dim representation of the observations
#that explains a good fraction of the variance

# PCA produces derived variables for use in supervised learning

# PCA provides also a tool to visualize data when number of features is large


# PERFORM PCA 

#use the prcomp()

# before PCA is performed the variables must be Standardized

pr.out <- prcomp(Auto,
             center = TRUE,  # Centers means to 0 (optional)
             scale = TRUE)   # Sets unit variance

#The output from prcomp() contains a number of useful quantities:
names(pr.out)

# The center and scale components are the means and standard deviations 
#of the variables that were used for scaling before implementing PCA.

pr.out$center
pr.out$scale

# INTERPRETATION

# There are 9 PCs (same number of variables)

# PC1 = normalized linear combination of the features - it has the largest variance.

# PC2 = linear combination of the features that has maximal variance 
#constraining PC2 to be uncorrelated with PC1


# Examine the results with summary stats
summary(pc)

# Screeplot for the number of PC 
# see which PCi explains the original variance
plot(pr.out)

# Get standard deviations and rotation
#see the correlation with each variable
pr.out

# plot  PC1 and PC2
biplot(pr.out, scale = 0)

#The variance explained by each PCi is obtained by squaring the sdev:
pr.out$sdev

pvar = (pr.out$sdev)^2
pvar

# HOW MUCH INFO IS LOST BY PROJECTING OUR DATASET ONTO PC1 & PC2

# Compute the proportion of variance explained by each PCi:
pve = pr.var/sum(pr.var)
pve

#PC1 explains 60% of the variance in the data
#PC2 explains 26% of the variance

# RESULTS:

# We can summarize the 32 observations and 9 variables using just the PC1 and PC2


# plot the PVE explained by each PCi
plot(pve, xlab =" Principal Component ", ylab=" Proportion of
Variance Explained ")

#plot the cummulative PVE explained by each PCi
plot(cumsum (pve), xlab=" Principal Component ", ylab ="
Cumulative Proportion of Variance Explained ")

# USES OF PCA

#One can perform regression using the principal component score vectors as features

