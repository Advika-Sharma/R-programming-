#Clean and wrangle data to remove errors and inconsistencies.
#Import and export data from various sources.
#availabe.packages()

#taking data from the system 
library(tidyverse)
library(readr)
data1<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\PLACES__Local_Data_for_Better_Health__County_Data_2024_release.csv", header = TRUE)
head(data1)

summary(data1)


