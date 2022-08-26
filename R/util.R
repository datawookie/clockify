#' Convert NULL elements in list to NA.
#'
#' @param l A list.
#' @return A list.
#' @noRd
list_null_to_na <- function(l) {
  map(l, function(l) {
    l[sapply(l, is.null)] <- NA
    l
  })
}

list_remove_empty <- function(l) {
  l <- l[!sapply(l, is.null)]
  l <- l[sapply(l, length) != 0]
  l
}
