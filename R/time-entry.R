EMPTY_ENTRIES <- tibble(
  id = character(),
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
  entries <- tibble(entries) %>%
    unnest_wider(entries) %>%
    unnest_wider(timeInterval) %>%
    clean_names() %>%
    select(
      id,
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
      duration = as.numeric(difftime(time_end, time_start, units = "mins"))
    ) %>%
    arrange(time_start)

  if (finished) {
    entries <- entries %>%
      filter(!is.na(time_end))
  }

  if (concise) {
    entries %>%
      select(
        id, project_id, description, duration
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
#' @param user_id User ID
#' @param start If provided, only time entries that started after the specified datetime will be returned.
#' @param end If provided, only time entries that started before the specified datetime will be returned.
#' @param description If provided, time entries will be filtered by description.
#' @param project If provided, time entries will be filtered by project.
#' @param task If provided, time entries will be filtered by task.
#' @param tags If provided, time entries will be filtered by tags. You can provide one or more tags.
#' @param finished Whether to include only finished time intervals (intervals with both start and end time)
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
time_entries <- function(user_id = NULL, start = NULL, end = NULL, description = NULL, project = NULL, task = NULL, tags = NULL, finished = TRUE, concise = TRUE, ...) {
  if (is.null(user_id)) {
    user_id <- user(concise = FALSE)$user_id
  }
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
  if (!is.null(project)) {
    query$project <- project
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

  entries <- paginate(path, query, ...)

  if (length(entries)) {
    entries <- parse_time_entries(entries, finished, concise)

    if (nrow(entries) == 0) {
      log_debug("No time entries for specified user.")
      entries <- EMPTY_ENTRIES
    }
  } else {
    entries <- EMPTY_ENTRIES
  }

  entries
}

#' Get a specific time entry on workspace
#'
#' Wraps \code{GET /workspaces/{workspaceId}/time-entries/{id}}.
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

#' Insert a time entry
#'
#' You can only insert time entries for the authenticated user.
#'
#' @param project_id Project ID
#' @param start Start time
#' @param end End time
#' @param description Description
#'
#' @return A time entry ID.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' time_entry(
#'   project_id = "600e73263e207962449a2c13",
#'   start = "2021-01-02 08:00:00",
#'   end   = "2021-01-02 10:00:00",
#'   description = "Doing stuff"
#' )
#' }
time_entry_insert <- function(
  project_id = NULL,
  start,
  end = NULL,
  description = NULL
) {
  log_debug("Insert time entry.")

  path <- sprintf("/workspaces/%s/time-entries", workspace())

  # Convert start and end times to POSIXct.
  #
  if (!is.POSIXct(start)) start <- anytime(start)
  if (!is.POSIXct(end)) end <- anytime(end)

  body = list()

  if (!is.null(start)) {
    body$start = time_format(start)
  } else {
    stop("Start time must be provided!", call. = FALSE)
  }
  if (!is.null(end)) {
    body$end = time_format(end)
  }
  if (!is.null(project_id)) {
    body$projectId = project_id
  }
  if (!is.null(description)) {
    body$description = description
  }

  result <- POST(
    path,
    body = body
  )

  httr::content(result) %>%
    list() %>%
    parse_time_entries(finished = FALSE, concise = FALSE) %>%
    pull(id)
}

#' Delete a time entry
#'
#' @param time_entry_id Time entry ID
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
  log_debug("Delete time entry.")

  path <- sprintf("/workspaces/%s/time-entries/%s", workspace(), time_entry_id)
  result <- DELETE(path)
  status_code(result) == 204
}
