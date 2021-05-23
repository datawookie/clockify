#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
user_groups <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/user-groups", workspace_id)
  user <- GET(path)
  content(user)
}
