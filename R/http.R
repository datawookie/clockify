api_url <- function(path) {
  file.path(BASE_PATH, path)
}

GET <- function(path) {
  url <- api_url(path)
  httr::GET(
    url,
    add_headers(
      "X-Api-Key" = get_api_key()
    )
  )
}
