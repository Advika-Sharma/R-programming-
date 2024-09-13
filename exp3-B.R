#Import and export data from various sources.
#availabe.packages()

#taking data from the system 
library(tidyverse)
library(readr)
data1<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\PLACES__Local_Data_for_Better_Health__County_Data_2024_release.csv", header = TRUE)
head(data1 , n=3)

#creating your own data 
df <- data.frame("name"=c("soni","ankit","adam","eve"),
"age"=c(25,30,35,40),
"language"=c("java","python","R","C++"),
"branch"=c("CS","DS","AI","IOT"))
print(df)

#exporting 
#exporting data to csv file
#write.csv(data1,"C:\\Users\\Advika Sharma\\Desktop\\R\\data.csv")

#exporting own data 
#write.table(df,
#file = "C:\\Users\\Advika Sharma\\Desktop\\R\\student.txt",
#sep = "\t",
#row.names = TRUE,
#col.names = NA)
