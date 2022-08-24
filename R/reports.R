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
#' @return A list with two elements, `totals` and `details`, each of which is a
#' data frame.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' report <- reports_summary("2022-08-01", "2022-09-01")
#'
#' # Summary per user.
#' report$details
#' # Summary per client/project.
#' report$details %>%
#'   select(-duration, -amount, -amounts) %>%
#'   unnest(children)
#' # Summary per time entry.
#' report$details %>%
#'   select(-duration, -amount, -amounts) %>%
#'   unnest(children) %>%
#'   select(-duration, -amount) %>%
#'   unnest(children)
#' }
reports_summary <- function(start, end) {
  path <- sprintf("/workspaces/%s/reports/summary", workspace())

  body <- list(
    dateRangeStart = clockify:::time_format(start),
    dateRangeEnd = clockify:::time_format(end),
    summaryFilter = list(
      groups = c(
        "USER",
        "PROJECT",
        "TIMEENTRY"
      )
    )
  )

  response <- clockify:::POST(
    path,
    body = body
  )

  response <- content(response)

  list(
    totals = tibble(totals = response$totals) %>%
      unnest_wider(totals) %>%
      select(-"_id") %>%
      mutate(
        amounts = map(amounts, ~ map_dfr(., identity))
      ),
    details = response$groupOne %>% map_dfr(
      function(user) {
        # Unpack data for each user.
        tibble(
          user_name = user$name,
          duration = user$duration,
          amount = user$amount,
          amounts = map(user$amounts, ~ map_dfr(., identity)),
          children = list(
            map_dfr(
              user$children,
              function(project) {
                # Unpack data for each client/project.
                tibble(
                  client_name = project$clientName,
                  project_name = project$name,
                  duration = project$duration,
                  amount = project$amount,
                  children = list(
                    map_dfr(
                      project$children,
                      function(entry) {
                        # Unpack data for each time entry.
                        tibble(
                          description = entry$name,
                          duration = entry$duration,
                          amount = entry$amount
                        )
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
  )
}

# - [ ] POST /workspaces/{workspaceId}/reports/detailed

#' Detailed report
#'
#' @export
reports_detailed <- function() {

}

# - [ ] POST /workspaces/{workspaceId}/reports/weekly

#' Weekly report
#'
#' @export
reports_weekly <- function() {

}

# - [ ] GET /workspaces/{workspaceId}/shared-reports
# - [ ] GET /shared-reports/{sharedReportId}

#' Get all shared reports
#'
#' @export
shared_reports_all <- function(shared_reports_id = NULL) {

}

# - [ ] POST /workspaces/{workspaceId}/shared-reports

#' Create a shared report
#'
#' @export
shared_reports_create <- function() {

}

# - [ ] PUT /workspaces/{workspaceId}/shared-reports/{sharedReportId}

#' Update a shared report
#'
#' @export
shared_reports_update <- function() {

}

# - [ ] DELETE /workspaces/{workspaceId}/shared-reports/{sharedReportId}

#' Delete a shared report
#'
#' @export
shared_reports_delete <- function() {

}
