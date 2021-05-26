#' Clockify
#'
#' @param api_key A key to connect to clockify generated from the clockify settings.
#'
#' @return
#' @export
#'
#' @examples set_api_key(api_key = "MGRiNGIyNGUtMzRmYS00ODg5LThkNmEtNWVjMWY1YWIxYzc2")
set_api_key <- function(api_key) {
  log_debug("Setting API key: {api_key}.")
  assign("api_key", api_key, envir = cache)
}

#' Get API key
#' Searches for the API key in the cache then defines "billable", "description", "error",
#' "project_id", "timeInterval", "time_end", "time_start" and  "workspace_id" globally.
#'
#' @return Returns "billable", "description", "error", "project_id", "timeInterval", "time_end",
#'  "time_start" and  "workspace_id".
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
