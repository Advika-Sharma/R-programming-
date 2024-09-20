# Load required libraries
library(tidyverse)
library(readr)
library(dplyr)

# Load the data
mydata <- read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\cleaned_data.csv", header = TRUE, stringsAsFactors = FALSE)

# Ensure Year is numeric
mydata$Year <- as.numeric(mydata$Year)

# Line chart: Average Data_Value for 'Stroke among adults' by year
stroke_data <- subset(mydata, Measure == "Stroke among adults")

# Check if there are any missing values in the Year or Data_Value columns and remove them
stroke_data <- stroke_data %>%
  filter(!is.na(Year) & !is.na(Data_Value))

# Calculate average Data_Value by Year
year_avg <- aggregate(stroke_data$Data_Value, by = list(stroke_data$Year), FUN = mean)
colnames(year_avg) <- c("Year", "AverageDataValue")

# Line chart with enhancements
plot(year_avg$Year, year_avg$AverageDataValue, 
     type = "o", col = "blue", 
     main = "Average Data Value for Stroke by Year", 
     xlab = "Year", 
     ylab = "Average Data Value", 
     lwd = 2, pch = 16, 
     xlim = c(min(year_avg$Year), max(year_avg$Year)), # Set limits for x-axis
     ylim = c(min(year_avg$AverageDataValue) - 1, max(year_avg$AverageDataValue) + 1), # Set limits for y-axis
     xaxt = "n") # Disable default x-axis labels

# Add axis labels with specific formatting for the x-axis
axis(1, at = seq(min(year_avg$Year), max(year_avg$Year), by = 1), las = 2)

# Add gridlines
grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted")

# Optionally, add labels to each point in the line chart
text(year_avg$Year, year_avg$AverageDataValue, 
     labels = round(year_avg$AverageDataValue, 2), 
     pos = 3, cex = 0.8, col = "blue")
