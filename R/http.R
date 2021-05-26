#' Set the api url
#'
#' @param path The path of the endpoint.
#'
#' @return
#' @export
#'
#' @examples api_url("https://api.clockify.me/api/v1")
api_url <- function(path) {
  paste0(BASE_PATH, path)
}

#' GET a url
#'
#' @param path The path of the endpoint.
#' @param query The query parameters.
#'
#' @return
#' @export
#'
#' @examples GET("https://api.clockify.me/api/v1")
GET <- function(path, query = NULL) {
  url <- api_url(path)
  httr::GET(
    url,
    query = query,
    add_headers(
      "X-Api-Key" = get_api_key()
    )
  )
}

#' POST file to a server
#'
#' @param path The path of the endpoint.
#' @param body The body of the query.
#'
#' @return
#' @export
#'
#' @examples POST("https://api.clockify.me/api/v1")
POST <- function(path, body = NULL) {
  url <- api_url(path)
  httr::POST(
    url,
    body = body,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json"
  )
}
