# Load required libraries
library(tidyverse)
library(readr)
library(dplyr)

# Load the data
mydata <- read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\cleaned_data.csv", header = TRUE, stringsAsFactors = FALSE)

# Bar chart: Average Data_Value for each StateAbbr
state_avg <- aggregate(mydata$Data_Value, by = list(mydata$StateAbbr), FUN = mean)
colnames(state_avg) <- c("StateAbbr", "AverageDataValue")

# Bar chart
barplot(state_avg$AverageDataValue, names.arg = state_avg$StateAbbr,
        main = "Average Data Value by State", 
        xlab = "State", 
        ylab = "Average Data Value",
        col = "skyblue", 
        las = 2, cex.names = 0.7)

# Box plot: Distribution of Data_Value
boxplot(mydata$Data_Value, 
        main = "Boxplot of Data Value", 
        ylab = "Data Value", 
        col = "lightgreen")

# Scatter plot: Data_Value vs TotalPopulation
plot(mydata$TotalPopulation, mydata$Data_Value,
     main = "Scatter Plot of Data Value vs Total Population", 
     xlab = "Total Population", 
     ylab = "Data Value",
     col = "red", pch = 19)

# Line chart: Average Data_Value for 'Stroke among adults' by year
stroke_data <- subset(mydata, Measure == "Stroke among adults")
year_avg <- aggregate(stroke_data$Data_Value, by = list(stroke_data$Year), FUN = mean)
colnames(year_avg) <- c("Year", "AverageDataValue")

# Line chart
plot(year_avg$Year, year_avg$AverageDataValue, 
     type = "o", col = "blue", 
     main = "Average Data Value for Stroke by Year", 
     xlab = "Year", 
     ylab = "Average Data Value",
     lwd = 2, pch = 16)

