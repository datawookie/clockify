time_format <- function(time) {
  time <- anytime(time)
  strftime(time, "%Y-%m-%dT%H:%M:%OS3Z")
}

time_parse <- function(time) {
  as.POSIXct(time, format = DATETIME_FORMAT)
}
