#' Title
#'
#' @param path The path of the endpoint.
#' @param pages Maximum number of pages to retrieve.
#' @param query The query parameters.
#' @param page_size Number of results requested per page.
#'
#' @return Paginated response from API.
paginate <- function(path, query = NULL, pages = NULL, page_size = 50) {
  if (is.null(query)) query <- list()

  page <- 1
  #
  # TODO: This is deeply inefficient?
  #
  results <- list()
  #
  while (TRUE) {
    result <- GET(
      path,
      query = c(query, list(page = page, "page-size" = page_size))
    )
    result <- content(result)

    records <- length(result)

    if (records == 0) {
      log_debug("Page is empty.")
      break
    } else {
      log_debug("Page contains {records} results.")
    }

    results <- append(results, result)

    if (
      # Have retrieved required number of pages.
      (!is.null(pages) && page >= pages) ||
        # Last page is not full.
        (records < page_size)
    ) {
      break
    } else {
      page <- page + 1
    }
  }

  log_debug("API returned {length(results)} results.")

  results
}
