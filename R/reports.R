#' Reports Parameters
#'
#' These are parameters which occur commonly across functions for reports.
#'
#' @name reports-parameters
#'
#' @param start Start time
#' @param end End time
NULL

#' Summary report
#'
#' @inheritParams reports-parameters
#' @param extra_args Extra arguments to be passed to the
#'   [API](https://docs.clockify.me/#tag/Time-Entry-Report/operation/generateSummaryReport).
#'   Example: `extra_args = list(rounding = TRUE)`.
#'
#' @return A data frame with summarised time entries for the specified time
#'   period. Time entries are summarised per description, so the `entries`
#'   don't have an ID. Billable rates are not available on the Free plan (since
#'   June 2026), so for Free workspaces the `amount` columns are `NA` and
#'   `amounts` is empty.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' report <- reports_summary("2022-08-01", "2022-09-01")
#'
#' # Summary per user.
#' report
#' # Summary per client/project.
#' report %>%
#'   select(-duration, -amount, -amounts) %>%
#'   unnest(projects)
#' # Summary per time entry.
#' report %>%
#'   select(-duration, -amount, -amounts) %>%
#'   unnest(projects) %>%
#'   select(-duration, -amount) %>%
#'   unnest(entries)
#' }
reports_summary <- function(start, end, extra_args = list()) {
  path <- sprintf("/workspaces/%s/reports/summary", workspace())

  body <- list(
    dateRangeStart = time_format(start),
    dateRangeEnd = time_format(end),
    summaryFilter = list(
      groups = c(
        "USER",
        "PROJECT",
        "TIMEENTRY"
      )
    ),
    timeZone = "Etc/UTC"
  )
  body[names(extra_args)] <- extra_args

  response <- POST(
    path,
    body = body
  ) %>% content()

  response$groupOne %>% map_dfr(
    function(user) {
      # Unpack data for each user.
      #
      # On the Free plan `amount` is missing and `amounts` is empty, which would
      # otherwise collapse the row to nothing. Use [[ ]] for `amount` because $
      # partially matches `amounts` when `amount` is missing.
      tibble(
        user_id = user$`_id`,
        user_name = user$name,
        duration = user$duration,
        amount = user[["amount"]] %||% NA_real_,
        amounts = if (length(user$amounts)) {
          map(user$amounts, ~ map_dfr(., identity))
        } else {
          list(tibble())
        },
        projects = list(
          map_dfr(
            user$children,
            function(project) {
              # Unpack data for each client/project.
              tibble(
                project_id = project$`_id`,
                client_name = project$clientName,
                project_name = project$name,
                duration = project$duration,
                amount = project[["amount"]] %||% NA_real_,
                entries = list(
                  map_dfr(
                    project$children,
                    function(entry) {
                      # Unpack data for each time entry description.
                      #
                      # Entries are grouped by description, so there's no time
                      # entry ID. The `_id` is a list of the group keys (user,
                      # project and description), which would otherwise give
                      # one row per key.
                      entry$amounts <- NULL
                      entry$`_id` <- NULL
                      as_tibble(entry) %>%
                        clean_names() %>%
                        ensure_columns(amount = NA_real_) %>%
                        select(description = name, duration, amount)
                    }
                  )
                )
              )
            }
          )
        )
      )
    }
  )
}

#' Detailed report
#'
#' @inheritParams reports-parameters
#' @param extra_args Extra arguments to be passed to the
#'  [API](https://docs.clockify.me/#tag/Time-Entry-Report).
#'  Example: `extra_args = list(rounding = TRUE)`.
#'
#' @return A data frame with detailed time entries for the specified time period.
#'   Billable rates are not available on the Free plan (since June 2026), so for
#'   Free workspaces the `amount` and `rate` columns are `NA`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' report <- reports_detailed("2022-08-01", "2022-09-01")
#' }
reports_detailed <- function(start, end, extra_args = list()) {
  path <- sprintf("/workspaces/%s/reports/detailed", workspace())

  body <- list(
    dateRangeStart = time_format(start),
    dateRangeEnd = time_format(end),
    detailedFilter = list(
      page = 1,
      pageSize = 50
    ),
    timeZone = "Etc/UTC"
  )
  body[names(extra_args)] <- extra_args

  results <- list()
  #
  while (TRUE) {
    log_debug("Page {body$detailedFilter$page}.")
    response <- POST(
      path,
      body = body
    ) %>% content()

    entries <- tibble(entries = response$timeentries) %>%
      unnest_wider(entries)

    if (!nrow(entries)) break

    results <- append(results, list(entries))

    body$detailedFilter$page <- body$detailedFilter$page + 1
  }

  results %>%
    bind_rows() %>%
    clean_names() %>%
    # Since June 2026 billable rates are not available on the Free plan, so the
    # API omits these fields. See
    # https://forum.clockify.me/t/breaking-change-to-the-reports-detailed-time-entry/10035.
    ensure_columns(amount = NA_real_, rate = NA_real_) %>%
    select(-project_color) %>%
    unnest_wider(time_interval)
}

#' Weekly report
#'
#' @inheritParams reports-parameters
#' @param extra_args Extra arguments to be passed to the
#'  [API](https://docs.clockify.me/#tag/Time-Entry-Report/operation/generateSummaryReport).
#'  Example: `extra_args = list(rounding = TRUE)`.
#'
#' @return A data frame with a weekly summary of time entries for the specified
#'   time period. Billable rates are not available on the Free plan (since June
#'   2026), and for Free workspaces the API returns an `amount` of 0.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' report <- reports_weekly("2022-08-01", "2022-08-08")
#'
#' report %>%
#'   select(-duration, -amount) %>%
#'   unnest(projects)
#' }
reports_weekly <- function(start, end, extra_args = list()) {
  path <- sprintf("/workspaces/%s/reports/weekly", workspace())

  body <- list(
    dateRangeStart = time_format(start),
    dateRangeEnd = time_format(end),
    weeklyFilter = list(
      group = "USER",
      subgroup = "TIME"
    ),
    timeZone = "Etc/UTC"
  )
  body[names(extra_args)] <- extra_args

  response <- POST(
    path,
    body = body
  ) %>% content()

  response$groupOne %>% map_dfr(
    function(user) {
      # Unpack data for each user.
      tibble(
        user_id = user$`_id`,
        user_name = user$name,
        duration = user$duration,
        amount = user[["amount"]] %||% NA_real_,
        projects = list(
          map_dfr(
            user$children,
            function(project) {
              # Unpack data for each client/project.
              tibble(
                project_id = project$`_id`,
                client_name = project$clientName,
                project_name = project$name,
                duration = project$duration,
                amount = project[["amount"]] %||% NA_real_
              )
            }
          )
        )
      )
    }
  )
}
