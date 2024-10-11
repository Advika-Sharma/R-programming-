library(shiny)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- navbarPage(
  # Application title centered using flexbox CSS
  title = tags$div(
    tags$h1("Health Data by State", 
            style = "color: white; font-weight: bold; margin: 10px; padding:0;"), 
    style = "display: flex; justify-content: center; align-items: center; width: 100%; height: 100%;"
  ),
  
  # Add custom colors and style using the updated palette
  tags$head(
    tags$style(HTML("
      body {
        background-color: #003049;
        color: #FDFCDB;
        margin: 0;
        padding: 0;
      }
      .navbar-default {
        background-color: #03071e;
        border: none;
      }
      .navbar-default .navbar-brand {
        color: white;
        margin: 0;
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 100%;
      }
      .navbar-default .navbar-nav > li > a {
        color: white;
      }
      .navbar-default .navbar-nav > li > a:hover {
        background-color: #F07167;
        color: white;
      }
      .navbar-header {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        padding: 1em;
        margin: 0;
      }
      .navbar-brand {
        margin: 0 auto;
        text-align: center;
        padding-top: 10px;
        padding-bottom: 10px;
      }
      .well {
        background-color: #FED9B7;
        border-color: #00AFB9;
      }
      .btn-primary {
        background-color: #ba181b;
        border-color: #F07167;
        color: #FDFCDB;
        padding: 4px 8px;
        font-size: 20px;
      }
      .btn-primary:hover {
        background-color: #00AFB9;
        color: #FDFCDB;
      }
      .selectize-input, .selectize-control.single .selectize-input {
        background-color: #0d3b66;
        color: #FDFCDB;
        border-color: #00AFB9;
        padding: 2px 6px;
      }
      .selectize-dropdown-content .option {
        background-color: #fae1dd;
        color: #0081A7;
        padding: 8px 10px;
      }
      .selectize-dropdown-content .option:hover {
        background-color: #62b6cb;
        color: #FDFCDB;
      }
      .selectize-input::placeholder {
        color: #FDFCDB;
      }
      table {
        background-color: #FED9B7;
        color: #000000;
        margin: 4px;
        max-width: 100%;
      }
      h1, h3, h4 {
        color: #FDFCDB;
        margin-bottom: 0.5em;
      }
      p {
        color: #000000;
        margin: 0.5em 0;
      }
      .select-label {
        color: #001D4A;
        font-weight: bold;
        margin-bottom: 0.5em;
      }
      .full-page-layout {
        display: flex;
        flex-direction: row;
        width: 100%;
        height: 100vh;
        font-size: 20px;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      .sidebar {
        width: 30%;
        background-color: #d3d3d3;
        padding: 5%;
        box-sizing: border-box;
        margin: 30px 10px 30px 30px;
      }
      .table-container {
        width: 70%;
        justify-content: center;
        background-color: #e76f51;
        padding: 1em;
        box-sizing: border-box;
        margin: 30px 30px 30px 10px;
        overflow-x: auto;
      }
      .table-container table {
        width: 100%;
        background-color: #fed9b7;
      }
      .footer {
        background-color: #03071e;
        color: white;
        text-align: center;
        padding: 10px 0; /* Remove side padding */
        position: fixed;
        bottom: 0;
        width: 100%;
        font-size: 16px;
        border-top: 2px solid #F07167;
        margin: 0; /* Remove any margin */
        box-sizing: border-box; /* Ensure padding does not affect the total width */
}

      .footer a {
        color: #00AFB9;
        text-decoration: none;
      }
    "))
  ),
  
  # Full-page layout with sidebar on the left and table on the right
  div(
    class = "full-page-layout",
    
    # Sidebar Panel
    div(
      class = "sidebar",
      h3("Data Overview", style = "color: #000000; font-weight: bold;"),
      
      tags$label(class = "select-label", "Select State:"),
      selectInput("state", NULL, choices = unique(data$StateDesc), 
                  selectize = TRUE, width = "100%"),
      
      tags$label(class = "select-label", "Select Category:"),
      selectInput("category", NULL, choices = unique(data$Category), 
                  selectize = TRUE, width = "100%"),
      
      actionButton("show_data", "Show Data", class = "btn btn-primary"),
      tags$hr(),
      
      h4("Instructions:", style = "color: #000000; font-weight: bold;"),
      tags$p("1. Select a state and category to view the corresponding data.", style = "color: #000000;"),
      tags$p("2. Click 'Show Data' to display the filtered results.", style = "color: #000000;")
    ),
    
    # Table Container for displaying filtered data
    div(
      class = "table-container",
      h4("Filtered Data Table", style = "text-align: center; color: #000000; font-weight: bold;"),
      tableOutput("table")
    )
  ),
  
  # Footer
  div(
    class = "footer",
    "© 2024 Health Data Visualizer | Created by Advika Sharma & Deepak Kumawat"
  )
)

# Define Server Logic
server <- function(input, output) {
  
  # Reactive expression to filter data based on state and category
  filtered_data <- reactive({
    req(input$show_data)
    isolate(data[data$StateDesc == input$state & data$Category == input$category, ])
  })
  
  # Display the filtered table
  output$table <- renderTable({
    req(filtered_data())
    isolate(filtered_data())
  }, options = list(scrollX = TRUE))
  
}

# Run the app
shinyApp(ui = ui, server = server)