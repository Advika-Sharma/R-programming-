# Load required library
library(plotly)

# Load your dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Select three columns (modify based on your dataset)
x <- data$Data_Value        # X-axis variable
y <- data$TotalPopulation    # Y-axis variable
z <- data$Measure            # Z-axis variable

# Create a 3D scatter plot with enhanced styling and vibrant colors
plot_ly(
  x = ~x,
  y = ~y,
  z = ~z,
  type = "scatter3d",
  mode = "markers",
  marker = list(
    size = 8,                               # Marker size
    color = ~z,                             # Color mapped to Z-axis values
    colorscale = list(c(0, "rgb(102,194,165)"), c(0.5, "rgb(252,141,98)"), c(1, "rgb(141,160,203)")), # Custom color scale: green to orange to blue
    opacity = 0.8,                          # Slight transparency for depth
    showscale = TRUE,                       # Display color scale legend
    colorbar = list(
      title = "Measure",
      titleside = "right"
    )
  )
) %>%
  layout(
    title = list(
      text = "<b>3D Scatter Plot of Health Data</b>",
      font = list(size = 20, color = "darkblue")
    ),
    scene = list(
      xaxis = list(
        title = list(text = "<b>Data Value</b>", font = list(size = 15, color = "black")),
        backgroundcolor = "rgb(240, 249, 232)",  # Light green background
        gridcolor = "rgb(200, 200, 200)",        # Light grid lines
        showbackground = TRUE
      ),
      yaxis = list(
        title = list(text = "<b>Total Population</b>", font = list(size = 15, color = "black")),
        backgroundcolor = "rgb(240, 249, 232)",
        gridcolor = "rgb(200, 200, 200)",
        showbackground = TRUE
      ),
      zaxis = list(
        title = list(text = "<b>Measure</b>", font = list(size = 15, color = "black")),
        backgroundcolor = "rgb(240, 249, 232)",
        gridcolor = "rgb(200, 200, 200)",
        showbackground = TRUE
      )
    ),
    margin = list(t = 50, b = 10)  # Adjust layout margins
  )
