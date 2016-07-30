## README

### About the application :
#### What is Jijou's app?

Jijou's app allows you to find interesting places around you.  
Looking for a good pizzeria, an aquarium, or the closest dentist? This app is for you! :) 

This application is based on [RStudio's Shiny](http://shiny.rstudio.com) and [Google Maps API](https://developers.google.com/maps/).

#### Links 

* To access the app: <https://jijou.shinyapps.io/my_shiny_app/>
* Github repository: <https://github.com/jbreitfelder/Jijou-s-app>

#### How to run the ui.R and server.R codes :

First copy them to a directory (ex: "siny_app") inside your working space. Then, on R studio's console :

```r
library(shiny)
setwd("your working directory") # which contains the "shiny_app" directory
runApp("shiny_app")
```

#### How to use the app?

1. Enter the kind of place you are looking for.
2. Enter your location
3. Choose the radius in which you want to look for (only the 20 closest results will be desplayed)
4. Adjust the map zoom: from 3 (continent) to 21 (building).
5. Actualize and enjoy :)  

#### Our users around the world speak about us!

* *En tant qu'utilisateurs on est conquis!*
Mélanie, **France**

* *On aime beaucoup le design, le retour à la simplicité!*
Damien, **France**

* *Súper chévere y facil de usar! Aunque no encontré la pizzeria al lado de mi casa..* 
Juan, **Brazil**  

***
### About this repository :

- **documentation.Rmd** and **documentation.html**: more details about the application
- **ui.R** and **server.R**: the source codes of the shiny application
- **www** directory: contains images used in the shiny app
- **logos**: an image used in the documentation files

