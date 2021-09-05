#' Helper function for parsing tags
#'
#' @noRd
#'
parse_tags <- function(tags) {
  tibble(tags) %>%
    unnest_wider(tags) %>%
    select(id, workspaceId, everything()) %>%
    clean_names()
}

#' Get tags
#'
#' Wraps \code{GET /workspaces/{workspaceId}/tags}.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' tags()
#' }
tags <- function() {
  path <- sprintf("/workspaces/%s/tags", workspace())

  paginate(path) %>%
    parse_tags()
}
