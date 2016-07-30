library(shiny)
library(markdown)

shinyUI(navbarPage("Welcome to Jijou's app! :)",
                   
        tabPanel("Map",
                 fluidRow(
                        column(3, wellPanel(
                               h3("Choose your options:"),
                               br(),
                               textInput("place", "What are you looking for?", "pizzeria"),
                               textInput("location", "Where?", "Paris"),
                               sliderInput("radius", "In which radius (in meters)?", 
                                           300, 2000, value=500),
                               sliderInput("zoom", "Map zoom:", 3, 21, value=15),
                               br(),
                               submitButton(text="Actualize"))),
                        
                        column(6, 
                               h3("Result of your request:", align="center"),
                               plotOutput("map")),

                        column(3, wellPanel(
                                h3("Why should you use this app?"),
                                br(),
                                p("Looking for a good pizzeria, an aquarium, or the 
                                 closest dentist? This app is for you!"),
                                h3("How to use this app?"),
                                br(),
                                p("1. Enter the kind of place you are looking for."),
                                p("2. Enter your location."),
                                p("3. Choose the radius in which you want to look for."),
                                p("4. Adjust the map zoom: from 3 (continent) to 21 (building)."),
                                p("5. Actualize and enjoy :)"),
                                br(),
                                img(src="RStudio-Ball.png", height=40, width=40),
                                "Shiny is a product of ", 
                                span(a("RStudio", style="color:blue", target="_blank",
                                       href="https://www.rstudio.com")),
                                p(),
                                img(src="googlemaps-icon.png", height=40, width=40),
                                "This app uses ",
                                span(a("Google Maps API", style="color:blue", target="_blank",
                                       href="https://developers.google.com/maps/")))))),
        
        tabPanel("Table",
                 fluidRow(
                         column(9, 
                                h3("Result of your request:"),
                                dataTableOutput("table")),
                         
                         column(3, wellPanel(
                                 h3("Why should you use this app?"),
                                 br(),
                                 p("Looking for a good pizzeria, an aquarium, or the 
                                   closest dentist? This app is for you!"),
                                 h3("How to use this app?"),
                                 br(),
                                 p("1. Enter the kind of place you are looking for."),
                                 p("2. Enter your location."),
                                 p("3. Choose the radius in which you want to look for."),
                                 p("4. Adjust the map zoom: from 3 (continent) to 21 (building)."),
                                 p("5. Actualize and enjoy :)"),
                                 br(),
                                 img(src="RStudio-Ball.png", height=40, width=40),
                                 "Shiny is a product of ", 
                                 span(a("RStudio", style="color:blue", target="_blank",
                                        href="https://www.rstudio.com")),
                                 p(),
                                 img(src="googlemaps-icon.png", height=40, width=40),
                                 "This app uses ",
                                 span(a("Google Maps API", style="color:blue", target="_blank",
                                        href="https://developers.google.com/maps/")))))),
        
        tabPanel("Documentation",
                 includeHTML("documentation.html"))
))

