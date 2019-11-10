library(rayshader)
library(geoviz)


lat <- 47.394319
long <- 13.687770

square_km <- 5


max_tiles <- 25
mapbox_key <- "pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ"



dem <- mapzen_dem(lat, long, square_km = square_km, max_tiles = max_tiles)

elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)

sunangle <- 60

overlay_image <-
  slippy_overlay(
    dem,
    image_source = "mapbox",
    image_type = "satellite",
    png_opacity = 0.9,
    api_key = mapbox_key
  )

scene <- elmat %>%
  sphere_shade(sunangle = sunangle, texture = "bw") %>%
  add_overlay(overlay_image)

rayshader::plot_3d(
  scene,
  elmat,
  zscale = raster_zscale(dem),
  solid = TRUE,
  shadow = TRUE,
  shadowdepth = -150
)

