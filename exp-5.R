library(tidyverse)
library(readr)
library(dplyr)
#install.packages("modeest")
library(modeest)
mydata<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\cleaned_data.csv", header = TRUE, stringsAsFactors = F) 

#head(mydata)

# Compute the mean value
mean = mean(mydata$TotalPopulation)
print(mean)

# Compute the median value
median = median(mydata$TotalPop18plus)
print(median)

# Compute the mode value
mode = mfv(mydata$Low_Confidence_Limit)
print(mode)

# Calculate the maximum
max = max(mydata$TotalPopulation)
cat("max is :\n")
print(max)

# Calculate the minimum
min = min(mydata$TotalPopulation)
cat("min is :\n")
print(min)

# Calculate the range
range = max - min
cat("Range is:\n")
print(range)

# Alternate method to get min and max
r = range(mydata$TotalPopulation)
print(r)

# Assuming the data is already loaded into 'mydata'

# Compute Quantiles (e.g., 25th, 50th, 75th percentiles)
quantiles <- quantile(mydata$TotalPopulation, probs = c(0.25, 0.5, 0.75))
print("Quantiles (25th, 50th, 75th percentiles):")
print(quantiles)

# Compute Interquartile Range (IQR)
iqr_value <- IQR(mydata$TotalPopulation)
print("Interquartile Range (IQR):")
print(iqr_value)

# Compute Variance
variance <- var(mydata$TotalPopulation)
print("Variance:")
print(variance)

# Compute Standard Deviation
std_deviation <- sd(mydata$TotalPopulation)
print("Standard Deviation:")
print(std_deviation)

# Summary Statistics
summary_stats <- summary(mydata$TotalPopulation)
print("Summary Statistics:")
print(summary_stats)
