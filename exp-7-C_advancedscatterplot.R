options(repos = c(CRAN = "https://cloud.r-project.org"))
# Load data
data <- read.csv("D:\\R\\cleaned_data.csv")

# Install necessary package
#install.packages("plotly")

# Load the library
library(plotly)

# Create the plot
p <- plot_ly(data, 
             x = ~StateDesc, 
             y = ~Data_Value, 
             type = 'scatter', 
             mode = 'markers',
             color = ~Category,
             text = ~paste("Measure: ", Measure, "<br>Total Population: ", TotalPopulation)) %>%
  layout(title = "Interactive Visualization of Health Data by State",
         xaxis = list(title = "State"),
         yaxis = list(title = "Data Value"))

# Save the plot as an HTML file
htmlwidgets::saveWidget(p, "D:/R/health_data_plot.html")