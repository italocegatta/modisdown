
# debbug ------------------------------------------------------------------

library(magrittr)
i = 1

tile = c("h00v08")
start = "2018-04-10"
end = "2018-05-01"
path = "."

# testar data sem cena

tile = c("h00v08", "h00v09")
start = "2018-03-01"
end = "2018-05-01"
day = tiles_days
scene <- scene_name
path = "teste"
date <- exact_date


modis_download_hdf(tile, start, end, path)
