# Install required libraries
install.packages("ggplot2")
install.packages("dplyr")
install.packages("reshape2")

# Load libraries
library(ggplot2)
library(dplyr)
library(reshape2)

# Load data
data <- read.csv("D:\\R\\cleaned_data.csv")

# Create a heatmap of the Data_Value across states and years
data_heatmap <- data %>%
  filter(Category == "Health Outcomes") %>%
  select(StateDesc, Year, Data_Value) %>%
  group_by(StateDesc, Year) %>%
  summarise(mean_value = mean(Data_Value, na.rm = TRUE))

# Plot heatmap
ggplot(data_heatmap, aes(x = Year, y = StateDesc, fill = mean_value)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Health Outcome Values by State and Year",
       x = "Year",
       y = "State",
       fill = "Mean Value") +
  theme_minimal()