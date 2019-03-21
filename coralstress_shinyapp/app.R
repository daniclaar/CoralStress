library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Coral Stress"),
  
  sidebarLayout(
    sidebarPanel(numericInput(inputId="lat",value="",
                              label="Latitude (Decimal Degrees)"),
                 br(),
                 numericInput(inputId="lon",value="",
                              label="Longitude (Decimal Degrees)"),
                 br(),
                 dateInput(inputId="date",label="Query Date"),
                 br(),
                 actionButton(inputId="submit",label="Submit")),
    mainPanel("Put map here",
              br(),
              "DHW Output goes here")
  )
)


# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)