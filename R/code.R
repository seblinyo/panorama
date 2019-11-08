library(rayshader)

elev_img <- raster::raster("new-cut.tif")
#elev_matrix <- matrix(
#raster::extract(elev_img, raster::extent(elev_img), buffer = 1000), 
#  nrow = ncol(elev_img), ncol = nrow(elev_img)
#)

elev_matrix <- raster::as.matrix(elev_img)

# calculate rayshader layers
ambmat <- ambient_shade(elev_matrix, zscale = 30)
raymat <- ray_shade(elev_matrix, zscale = 30, lambert = TRUE)
watermap <- detect_water(elev_matrix)

zscale <- 40
rgl::clear3d()
elev_matrix %>% 
  sphere_shade(texture = "imhof1") %>% 
  add_water(watermap, color = "imhof1") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_3d(elev_matrix, zscale = zscale, windowsize = c(1200, 1000),
          water = TRUE, soliddepth = -max(elev_matrix)/zscale, wateralpha = 0,
          theta = 250, phi = 20, zoom = 0.35, fov = 10)
render_snapshot()
