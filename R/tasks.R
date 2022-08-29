# Columns which might not be present in data.
#
EXTRA_COLS <- c(assignee_ids = NA_character_)

#' Helper function for parsing tags
#'
#' @noRd
#'
parse_tasks <- function(tasks) {
  if (!length(tasks)) {
    NULL
  } else {
    tibble(tasks) %>%
      unnest_wider(tasks) %>%
      clean_names() %>%
      add_column(!!!EXTRA_COLS[!names(EXTRA_COLS) %in% names(.)]) %>%
      select(-assignee_id) %>%
      rename(assignee_id = assignee_ids) %>%
      select(id, name,  project_id, status, billable, assignee_id)
  }
}

#' Get tasks
#'
#' @param project_id Project ID
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' workspace("61343c45ab05e02be2c8c1fd")
#' tasks("61343c9ba15c1d53ad33369f")
#' }
tasks <- function(project_id) {
  path <- sprintf("/workspaces/%s/projects/%s/tasks", workspace(), project_id)

  GET(path) %>%
    content() %>%
    parse_tasks()
}

#' Get task
#'
#' @param project_id Project ID
#' @param task_id Task ID
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' workspace("61343c45ab05e02be2c8c1fd")
#' tasks("61343c9ba15c1d53ad33369f")
#' }
task <- function(project_id, task_id) {
  path <- sprintf("/workspaces/%s/projects/%s/tasks/%s", workspace(), project_id, task_id)

  GET(path) %>%
    content() %>%
    list() %>%
    parse_tasks()
}
