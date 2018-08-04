#' Extract bands from MODIS HDF file
#'
#' @export
#'
modis_extract_bands <- function(path_hdr, path_tiff, bands = c(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), path_mrt = "C:/MRT") {

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

    call_mrt(path_mrt, param, path_tiff)
  }
}

call_mrt <- function(path, param, path_tiff) {
  path_resample <- list.files(path, "resample.exe", recursive = TRUE, full.names = TRUE, include.dirs = TRUE)

  if (length(path_resample) == 0) {
    stop("MRT path incorrect")
  }

  path_resample <- stringr::str_remove(path_resample, ".exe")
# corrigir o normalize barra envertida
  system(stringr::str_glue("{path_resample} -p {normalizePath(path_tiff)}/{param}"))
}
