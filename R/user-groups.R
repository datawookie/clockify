#' Get user groups
#'
#' @return A data frame with one record per user group.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' user_groups()
user_groups <- function() {
  path <- sprintf("/workspaces/%s/user-groups", workspace())
  GET(path) %>%
    content()
}
