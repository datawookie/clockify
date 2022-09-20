#' Convert NULL elements in list to NA.
#'
#' @param l A list.
#' @return A list.
#' @noRd
list_null_to_na <- function(l) {
  # nocov start
  map(l, function(l) {
    l[sapply(l, is.null)] <- NA
    l
  })
  # nocov end
}

list_remove_empty <- function(l) {
  # nocov start
  rlist::list.clean(l, recursive = TRUE)
  # nocov end
}

check_valid_role <- function(role) {
  # nocov start
  if (!(role %in% c("TEAM_MANAGER", "PROJECT_MANAGER", "WORKSPACE_ADMIN"))) {
    stop("Invalid role.")
  }
  # nocov end
}
