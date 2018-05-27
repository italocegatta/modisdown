mod13_avaliable_days <- function() {

  xml2::read_html("http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006") %>%
    rvest::html_nodes("a") %>%
    rvest::html_text(trim = T) %>%
    '['(-c(1:7)) %>%
    stringr::str_replace_all("\\/", "") %>%
    as.Date("%Y.%m.%d")
}

myd13_avaliable_days <- function() {

  xml2::read_html("http://e4ftl01.cr.usgs.gov/MOLA/MYD13Q1.006") %>%
    rvest::html_nodes("a") %>%
    rvest::html_text(trim = T) %>%
    '['(-c(1:7)) %>%
    stringr::str_replace_all("\\/", "") %>%
    as.Date("%Y.%m.%d")
}
