#' Get MOD13 hdf
#'
#' @export
#'
mod13_hdf <- function(tile, start, end) {
  day <- get_exact_date(start, end)

  for (i in tile) {
    get_hdf(i, day)
  }
}

# Helpers
get_hdf <- function(tile, day) {
  name <- purrr::map2_chr(day, tile, get_name_cene)

  cene <- purrr::map2_chr(day, name, get_path_cene)

  purrr::walk2(cene, name, download_cene)
}

get_name_cene <- function(day, tile) {
  path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"
  path_day <- paste(path_root, format(day, "%Y.%m.%d"),  sep = "/")
  page_day <- xml2::read_html(path_day)

  node <- rvest::html_nodes( page_day, "a")
  text <- rvest::html_text(node, trim = T)
  tiles <- '['(text, stringr::str_detect(text, "[hdf]$"))
  z <- '['(tiles, stringr::str_detect(tiles, tile))

  return(z)
}

get_path_cene <- function(day, name) {
  path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"
  z <- paste(path_root, format(day, "%Y.%m.%d"), name, sep = "/")

  return(z)
}

download_cene <- function(path, name) {
  temp <- httr::GET(path, httr::authenticate("Tecnologia", "Tec123456"), httr::progress())
  writeBin(httr::content(temp, "raw"), name)
}
