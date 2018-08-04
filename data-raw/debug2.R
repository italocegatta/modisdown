library(modisdown)


modis_download_hdf("h01v10", "01/07/2018", "01/08/2018", path = "hdf")

modis_extract_bands(
  path_hdr = "hdf", path_tiff = "tiff",
  c(1, 1, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0),
  path_mrt = "C:/MODIS"
)
