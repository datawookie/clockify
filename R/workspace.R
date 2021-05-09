#' Title
#'
#' @return
#' @export
#'
#' @examples
workspaces <- function() {
  workspaces <- GET("/workspaces")
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

#' Title
#'
#' @param entry
#'
#' @return
#' @export
#'
#' @examples
#' # Specify number of results per page (default: 50).
#' time_entries <- clockify::time_entries(workspace_id, user_id, page_size = 200)
#' # Specify number of pages.
#' time_entries <- clockify::time_entries(workspace_id, user_id, pages = 3)
time_entries <- function(workspace_id, user_id, start = NULL, end = NULL, ...) {
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace_id, user_id)

  query = list()

  if (!is.null(start)) {
    query$start = time_format(start)
  }
  if (!is.null(end)) {
    query$end = time_format(end)
  }

  # TODO: Limit time period rather than specifying number of pages.
  time_entries <- paginate(path, query, ...)

  time_entries <- time_entries %>%
    map_df(function(entry) {
      with(
        entry,
        tibble(
          id,
          user_id = userId,
          workspace_id = workspaceId,
          project_id = projectId,
          billable,
          description,
          time_start = timeInterval$start,
          time_end = timeInterval$end
        )
      )
    }) %>%
    clean_names()

  if (nrow(time_entries) == 0) {
    log_debug("No time entries for specified user.")
    time_entries <- tibble(
      id = character(),
      user_id = character(),
      workspace_id = character(),
      project_id = character(),
      billable = logical(),
      description = character(),
      time_start = character(),
      time_end = character(),
      duration = numeric()
    )
  }

  time_entries %>%
    mutate(
      time_start = time_parse(time_start),
      time_end = time_parse(time_end),
      duration = as.numeric(difftime(time_end, time_start, units = "mins"))
    ) %>%
    arrange(time_start)
}
