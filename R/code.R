library(rayshader)

newtiff = raster::raster("small.tif")
el1 = raster::as.matrix(newtiff)
el1 %>%
  sphere_shade(zscale = 10, texture = "imhof1") %>%
  add_shadow(ray_shade(el1, zscale = 50)) %>%
  add_shadow(ambient_shade(el1, zscale = 50)) %>%
  plot_3d(el1, zscale = 50, theta = -45, phi = 45, water = TRUE,
          windowsize = c(1000,800), zoom = 0.75, waterlinealpha = 0.3,
          wateralpha = 0.5, watercolor = "blue", waterlinecolor = "black")
render_snapshot()