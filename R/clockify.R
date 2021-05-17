#' @import httr
#' @import dplyr
#' @import purrr
#' @import janitor
#' @import logger
#' @import anytime
NULL

cache <- new.env()

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
