library(shiny)

# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- fluidPage(
  
  # Add custom colors and style using the updated palette
  tags$head(
    tags$style(HTML("
      body {
        background-color: #0081A7; /* Deep teal background */
        color: #FDFCDB; /* Light cream text */
      }
      .well {
        background-color: #FED9B7; /* Peach background */
        border-color: #00AFB9; /* Light teal borders */
      }
      .btn-primary {
        background-color: #F07167; /* Coral pink button */
        border-color: #F07167;
        color: #FDFCDB; /* Light cream text on buttons */
      }
      .btn-primary:hover {
        background-color: #00AFB9; /* Light teal on hover */
        color: #FDFCDB; /* Light cream text */
      }
      .selectize-input, .selectize-control.single .selectize-input {
        background-color: #800000; /* Maroon input */
        color: #FDFCDB; /* Light cream text */
        border-color: #00AFB9; /* Light teal border */
      }
      .selectize-dropdown-content .option {
        background-color: #FED9B7; /* Dropdown background */
        color: #0081A7; /* Dropdown text */
      }
      .selectize-dropdown-content .option:hover {
        background-color: #800000; /* Maroon on hover */
        color: #FDFCDB; /* Light cream text on hover */
      }
      .selectize-input::placeholder {
        color: #FDFCDB; /* Placeholder text */
      }
      table {
        background-color: #FED9B7; /* Table background */
        color: #0081A7; /* Table text */
      }
      h1, h3, h4 {
        color: #FDFCDB; /* Light cream for headers */
      }
      p {
        color: #000000; /* Black for paragraph text */
      }
      .select-label {
        color: #001D4A; /* Dark navy blue for labels */
        font-weight: bold; /* Bold text for labels */
      }
    "))
  ),
  
  # Application title with the updated color scheme
  titlePanel(tags$h1("Health Data by State", style = "color: #FDFCDB; font-weight: bold; text-align: center;")),
  
  sidebarLayout(
    sidebarPanel(
      # Sidebar with the color scheme updates
      h3("Data Overview", style = "color: #000000; font-weight: bold;"), # Black text for Data Overview
      
      # Add a custom class to the labels for styling
      tags$label(class = "select-label", "Select State:"),
      selectInput("state", NULL, choices = unique(data$StateDesc), 
                  selectize = TRUE, width = "100%"),
      
      tags$label(class = "select-label", "Select Category:"),
      selectInput("category", NULL, choices = unique(data$Category), 
                  selectize = TRUE, width = "100%"),
      
      actionButton("show_data", "Show Data", class = "btn btn-primary"),
      tags$hr(),
      
      h4("Instructions:", style = "color: #000000;"), # Black text for Instructions
      tags$p("1. Select a state and category to view the corresponding data.", style = "color: #000000;"),
      tags$p("2. Click 'Show Data' to display the filtered results.", style = "color: #000000;"),
    ),
    
    mainPanel(
      # Displaying the table output with the updated palette
      h3("Filtered Data Table", style = "color: #FDFCDB; font-weight: bold;"),
      tableOutput("table")
    )
  )
)

# Define Server Logic
server <- function(input, output) {
  
  # Reactive expression to filter data based on state and category
  filtered_data <- reactive({
    req(input$show_data)  # Ensure the button is clicked
    isolate(data[data$StateDesc == input$state & data$Category == input$category, ])
  })
  
  # Display the filtered table
  output$table <- renderTable({
    req(filtered_data())
    isolate(filtered_data())
  })
}

# Run the app
shinyApp(ui = ui, server = server) 
