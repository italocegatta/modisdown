#' Get MOD13 avaiables days
#'
#' @export
#'
mod13_avaliable_days <- function() {

  page <- xml2::read_html("http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006")

  node <- rvest::html_nodes(page, "a")

  text <- rvest::html_text(node, trim = T)

  day <- stringr::str_replace_all(text[-c(1:7)], "\\/", "")

  date <- as.Date(day, "%Y.%m.%d")

  z <- rev(date)

  return(z)
}

page_tiles <- function(day) {
  xml2::read_html(paste("http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006", day, sep = "/"))
}

get_tiles <- function(day) {

  page <- xml2::read_html(paste("http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006", format(day, "%Y.%m.%d"), sep = "/"))

  node <- rvest::html_nodes(page, "a")

  text <- rvest::html_text(node, trim = T)[-c(1:7)]

  name <- '['(text, stringr::str_detect(text, "[hdf]$"))

  z <- stringr::str_sub(name, 18, 23)

  return(z)

}
