check_active <- function(active) {
  if (is.logical(active)) {
    active <- ifelse(active, "ACTIVE", "INACTIVE")
  } else if (!is.character(active) || !(active %in% c("ACTIVE", "INACTIVE"))) {
    stop('Argument "active" must be either TRUE, FALSE, "ACTIVE" or "INACTIVE".')
  }

  active
}
