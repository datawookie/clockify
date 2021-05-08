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
  users <- GET(path)

  content(users) %>%
    map_df(function(user) {
      with(
        user,
        tibble(
          id,
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

time_entries <- function(workspace_id, user_id) {
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace_id, user_id)

  # TODO: Limit time period rather than specifying number of pages.
  time_entries <- paginate(path, 3)

  time_entries %>%
    map_df(function(entry) {
      with(
        entry,
        tibble(
          id,
          userId,
          workspaceId,
          projectId,
          billable,
          description,
          time_start = timeInterval$start,
          time_end = timeInterval$end
        )
      )
    })
}
