time_format <- function(time, to_utc = FALSE) {
  time <- anytime(time)

  if (to_utc) {
    time <- with_tz(time, tzone = "UTC")
    tz = "GMT"
  } else {
    tz = ""
  }

  strftime(time, "%Y-%m-%dT%H:%M:%OS3Z", tz = tz)
}

#' Title
#'
#' Times returned by the API are all in UTC.
#'
#' @param time
#'
#' @return A POSIXct object.
#'
#' @examples
time_parse <- function(time, format = "%Y-%m-%dT%H:%M:%SZ", to_local = TRUE) {
  time <- as.POSIXct(time, format = format, tz = "UTC")

  if (to_local) {
    with_tz(time)
  } else {
    time
  }
}
