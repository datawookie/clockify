list_null_to_na_flat <- function(l) {
  l[sapply(l, is.null)] <- NA
  l
}

#' Convert NULL elements in list or nested lists to NA.
#'
#' @param l A list of lists.
#' @param nested Is this a list of lists?
#' @return A list of lists.
#' @noRd
list_null_to_na <- function(l, nested = TRUE) {
  # nocov start
  if (nested) {
    map(l, list_null_to_na_flat)
  } else {
    list_null_to_na_flat(l)
  }
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
