# The unit used for the duration column.
#
get_option_duration_units <- function(default = "mins") {
  getOption("duration.units", default = default)
}
