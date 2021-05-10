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
workspace_clients <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/clients", workspace_id)
  clients <- GET(path)
  content(clients) %>%
    map_df(function(client) {
      with(
        client,
        tibble(
          client_id = id,
          name,
          workspaceId,
          archived,
          address = ifelse(is.null(address) || address == "", NA, address)
        )
      )
    }) %>%
    clean_names()
}

#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
workspace_projects <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/projects", workspace_id)
  projects <- GET(path)
  content(projects) %>%
    map_df(function(project) {
      with(
        project,
        tibble(
          project_id = id,
          name,
          clientId,
          workspaceId,
          billable,
          public,
          template
        )
      )
    }) %>%
    clean_names()
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
#' @param workspace_id
#' @param user_id
#' @param start
#' @param end
#' @param finished Whether to include only finished time intervals (intervals with both start and end time).
#'
#' @return
#' @export
#'
#' @examples
#' # Specify number of results per page (default: 50).
#' time_entries <- clockify::time_entries(workspace_id, user_id, page_size = 200)
#' # Specify number of pages.
#' time_entries <- clockify::time_entries(workspace_id, user_id, pages = 3)
time_entries <- function(workspace_id, user_id, start = NULL, end = NULL, finished = TRUE, ...) {
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace_id, user_id)

  query = list()

  if (!is.null(start)) {
    query$start = time_format(start)
  }
  if (!is.null(end)) {
    query$end = time_format(end)
  }

  time_entries <- paginate(path, query, ...)

  time_entries <- time_entries %>%
    map_df(function(entry) {
      with(
        entry,
        tibble(
          id,
          user_id = userId,
          workspace_id = workspaceId,
          project_id = null_to_na(projectId),
          billable,
          description,
          time_start = null_to_na(timeInterval$start),
          time_end = null_to_na(timeInterval$end)
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
      time_end = character()
    )
  }

  if (finished) {
    time_entries <- time_entries %>%
      filter(!is.na(time_end))
  }

  time_entries %>%
    mutate(
      time_start = time_parse(time_start),
      time_end = time_parse(time_end),
      duration = as.numeric(difftime(time_end, time_start, units = "mins"))
    ) %>%
    arrange(time_start)
}
