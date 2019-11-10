library(rayshader)
library(geoviz)


lat <- 47.394319
long <- 13.687770

square_km <- 6

max_tiles <- 60
#mapbox_key <- "pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ"



dem <- mapzen_dem(lat, long, square_km = square_km, max_tiles = max_tiles)

elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)

sunangle <- 270



#overlay_image <-
#  slippy_overlay(
#    dem,
#    image_source = "mapbox",
#    image_type = "satellite",
#    png_opacity = 0.6,
#    api_key = mapbox_key
# )


#Optionally, turn mountainous parts of the overlay transparent

scene <- elmat %>%
  sphere_shade(sunangle = sunangle, texture = "imhof1") %>%
  #add_overlay(overlay_image) %>%
  add_shadow(
    ray_shade(
      elmat,
      anglebreaks = seq(30, 60),
      sunangle = sunangle,
      multicore = TRUE,
      lambert = FALSE,
      remove_edges = FALSE
    )
  ) %>%
  add_shadow(ambient_shade(elmat, multicore = TRUE, remove_edges = FALSE))


rayshader::plot_3d(
  scene,
  elmat,
  zscale = raster_zscale(dem),
  solid = TRUE,
  shadow = TRUE,
  shadowdepth = -150
)



rgl::view3d(theta =290, phi = 18, zoom = 0.5, fov = 5)



#rayshader::render_depth(
#  focus = 0.5,
#  fstop = 18,
#  filename = "scene.png"
#)



