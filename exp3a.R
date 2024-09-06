# 1. Loading 
data("mtcars")
# 2. Print
head(mtcars)
nrow(mtcars)
ncol(mtcars)

summary(mtcars)

#Min: The minimum value.
#1st Qu: The value of the first quartile (25th percentile).
#Median: The median value.
#Mean: The mean value.
#3rd Qu: The value of the third quartile (75th percentile).
#Max: The maximum value.

dim(mtcars)
names(mtcars)

hist(mtcars$mpg,
     col='steelblue',
     main='Histogram',
     xlab='mpg',
     ylab='Frequency')
