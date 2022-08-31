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
  rlist::list.clean(l, recursive = TRUE)
}

check_valid_role <- function(role) {
  if (!(role %in% c("TEAM_MANAGER", "PROJECT_MANAGER", "WORKSPACE_ADMIN"))) {
    stop("Invalid role.")
  }
}
