options(repos = c(CRAN = "https://cloud.r-project.org"))

install.packages("treemap")
# Load libraries
library(ggplot2)
library(dplyr)
library(reshape2)
library(treemap)

# Load data
data <- read.csv("D:\\R\\cleaned_data.csv")


# Convert Data_Value to numeric
data$Data_Value <- as.numeric(data$Data_Value)

# Check and ensure vSize (TotalPopulation) is numeric
data$TotalPopulation <- as.numeric(data$TotalPopulation)

# Handle any NA values in both Data_Value and TotalPopulation
# Remove rows with NA in Data_Value or TotalPopulation
data <- data %>%
  filter(!is.na(Data_Value), !is.na(TotalPopulation))

# Create the treemap
treemap(data,
        index = c("Category", "Measure"),
        vSize = "TotalPopulation",
        vColor = "Data_Value",
        type = "value",
        title = "Tree Map of Health Measures by Population",
        palette = "Blues")