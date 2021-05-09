time_format <- function(time) {
  time <- anytime(time)
  strftime(time, "%Y-%m-%dT%H:%M:%OS3Z")
}

#' Title
#'
#' Times returned by the API are all in UTC.
#'
#' @param time
#'
#' @return A POSIXct object with UTC timezone.
#'
#' @examples
time_parse <- function(time, format = "%Y-%m-%dT%H:%M:%SZ") {
  as.POSIXct(time, format = format, tz = "UTC")
}
