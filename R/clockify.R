#' @import httr
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import janitor
#' @import logger
#' @import anytime
NULL

#' Title
#'
#' @param api_key
#'
#' @return
#' @export
#'
#' @examples
set_api_key <- function(api_key) {
  log_debug("Setting API key: {api_key}.")
  assign("api_key", api_key, envir = cache)
}

#' Title
#'
#' @return
#' @export
#'
#' @examples
get_api_key <- function() {
  get("api_key", envir = cache)
}

BASE_PATH = "https://api.clockify.me/api/v1"

globalVariables(
  c(
    "billable",
    "description",
    "error",
    "project_id",
    "timeInterval",
    "time_end",
    "time_start",
    "workspace_id"
  )
)
