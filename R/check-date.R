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

get_exact_date <- function(start, end) {
  aval_d <- mod13_avaliable_days()

  # testar se start é maior que end
  # start_d <- aval_d[which.min(abs(start - aval_d))]
  # end_d <- aval_d[which.min(abs(end - aval_d))]

  aval_d[aval_d >= start & aval_d <= end]
}
