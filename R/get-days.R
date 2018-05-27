mod13_avaliable_days <- function() {

  page <- xml2::read_html("http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006")

  node <- rvest::html_nodes(page, "a")

  text <- rvest::html_text(node, trim = T)

  day <- stringr::str_replace_all(text[-c(1:7)], "\\/", "")

  date <- as.Date(day, "%Y.%m.%d")

  z <- rev(date)

  return(z)
}
