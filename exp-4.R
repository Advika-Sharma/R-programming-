#Clean and wrangle data to remove errors and inconsistencies.

#taking data from the system 
library(tidyverse)
library(readr)
data1<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\PLACES__Local_Data_for_Better_Health__County_Data_2024_release.csv", header = TRUE) 
#head(data1)

data1 <- data1[, -12]
View(data1)
data1 <- data1[, -11]
View(data1)
data1 <- data1[, -20]
View(data1)

write.csv(data1,"C:\\Users\\Advika Sharma\\Desktop\\data.csv")