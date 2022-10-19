EMPTY_ENTRIES <- tibble(
  time_entry_id = character(),
  user_id = character(),
  workspace_id = character(),
  project_id = character(),
  billable = logical(),
  description = character(),
  time_start = POSIXct(),
  time_end = POSIXct(),
  duration = numeric()
)

parse_time_entries <- function(entries, finished, concise) {
  if (length(entries)) {
    entries <- tibble(entries) %>%
      unnest_wider(entries) %>%
      unnest_wider(timeInterval) %>%
      clean_names() %>%
      select(
        time_entry_id = id,
        user_id,
        workspace_id,
        project_id,
        billable,
        description,
        time_start = start,
        time_end = end
      ) %>%
      mutate(
        time_start = time_parse(time_start),
        time_end = time_parse(time_end),
        duration = as.numeric(difftime(time_end, time_start, units = get_option_duration_units()))
      ) %>%
      arrange(time_start)

    if (finished) {
      entries <- entries %>%
        filter(!is.na(time_end))
    }
  } else {
    entries <- EMPTY_ENTRIES
  }

  if (concise) {
    entries %>%
      select(
        time_entry_id, project_id, description, duration
      )
  } else {
    entries
  }
}

#' Get time entries
#'
#' You send time according to your account's timezone (from Profile Settings) and get response with time in UTC.
#'
#' @inheritParams users
#'
#' @param user_id User ID. If not specified then use authenticated user.
#' @param start If provided, only time entries that started after the specified datetime will be returned.
#' @param end If provided, only time entries that started before the specified datetime will be returned.
#' @param description If provided, time entries will be filtered by description.
#' @param project_id If provided, time entries will be filtered by project.
#' @param task If provided, time entries will be filtered by task.
#' @param tags If provided, time entries will be filtered by tags. You can provide one or more tags.
#' @param finished Whether to include only finished time intervals (intervals with both start and end time).
#' @param ... Further arguments passed to \code{\link{paginate}}.
#'
#' @return A data frame with one record per time entry.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' USER_ID <- "612b15a4f4c3bf0462192676"
#'
#' # Specify number of results per page (default: 50).
#' time_entries(USER_ID, page_size = 200)
#' # Specify number of pages.
#' time_entries(USER_ID, pages = 3)
#' }
time_entries <- function(user_id = NULL,
                         start = NULL,
                         end = NULL,
                         description = NULL,
                         project_id = NULL,
                         task = NULL,
                         tags = NULL,
                         finished = TRUE,
                         concise = TRUE,
                         ...) {
  if (is.null(user_id)) user_id <- user_get_id()
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace(), user_id)

  query <- list()

  if (!is.null(start)) {
    query$start <- time_format(start)
    log_debug("start time: {start} - {query$start}")
  }
  if (!is.null(end)) {
    query$end <- time_format(end)
    log_debug("end time:   {end} - {query$end}")
  }
  if (!is.null(description)) {
    query$description <- description
  }
  if (!is.null(project_id)) {
    query$project <- project_id
  }
  if (!is.null(task)) {
    query$task <- task
  }
  if (!is.null(tags)) {
    # Multiple tags need to be passed as separate parameters. For example,
    # ?tags=tagId_1&tags=tagId_2.
    #
    tag_list <- as.list(setNames(tags, rep("tags", length(tags))))
    query <- c(query, tag_list)
  }

  parse_time_entries(paginate(path, query, ...), finished, concise)
}

#' Get a specific time entry on workspace
#'
#' @inheritParams users
#'
#' @param time_entry_id Time entry ID
#'
#' @return A data frame with one record per time entry.
#' @export
#'
#' @examples
#' \dontrun{
#' time_entry("61343d27ab05e02be2c8c266")
#' }
time_entry <- function(time_entry_id, concise = TRUE) {
  path <- sprintf("/workspaces/%s/time-entries/%s", workspace(), time_entry_id)

  GET(path) %>%
    content() %>%
    list() %>%
    parse_time_entries(finished = FALSE, concise = concise)
}

#' Time Entry Parameters
#'
#' These are parameters which occur commonly across functions for time entries.
#'
#' @name time-entry-parameters
#'
#' @param time_entry_id Time entry ID
#' @param project_id Project ID
#' @param start Start time
#' @param end End time
#' @param description Description
NULL

prepare_body <- function(project_id,
                         start,
                         end,
                         description,
                         task_id) {
  body <- list()

  if (!is.null(start)) {
    if (!is.POSIXct(start)) start <- anytime(start)
    body$start <- time_format(start)
  }
  if (!is.null(end)) {
    if (!is.POSIXct(end)) end <- anytime(end)
    body$end <- time_format(end)
  }
  if (!is.null(project_id)) {
    body$projectId <- project_id
  }
  if (!is.null(description)) {
    body$description <- description
  }
  if (!is.null(task_id)) {
    body$taskId <- task_id
  }

  body
}

#' Create a time entry
#'
#' Creating time entries for other users is a paid feature.
#'
#' @inheritParams time-entry-parameters
#' @param user_id User ID
#' @param task_id Task ID
#'
#' @return A time entry ID.
#' @export
#'
#' @examples
#' \dontrun{
#' # Create a time entry for the authenticated user.
#' time_entry_create(
#'   project_id = "600e73263e207962449a2c13",
#'   start = "2021-01-02 08:00:00",
#'   end = "2021-01-02 10:00:00",
#'   description = "Doing stuff"
#' )
#' # Create a time entry for another user (paid feature).
#' time_entry_create(
#'   "5df56293df753263139e60c5",
#'   "600e73263e207962449a2c13",
#'   "2021-01-02 10:00:00",
#'   "2021-01-02 12:00:00",
#'   "Doing other stuff"
#' )
#' }
time_entry_create <- function(user_id = NULL,
                              project_id = NULL,
                              start,
                              end = NULL,
                              description = NULL,
                              task_id = NULL) {
  path <- sprintf("/workspaces/%s/", workspace())
  if (!is.null(user_id) && user_id != user()$user_id) {
    warning("Inserting time entries for other users is a paid feature.", call. = FALSE, immediate. = TRUE)
    path <- paste0(path, sprintf("user/%s/", user_id))
  }
  path <- paste0(path, "time-entries")

  body <- prepare_body(project_id, start, end, description, task_id)

  result <- POST(
    path,
    body = body
  )

  content(result) %>%
    list() %>%
    parse_time_entries(finished = FALSE, concise = FALSE)
}

#' Delete a time entry
#'
#' @inheritParams time-entry-parameters
#'
#' @return A Boolean: \code{TRUE} on success or \code{FALSE} on failure.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' time_entry_delete("612c7bd2a34530476ab25c67")
#' }
time_entry_delete <- function(time_entry_id = NULL) {
  path <- sprintf("/workspaces/%s/time-entries/%s", workspace(), time_entry_id)
  result <- DELETE(path)
  status_code(result) == 204
}

#' Replace a time entry
#'
#' This does not update the time entry. It uses the same time entry ID but sets
#' all details from scratch.
#'
#' @inheritParams time-entry-parameters
#'
#' @export
time_entry_set <- function(time_entry_id,
                           project_id = NULL,
                           start,
                           end = NULL,
                           description = NULL) {
  log_debug("Set time entry.")

  path <- sprintf("/workspaces/%s/time-entries/%s", workspace(), time_entry_id)

  body <- prepare_body(project_id, start, end, description, NULL)

  result <- PUT(
    path,
    body = body
  )

  content(result) %>%
    list() %>%
    parse_time_entries(finished = FALSE, concise = FALSE)
}

#' Mark time entries as invoiced
#'
#' The `time_entry_invoiced()` function will only work on a paid plan.
#'
#' @inheritParams time-entry-parameters
#' @param invoiced Has this time entry been invoiced?
#'
#' @export
time_entry_invoiced <- function(time_entry_id,
                                invoiced = TRUE) {
  log_debug("Mark time entry as invoiced.")

  path <- sprintf("/workspaces/%s/time-entries/invoiced", workspace())

  body <- list(
    timeEntryIds = I(c(time_entry_id)),
    invoiced = invoiced
  )

  result <- PATCH(
    path,
    body = body
  )
  status_code(result) == 200
}

#' Stop currently running timer
#'
#' @inheritParams time-entry-parameters
#' @param user_id User ID. If not specified then use authenticated user.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Start timer running.
#' time_entry_create(
#'   user_id = "5df56293df753263139e60c5",
#'   project_id = "600e73263e207962449a2c13",
#'   start = "2022-09-02 14:00:00",
#'   description = "Doing other stuff"
#' )
#' # Stop timer.
#' time_entry_stop(
#'   user_id = "5df56293df753263139e60c5",
#'   end = "2022-09-02 15:00:00"
#' )
#' }
time_entry_stop <- function(user_id = NULL,
                            end = NULL) {
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace(), user_id)

  body <- prepare_body(NULL, NULL, end, NULL, NULL)

  result <- PATCH(
    path,
    body = body
  )

  content(result) %>%
    list() %>%
    parse_time_entries(finished = FALSE, concise = FALSE)
}
