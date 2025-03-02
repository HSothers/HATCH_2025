library(shiny)
library(bslib)
library(digest)
library(Rook)
library(shinythemes)


# User database with hashed passwords
users <- data.frame(
  username = c("admin", "user1"),
  password = c(digest("password123", algo = "sha256"), digest("mypassword", algo = "sha256")),
  email = c("admin@example.com", "user1@example.com"),  # Emails for sending OTP
  stringsAsFactors = FALSE
)
# Store OTPs (in a real app, use a database or session-based storage)
otp_storage <- reactiveValues(otp = NULL, user = NULL, otp_requested = FALSE)  # Added otp_requested
# Define UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  titlePanel("WormHole Login Page"),
  sidebarLayout(
    sidebarPanel(
      textInput("username", "Username:", placeholder = "Enter your username"),
      passwordInput("password", "Password:", placeholder = "Enter your password"),
      actionButton("login", "Login", class = "btn-primary"),
      uiOutput("otp_ui")  # OTP Input UI (only shown after login step)
    ),
    mainPanel(
      br(),  # Adds some spacing
      textOutput("message")
    )
  )
)
# Define server logic
server <- function(input, output, session) {
  observeEvent(input$login, {
    user <- input$username
    pass <- digest(input$password, algo = "sha256")  # Hash the entered password
    # Reset OTP UI when a new login attempt is made
    otp_storage$otp_requested <- FALSE
    output$otp_ui <- renderUI(NULL)  # Clear previous OTP UI
    # Check if username exists in the database
    if (user %in% users$username) {
      stored_pass <- users$password[users$username == user]
      if (pass == stored_pass) {
        # Generate a random 6-digit OTP
        otp_storage$otp <- sprintf("%06d", sample(100000:999999, 1))
        otp_storage$user <- user
        # Simulate sending OTP (for real apps, use an email API)
        email <- users$email[users$username == user]
        cat("Sending OTP to", email, ":", otp_storage$otp, "\n")
        # Ensure OTP UI is displayed only once per login
        otp_storage$otp_requested <- TRUE
        output$message <- renderText("OTP has been sent to your email. Please enter it below.")
        # Show OTP input field dynamically
        output$otp_ui <- renderUI({
          tagList(
            textInput("otp", "Enter OTP:", placeholder = "Enter the OTP sent to your email"),
            actionButton("verify_otp", "Verify OTP", class = "btn-success")
          )
        })
      } else {
        output$message <- renderText("Invalid username or password.")
      }
    } else {
      output$message <- renderText("Invalid username or password.")
    }
  })
  observeEvent(input$verify_otp, {
    if (!is.null(otp_storage$otp) && input$otp == otp_storage$otp) {
      output$message <- renderText("Welcome to Wormhole! Login successful.")
      otp_storage$otp <- NULL  # Reset OTP after successful login
      otp_storage$otp_requested <- FALSE  # Reset so OTP UI disappears
      # Clear OTP UI after successful login
      output$otp_ui <- renderUI(NULL)
    } else {
      output$message <- renderText("Invalid OTP. Please try again.")
    }
  })
}
# Run the application
shinyApp(ui = ui, server = server)
```
```{r}
# User database with hashed passwords
users <- data.frame(
  username = c("admin", "user1"),
  password = c(digest("password123", algo = "sha256"), digest("mypassword", algo = "sha256")),
  email = c("admin@example.com", "user1@example.com"),  # Emails for sending OTP
  stringsAsFactors = FALSE
)
# Store OTPs (in a real app, use a database or session-based storage)
otp_storage <- reactiveValues(otp = NULL, user = NULL, otp_requested = FALSE)
# Define UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  titlePanel("WormHole Login Page"),
  sidebarLayout(
    sidebarPanel(
      textInput("username", "Username:", placeholder = "Enter your username"),
      passwordInput("password", "Password:", placeholder = "Enter your password"),
      actionButton("login", "Login", class = "btn-primary"),
      uiOutput("otp_ui"),  # OTP Input UI (only shown after login step)
      uiOutput("upload_ui")  # Data upload UI (only shown after successful login)
    ),
    mainPanel(
      br(),  # Adds some spacing
      textOutput("message")
    )
  )
)
# Define server logic
server <- function(input, output, session) {
  observeEvent(input$login, {
    user <- input$username
    pass <- digest(input$password, algo = "sha256")  # Hash the entered password
    # Reset OTP UI when a new login attempt is made
    otp_storage$otp_requested <- FALSE
    output$otp_ui <- renderUI(NULL)  # Clear previous OTP UI
    output$upload_ui <- renderUI(NULL)  # Clear file upload UI initially
    # Check if username exists in the database
    if (user %in% users$username) {
      stored_pass <- users$password[users$username == user]
      if (pass == stored_pass) {
        # Generate a random 6-digit OTP
        otp_storage$otp <- sprintf("%06d", sample(100000:999999, 1))
        otp_storage$user <- user
        # Simulate sending OTP (for real apps, use an email API)
        email <- users$email[users$username == user]
        cat("Sending OTP to", email, ":", otp_storage$otp, "\n")
        # Ensure OTP UI is displayed only once per login
        otp_storage$otp_requested <- TRUE
        output$message <- renderText("OTP has been sent to your email. Please enter it below.")
        # Show OTP input field dynamically
        output$otp_ui <- renderUI({
          tagList(
            textInput("otp", "Enter OTP:", placeholder = "Enter the OTP sent to your email"),
            actionButton("verify_otp", "Verify OTP", class = "btn-success")
          )
        })
      } else {
        output$message <- renderText("Invalid username or password.")
      }
    } else {
      output$message <- renderText("Invalid username or password.")
    }
  })
  observeEvent(input$verify_otp, {
    if (!is.null(otp_storage$otp) && input$otp == otp_storage$otp) {
      output$message <- renderText("Welcome to Wormhole! Login successful.")
      otp_storage$otp <- NULL  # Reset OTP after successful login
      otp_storage$otp_requested <- FALSE  # Reset so OTP UI disappears
      # Clear OTP UI after successful login
      output$otp_ui <- renderUI(NULL)
      # Show the data upload UI after OTP verification
      output$upload_ui <- renderUI({
        tagList(
          fileInput("file_upload", "Upload Data File:", accept = c(".csv", ".txt")),
          actionButton("upload_data", "Upload Data", class = "btn-primary")
        )
      })
    } else {
      output$message <- renderText("Invalid OTP. Please try again.")
    }
  })
  observeEvent(input$upload_data, {
    req(input$file_upload)  # Ensure that a file is selected
    # Read the uploaded data (assuming CSV or text file)
    file <- input$file_upload
    if (tools::file_ext(file$name) == "csv") {
      uploaded_data <- read.csv(file$datapath)
    } else if (tools::file_ext(file$name) == "txt") {
      uploaded_data <- read.table(file$datapath)
    } else {
      output$message <- renderText("Invalid file format. Please upload a CSV or TXT file.")
      return()
    }
    # Display the first few rows of the uploaded data
    output$message <- renderText({
      paste("File uploaded successfully. Preview of the data:\n", head(uploaded_data, 5))
    })
  })
}
# Run the application
shinyApp(ui = ui, server = server)