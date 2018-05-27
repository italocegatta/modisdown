check_date <- function(x) {

  if (!lubridate::is.Date(x)) {

    test1 <- tryCatch(lubridate::dmy(x), warning=function(w) w)

    if (!any((class(test1) == "warning") == TRUE)) {

      d <- test1

    } else {

      test2 <- tryCatch(lubridate::ymd(x), warning=function(w) w)

      if (lubridate::is.Date(test2)) {

        d <- test2

      } else {

        stop("All formats failed to parse to date. No formats found.")

      }
    }
  } else {

    d <- x

  }

  return(d)
}

get_exact_date <- function(start, end, satellites) {

  terra = NULL
  aqua = NULL

  if (any(stringr::str_detect(satellites, "terra"))) {
    terra <- mod13_avaliable_days()
    names(terra) <- rep("terra", length(terra))
  }

  if (any(stringr::str_detect(satellites, "aqua"))) {
    aqua <- myd13_avaliable_days()
    names(aqua) <- rep("aqua", length(aqua))
  }

  aval_d <- c(terra, aqua)

  aval_d[aval_d >= start & aval_d <= end]
}
