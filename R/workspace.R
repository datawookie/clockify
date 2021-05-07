#' Title
#'
#' @return
#' @export
#'
#' @examples
workspaces <- function() {
  workspaces <- GET("workspaces")
  content(workspaces)
}

#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
workspace_user_groups <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/user-groups", workspace_id)
  user <- GET(path)
  content(user)
}

#' Title
#'
#' @return
#' @export
#'
#' @examples
workspace_users <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/users", workspace_id)
  workspaces <- GET(path)
  content(workspaces)
}
