#install.packages("shiny")
library(shiny)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Health Data by State"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Data Overview"),
      selectInput("state", "Select State:", choices = unique(data$StateDesc)),
      selectInput("category", "Select Category:", choices = unique(data$Category)),
      actionButton("show_data", "Show Data")
    ),
    
    mainPanel(
      tableOutput("table"),
      plotOutput("plot")
    )
  )
)

# Define Server Logic
server <- function(input, output) {
  
  # Filter data based on state and category
  filtered_data <- reactive({
    data[data$StateDesc == input$state & data$Category == input$category, ]
  })
  
  # Display the filtered table
  output$table <- renderTable({
    input$show_data
    isolate(filtered_data())
  })
  
  # Create a plot based on the selected data
  output$plot <- renderPlot({
    input$show_data
    isolate({
      plot_data <- filtered_data()
      barplot(plot_data$Data_Value, names.arg = plot_data$Measure, 
              col = "lightblue", main = "Data Value by Measure", ylab = "Data Value")
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)
