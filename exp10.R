library(shiny)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- navbarPage(
  "Health Data Application",
  
  # Page 1: Filtered Data Table
  tabPanel(
    "Filtered Data",
    fluidPage(
      # Add custom colors and style using the updated palette
      tags$head(
        tags$style(HTML("
          body {
            background-color: #124559; /* Dark theme background */
            color: #FDFCDB; /* Light cream text */
          }
          .well {
            background-color: #FED9B7; /* Peach background */
            border-color: #00AFB9; /* Light teal borders */
            max-width: 600px;
            margin: auto;
          }
          .btn-primary {
            background-color: #F07167;
            border-color: #F07167;
            color: #FDFCDB;
          }
          .btn-primary:hover {
            background-color: #00AFB9;
            color: #FDFCDB;
          }
          .selectize-input {
            background-color: #800000; /* Maroon input */
            color: #000000; /* Black input text */
            border-color: #00AFB9;
          }
          .selectize-dropdown-content .option:hover {
            background-color: #00AFB9; /* Light teal hover */
            color: #000000; /* Black hover text */
          }
          h1 {
            color: #000000;
            font-weight: bold;
          }
          h3, h4 {
            color: #FDFCDB;
          }
          p {
            color: #000000;
          }
          .select-label {
            color: #001D4A;
            font-weight: bold;
          }
        "))
      ),
      
      titlePanel(tags$h1("Health Data by State", style = "text-align: center;")),
      
      sidebarLayout(
        sidebarPanel(
          h3("Data Overview", style = "color: #000000; font-weight: bold;"),
          
          tags$label(class = "select-label", "Select State:"),
          selectInput("state", NULL, choices = unique(data$StateDesc), 
                      selectize = TRUE, width = "100%"),
          
          tags$label(class = "select-label", "Select Category:"),
          selectInput("category", NULL, choices = unique(data$Category), 
                      selectize = TRUE, width = "100%"),
          
          actionButton("show_data", "Show Data", class = "btn btn-primary"),
          tags$hr(),
          
          h4("Instructions:", style = "color: #000000;"),
          tags$p("1. Select a state and category to view the corresponding data.", style = "color: #000000;"),
          tags$p("2. Click 'Show Data' to display the filtered results.", style = "color: #000000;")
        ),
        
        mainPanel(
          h3("Filtered Data Table", style = "color: #FDFCDB; font-weight: bold;"),
          tableOutput("table")
        )
      )
    )
  ),
  
  # Page 2: Data Summary with User-Selected Graph
  tabPanel(
    "Data Summary",
    fluidPage(
      titlePanel(tags$h1("Summary of Health Data by State", style = "text-align: center; color: #FDFCDB;")),
      
      sidebarLayout(
        sidebarPanel(
          h4("Dataset Overview", style = "color: #FDFCDB; font-weight: bold;"),
          tags$p("This page provides an overview or summary of the health dataset.", style = "color: #FDFCDB;"),
          
          h4("Graph Options", style = "color: #FDFCDB; font-weight: bold;"),
          
          tags$label(class = "select-label", "Select X-Axis:"),
          selectInput("x_var", "X-axis Variable", choices = c("StateDesc", "Category", "Measure")),
          
          tags$label(class = "select-label", "Select Y-Axis:"),
          selectInput("y_var", "Y-axis Variable", choices = c("Data_Value", "TotalPopulation")),
          
          actionButton("plot_graph", "Plot Graph", class = "btn btn-primary")
        ),
        
        mainPanel(
          h3("Graph Output", style = "color: #FDFCDB; font-weight: bold;"),
          plotOutput("dynamic_plot"),
          
          h3("Summary Output", style = "color: #FDFCDB; font-weight: bold;"),
          verbatimTextOutput("summary")
        )
      )
    )
  )
)

# Define Server Logic
server <- function(input, output) {
  
  # Page 1: Reactive expression to filter data based on state and category
  filtered_data <- reactive({
    req(input$show_data)  # Ensure the button is clicked
    isolate(data[data$StateDesc == input$state & data$Category == input$category, ])
  })
  
  # Display the filtered table on Page 1
  output$table <- renderTable({
    req(filtered_data())
    isolate(filtered_data())
  })
  
  # Page 2: Show dataset summary
  observeEvent(input$plot_graph, {
    output$dynamic_plot <- renderPlot({
      # Use the user-selected X and Y variables to create a bar plot
      x <- data[[input$x_var]]
      y <- data[[input$y_var]]
      
      barplot(height = tapply(y, x, mean), 
              col = "#008080",  # Changed color to teal for better contrast
              border = "white",  # Adding a white border for clarity
              main = paste("Bar Plot of", input$y_var, "by", input$x_var),
              xlab = input$x_var, 
              ylab = input$y_var,
              las = 2)  # Rotate the x-axis labels for better readability
    })
    
    # Display the summary of the dataset
    output$summary <- renderPrint({
      summary(data)
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)
