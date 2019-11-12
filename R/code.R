# setwd("TUDresden/ACFS/panorama/R")

library(rayshader)
library(geoviz)
library(plotKML) # for reading GPX files

elev_img <- raster::raster("new-cut.tif")
#elev_matrix <- matrix(
#raster::extract(elev_img, raster::extent(elev_img), buffer = 1000), 
#  nrow = ncol(elev_img), ncol = nrow(elev_img)
#)

elev_matrix <- raster::as.matrix(elev_img)

# calculate rayshader layers
ambmat <- ambient_shade(elev_matrix, zscale = 10)
raymat <- ray_shade(elev_matrix, zscale = 10, lambert = TRUE)
watermap <- detect_water(elev_matrix)


# ============GPS Skii routes
tracklog <- readGPX("skii-route_edited.gpx")
#Increase this to ~60 for a higher resolution (but slower) image

max_tiles <- 10

# Consolidate routes in one drata frame

lat <- c()
lon <- c()

index <- c()


# clumpsy way of doing this.
routes1 <- data.frame(cbind(name = 1, lat = tracklog$routes$`1`$lat, lon = tracklog$routes$`1`$lon))
routes2 <- data.frame(cbind(name = 2, lat = tracklog$routes$`2`$lat, lon = tracklog$routes$`2`$lon))
routes3 <- data.frame(cbind(name = 3, lat = tracklog$routes$`3`$lat, lon = tracklog$routes$`3`$lon))
routes4 <- data.frame(cbind(name = 4, lat = tracklog$routes$`4`$lat, lon = tracklog$routes$`4`$lon))
routes5 <- data.frame(cbind(name = 5, lat = tracklog$routes$`5`$lat, lon = tracklog$routes$`5`$lon))
routes6 <- data.frame(cbind(name = 6, lat = tracklog$routes$`6`$lat, lon = tracklog$routes$`6`$lon))
routes7 <- data.frame(cbind(name = 7, lat = tracklog$routes$`7`$lat, lon = tracklog$routes$`7`$lon))
routes8 <- data.frame(cbind(name = 8, lat = tracklog$routes$`8`$lat, lon = tracklog$routes$`8`$lon))
routes9 <- data.frame(cbind(name = 9, lat = tracklog$routes$`9`$lat, lon = tracklog$routes$`9`$lon))
routes10 <- data.frame(cbind(name = 10, lat = tracklog$routes$`10`$lat, lon = tracklog$routes$`10`$lon))
routes11 <- data.frame(cbind(name = 11, lat = tracklog$routes$`11`$lat, lon = tracklog$routes$`11`$lon))
routes12 <- data.frame(cbind(name = 12, lat = tracklog$routes$`12`$lat, lon = tracklog$routes$`12`$lon))
routes13 <- data.frame(cbind(name = 13, lat = tracklog$routes$`13`$lat, lon = tracklog$routes$`13`$lon))
routes14 <- data.frame(cbind(name = 14, lat = tracklog$routes$`14`$lat, lon = tracklog$routes$`14`$lon))
routes15 <- data.frame(cbind(name = 15, lat = tracklog$routes$`15`$lat, lon = tracklog$routes$`15`$lon))


routes <- data.frame(rbind(routes1,routes2,routes3,routes4,routes5,routes6,routes7,routes8,routes9,
                           routes10,routes11,routes12,routes13,routes14,routes15))




zscale <- 30

rgl::clear3d()
output <- elev_matrix %>% 
  sphere_shade(texture = "imhof1") %>% 
  add_water(watermap, color = "desert") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_3d(elev_matrix, zscale = zscale, windowsize = c(800, 800),
          water = TRUE, waterdepth = 750, soliddepth = 10,wateralpha = 4,
          theta = 250, phi = 20, zoom = 0.75, fov = 10)
render_snapshot()
