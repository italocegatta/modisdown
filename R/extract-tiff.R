

modis_extract_tiff <- function(path_hdr, path_tiff, bands = c(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)) {

  file <- list.files(path = path_hdr, pattern = ".hdf", recursive = T)

  if (!dir.exists(path_tiff)) dir.create(path_tiff)

  path_full_in <- paste(normalizePath(path_hdr), file, sep = "/") %>%
    stringr::str_replace_all('/', "\\\\")

  path_full_out <- paste(normalizePath(path_tiff), file, sep = "/") %>%
    stringr::str_replace_all('/', "\\\\") %>%
    stringr::str_replace_all(".hdf$", ".tif")

  for (i in seq_along(file)) {
    base_file <- param_base

    base_file[2] <- paste0(base_file[2], path_full_in[i])

    base_file[8] <- paste0(base_file[8], path_full_out[i])

    param <- stringr::str_replace_all(file[i], ".hdf$", ".prm")

    # Parametro da cena -------------------------------------------------------

    folder_out <- dirname(path_full_out[i])

    if(!dir.exists(folder_out)) dir.create(folder_out)

    writeLines(base_file, paste(path_tiff, param, sep = "/"))


  # Call MRT ----------------------------------------------------------------

    system(
      paste0(
        "C:/modis_mrt/bin/resample -p ",
        paste(normalizePath(path_tiff), param, sep = "/")
      )
    )

    rm("resample.log")
  }
}
