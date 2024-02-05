api_url <- function(path) {
  if (grepl("reports", path)) {
    base_path <- REPORTS_BASE_PATH
  } else {
    base_path <- BASE_PATH
  }

  paste0(base_path, path)
}

check_response <- function(response) {
  if (http_error(response)) {
    log_debug("URL: {response$url}")
    log_debug("response headers:")
    iwalk(response$headers, ~ log_debug("  {format(.y, width = 24)}: {.x}"))
    log_debug("request headers:")
    iwalk(response$request$headers, ~ log_debug("  {format(.y, width = 24)}: {.x}"))

    postfields <- response$request$options$postfields

    if (!is.null(postfields) && is(postfields, "raw")) {
      log_debug("body: {rawToChar(postfields)}")
    }
    log_error("message: {content(response)$message}")
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
GET <- function(path, query = NULL, ...) {
  url <- api_url(path)
  log_debug("GET {url}")

  response <- httr::GET(
    url,
    query = query,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    ...
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
POST <- function(path, body = NULL, query = NULL, ...) {
  url <- api_url(path)
  log_debug("POST {url}")

  response <- httr::POST(
    url,
    body = body,
    query = query,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json",
    ...
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
DELETE <- function(path, ...) {
  url <- api_url(path)
  log_debug("DELETE {url}")

  response <- httr::DELETE(
    url,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json",
    ...
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
PUT <- function(path, body = NULL, ...) {
  url <- api_url(path)
  log_debug("PUT {url}")

  response <- httr::PUT(
    url,
    body = body,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json",
    ...
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
PATCH <- function(path, body = NULL, ...) {
  url <- api_url(path)
  log_debug("PATCH {url}")

  response <- httr::PATCH(
    url,
    body = body,
    add_headers(
      "X-Api-Key" = get_api_key()
    ),
    encode = "json",
    ...
  )

  check_response(response)

  response
}
