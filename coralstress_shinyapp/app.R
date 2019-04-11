library(shiny)
library(ggplot2)
library(maps)
library(maptools)
library(ggmap)


#Load in a generic map of the world for plotting purposes later
mapWorld <- borders("world", colour="grey20", fill="grey20")

#Load in the mmm data
load("../NOAA/ct5km_climatology_v3.1_MMM.RData")






# Define UI ----
ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel",
                 #Add in an input location for latitude in decimal degrees
                 numericInput(inputId = 'lat_in',label = 'Latitude, decimal degrees [-90,90] ',value = 0,min=-90,max=90),
                 #Add in an input location for longitude in decimal degrees
                 numericInput(inputId = 'lon_in',label = 'Longitude, decimal degrees [-180,180]',value=0,min=-180,max=180),
                 #Add a run buton so that the plots and output doesn't update until the button is pressed
                 actionButton(inputId = 'click',label = 'Run')
    ),
    mainPanel("main panel",
              #Add in a location for the output of the maximum monthly mean
              textOutput('mmm_out'),
              #Add in a location for the output of a map with a dot for the supplied lat and lon
              plotOutput('map')
              )
  )
)
# Define server logic ----
server <- function(input, output) {
  #When the button in the UI is pressed, record the supplied lat and lon from the UI
  location=eventReactive(input$click,{location=data.frame(lat=input$lat_in,long=input$lon_in)})
  
  #Create a plot of the world with a point for the supplied lat and lon as a visual check for the user to make sure they supplied the right lat and lon
  output$map=renderPlot(ggplot(aes(x=long,y=lat),data=location())+mapWorld+geom_point(color='red'))

  #Find the nearest indexed location for the mmm data
  latIdx <-eventReactive(input$click,{which(abs(lat-input$lat_in)==min(abs(lat-input$lat_in)))})
  lonIdx <- eventReactive(input$click,{which(abs(lon-input$lon_in)==min(abs(lon-input$lon_in)))})
 
  #Create a line of text that supplies the mmm to two digits past the decimal 
  output$mmm_out=renderText({paste("Maximum Monthly Mean =",round(sst_NOAA_clim_full[lonIdx(),latIdx()],digits=2),"°C")})
}
  
  

# Run the app ----
shinyApp(ui = ui, server = server)