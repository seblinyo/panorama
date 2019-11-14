library(rayshader)
library(geoviz)
library(plotKML) # for reading GPX files
require(extrafont) # to curl fonts from OS.
library(magick)
require(rgl)
require(gifski)
require(rlang)

# Set the working directory
setwd("C:/Users/sebas/documents/github/panorama/r")



# ============DEM =========================== #
#=========================================================#

lat <- 47.394319
long <- 13.687770

square_km <- 6

max_tiles <- 10

dem <- mapzen_dem(lat, long, square_km = square_km, max_tiles = max_tiles)

elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)

# from https://github.com/tylermorganwall/rayshader/issues/39
for(sunangle in 1:200) {
  elmat %>%
    sphere_shade %>%
    add_shadow(ray_shade(elmat,raster_zscale(dem),maxsearch = 300, sunangle = sunangle),0.5) %>%
    plot_3d(elmat,zscale=raster_zscale(dem),fov=5,theta=200,zoom=0.75, phi=38, windowsize = c(1000,800))
  render_snapshot(filename=paste0("frame",sunangle))
  rgl::rgl.clear()
    
}

png_files <- sprintf("frame%d.png", 1: 200)
av::av_encode_video(png_files, 'output.mp4', framerate = 10)
utils::browseURL('output.mp4')

#rgl::view3d(theta =200, phi = 38, zoom = 0.75, fov = 5)

# scene <- elmat %>%
#     sphere_shade(texture = "imhof1") %>%
#     add_shadow(
#       ray_shade(
#         elmat,
#         anglebreaks = seq(30, 60),
#         sunangle = sunangle[i],
#         multicore = TRUE,
#         lambert = FALSE,
#         remove_edges = FALSE
#       )
#     ) %>%
#     add_shadow(
#       ambient_shade(
#         elmat,
#         multicore = TRUE,
#         remove_edges = FALSE
#       )
#     )
# 
# 
# rayshader::plot_3d(
#     scene,
#     elmat,
#     zscale = raster_zscale(dem),
#     solid = TRUE,
#     shadow = TRUE,
#     shadowdepth = -100
# )
  
  
  

  

