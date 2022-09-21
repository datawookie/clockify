#' Convert time object into format required by API
#'
#' @param time String representation of date and time
#' @param to_utc Whether to convert time to UTC
#' @keywords internal
#' @noRd
#' @return A string representation of POSIXct.
time_format <- function(time, to_utc = TRUE) {
  # nocov start
  if (is.null(time)) {
    NULL
  } else {
    time <- anytime(time)

    if (to_utc) {
      time <- with_tz(time, tzone = "UTC")
      tz <- "GMT"
    } else {
      tz <- ""
    }

    strftime(time, "%Y-%m-%dT%H:%M:%OS3Z", tz = tz)
  }
} # nocov end

#' Parse times returned by API
#'
#' Times returned by the API are all in UTC.
#'
#' @param time Time string returned by API
#' @param format Format string
#' @param to_local Whether to convert time to local time zone
#' @keywords internal
#' @noRd
#' @return A POSIXct object.
time_parse <- function(time,
                       format = "%Y-%m-%dT%H:%M:%SZ",
                       to_local = TRUE) {
  # nocov start
  time <- as.POSIXct(time, format = format, tz = "UTC")

  if (to_local) {
    with_tz(time)
  } else {
    time
  }
} # nocov end
