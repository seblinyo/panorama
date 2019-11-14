library(rayshader)
library(geoviz)
library(plotKML) # for reading GPX files
require(extrafont) # to curl fonts from OS.
library(magick)

# Set the working directory
setwd("C:/Users/sebas/documents/github/panorama/r")

rgl::clear3d()


#from https://github.com/wcmbishop/rayshader-demo/blob/master/R/find-image-coordinates.R
# find_image_coordinates <- function(long, lat, bbox, image_width, image_height) {
#   x_img <- round(image_width * (long - min(bbox$p1$long, bbox$p2$long)) / abs(bbox$p1$long - bbox$p2$long))
#   y_img <- round(image_height * (lat - min(bbox$p1$lat, bbox$p2$lat)) / abs(bbox$p1$lat - bbox$p2$lat))
#   list(x = x_img, y = y_img)
# }

# ============DEM =========================== #
#=========================================================#

lat <- 47.394319
long <- 13.687770

square_km <- 6

max_tiles <- 10
#mapbox_key <- "pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ"

dem <- mapzen_dem(lat, long, square_km = square_km, max_tiles = max_tiles)


elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)


# ============GPS Skii routes =========================== #
#=========================================================#

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
routes16 <- data.frame(cbind(name = 16, lat = tracklog$routes$`16`$lat, lon = tracklog$routes$`16`$lon))
routes17 <- data.frame(cbind(name = 17, lat = tracklog$routes$`17`$lat, lon = tracklog$routes$`17`$lon))
routes18 <- data.frame(cbind(name = 18, lat = tracklog$routes$`18`$lat, lon = tracklog$routes$`18`$lon))

# routes <- data.frame(rbind(routes1,routes2,routes3,routes4,routes5,routes6,routes7,routes8,routes9,
#                            routes10,routes11,routes12,routes13,routes14,routes15))

# run the beow to remove clumpsy variables from your Global environment
# remove(routes1,routes2,routes3,routes4,routes5,routes6,routes7,routes8,routes9,routes10,
#        routes11,routes12,routes13,routes14,routes15)

n_frames <- 12
sunangle <- c(30,60,90,120,150,180,210,240,270,300,330,360)
#sunangle <- 270

#mapbox overlay if we want
#overlay_image <-
#  slippy_overlay(
#    dem,
#    image_source = "mapbox",
#    image_type = "satellite",
#    png_opacity = 0.6,
#    api_key = mapbox_key
# )

img_frames <- paste0("shadow", seq_len(n_frames), ".png")
for (i in seq_len(n_frames)) {
  message(paste(" - image", i, "of", n_frames))
  scene <- elmat %>%
    sphere_shade(texture = "imhof4") %>%
    #add_overlay(overlay_image) %>%
    add_shadow(
      ray_shade(
        elmat,
        anglebreaks = seq(30, 60),
        sunangle = sunangle[i],
        multicore = TRUE,
        lambert = FALSE,
        remove_edges = FALSE
      )
    ) %>%
    add_shadow(
      ambient_shade(
        elmat, 
        multicore = TRUE, 
        remove_edges = FALSE
      )
    )
  
  
  rayshader::plot_3d(
    scene,
    elmat,
    zscale = raster_zscale(dem),
    solid = TRUE,
    shadow = TRUE,
    shadowdepth = -100
    #water = TRUE,
    #waterdepth = 740,
    #watercolor = "lightblue"
  )
  
  
  
  add_gps_to_rayshader(
    dem,
    routes1$lat,
    routes1$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes2$lat,
    routes2$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes3$lat,
    routes3$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes4$lat,
    routes4$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes5$lat,
    routes5$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes6$lat,
    routes6$lon,
    800,
    line_width = 5,
    clamp_to_ground = TRUE,
    lightsaber = FALSE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes7$lat,
    routes7$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes8$lat,
    routes8$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes9$lat,
    routes9$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes10$lat,
    routes10$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes11$lat,
    routes11$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes12$lat,
    routes12$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes13$lat,
    routes13$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes14$lat,
    routes14$lon,
    800,
    line_width = 5,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes15$lat,
    routes15$lon,
    800,
    line_width = 4,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes16$lat,
    routes16$lon,
    800,
    line_width = 4,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  add_gps_to_rayshader(
    dem,
    routes17$lat,
    routes17$lon,
    800,
    line_width = 4,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  
  add_gps_to_rayshader(
    dem,
    routes18$lat,
    routes18$lon,
    800,
    line_width = 4,
    lightsaber = FALSE,
    clamp_to_ground = TRUE,
    zscale = raster_zscale(dem),
    ground_shadow = FALSE,
    colour = "red"
  )
  
  rayshader::render_label(
    elmat,
    x = 718,
    y = 150,
    z = 1000,
    zscale = raster_zscale(dem),
    freetype = FALSE,
    text = "Far Left",
    textsize = 2,
    dashed = TRUE,
    linewidth = 3,
    family = "mono"
  )
  
  rayshader::render_label(
    elmat,
    x = 553,
    y = 150,
    z = 3000,
    zscale = raster_zscale(dem),
    freetype = FALSE,
    text = "Hauser Kaibling (2015m)",
    textsize = 2,
    dashed = TRUE,
    linewidth = 3,
    family = "mono"
  )
  
  #Planai (1906m)
  rayshader::render_label(
   elmat,
   x = 310,
   y = 95,
    z = 2000,
    zscale = raster_zscale(dem),
    freetype = FALSE,
    text = "Hochwurzen (1849m)",
    textsize = 2,
    dashed = TRUE,
    linewidth = 3,
   family = "mono"
  )
  
  rayshader::render_label(
   elmat,
   x = 167,
   y = 95,
   z = 4000,
   zscale = raster_zscale(dem),
   freetype = FALSE,
   text = "Gasselhoehe (2001m)",
   textsize = 2,
   dashed = TRUE,
   linewidth = 3,
   family = "mono"
  )
  
  rgl::view3d(theta =200, phi = 38, zoom = 0.75, fov = 5)
  render_snapshot(img_frames[i])
  #rgl::clear3d()
  
}
  
# build gif
magick::image_write_gif(magick::image_read(img_frames), 
                        path = "Panorama.gif", 
                        delay = 6/n_frames)

#rgl::view3d(theta =290, phi = 18, zoom = 0.5, fov = 5)

#rayshader::render_depth(
#  focus = 0.5,
#  fstop = 18,
#  filename = "scene.png"
#)
