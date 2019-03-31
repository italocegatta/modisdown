library(modisdown)


modis_download_hdf(c("h12v10", "h12v11", "h13v09", "h13v10", "h13v11", "h14v10", "h14v11"), "01/07/2018", "01/08/2018", path = "hdf")

modis_extract_bands(
  path_hdr = "hdf", path_tiff = "tiff",
  c(1, 1, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0),
  path_mrt = "C:/MODIS"
)
