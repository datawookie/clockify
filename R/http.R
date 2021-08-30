api_url <- function(path) {
  paste0(BASE_PATH, path)
}

check_response <- function(response) {
  if (status_code(response) == 404) {
    stop("Page not found!", call. = FALSE)
  }
}

#' GET a url
#'
#' @param path The path of the endpoint.
#' @param query The query parameters.
#'
#' @inherit httr::GET return
GET <- function(path, query = NULL) {
  url <- api_url(path)
  log_debug("GET {path}")

  response <- httr::GET(
    url,
    query = query,
    add_headers(
      "X-Api-Key" = get_api_key()
    )
  )

  check_response(response)

  response
}

#' POST file to a server
#'
#' @param path The path of the endpoint.
#' @param body The body of the query.
#'
#' @inherit httr::POST return
POST <- function(path, body = NULL) {
  url <- api_url(path)
  log_debug("POST {path}")

  response <- httr::POST(
    url,
    body = body,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json"
  )

  check_response(response)

  response
}

#' DELETE
#'
#' @param path The path of the endpoint.
#'
#' @inherit httr::DELETE return
DELETE <- function(path) {
  url <- api_url(path)
  log_debug("DELETE {path}")

  response <- httr::DELETE(
    url,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json"
  )

  check_response(response)

  response
}
