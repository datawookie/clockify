api_url <- function(path) {
  paste0(BASE_PATH, path)
}

#' Title
#'
#' @param path
#' @param query
#'
#' @return
#' @export
#'
#' @examples
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
