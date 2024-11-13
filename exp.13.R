# Install necessary packages if not already installed
if (!require("data.table")) install.packages("data.table")
if (!require("dplyr")) install.packages("dplyr")
if (!require("DBI")) install.packages("DBI")
if (!require("dbplyr")) install.packages("dbplyr")
if (!require("parallel")) install.packages("parallel")
if (!require("furrr")) install.packages("furrr")  # Install furrr if missing
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("qs")) install.packages("qs")
if (!require("RSQLite")) install.packages("RSQLite")

# Load libraries
library(data.table)
library(dplyr)
library(DBI)
library(dbplyr)
library(parallel)
library(furrr)
library(ggplot2)
library(qs)
library(RSQLite)

# Step 1: Load Data Efficiently with data.table
data <- fread("D:\\R\\cleaned_data.csv")

# Step 2: Basic Data Manipulation with data.table
filtered_data <- data[Category == "Health" & Data_Value > 500]
summary_data <- data[, .(mean_value = mean(Data_Value, na.rm = TRUE)), by = Category]

# Step 3: Use dplyr for more manipulation
avg_data_by_state <- data %>%
  filter(Category == "Health") %>%
  group_by(StateDesc) %>%
  summarize(avg_data_value = mean(Data_Value, na.rm = TRUE))

# Step 4: Connect R to a Database
con <- dbConnect(RSQLite::SQLite(), dbname = "large_data.db")
dbWriteTable(con, "cleaned_data", data, overwrite = TRUE)

# Querying a subset of data from the database
db_data <- tbl(con, "cleaned_data") %>%
  filter(Data_Value > 1000) %>%
  collect()

# Close the database connection after use
dbDisconnect(con)

# Step 5: Parallel Processing with furrr for large computations
plan(multisession, workers = detectCores() - 1)  # Use all available cores minus one
results <- future_map_dbl(data$Data_Value, ~ mean(.x, na.rm = TRUE))

# Step 6: Visualization of Big Data (Sampled for better performance)
sampled_data <- data %>% sample_frac(0.1)

# Scatter plot with ggplot2 (using sampled data)
ggplot(sampled_data, aes(x = TotalPopulation, y = Data_Value, color = Category)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Scatter Plot of Data Value vs. Total Population",
       x = "Total Population",
       y = "Data Value")

# Step 7: Efficient Data Storage with qs
qsave(data, "large_data.qs")
loaded_data <- qread("large_data.qs")

# Summary output of processing for validation
print(head(filtered_data))
print(summary_data)
print(avg_data_by_state)
print("Parallel computation results: ")
print(head(results))
