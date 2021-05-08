#' Title
#'
#' @param path
#' @param pages Maximum number of pages to retrieve.
#'
#' @return
#' @export
#'
#' @examples
paginate <- function(path, query = NULL, pages = NULL, page_size = 50) {
  if (is.null(query)) query = list()

  # query = list()
  # query$start <- "2020-12-16T05:15:32.998Z"

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

    if (!is.null(pages) && page >= pages) {
      break
    } else {
      page <- page + 1
    }
  }

  log_debug("API returned {length(results)} results.")

  results
}
