library(tidyverse)

root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"

mod13_avaliable_days <- function() {
  xml2::read_html(root) %>%
    rvest::html_nodes("a") %>%
    rvest::html_text(trim = T) %>%
    '['(-c(1:7)) %>%
    stringr::str_replace_all("\\/", "")
}

mod13_page_tiles <- function(day) {
  xml2::read_html(paste(root, day, sep = "/"))
}

mod13_get_tiles <- function(day) {
  xml2::read_html(paste(root, day, sep = "/")) %>%
  rvest::html_nodes("a") %>%
  rvest::html_text(trim = T) %>%
  '['(stringr::str_detect(., "[hdf]$")) %>%
  stringr::str_sub(18, 23) %>%
  '['(-1)
}
