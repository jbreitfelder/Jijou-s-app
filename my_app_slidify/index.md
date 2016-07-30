---
title       : Jijou's app
subtitle    : Best app of the year!
author      : Joanne Breitfelder
job         : App developer since recently :) 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap]           
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : 

---
## Jijou's app

Jijou's app allows you to find interesting places around you. Super high tech, this application is based on a completely new concept mixing RStudio's Shiny and Google Maps API. And it is totally free!! :) 

### How to use it? 
Nothing more simple! Just follow this url(link)[http://jijou.shinyapps.io/my_shiny_app]!

### Fact...
Jijou's app was elected "App Of The Year" by a very special set of electors!* 

### They speak about us!
"En tant qu'utilisateurs on est conquis!" Mélanie (France)
"On aime beaucoup le design, le retour à la simplicité!" Damien (France)
"súper chévere y facil de usar, aunque no encontré la pizzeria al lado de mi casa." Juan (Brazil)

*My friends and family

---
## Google Maps API to help us :)

Explanation of the 2 main codes, with an example calculated inside the slide.

---
## General structure of the ui.R code


```r
shinyUI(fluidPage(theme="bootstrap.css",
        titlePanel("Welcome to Jijou's app! :)", windowTitle="Jijou's app"),
        
        fluidRow(
                # First panel contains the different widgets :
                column(3, wellPanel(h3("Choose your options:"),
                       textInput("place", "What are you looking for?", "pizzeria"))),
                
                # Second panel displays the map calculated by the server :
                column(5, h3("Result of your request:", align="center"),
                       plotOutput("map")),
                
                # Last panel gives general explanations about the app :
                column(4, wellPanel(h3("Why should you use this app?"),
                        p("Looking for a good pizzeria? This app is for you!")))
                ))
```

---
## General structure of the server.R code

The `shinyServer()` function uses the Google Maps API functions `close_places()` and `geoCode()`, which have to be written in the same file.


```r
shinyServer(function(input, output) {
        output$map <- renderPlot({
                
                ## Using inputs + Google Maps functions to calculate results
                data <- close_places(input$location, input$radius, input$place)
                coord <- data.frame(lon=as.numeric(geoCode(input$location)[2]),
                           lat=as.numeric(geoCode(input$location)[1]))
                                
                ## Creation of the output plot with ggmap
                ggmap(get_map(c(coord$lon, coord$lat), zoom=input$zoom)) +
                        geom_point(data=data, aes(x=as.numeric(long), 
                                                  y=as.numeric(lat)), 
                                   size=4, alpha=0.8)})})
```

