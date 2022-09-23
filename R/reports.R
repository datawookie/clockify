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
#'
#' @return A data frame with summarised time entries for the specified time period.
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
reports_summary <- function(start, end) {
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

  response <- POST(
    path,
    body = body
  ) %>% content()

  response$groupOne %>% map_dfr(
    function(user) {
      # Unpack data for each user.
      tibble(
        user_name = user$name,
        duration = user$duration,
        amount = user$amount,
        amounts = map(user$amounts, ~ map_dfr(., identity)),
        projects = list(
          map_dfr(
            user$children,
            function(project) {
              # Unpack data for each client/project.
              tibble(
                client_name = project$clientName,
                project_name = project$name,
                duration = project$duration,
                amount = project$amount,
                entries = list(
                  map_dfr(
                    project$children,
                    function(entry) {
                      # Unpack data for each time entry.
                      entry$amounts <- NULL
                      as_tibble(entry) %>%
                        clean_names() %>%
                        select(id, description = name, duration, amount)
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
#'
#' @return A data frame with detailed time entries for the specified time period.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' report <- reports_detailed("2022-08-01", "2022-09-01")
#' }
reports_detailed <- function(start, end) {
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
    select(-project_color) %>%
    unnest_wider(time_interval)
}

#' Weekly report
#'
#' @inheritParams reports-parameters
#'
#' @return A data frame with a weekly summary of time entries for the specified time period.
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
reports_weekly <- function(start, end) {
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

  response <- POST(
    path,
    body = body
  ) %>% content()

  response$groupOne %>% map_dfr(
    function(user) {
      # Unpack data for each user.
      tibble(
        user_name = user$name,
        duration = user$duration,
        amount = user$amount,
        projects = list(
          map_dfr(
            user$children,
            function(project) {
              # Unpack data for each client/project.
              tibble(
                client_name = project$clientName,
                project_name = project$name,
                duration = project$duration,
                amount = project$amount
              )
            }
          )
        )
      )
    }
  )
}
