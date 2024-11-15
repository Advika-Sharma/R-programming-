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
  id = "main_tabs",  # Add an ID here for tab navigation
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
            style = "background: linear-gradient(to right, #333333, #444444); border-color: #00AFB9; border-radius: 10px; padding: 30px;",
            
            tags$div(
              style = "display: flex; justify-content: center; align-items: center; margin-bottom: 20px;",
              tags$img(
                src = "https://www.rishabhsoft.com/wp-content/uploads/2023/12/Banner-Image-Data-Analytics-in-Healthcare.jpg", 
                alt = "Health Data Image",
                style = "width: 60%; height: auto; border-radius: 10px; transition: transform 0.3s ease;",
                onmouseover = "this.style.transform = 'scale(1.1)';", 
                onmouseout = "this.style.transform = 'scale(1)';"
              )
            ),
            
            h3("Introduction", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
            p(
              "Welcome to the Health Data Prediction App, your interactive platform to explore and analyze health metrics across the United States. This application provides users with insights into various health-related statistics, such as state-wise health outcomes, disease prevalence, and overall public health trends. With the power of data visualization and predictive analytics, this app allows you to make informed decisions based on the data at hand. Whether you're a healthcare professional, a policymaker, or just someone interested in learning more about public health, this platform is designed to cater to a variety of needs and offer detailed reports and visualizations.",
              style = "color: #FDFCDB; text-align: center; padding: 10px; font-size: 1.1em; line-height: 1.5;"
            ),
            p(
              "This app allows you to explore health data by filtering it based on different categories like state, health measures, and data value. You can also dive deeper into advanced analysis features, where more sophisticated charts and 3D visualizations await you. The ability to access real-time data and understand the implications of health indicators at both state and national levels makes this app an invaluable tool for anyone interested in public health research or policy development. The integration of both descriptive and predictive analytics helps you to draw meaningful conclusions from the data, which can influence the way health interventions are planned and executed across the country.",
              style = "color: #FDFCDB; text-align: center; padding: 10px; font-size: 1.1em; line-height: 1.5;"
            ),
            p(
              "Start exploring with interactive charts, visualizations, and tables that bring health data to life. Our goal is to make complex data sets accessible and understandable for everyone, whether you're just getting started with health data analysis or you're an expert in the field. Enjoy navigating through the platform and make data-driven decisions that can potentially impact healthcare policies and initiatives.",
              style = "color: #FDFCDB; text-align: center; padding: 10px; font-size: 1.1em; line-height: 1.5;"
            )
          )
        )
      ),
      
      # Align the buttons in a horizontal line
      fluidRow(
        column(2,
               actionButton("explore_button", "Start Exploring", class = "btn btn-success", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #00AFB9; border: none; color: white; transition: background-color 0.3s ease;")
        ),
        column(2,
               actionButton("analysis_button", "Analysis", class = "btn btn-warning", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #FFB800; border: none; color: white; transition: background-color 0.3s ease;")
        ),
        column(2,
               actionButton("summary_button", "Summary", class = "btn btn-info", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #5bc0de; border: none; color: white;")
        ),
        column(2,
               actionButton("visualization_button", "3D Visualization", class = "btn btn-danger", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #d9534f; border: none; color: white;")
        ),
        column(2,
               actionButton("about_button", "About Us", class = "btn btn-secondary", style = "font-size: 1.2em; padding: 10px 20px; border-radius: 10px; background-color: #6c757d; border: none; color: white;")
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
  
  # About Page
  tabPanel(
    "About",
    fluidPage(
      titlePanel(tags$h1("About the Health Data Prediction App", style = "text-align: center; color: #FDFCDB;")),
      fluidRow(
        column(
          12,
          wellPanel(
            style = "background: linear-gradient(to right, #333333, #444444); border-color: #00AFB9; border-radius: 10px; padding: 30px;",
            h4("Introduction", style = "color: #FDFCDB; font-weight: bold;"),
            p("The Health Data Prediction App provides insights into healthcare metrics across the United States. This app empowers users to analyze health-related data from different perspectives, allowing for better decision-making in healthcare."),
            h4("Features", style = "color: #FDFCDB; font-weight: bold;"),
            tags$ul(
              tags$li("Access a variety of health data from multiple states"),
              tags$li("Filter data based on different categories and metrics"),
              tags$li("Visualize data in both 2D and 3D formats"),
              tags$li("Get quick insights using dynamic graphs and tables")
            ),
            h4("Developers", style = "color: #FDFCDB; font-weight: bold;"),
            p("This app is developed by Advika Sharma and Deepak Kumawat.", style = "color: #FDFCDB;")
          )
        )
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  # Filter data based on selected state and category
  observeEvent(input$show_data, {
    output$table <- renderTable({
      subset(data, StateDesc == input$state & Category == input$category)
    })
  })
  
  # Render dynamic plot
  observeEvent(input$plot_graph, {
    output$dynamic_plot <- renderPlot({
      plot(data[[input$x_var]], data[[input$y_var]], main = "Dynamic Plot")
    })
  })
  
  # Render 3D plot using plotly
  observeEvent(input$plot_3D_graph, {
    output$plot3D <- renderPlotly({
      plot_ly(data, x = ~get(input$x_var3D), y = ~get(input$y_var3D), z = ~get(input$z_var3D), type = "scatter3d", mode = "markers")
    })
  })
  
  # Show summary
  observeEvent(input$show_summary, {
    output$summary <- renderPrint({
      summary(data)
    })
  })
  
  # Button actions to navigate between tabs
  observeEvent(input$explore_button, {
    updateTabsetPanel(session, "main_tabs", selected = "Filtered Data")
  })
  
  observeEvent(input$analysis_button, {
    updateTabsetPanel(session, "main_tabs", selected = "Data Summary")
  })
  
  observeEvent(input$summary_button, {
    updateTabsetPanel(session, "main_tabs", selected = "Advanced Analysis")
  })
  
  observeEvent(input$visualization_button, {
    updateTabsetPanel(session, "main_tabs", selected = "3D Visualization")
  })
  
  observeEvent(input$about_button, {
    updateTabsetPanel(session, "main_tabs", selected = "About")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
