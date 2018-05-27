#  debbug tiff

path_hdr <- "teste_hdf"
path_tiff <- "teste_tiff"


# debbug ------------------------------------------------------------------

library(magrittr)
library(modisdown)
load("R/sysdata.rda")
i = 1

tile = "h14v10"

tile = c("h00v08")
start = "2018-04-20"
end = "2018-05-01"
path = "."
satellites = c("terra", "aqua")

day = exact_date[3]
satellite = names(exact_date[3])


# testar data sem cena

tile = c("h00v08", "h00v09")
start = "2018-03-01"
end = "2018-05-01"
day = as.Date("2018-04-23")
scene <- scene_name
path = "teste_hdf"
date <- exact_date

satellites = c("terra", "aqua")

modis_download_hdf(tile, start, end, path)
modis_extract_tiff("teste_hdf", "teste_tiff")

# library(raster)
# r1 <- raster::raster("teste_tiff/2018.04.23/MOD13Q1.A2018113.h14v10.006.2018130000342.250m_16_days_NDVI.tif")
# r2 <- raster::raster("teste_tiff/2018.05.01/MYD13Q1.A2018121.h14v10.006.2018137234812.250m_16_days_NDVI.tif")
#
#
# plot(r1)
# plot(r2)
