null_to_na <- function(x) {
  ifelse(is.null(x), NA, x)
}
