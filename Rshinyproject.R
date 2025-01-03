# Install required packages if not already installed
if (!requireNamespace("shinyjs", quietly = TRUE)) install.packages("shinyjs")
if (!requireNamespace("plotly", quietly = TRUE)) install.packages("plotly")
if (!requireNamespace("shinythemes", quietly = TRUE)) install.packages("shinythemes")
if (!requireNamespace("gargle", quietly = TRUE)) install.packages("gargle")
if (!requireNamespace("googleAuthR", quietly = TRUE)) install.packages("googleAuthR")
if (!requireNamespace("DBI", quietly = TRUE)) install.packages("DBI")
if (!requireNamespace("RSQLite", quietly = TRUE)) install.packages("RSQLite")
if (!requireNamespace("sodium", quietly = TRUE)) install.packages("sodium")

library(DBI)
library(RSQLite)
library(sodium)
library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)
library(gargle)
library(googleAuthR)

# Create or connect to SQLite database
db <- dbConnect(SQLite(), "users.db")

# Create a 'users' table if it doesn't exist
dbExecute(db, "
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
  )
")

# Example: Insert a test user (run this only once)
# Hash the password using the sodium package
test_password_hash <- sodium::password_store("password123")
dbExecute(db, "INSERT OR IGNORE INTO users (username, password_hash) VALUES ('admin', ?)", list(test_password_hash))

test_password_hash <- sodium::password_store("@123")
dbExecute(db, "INSERT OR IGNORE INTO users (username, password_hash) VALUES ('advika', ?)", list(test_password_hash))

test_password_hash <- sodium::password_store("Deepak@162509")
dbExecute(db, "INSERT OR IGNORE INTO users (username, password_hash) VALUES ('Deepak', ?)", list(test_password_hash))


# Close the connection
dbDisconnect(db)


# Replace with your Google API credentials
options(
  gargle_oauth_client = gargle::gargle_oauth_client(
    id = "YOUR_GOOGLE_CLIENT_ID",
    secret = "YOUR_GOOGLE_CLIENT_SECRET"
  )
)

options(gargle_oauth_email = TRUE)
options(gargle_oauth_cache = ".secrets")
unlink(".secrets", recursive = TRUE, force = TRUE)
print("Token cache cleared.")



# Load the dataset
data <- read.csv("D:\\R\\cleaned_data.csv")

# Define UI
ui <- navbarPage(
  id = "navbarPage",
  title = div(icon("heartbeat"), "Health Data Analytics"),
  theme = shinytheme("slate"),
  
  # Login Page
  tabPanel(
    "Login",
    fluidPage(
      useShinyjs(),
      titlePanel(tags$h2("Login to Health Data Analytics", style = "text-align: center; color: #f4f4f4;")),
      fluidRow(
        column(
          width = 4, offset = 4,
          wellPanel(
            style = "background-color: #444; border-radius: 10px;",
            textInput("username", "Username", placeholder = "Enter your username", width = "100%"),
            passwordInput("password", "Password", placeholder = "Enter your password", width = "100%"),
            div(
              style = "text-align: center;",
              actionButton("login_btn", "Login", class = "btn btn-success"),
              br(), br(),
              h4("Or", style = "color: #f4f4f4; text-align: center;"),
              actionButton("google_login_btn", "Login with Google", class = "btn btn-info"),
              br(), br(),
              actionButton("logout_btn", "Logout from Google", class = "btn btn-danger")
            )
          )
        )
      )
    )
  ),
  
  
  # Page 1: Welcome Page
  tabPanel(
    "Welcome",
    fluidPage(
      useShinyjs(),
      titlePanel(tags$h1("Welcome to the Health Data Prediction App", style = "text-align: center; color: #f4f4f4;")),
      fluidRow(
        column(
          12, 
          img(src = "https://www.rishabhsoft.com/wp-content/uploads/2023/12/Banner-Image-Data-Analytics-in-Healthcare.jpg",
              alt = "Healthcare Data Banner", style = "display: block; margin: 20px auto; width: 90%; border-radius: 10px;"),
          wellPanel(
            style = "background-color: #444; border-radius: 10px;",
            h3("Introduction", style = "color: #f4f4f4; text-align: center;"),
            p("Welcome to our Health Data Prediction App, a comprehensive platform designed to revolutionize the way we interact with health data. 
               By leveraging state-of-the-art tools and intuitive visualizations, this app empowers users to explore key health indicators across various U.S. states. 
               Our mission is to provide a resourceful gateway for health professionals, policymakers, researchers, and data enthusiasts to derive meaningful insights from public health data.",
              style = "color: #dcdcdc; text-align: justify;"),
            h4("What You Can Expect", style = "color: #f4f4f4; text-align: center;"),
            tags$ul(
              style = "color: #dcdcdc; padding-left: 20px;",
              tags$li("Effortless filtering of comprehensive health data by state and health-related categories."),
              tags$li("Dynamic, interactive visualizations to uncover trends, correlations, and insights."),
              tags$li("Advanced analytics to aid decision-making processes and strategic planning."),
              tags$li("3D visualizations for multi-dimensional exploration of data relationships and complexities.")
            ),
            div(
              style = "text-align: center;",
              actionButton("btn_filtered_data", "Explore Filtered Data", class = "btn btn-success"),
              actionButton("btn_data_summary", "View Data Summary", class = "btn btn-info"),
              actionButton("btn_advanced_analysis", "Advanced Analysis", class = "btn btn-primary"),
              actionButton("btn_3d_visual", "3D Visualization", class = "btn btn-warning"),
              actionButton("btn_about", "About", class = "btn btn-secondary")
            )
          )
        )
      )
    ),
    tags$script(HTML('
      $("#btn_filtered_data").on("click", function() {
        $("a:contains(\'Filtered Data\')").tab("show");
      });
      $("#btn_data_summary").on("click", function() {
        $("a:contains(\'Data Summary\')").tab("show");
      });
      $("#btn_advanced_analysis").on("click", function() {
        $("a:contains(\'Advanced Analysis\')").tab("show");
      });
      $("#btn_3d_visual").on("click", function() {
        $("a:contains(\'3D Visualization\')").tab("show");
      });
      $("#btn_about").on("click", function() {
        $("a:contains(\'About\')").tab("show");
      });
    '))
  ),
  
  # Page 2: Filtered Data Table
  tabPanel(
    "Filtered Data",
    fluidPage(
      titlePanel(tags$h1("Filter Health Data by State and Category", style = "text-align: center; color: #f4f4f4;")),
      sidebarLayout(
        sidebarPanel(
          h4("Select Filters", style = "color: #f4f4f4;"),
          selectInput("state", "Select State:", choices = unique(data$StateDesc), selectize = TRUE, width = "100%"),
          selectInput("category", "Select Category:", choices = unique(data$Category), selectize = TRUE, width = "100%"),
          actionButton("show_data", "Show Data", class = "btn btn-success"),
          br(), br(),
          p("Use the filters to narrow down the dataset based on specific states and health categories. This feature is designed for users 
              seeking granular insights into particular regions or focus areas within public health metrics.",
            style = "color: #dcdcdc; text-align: justify;")
        ),
        mainPanel(
          h3("Filtered Data Table", style = "color: #f4f4f4;"),
          p("This table dynamically updates based on the filters you apply, providing a concise and clear view of the data you're interested in. 
              Whether you're analyzing health trends in a single state or comparing metrics across categories, this feature helps you focus on what matters most.",
            style = "color: #dcdcdc; text-align: justify;"),
          tableOutput("table")
        )
      )
    )
  ),
  
  # Page 3: Data Summary and Visualization
  tabPanel(
    "Data Summary",
    fluidPage(
      titlePanel(tags$h1("Summary of Health Data", style = "text-align: center; color: #f4f4f4;")),
      sidebarLayout(
        sidebarPanel(
          h4("Graph Options", style = "color: #f4f4f4;"),
          selectInput("x_var", "X-axis Variable:", choices = c("StateDesc", "Category", "Measure")),
          selectInput("y_var", "Y-axis Variable:", choices = c("Data_Value", "TotalPopulation")),
          actionButton("plot_graph", "Plot Graph", class = "btn btn-info"),
        ),
        mainPanel(
          h3("Graph Output", style = "color: #f4f4f4;"),
          p("Our bar plot visualization offers an intuitive way to understand relationships and distributions in the dataset. Choose the variables you want to analyze, 
              and let the app create a graphical representation that highlights trends, patterns, and areas of concern in public health data.",
            style = "color: #dcdcdc; text-align: justify;"),
          plotOutput("dynamic_plot")
        )
      )
    )
  ),
  
  # Page 4: Advanced Analysis
  tabPanel(
    "Advanced Analysis",
    fluidPage(
      titlePanel(tags$h1("Advanced Data Analysis", style = "text-align: center; color: #f4f4f4;")),
      sidebarLayout(
        sidebarPanel(
          h4("Options", style = "color: #f4f4f4;"),
          actionButton("show_summary", "Show Summary", class = "btn btn-primary"),
        ),
        mainPanel(
          h3("Summary Output", style = "color: #f4f4f4;"),
          p("This section provides a comprehensive statistical summary of the dataset, including descriptive metrics such as means, medians, ranges, and standard deviations. 
              With these insights, you can evaluate health trends and disparities with a data-driven approach.",
            style = "color: #dcdcdc; text-align: justify;"),
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
      p("This interactive 3D scatter plot enables you to explore the dataset in three dimensions, providing a unique perspective on the relationships between variables. 
              Use this tool to uncover hidden patterns and gain a deeper understanding of the data's multi-dimensional nature.",
        style = "color: #FDFCDB; text-align: justify; padding: 10px;"),
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
        p("Our mission is to empower stakeholders with meaningful insights and tools, enabling data-driven decisions for better public health outcomes, this application is made by Advika Sharma & Deepak Kumawat",
          style = "color: #FDFCDB; padding: 10px; text-align: justify;")
      )
    )
  )
)


#Define server logic
server <- function(input, output, session) {
  
  
  # Reconnect to the database
  db <- dbConnect(SQLite(), "users.db")
  
  # Initialize login status
  login_status <- reactiveVal(FALSE)
  
  # Handle username/password login
  observeEvent(input$login_btn, {
    # Query the database for the username
    user <- dbGetQuery(db, "SELECT * FROM users WHERE username = ?", params = list(input$username))
    
    if (nrow(user) == 1 && sodium::password_verify(user$password_hash, input$password)) {
      login_status(TRUE)
      showNotification("Login successful!", type = "message")
      updateTabsetPanel(session, "navbarPage", selected = "Welcome")
    }else {
      showNotification("Invalid username or password", type = "error")
    }
  })
  
  
  # Filtered data based on inputs
  filtered_data <- reactive({
    req(input$show_data)
    isolate(data[data$StateDesc == input$state & data$Category == input$category, ])
  })
  
  output$table <- renderTable({
    req(filtered_data())
    filtered_data()
  })
  
  # Generate dynamic plot
  observeEvent(input$plot_graph, {
    output$dynamic_plot <- renderPlot({
      x <- data[[input$x_var]]
      y <- data[[input$y_var]]
      barplot(height = tapply(y, x, mean), col = "#009688", border = "white",
              main = paste("Bar Plot of", input$y_var, "by", input$x_var),
              xlab = input$x_var, ylab = input$y_var, las = 2)
    })
  })
  
  # Show dataset summary
  observeEvent(input$show_summary, {
    output$summary <- renderPrint({
      summary(data)
    })
  })
  
  # Render 3D Visualization
  output$plotly_3d <- renderPlotly({
    plot_ly(data, x = ~StateDesc, y = ~Data_Value, z = ~TotalPopulation,
            type = "scatter3d", mode = "markers", color = ~Category)
  })

  
  # Handle Google login
  observeEvent(input$google_login_btn, {
    token <- tryCatch(
      gargle::token_fetch(scopes = c("https://www.googleapis.com/auth/drive")),
      error = function(e) NULL
    )
    if (!is.null(token)) {
      showNotification("Google Authentication Successful!", type = "message")
      login_status(TRUE)
      updateTabsetPanel(session, "navbarPage", selected = "Welcome")
    } else {
      showNotification("Google Authentication Failed", type = "error")
    }
  })
  
  # Handle Google logout
  observeEvent(input$logout_btn, {
    tryCatch({
      # Fetch the current token (if any)
      token <- gargle::token_fetch(scopes = c("https://www.googleapis.com/auth/drive"))
      
      if (!is.null(token)) {
        # Revoke the token using Google's OAuth2 endpoint
        httr::POST(
          url = "https://oauth2.googleapis.com/revoke",
          body = list(token = token$credentials$access_token),
          encode = "form"
        )
        showNotification("Logged out from Google account successfully!", type = "message")
      } else {
        showNotification("No active Google session found.", type = "warning")
      }
      
      # Clear cached tokens
      unlink(".secrets", recursive = TRUE, force = TRUE)
      showNotification("Token cache cleared successfully.", type = "message")
    }, error = function(e) {
      showNotification(paste("Error during logout:", e$message), type = "error")
    })
    
    # Update the login status and redirect to login page
    login_status(FALSE)
    updateTabsetPanel(session, "navbarPage", selected = "Login")
  })
  
  
  # Show/hide tabs based on login status
  observe({
    if (login_status()) {
      shinyjs::show(selector = "#navbarPage li a[data-value='Welcome']")
      shinyjs::show(selector = "#navbarPage li a[data-value='Filtered Data']")
      shinyjs::show(selector = "#navbarPage li a[data-value='Data Summary']")
      shinyjs::show(selector = "#navbarPage li a[data-value='Advanced Analysis']")
      shinyjs::show(selector = "#navbarPage li a[data-value='3D Visualization']")
      shinyjs::show(selector = "#navbarPage li a[data-value='About']")
    } else {
      shinyjs::hide(selector = "#navbarPage li a[data-value='Welcome']")
      shinyjs::hide(selector = "#navbarPage li a[data-value='Filtered Data']")
      shinyjs::hide(selector = "#navbarPage li a[data-value='Data Summary']")
      shinyjs::hide(selector = "#navbarPage li a[data-value='Advanced Analysis']")
      shinyjs::hide(selector = "#navbarPage li a[data-value='3D Visualization']")
      shinyjs::hide(selector = "#navbarPage li a[data-value='About']")
    }
  })
}


# Run the application
shinyApp(ui = ui, server = server) 
