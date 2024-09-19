#Clean and wrangle data to remove errors and inconsistencies.
#taking data from the system 
library(tidyverse)
library(readr)
#install.packages("dplyr")
library(dplyr)
data1<-read.csv("C:\\Users\\Advika Sharma\\Desktop\\R\\data.csv", header = TRUE)  
#head(data1)

#delete unwanted columns 
data1 <- data1[, -12]
View(data1)
data1 <- data1[, -11]
View(data1)
data1 <- data1[, -20]
View(data1)

# Replace empty strings with NA in only character columns
data1 <- data1 %>%
  mutate(across(where(is.character), ~ na_if(., "")))

# Replace a specific numeric placeholder (-999) with NA for numeric columns
data1 <- data1 %>%
  mutate(across(where(is.numeric), ~ na_if(., -999)))

#showing the new changed data
view(data1)

#printing all na valued cells 
na_positions <- which(is.na(data1), arr.ind = TRUE)

# Print the row and column indices of NA values
for (i in 1:nrow(na_positions)) {
  row <- na_positions[i, 1]
  col <- na_positions[i, 2]
  cat("NA found at Row:", row, "Column:", col, "Value:", data1[row, col], "\n")
}


# Replace numerical NA values with the mean of their respective columns
data1[] <- lapply(data1, function(col) {
  if (is.numeric(col)) {
    col[is.na(col)] <- mean(col, na.rm = TRUE)
  }
  return(col)
})

# Drop rows with NA values in character columns
data1 <- data1[complete.cases(data1[ ,sapply(data1, is.character)]), ]

view(data1)


# Reset row names to start from 1
rownames(data1) <- NULL

# Reset the 'X' column to start from 1
data1$X <- seq_len(nrow(data1))
view(data1)

# Check for remaining NA values
remaining_na <- any(is.na(data1))

# Check for remaining empty cells (for character columns)
remaining_empty <- any(data1 == "")

# Print results
if (remaining_na) {
  cat("There are remaining NA values in the dataset.\n")
} else {
  cat("There are no remaining NA values in the dataset.\n")
}

if (remaining_empty) {
  cat("There are remaining empty cells in the dataset.\n")
} else {
  cat("There are no remaining empty cells in the dataset.\n")
}
# Save the dataset 
write.csv(data1,"C:\\Users\\Advika Sharma\\Desktop\\cleaned_data.csv")
