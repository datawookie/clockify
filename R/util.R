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

#' Add columns to a data frame if they are missing.
#'
#' The API omits some fields entirely (rather than returning `null`), depending
#' on the data or the workspace plan. For example, `amount` and `rate` are
#' absent from detailed report entries on the Free plan. This guarantees that
#' the columns exist so that downstream code and output are stable.
#'
#' @param df A data frame.
#' @param ... Name-value pairs giving the default value for each column. The
#'   value is only used if the column is missing.
#' @return A data frame with the missing columns appended.
#' @noRd
ensure_columns <- function(df, ...) {
  defaults <- list(...)
  missing <- setdiff(names(defaults), names(df))
  df[missing] <- defaults[missing]
  df
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
