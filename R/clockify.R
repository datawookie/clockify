#' @import httr
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
  assign("api_key", api_key, envir = cache)
}

get_api_key <- function() {
  get("api_key", envir = cache)
}

BASE_PATH = "https://api.clockify.me/api/v1/"
