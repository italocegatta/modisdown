library(modisdown)


path_root <- "http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006"

start <- Sys.Date() - 120
s <- Sys.Date() - 90
end <- Sys.Date() - 90
e <- Sys.Date() - 120

import_tile(tile, start, end) {

  start <- check_date(start)
  end <- check_date(end)

  aval_d <- mod13_avaliable_days()

  # testar se start é maior que end
  start_d <- aval_d[which.min(abs(start - aval_d))]
  end_d <- aval_d[which.min(abs(end - aval_d))]

  util_d <- aval_d[aval_d >= start_d & aval_d <= end_d]

  get_tiles(util_d)

  path_day <- paste(path_root, format(util_d, "%Y.%m.%d"), sep = "/")



  path_tile <- paste(path_day, )

}

