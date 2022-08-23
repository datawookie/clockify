api_url <- function(path) {
  paste0(BASE_PATH, path)
}

check_response <- function(response) {
  if (http_error(response)) {
    stop(http_status(response)$message, call. = FALSE)
  }
}

#' GET an URL
#'
#' @noRd
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

#' POST file to an URL
#'
#' @noRd
#'
#' @param path The path of the endpoint.
#' @param body The body of the query.
#'
#' @inherit httr::POST return
POST <- function(path, body = NULL, query = NULL) {
  url <- api_url(path)
  log_debug("POST {path}")

  response <- httr::POST(
    url,
    body = body,
    query = query,
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
#' @noRd
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

#' PUT
#'
#' @noRd
#'
#' @param path The path of the endpoint.
#'
#' @inherit httr::PUT return
PUT <- function(path, body = NULL) {
  url <- api_url(path)
  log_debug("PUT {path}")

  response <- httr::PUT(
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

#' PATCH
#'
#' @noRd
#'
#' @param path The path of the endpoint.
#'
#' @inherit httr::PATCH return
PATCH <- function(path, body = NULL) {
  url <- api_url(path)
  log_debug("PATCH {path}")

  response <- httr::PATCH(
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
