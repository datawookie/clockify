#' Title
#'
#' @return
#' @export
#'
#' @examples
user <- function() {
  user <- GET("/user")
  content(user)
}

#' Title
#'
#' @return
#' @export
#'
#' @examples
users <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/users", workspace_id)
  users <- GET(path)

  content(users) %>%
    map_df(function(user) {
      with(
        user,
        tibble(
          user_id = id,
          name,
          email,
          status,
          activeWorkspace,
          defaultWorkspace
        )
      )
    }) %>%
    clean_names()
}
