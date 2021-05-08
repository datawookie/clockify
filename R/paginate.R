#' Title
#'
#' @param path
#' @param pages Maximum number of pages to retrieve.
#'
#' @return
#' @export
#'
#' @examples
paginate <- function(path, pages = NULL) {
  page <- 1
  #
  # TODO: This is deeply inefficient?
  #
  results <- list()
  #
  while (TRUE) {
    print(page)
    result <- GET(path, query = list(page = page))
    result <- content(result)
    print(length(result))
    page <- page + 1

    results <- append(results, result)

    if (!is.null(pages) && page > pages) break
  }

  results
}
