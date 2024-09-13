#Import and export data from various sources.
#availabe.packages()

#taking data from the system 
library(tidyverse)
library(readr)
data1<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\PLACES__Local_Data_for_Better_Health__County_Data_2024_release.csv", header = TRUE)
head(data1)

#creating your own data 
data.frame("name"=c("soni","ankit","adam","eve"),
"age"=c(25,30,35,40),
"language"=c("java","python","R","C++"),
"branch"=c("CS","DS","AI","IOT"))


