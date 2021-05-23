#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
user_groups <- function() {
  path <- sprintf("/workspaces/%s/user-groups", workspace())
  user <- GET(path)
  content(user)
}
