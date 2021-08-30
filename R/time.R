#' Convert time object into format required by API
#'
#' @param time String representation of date and time
#' @param to_utc Whether to convert time to UTC
#'
#' @return A string representation of POSIXct.
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

#' Parse times returned by API
#'
#' Times returned by the API are all in UTC.
#'
#' @param time Time string returned by API
#' @param format Format string
#' @param to_local Whether to convert time to local time zone
#'
#' @return A POSIXct object.
time_parse <- function(time, format = "%Y-%m-%dT%H:%M:%SZ", to_local = TRUE) {
  time <- as.POSIXct(time, format = format, tz = "UTC")

  if (to_local) {
    with_tz(time)
  } else {
    time
  }
}
