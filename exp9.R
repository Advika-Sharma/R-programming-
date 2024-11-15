# Install shinyjs if not already installed
if (!requireNamespace("shinyjs", quietly = TRUE)) {
  install.packages("shinyjs")
}

library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- navbarPage(
  "Health Data Application",
  
  # Custom CSS for dark theme
  theme = shinytheme("darkly"),
  
  # Page 1: Welcome Page
  tabPanel(
    "Welcome",
    fluidPage(
      useShinyjs(),  # Use shinyjs to show the popup
      titlePanel(tags$h1("Welcome to the Health Data Prediction App", style = "text-align: center; color: #FDFCDB;")),
      fluidRow(
        column(
          12, 
          img(src = "https://www.rishabhsoft.com/wp-content/uploads/2023/12/Banner-Image-Data-Analytics-in-Healthcare.jpg",
              alt = "Healthcare Data Banner", style = "display: block; margin-left: auto; margin-right: auto; width: 80%;"),
          wellPanel(
            style = "background-color: #333333; border-color: #00AFB9;",
            h3("Introduction", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
            p("Welcome to our next-generation Health Data Prediction App! This platform is designed to provide healthcare professionals, researchers, and policymakers with tools to analyze, visualize, and make data-driven decisions based on comprehensive U.S. state-level health data.",
              style = "color: #FDFCDB; text-align: justify; padding: 10px;"),
            p("With an emphasis on actionable insights, this application allows users to filter, summarize, and visualize health metrics with ease. Whether you're tackling public health challenges, forecasting trends, or exploring patterns, our app offers robust tools to support your goals.",
              style = "color: #FDFCDB; text-align: justify; padding: 10px;"),
            h4("What You Can Expect", style = "color: #FDFCDB; text-align: center;"),
            tags$ul(
              style = "color: #FDFCDB; padding-left: 20px;",
              tags$li("Interactive filtering of health data by state and category."),
              tags$li("Dynamic visualizations to uncover trends and correlations."),
              tags$li("Advanced analysis capabilities tailored for in-depth insights."),
              tags$li("3D visualizations to explore complex relationships in data.")
            ),
            h4("Quick Navigation", style = "color: #FDFCDB; text-align: center;"),
            actionButton("btn_filtered_data", "Go to Filtered Data", class = "btn btn-primary"),
            actionButton("btn_data_summary", "Go to Data Summary", class = "btn btn-primary"),
            actionButton("btn_advanced_analysis", "Go to Advanced Analysis", class = "btn btn-primary"),
            actionButton("btn_about", "Go to About", class = "btn btn-primary"),
            actionButton("btn_3d_visual", "Go to 3D Visualization", class = "btn btn-primary")
          )
        )
      )
    ),
    # JavaScript to handle button clicks and navigate to the corresponding tab
    tags$script(HTML('
      $("#btn_filtered_data").on("click", function() {
        $("a:contains(Filtered Data)").tab("show");
      });
      $("#btn_data_summary").on("click", function() {
        $("a:contains(Data Summary)").tab("show");
      });
      $("#btn_advanced_analysis").on("click", function() {
        $("a:contains(Advanced Analysis)").tab("show");
      });
      $("#btn_about").on("click", function() {
        $("a:contains(About)").tab("show");
      });
      $("#btn_3d_visual").on("click", function() {
        $("a:contains(3D Visualization)").tab("show");
      });
    '))
  ),
  
  # Page 2: Filtered Data Table
  tabPanel(
    "Filtered Data",
    fluidPage(
      titlePanel(tags$h1("Filter Health Data by State and Category", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("Select Filters", style = "color: #FDFCDB; font-weight: bold;"),
          tags$label(class = "select-label", "Select State:"),
          selectInput("state", NULL, choices = unique(data$StateDesc), selectize = TRUE, width = "100%"),
          tags$label(class = "select-label", "Select Category:"),
          selectInput("category", NULL, choices = unique(data$Category), selectize = TRUE, width = "100%"),
          actionButton("show_data", "Show Data", class = "btn btn-primary"),
          p("Use this page to narrow down data by selecting a state and health category. Click 'Show Data' to reveal results tailored to your choices, providing a targeted view of health statistics for that area.", style = "color: #FDFCDB; padding-top: 10px;")
        ),
        mainPanel(
          h3("Filtered Data Table", style = "color: #FDFCDB; font-weight: bold;"),
          tableOutput("table")
        )
      )
    )
  ),
  
  # Page 3: Data Summary and Visualization
  tabPanel(
    "Data Summary",
    fluidPage(
      titlePanel(tags$h1("Summary of Health Data", style = "text-align: center; color: #FDFCDB;")),
      sidebarLayout(
        sidebarPanel(
          h4("Graph Options", style = "color: #FDFCDB; font-weight: bold;"),
          tags$label(class = "select-label", "Select X-Axis:"),
          selectInput("x_var", "X-axis Variable", choices = c("StateDesc", "Category", "Measure")),
          tags$label(class = "select-label", "Select Y-Axis:"),
          selectInput("y_var", "Y-axis Variable", choices = c("Data_Value", "TotalPopulation")),
          actionButton("plot_graph", "Plot Graph", class = "btn btn-primary")
        ),
        mainPanel(
          h3("Graph Output", style = "color: #FDFCDB; font-weight: bold;"),
          plotOutput("dynamic_plot")
        )
      )
    )
  ),
  
  # Page 4: Advanced Analysis
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
  
  # Page 5: 3D Visualization
  tabPanel(
    "3D Visualization",
    fluidPage(
      titlePanel(tags$h1("3D Visualization of Health Data", style = "text-align: center; color: #FDFCDB;")),
      plotlyOutput("plotly_3d")
    )
  ),
  
  # Page 6: About the Dataset
  tabPanel(
    "About",
    fluidPage(
      titlePanel(tags$h1("About the Dataset", style = "text-align: center; color: #FDFCDB;")),
      wellPanel(
        style = "background-color: #333333; border-color: #00AFB9;",
        h3("Dataset Information", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
        p("This dataset contains a wide range of health metrics collected across all U.S. states. The data has been meticulously cleaned and preprocessed to ensure accuracy and relevance. Metrics include public health indicators, population statistics, and healthcare access data.",
          style = "color: #FDFCDB; padding: 10px; text-align: justify;"),
        p("These insights are crucial for understanding disparities, evaluating health programs, and formulating effective policies to address public health challenges.",
          style = "color: #FDFCDB; padding: 10px; text-align: justify;"),
        h3("Who We Serve", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
        p("Our platform is tailored for a diverse audience including:",
          style = "color: #FDFCDB; padding: 10px; text-align: justify;"),
        tags$ul(
          style = "color: #FDFCDB; padding-left: 20px;",
          tags$li("Healthcare professionals seeking data-driven patient care strategies."),
          tags$li("Policy makers and public health officials aiming to develop impactful interventions."),
          tags$li("Researchers exploring patterns and trends in healthcare outcomes."),
          tags$li("Data scientists creating predictive models for public health initiatives.")
        ),
        h3("Vision and Mission", style = "color: #FDFCDB; font-weight: bold; text-align: center;"),
        p("Our mission is to empower stakeholders with meaningful insights and tools, enabling data-driven decisions for better public health outcomes.",
          style = "color: #FDFCDB; padding: 10px; text-align: justify;")
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  
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
  
  # Page 5: 3D visualization
  output$plotly_3d <- renderPlotly({
    plot_ly(data, x = ~StateDesc, y = ~Data_Value, z = ~TotalPopulation,
            type = "scatter3d", mode = "markers", color = ~Category)
  })
  
  # Show a welcome popup when the app runs
  shinyjs::runjs('alert("Welcome to Health Data Analysis!")')
}

# Run the app
shinyApp(ui = ui, server = server)
