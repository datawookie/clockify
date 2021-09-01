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

time_entries_parse <- function(entries, finished, concise) {
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
        project_id, description, duration
      )
  } else {
    entries
  }
}

#' Get time entries
#'
#' @inheritParams users
#'
#' @param user_id User ID
#' @param start Start time
#' @param end End time
#' @param finished Whether to include only finished time intervals (intervals with both start and end time).
#' @param ... Further arguments passed to \code{\link{paginate}}.
#'
#' @return A data frame with one record per time entry.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' USER_ID <- "612b15a4f4c3bf0462192676"
#'
#' \dontrun{
#' # Specify number of results per page (default: 50).
#' time_entries(USER_ID, page_size = 200)
#' # Specify number of pages.
#' time_entries(USER_ID, pages = 3)
#' }
time_entries <- function(user_id = NULL, start = NULL, end = NULL, finished = TRUE, concise = TRUE, ...) {
  if (is.null(user_id)) {
    user_id <- user(concise = FALSE)$user_id
  }
  path <- sprintf("/workspaces/%s/user/%s/time-entries", workspace(), user_id)

  query = list()

  if (!is.null(start)) {
    query$start = time_format(start)
    log_debug("start time: {start} - {query$start}")
  }
  if (!is.null(end)) {
    query$end = time_format(end)
    log_debug("end time:   {end} - {query$end}")
  }

  entries <- paginate(path, query, ...)

  if (length(entries)) {
    entries <- time_entries_parse(entries, finished, concise)

    if (nrow(entries) == 0) {
      log_debug("No time entries for specified user.")
      entries <- EMPTY_ENTRIES
    }
  }
  else {
    entries <- EMPTY_ENTRIES
  }

  entries
}

#' Insert a time entry
#'
#' You can only insert time entries for the authenticated used.
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
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' \dontrun{
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
    time_entries_parse(finished = FALSE, concise = FALSE) %>%
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
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' \dontrun{
#' time_entry_delete("612c7bd2a34530476ab25c67")
#' }
time_entry_delete <- function(time_entry_id = NULL) {
  log_debug("Delete time entry.")

  path <- sprintf("/workspaces/%s/time-entries/%s", workspace(), time_entry_id)
  result <- DELETE(path)
  status_code(result) == 204
}
