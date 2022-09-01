#' Shared Reports Parameters
#'
#' These are parameters which occur commonly across functions for shared reports.
#'
#' @name shared-reports-parameters
#'
#' @param shared_report_id Identifier for a specific shared report
NULL

#' Get all shared reports
#'
#' @export
shared_reports <- function() {
  path <- sprintf("/workspaces/%s/shared-reports", workspace())

  query <- list(
    page = 1,
    pageSize = 50
  )

  reports <- list()

  while (TRUE) {
    response <- GET(
      path,
      query = query
    ) %>% content()

    if (!length(response$reports)) break

    reports <- c(reports, response$reports)

    query$page <- query$page + 1
  }

  tibble(reports = reports) %>%
    unnest_wider(reports) %>%
    clean_names() %>%
    select(
      shared_report_id = id,
      everything()
    )
}

#' Get a specific shared report
#'
#' @inheritParams shared-reports-parameters
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all shared reports.
#' shared_reports()
#' # Get specific shared report by shared report ID.
#' shared_report("6307f29f1bbd1d34e56b9eb7")
#' }
shared_report <- function(shared_report_id) {
  path <- sprintf("/shared-reports/%s", shared_report_id)

  report <- GET(
    path,
    query = query
  ) %>% content()

  tibble(group = report$groupOne) %>%
    unnest_wider(group) %>%
    clean_names() %>%
    select(id, name, client_name, duration, amount, amounts, children) %>%
    mutate(
      children = map(
        children,
        function(children) {
          map_dfr(children, identity) %>%
            mutate(
              amounts = map(amounts, ~ map_dfr(., identity))
            ) %>%
            clean_names() %>%
            select(id, name, duration, amount, amounts)
        }
      )
    )
}

#' Create a shared report
#'
#' @export
#'
#' @examples
#' \dontrun{
#' shared_report_create("Sample Report", "2022-03-01", "2022-04-01")
#' }
shared_report_create <- function(
    name,
    start,
    end,
    is_public = TRUE,
    fixed_date = FALSE
) {
  path <- sprintf("/workspaces/%s/shared-reports", workspace())

  body <- list(
    name = name,
    isPublic = is_public,
    fixedDate = fixed_date,
    type = "SUMMARY",
    filter = list(
      dateRangeStart = time_format(start),
      dateRangeEnd = time_format(end),
      summaryFilter = list(
        groups = c("USER", "PROJECT", "TIMEENTRY")
      )
    )
  )

  response <- POST(
    path,
    body = body
  )

  # This contains the report parameters. Could be unpacked into return value.
  #
  report <- content(response)

  status_code(response) == 200
}

#' Update a shared report
#'
#' @export
#'
#' @examples
#' \dontrun{
#' shared_report_update("6307f29f1bbd1d34e56b9eb7", name = "Test Report")
#' }
shared_report_update <- function(shared_report_id, name = NULL, is_public = NULL, fixed_date = NULL) {
  path <- sprintf("/workspaces/%s/shared-reports/%s", workspace(), shared_report_id)

  if (!is.null(is_public)) is_public <- as.logical(is_public)
  if (!is.null(fixed_date)) fixed_date <- as.logical(fixed_date)

  body <- list(
    name = name,
    isPublic = is_public,
    fixedDate = fixed_date,
    visibleToUsers = c(),
    visibleToUserGroups = c()
  )

  response <- PUT(
    path,
    body = body
  )

  status_code(response) == 200
}

#' Delete a shared report
#'
#' @export
#'
#' @examples
#' \dontrun{
#' shared_report_delete("6307f29f1bbd1d34e56b9eb7", name = "Test Report")
#' }
shared_report_delete <- function(shared_report_id) {
  path <- sprintf("/workspaces/%s/shared-reports/%s", workspace(), shared_report_id)

  response <- DELETE(path)

  status_code(response) == 204
}
