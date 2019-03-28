library(shiny)
library(ggplot2)
library(maps)
library(maptools)
library(ggmap)



mapWorld <- borders("world", colour="grey20", fill="grey20")


load("NOAA/ct5km_climatology_v3.1_MMM.RData")






# Define UI ----
ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel",
                 numericInput(inputId = 'lat_in',label = 'Latitude, decimal degrees [-90,90] ',value = 0,min=-90,max=90),
                 numericInput(inputId = 'lon_in',label = 'Longitude, decimal degrees [-180,180]',value=0,min=-180,max=180),
                 actionButton(inputId = 'click',label = 'Run')
    ),
    mainPanel("main panel",
              plotOutput('map'),
              textOutput('mmm_out'))
  )
)
# Define server logic ----
server <- function(input, output) {
  location=eventReactive(input$click,{location=data.frame(lat=input$lat_in,long=input$lon_in)})
  output$map=renderPlot(ggplot(aes(x=long,y=lat),data=location())+mapWorld+geom_point(color='red'))

  
  latIdx <- which(abs(lat-input$lat_in)==min(abs(lat-input$lat_in)))
  lonIdx <- which(abs(lon-input$lon_in)==min(abs(lon-input$lon_in)))
  
  output$mmm_out <- reactiveText(sst_NOAA_clim_full[lonIdx,latIdx])
  
  }

# Run the app ----
shinyApp(ui = ui, server = server)