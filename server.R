################################################################################
# HEADER
################################################################################

library(shiny)
library(RCurl)
library(jsonlite)
library(plyr)
library(ggmap)
library(curl)


################################################################################
# GOOGLE API FUNCTIONS
################################################################################

url <- function(address, return.call="json", sensor="false") {
        root <- "http://maps.google.com/maps/api/geocode/"
        u <- paste(root, return.call, "?address=", 
                   address, "&sensor=", sensor, sep="")
        return(URLencode(u))
}

geoCode <- function(address) {
        u <- url(address)
        doc <- getURL(u)
        x <- fromJSON(doc, simplifyVector=FALSE)
        if(x$status=="OK") {
                lat <- x$results[[1]]$geometry$location$lat
                lng <- x$results[[1]]$geometry$location$lng
                location_type <- x$results[[1]]$geometry$location_type
                formatted_address <- x$results[[1]]$formatted_address
                return(c(lat, lng, location_type, formatted_address))
        } else {
                return(c(NA, NA, NA, NA))
        }
}

close_places <- function(location, radius, place){ 
        
        ## Coordinates of the location
        coord <- geoCode(location)
        coord <- paste(as.character(round(as.numeric(coord[1]), 5)), 
                       as.character(round(as.numeric(coord[2]), 5)), sep=",")
        
        ## Creation of the URL
        baseurl<-"https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        google_key <- "AIzaSyD-8mknrSyCYh0Feg5PgGmq8gFIh3GINJo"
        newurl <- paste(baseurl,"location=", coord,
                        "&radius=", radius,
                        "&name=", place,
                        "&key=", google_key, sep="")
        
        ## Results
        final <- fromJSON(newurl, simplifyVector=TRUE)
        
        if(final$status=="ZERO_RESULTS"){
                details <- data.frame(icon="No result, try a bigger radius",
                                      rating=0,
                                      address="No result, try a bigger radius",
                                      open_now="No result, try a bigger radius",
                                      name="No result, try a bigger radius",
                                      idx=1,
                                      lat=geoCode(location)[2],
                                      long=geoCode(location)[1])
        } else {
                final <- final$results
                if("opening_hours" %in% names(final)){
                        if("open_now" %in% names(final$opening_hours)){
                                open_now <- ifelse(is.na(final$opening_hours$open_now), "No information",
                                                 ifelse(final$opening_hours$open_now==FALSE,
                                                        "Closed :(", "Open :)"))
                        }
                } else {
                        open_now <- rep("No information", length(final$name))
                }
                
                if("rating" %in% names(final)){
                        rating <- ifelse(is.na(final$rating), 
                                         mean(final$rating, na.rm=TRUE),
                                         final$rating)
                } else {
                        rating <- rep(5, length(final$name))
                }
                
                if("icon" %in% names(final)){
                        icon <- paste("<img src='", final$icon, 
                                      "' width='50'></img>", sep="")
                } else {
                        icon <- rep("No information", length(final$name))
                }
                
                details <- data.frame(icon=icon,
                                      rating=rating,
                                      address=final$vicinity,
                                      open_now=open_now,
                                      name=final$name,
                                      idx=1:length(final$geometry$location$lat),
                                      lat=final$geometry$location$lat,
                                      long=final$geometry$location$lng)
        }
        
        return(details)
}


################################################################################
# OTHER FUNCTIONS
################################################################################

make_circles <- function(center=c(0, 0), radius=1, npoints=100){
        meanLat <- center[2]
        radiusLon <- radius/(40075000/360)/cos(meanLat/57.3) 
        radiusLat <- radius/(40075000/360)
        circleDF <- data.frame(ID=1:npoints)
        angle <- seq(0, 2*pi, length.out=npoints)
        
        circleDF$lon <- center[1]+radiusLon*2*cos(angle)
        circleDF$lat <- center[2]+radiusLat*2*sin(angle)
        return(circleDF)
}


################################################################################
# SHINY SERVER
################################################################################

shinyServer(function(input, output) {

        output$map <- renderPlot({
                data <- close_places(input$location, 
                                     input$radius, 
                                     input$place)
                
                coord <- data.frame(lon=as.numeric(geoCode(input$location)[2]),
                           lat=as.numeric(geoCode(input$location)[1]))
                
                circle_data <- make_circles(c(coord$lon, coord$lat), 
                                         input$radius, 
                                         npoints=100)
                
                ggmap(get_map(c(coord$lon, coord$lat), zoom=input$zoom)) +
                        geom_point(data=data, 
                                   aes(x=as.numeric(long), y=as.numeric(lat), size=rating),
                                   color="black", stroke=0.5) +
                        scale_size("Rating") +
                        geom_point(data=data, 
                                   aes(x=as.numeric(long), y=as.numeric(lat), size=rating,
                                       color=open_now), stroke=0.02) +
                        scale_color_discrete("Can I go now?") +
                        geom_polygon(data=circle_data, aes(x=lon, y=lat), 
                                     fill="SteelBlue", alpha=0.15) +
                        geom_text(data=data, 
                                  aes(x=as.numeric(long), y=as.numeric(lat), label=idx),
                                  check_overlap=TRUE, size=5, vjust=-1.1) +
                        xlab("Longitude") + ylab("Latitude") +
                        guides(colour=guide_legend(override.aes=list(size=5)))
        })
        
        output$table <- renderDataTable(close_places(input$location, 
                                                     input$radius, 
                                                     input$place)[, c(1, 6, 5, 3, 2, 4)],
                                        escape=FALSE)
})




