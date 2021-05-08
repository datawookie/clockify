api_url <- function(path) {
  file.path(BASE_PATH, path)
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
  print(url)
  httr::GET(
    url,
    query = query,
    add_headers(
      "X-Api-Key" = get_api_key()
    )
  )
}
