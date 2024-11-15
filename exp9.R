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
      # Page Title with Centered Heading
      titlePanel(tags$h1("Welcome to the Health Data Prediction App", style = "text-align: center; color: #FDFCDB;")),
      
      fluidRow(
        # First Column with Image and Description
        column(
          12, 
          wellPanel(
            style = "background: linear-gradient(to right, #333333, #444444); border-color: #00AFB9; border-radius: 10px; padding: 30px;",
            
            # Image Section with Hover Effect
            tags$div(
              style = "display: flex; justify-content: center; align-items: center; margin-bottom: 20px;",
              tags$img(
                src = "https://www.rishabhsoft.com/wp-content/uploads/2023/12/Banner-Image-Data-Analytics-in-Healthcare.jpg", # Add your image path here
                alt = "Health Data Image",
                style = "width: 60%; height: auto; border-radius: 10px; transition: transform 0.3s ease;",
                onmouseover = "this.style.transform = 'scale(1.1)';", 
                onmouseout = "this.style.transform = 'scale(1)';"
              )
            ),
            
            # Text Section with Introduction
            h3("Introduction", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
            p(
              "Welcome to the Health Data Prediction App, your interactive platform to explore and analyze health metrics across the United States. This application is designed to empower you with tools to delve into vital public health data, enabling you to make informed decisions and discover trends that impact our communities. Whether you're a healthcare professional, a researcher, or someone simply interested in understanding the state of public health, this app provides a user-friendly experience to explore key health indicators and analyze how they vary across states.",
              style = "color: #FDFCDB; text-align: center; padding: 10px; font-size: 1.1em; line-height: 1.5;"
            ),
            p(
              "Start exploring with interactive charts, visualizations, and tables that bring health data to life. From analyzing data trends to uncovering insights on specific health issues, this app has something for everyone committed to enhancing public health awareness.",
              style = "color: #FDFCDB; text-align: center; padding: 10px; font-size: 1.1em; line-height: 1.5;"
            )
          )
        )
      ),
      
      # Add a Call to Action Section with Button and Hover Effects
      fluidRow(
        column(12, 
               tags$div(
                 style = "display: flex; justify-content: center; margin-top: 30px;",
                 actionButton("explore_button", "Start Exploring", class = "btn btn-success", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #00AFB9; border: none; color: white; transition: background-color 0.3s ease;"),
                 tags$script(HTML("
            $('#explore_button').hover(function() {
              $(this).css('background-color', '#008C7A');
            }, function() {
              $(this).css('background-color', '#00AFB9');
            });
          "))
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
        p("Our health dataset compiles a comprehensive set of metrics related to public health across various states in the U.S. The dataset includes valuable information on health behaviors, chronic conditions, and population statistics, gathered from various credible sources. By analyzing this dataset, you can uncover patterns and insights that reveal how different health factors are distributed across states, helping to identify at-risk populations and areas requiring more health interventions.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;"),
        p("The dataset contains detailed measurements for health conditions such as obesity rates, smoking prevalence, diabetes rates, and more. Each data point is categorized under specific health themes, offering a granular view of the public health landscape. With this data, we hope to spark conversations around improving healthcare policy, promoting healthier lifestyles, and addressing health disparities across regions.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;"),
        p("By engaging with this dataset, you can better understand how various health indicators vary from state to state, explore how health factors are interlinked, and ultimately help make informed decisions that improve public health outcomes.",
          style = "color: #FDFCDB; text-align: center; padding: 10px;")
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  
  observeEvent(input$explore_button, {
    updateTabsetPanel(session, "tabs", selected = "Filtered Data")
  })
  
  filtered_data <- reactive({
    req(input$state, input$category)
    subset(data, StateDesc == input$state & Category == input$category)
  })
  
  output$table <- renderTable({
    req(input$show_data)
    filtered_data()
  })
  
  output$dynamic_plot <- renderPlot({
    req(input$plot_graph)
    ggplot(filtered_data(), aes_string(x = input$x_var, y = input$y_var)) + 
      geom_bar(stat = "identity", fill = "#00AFB9") +
      theme_minimal() +
      labs(title = "Health Data Visualization", x = input$x_var, y = input$y_var)
  })
  
  output$summary <- renderPrint({
    req(input$show_summary)
    summary(data)
  })
  
  output$plot3D <- renderPlotly({
    req(input$plot_3D_graph)
    plot_ly(
      data = filtered_data(),
      x = ~get(input$x_var3D),
      y = ~get(input$y_var3D),
      z = ~get(input$z_var3D),
      type = "scatter3d",
      mode = "markers"
    )
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
