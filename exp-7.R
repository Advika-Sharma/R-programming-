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

# Install necessary package
#install.packages("plotly")

# Load the library
library(plotly)

# Interactive scatter plot
plot_ly(data, 
        x = ~StateDesc, 
        y = ~Data_Value, 
        type = 'scatter', 
        mode = 'markers',
        color = ~Category,
        text = ~paste("Measure: ", Measure, "<br>Total Population: ", TotalPopulation)) %>%
  layout(title = "Interactive Visualization of Health Data by State",
         xaxis = list(title = "State"),
         yaxis = list(title = "Data Value"))



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
