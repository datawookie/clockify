#' Title
#'
#' @return
#' @export
#'
#' @examples
workspaces <- function() {
  workspaces <- GET("/workspaces")
  content(workspaces) %>%
    map_df(function(workspace) {
      with(
        workspace,
        tibble(
          workspace_id = id,
          name
        )
      )
    })
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
