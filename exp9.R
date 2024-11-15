# Install required packages if not already installed
if (!requireNamespace("shinythemes", quietly = TRUE)) {
  install.packages("shinythemes")
}
if (!requireNamespace("plotly", quietly = TRUE)) {
  install.packages("plotly")
}

library(shiny)
library(shinythemes)
library(plotly)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- navbarPage(
  "Health Data Application",
  
  theme = shinytheme("darkly"),
  
  tags$head(
    tags$script(HTML("
      $(document).ready(function() {
        alert('Welcome to the Health Data Prediction App!');
      });
      
      $(document).on('shown.bs.tab', 'a[data-toggle=\"tab\"]', function (e) {
        var tabText = $(e.target).text();
        document.title = tabText + ' | Health Data Application';
      });
    "))
  ),
  
  # Welcome Page
  tabPanel(
    "Welcome",
    fluidPage(
      titlePanel(tags$h1("Welcome to the Health Data Prediction App", style = "text-align: center; color: #FDFCDB;")),
      fluidRow(
        column(
          12, 
          wellPanel(
            style = "background-color: #333333; border-color: #00AFB9;",
            h3("Introduction", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
            p("Welcome to the Health Data Prediction App, your interactive platform to explore and analyze health metrics across the United States. This application is designed to empower you with tools to delve into vital public health data, enabling you to make informed decisions and discover trends that impact our communities. Whether you're a healthcare professional, a researcher, or someone simply interested in understanding the state of public health, this app provides a user-friendly experience to explore key health indicators and analyze how they vary across states.",
              style = "color: #FDFCDB; text-align: center; padding: 10px;")
          )
        )
      )
    )
  ),
  
  # Filtered Data Table
  tabPanel(
    "Filtered Data",
    fluidPage(
      titlePanel(tags$h1("Filter Health Data by State and Category", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("Select Filters", style = "color: #FDFCDB; font-weight: bold;"),
          selectInput("state", "Select State:", choices = unique(data$StateDesc), selectize = TRUE),
          selectInput("category", "Select Category:", choices = unique(data$Category), selectize = TRUE),
          actionButton("show_data", "Show Data", class = "btn btn-primary")
        ),
        mainPanel(
          h3("Filtered Data Table", style = "color: #FDFCDB; font-weight: bold;"),
          tableOutput("table")
        )
      )
    )
  ),
  
  # Data Summary and Visualization
  tabPanel(
    "Data Summary",
    fluidPage(
      titlePanel(tags$h1("Summary of Health Data", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("Graph Options", style = "color: #FDFCDB; font-weight: bold;"),
          selectInput("x_var", "X-axis Variable:", choices = c("StateDesc", "Category", "Measure")),
          selectInput("y_var", "Y-axis Variable:", choices = c("Data_Value", "TotalPopulation")),
          actionButton("plot_graph", "Plot Graph", class = "btn btn-primary")
        ),
        mainPanel(
          h3("Graph Output", style = "color: #FDFCDB; font-weight: bold;"),
          plotOutput("dynamic_plot")
        )
      )
    )
  ),
  
  # Advanced Analysis
  tabPanel(
    "Advanced Analysis",
    fluidPage(
      titlePanel(tags$h1("Advanced Data Analysis", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("Summary Options", style = "color: #FDFCDB; font-weight: bold;"),
          actionButton("show_summary", "Show Summary", class = "btn btn-primary")
        ),
        mainPanel(
          h3("Summary Output", style = "color: #FDFCDB; font-weight: bold;"),
          verbatimTextOutput("summary")
        )
      )
    )
  ),
  
  # 3D Visualization
  tabPanel(
    "3D Visualization",
    fluidPage(
      titlePanel(tags$h1("3D Visualization of Health Data", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("3D Graph Options", style = "color: #FDFCDB; font-weight: bold;"),
          selectInput("x_var3D", "X-axis Variable:", choices = c("StateDesc", "Category", "Measure")),
          selectInput("y_var3D", "Y-axis Variable:", choices = c("Data_Value", "TotalPopulation")),
          selectInput("z_var3D", "Z-axis Variable:", choices = c("Data_Value", "TotalPopulation")),
          actionButton("plot_3D_graph", "Plot 3D Graph", class = "btn btn-primary")
        ),
        mainPanel(
          h3("3D Graph Output", style = "color: #FDFCDB; font-weight: bold;"),
          plotlyOutput("plot3D")
        )
      )
    )
  ),
  
  # About the Dataset
  tabPanel(
    "About",
    fluidPage(
      titlePanel(tags$h1("About the Dataset", style = "text-align: center; color: #FDFCDB;")),
      wellPanel(
        style = "background-color: #333333; border-color: #00AFB9;",
        h3("Dataset Information", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
        p("Our health dataset compiles a comprehensive set of metrics related to public health across various states in the U.S. The dataset includes valuable information on health behaviors, chronic conditions, and population statistics, gathered from various credible sources. By analyzing this dataset, you can uncover patterns and insights that reveal how different health factors are distributed across states, helping to identify at-risk populations and areas requiring more health interventions.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;"),
        p("The dataset contains detailed measurements for health conditions such as obesity rates, smoking prevalence, diabetes rates, and more. Each data point is categorized under specific health themes, offering a granular view of the public health landscape. With this data, we hope to spark conversations around improving healthcare policy, promoting healthier lifestyles, and addressing health disparities across regions.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;"),
        p("By engaging with this dataset, you can better understand how various health indicators vary from state to state, explore how health factors are interlinked, and ultimately help make informed decisions that improve public health outcomes.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;"))
    )
  )
)

# Define Server Logic
server <- function(input, output) {
  
  # Page 2: Filtered data based on state and category
  filtered_data <- reactive({
    req(input$show_data)
    isolate(data[data$StateDesc == input$state & data$Category == input$category, ])
  })
  
  output$table <- renderTable({
    req(filtered_data())
    filtered_data()
  })
  
  # Page 3: Generate plot
  observeEvent(input$plot_graph, {
    output$dynamic_plot <- renderPlot({
      x <- data[[input$x_var]]
      y <- data[[input$y_var]]
      barplot(height = tapply(y, x, mean), col = "#008080", border = "white",
              main = paste("Bar Plot of", input$y_var, "by", input$x_var),
              xlab = input$x_var, ylab = input$y_var, las = 2)
    })
  })
  
  # Page 4: Show dataset summary
  observeEvent(input$show_summary, {
    output$summary <- renderPrint({
      summary(data)
    })
  })
  
  # Page 5: Render 3D plot with plotly
  observeEvent(input$plot_3D_graph, {
    output$plot3D <- renderPlotly({
      plot_ly(
        data = data,
        x = ~data[[input$x_var3D]],
        y = ~data[[input$y_var3D]],
        z = ~data[[input$z_var3D]],
        type = "scatter3d",
        mode = "markers",
        marker = list(size = 3, color = "lightblue")
      )
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)

