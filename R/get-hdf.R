#' Get MOD13 hdf
#'
#' @export
#'
modis_download_hdf <- function(tile, start, end, path = NULL) {

  # check and extract tiles detas
  start <- check_date(start)
  end <- check_date(end)

  if (start > end) stop("End date wrong") # melhorar teste e menssagem

  exact_date <- get_exact_date(start, end)

  # get infos for download
  scene_info <- tidyr::crossing(exact_date, tile) %>%
    dplyr::mutate(scene_name = purrr::map2_chr(exact_date, tile, get_scene_name)) %>%
    dplyr::mutate(scene_path = purrr::map2_chr(exact_date, scene_name, get_scene_path))

  for (i in seq_len(nrow(scene_info))) {
    print(stringr::str_glue(
      "scene: {i} {scene_info$scene_name[i]}, start: {Sys.time()}"
    ))

    get_scene_hdf(
      scene_info$scene_name[i],
      scene_info$scene_path[i],
      scene_info$exact_date[i],
      path
    )
  }
}

# Helpers
get_scene_name <- function(day, tile) {

  path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"

  path_day <- paste(path_root, format(day, "%Y.%m.%d"),  sep = "/")

  purrr::map(path_day, xml2::read_html) %>%
    purrr::map(rvest::html_nodes, css = "a") %>%
    purrr::map(rvest::html_text, trim = T) %>%
    purrr::map(stringr::str_subset, pattern = "[hdf]$") %>%
    purrr::map(stringr::str_subset, pattern = stringr::str_c(tile, collapse = "|")) %>%
    purrr::flatten_chr()
}

get_scene_path <- function(day, scene) {

  path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"

  paste(path_root, format(day, "%Y.%m.%d"), scene, sep = "/")
}

get_scene_hdf <- function(scene_name, scene_path, exact_date, path) {

  date_out <- base::format.Date(as.Date(exact_date), "%Y.%m.%d")

  if (!dir.exists(path)) dir.create(path)
  if (!dir.exists(file.path(path, date_out))) dir.create(file.path(path, date_out))

  filename <- file.path(path, date_out, scene_name)

  temp <- httr::GET(scene_path, httr::authenticate("Tecnologia", "Tec123456"), httr::progress())
  writeBin(httr::content(temp, "raw"), filename)
}

