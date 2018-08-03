#' Get MOD13 hdf
#'
#' @export
#'
modis_download_hdf <- function(tile, start, end, path = ".", satellites = c("terra", "aqua")) {

  # check and extract tiles detas
  start <- check_date(start)
  end <- check_date(end)

  if (start > end) stop("End date wrong") # melhorar teste e menssagem

  exact_date <- get_exact_date(start, end, satellites)

  # get infos for download
  scene_info <- dplyr::data_frame(exact_date, satellite = names(exact_date)) %>%
    tidyr::crossing(tile) %>%
    dplyr::mutate(scene_name = purrr::pmap_chr(list(exact_date, tile, satellite), get_scene_name)) %>%
    dplyr::mutate(scene_path = purrr::pmap_chr(list(exact_date, scene_name, satellite), get_scene_path))

  for (i in seq_len(nrow(scene_info))) {

    cat(
      stringr::str_glue("scene {i}: {scene_info$scene_name[i]}, start: {Sys.time()}"), "\n"
    )

    get_scene_hdf(
      scene_info$scene_name[i],
      scene_info$scene_path[i],
      scene_info$exact_date[i],
      path
    )

  }
}

# Helpers
get_scene_name <- function(day, tile, satellite) {

  if (satellite == "terra") {
    path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"
  } else {
    path_root <- "http://e4ftl01.cr.usgs.gov/MOLA/MYD13Q1.006"
  }

  path_day <- paste(path_root, format(lubridate::as_date(day), "%Y.%m.%d"),  sep = "/")

  purrr::map(path_day, xml2::read_html) %>%
    purrr::map(rvest::html_nodes, css = "a") %>%
    purrr::map(rvest::html_text, trim = T) %>%
    purrr::map(stringr::str_subset, pattern = "[hdf]$") %>%
    purrr::map(stringr::str_subset, pattern = stringr::str_c(tile, collapse = "|")) %>%
    purrr::flatten_chr()
}

get_scene_path <- function(day, scene, satellite) {

  if (satellite == "terra") {
    path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"
  } else {
    path_root <- "http://e4ftl01.cr.usgs.gov/MOLA/MYD13Q1.006"
  }

  paste(path_root, format(lubridate::as_date(day), "%Y.%m.%d"), scene, sep = "/")
}

get_scene_hdf <- function(scene_name, scene_path, exact_date, path) {

  date_out <- base::format.Date(lubridate::as_date(exact_date), "%Y.%m.%d")

  if (!dir.exists(path)) {
    dir.create(path)
  }

  if (!dir.exists(file.path(path, date_out))) {
    dir.create(file.path(path, date_out))
  }

  filename <- file.path(path, date_out, scene_name)

  if (file.exists(filename)) {

    cat("file already exists\n")

  } else {

    httr::GET(
      scene_path,
      httr::authenticate("Tecnologia", "Tec123456"),
      httr::write_disk(filename, overwrite = TRUE),
      httr::progress()
    )
  }
}

