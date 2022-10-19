EMPTY_TASKS <- tibble(
  task_id = character(),
  name = character(),
  project_id = character(),
  status = character(),
  billable = logical(),
  assignees = list()
)

EMPTY_ASSIGNEES <- tibble(user_id = list())

#' Helper function for parsing tasks
#'
#' @noRd
#'
parse_tasks <- function(tasks) {
  if (!length(tasks)) {
    EMPTY_TASKS
  } else {
    tibble(tasks) %>%
      unnest_wider(tasks) %>%
      clean_names() %>%
      select(-assignee_id) %>%
      rename(assignees = assignee_ids) %>%
      select(task_id = id, name, project_id, status, billable, assignees) %>%
      mutate(
        assignees = map(assignees, ~ if (is.null(.)) {
          NA
        } else {
          unlist(.)
        }),
        assignees = map(
          assignees,
          ~ if (length(.) == 1 && is.na(.)) {
            EMPTY_ASSIGNEES
          } else {
            tibble(user_id = .)
          }
        )
      )
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
#' @name task
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

#' Create a task
#'
#' @name task-create
#'
#' @param project_id Project ID
#' @param name Task name
#'
#' @export
#'
#' @examples
#' \dontrun{
#' task_create("630ce53290cfd8789366fd49", "tests")
#' task_create("630ce53290cfd8789366fd49", "docs")
#' }
task_create <- function(project_id, name) {
  body <- list(
    name = name
  )

  result <- POST(
    sprintf("/workspaces/%s/projects/%s/tasks", workspace(), project_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tasks()
}

#' Update a task
#'
#' @inheritParams task
#' @inheritParams task-create
#' @param billable Is the task billable?
#' @param status Is the task ACTIVE or DONE?
#' @param assignee_id Assignee ID
#'
#' @export
#'
#' @examples
#' \dontrun{
#' task_update("630ce53290cfd8789366fd49", "630ce57e25e863294e5c6cf2", "Tests")
#' task_create("630ce53290cfd8789366fd49", "630ce80a7f07da44c14ca9a2", "Docs", FALSE)
#' }
task_update <- function(project_id, task_id, name, billable = NULL, status = NULL, assignee_id = NULL) {
  if (!is.null(assignee_id)) assignee_id <- as.list(assignee_id)

  body <- list(
    name = name,
    billable = billable,
    status = status,
    assigneeIds = assignee_id
  ) %>% list_remove_empty()

  result <- PUT(
    sprintf("/workspaces/%s/projects/%s/tasks/%s", workspace(), project_id, task_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tasks()
}

#' Update task billable rate
#'
#' This feature is only available on the Standard, Pro and Enterprise plans.
#'
#' @inheritParams task
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
task_update_billable_rate <- function(project_id, task_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = time_format(since)
  ) %>% list_remove_empty()

  result <- PUT(
    sprintf("/workspaces/%s/projects/%s/tasks/%s/hourly-rate", workspace(), project_id, task_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tasks()
}

#' Update task cost rate
#'
#' This feature is only available on the Pro and Enterprise plans.
#'
#' @inheritParams task
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
task_update_cost_rate <- function(project_id, task_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = time_format(since)
  )

  result <- PUT(
    sprintf("/workspaces/%s/projects/%s/tasks/%s/cost-rate", workspace(), project_id, task_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tasks()
}

#' Delete task
#'
#' @inheritParams task
#'
#' @export
#'
#' @examples
#' \dontrun{
#' task_delete("630ce53290cfd8789366fd49", "630ce57e25e863294e5c6cf2")
#' }
task_delete <- function(project_id, task_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/projects/%s/tasks/%s", workspace(), project_id, task_id)
  )
  status_code(result) == 200
}
