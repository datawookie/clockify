EMPTY_SHARED_REPORTS <- tibble(
  shared_report_id = character(),
  workspace_id = character(),
  user_id = character(),
  report_author = character(),
  name = character(),
  link = character(),
  visible_to_users = logical(),
  visible_to_user_groups = logical(),
  fixed_date = logical(),
  type = character(),
  filter = logical(),
  is_public = logical()
)

parse_shared_report_list <- function(reports) {
  reports <- tibble(reports) %>%
    unnest_wider(reports) %>%
    clean_names()

  if (!("report_author" %in% names(reports))) reports$report_author <- NA
  if (!("link" %in% names(reports))) reports$link <- NA
  if (!("workspace_id" %in% names(reports))) reports$workspace_id <- NA
  if (!("user_id" %in% names(reports))) reports$user_id <- NA
  if (!("filter" %in% names(reports))) reports$filter <- NA

  reports %>% select(
    shared_report_id = id,
    workspace_id,
    user_id,
    report_author,
    name,
    link,
    visible_to_users,
    visible_to_user_groups,
    fixed_date,
    type,
    filter,
    is_public
  )
}

parse_shared_report <- function(report) {
  report <- tibble(report) %>%
    unnest_wider(report)

  if ("groupOne" %in% names(report)) {
    report <- report %>% rename(groups = groupOne)
  } else {
    report$groups <- NA
  }

  if (!is.na(report$groups)) {
    report <- report %>%
      mutate(
        groups = groups %>%
          unlist(recursive = FALSE) %>%
          tibble(groups = .) %>%
          unnest_wider(groups) %>%
          clean_names() %>%
          select(user_id = id, everything()) %>%
          list()
      )
  }

  report <- report %>%
    mutate(
      filters = filters %>%
        tibble(filters = .) %>%
        unnest_wider(filters) %>%
        clean_names() %>%
        list()
    )

  # NOTE: Filters might have common structure with regular reports.
  # NOTE: Filters might have common structure with regular reports.
  # NOTE: Filters might have common structure with regular reports.
  # NOTE: Filters might have common structure with regular reports.

  # %>%
  #   select(id, name, client_name, duration, amount, amounts, children) %>%
  #   mutate(
  #     children = map(
  #       children,
  #       function(children) {
  #         map_dfr(children, identity) %>%
  #           mutate(
  #             amounts = map(amounts, ~ map_dfr(., identity))
  #           ) %>%
  #           clean_names() %>%
  #           select(id, name, duration, amount, amounts)
  #       }
  #     )
  #   )

  report
}

#' Shared Reports Parameters
#'
#' These are parameters which occur commonly across functions for shared reports.
#'
#' @name shared-reports-parameters
#'
#' @param shared_report_id Identifier for a specific shared report
#' @param name Name of the report
#' @param start Start time
#' @param end End time
#' @param is_public Is this a public report?
#' @param fixed_date Are the dates fixed?
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

  if (length(reports)) {
    reports %>%
      parse_shared_report_list()
  } else {
    EMPTY_SHARED_REPORTS
  }
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

  response <- GET(
    path
  )

  content(response) %>%
    list() %>%
    parse_shared_report()
}

#' Create a shared report
#'
#' @inheritParams shared-reports-parameters
#'
#' @export
#'
#' @examples
#' \dontrun{
#' shared_report_create("Sample Report", "2022-03-01", "2022-04-01")
#' }
shared_report_create <- function(name,
                                 start,
                                 end,
                                 is_public = TRUE,
                                 fixed_date = FALSE) {
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

  content(response) %>%
    list() %>%
    parse_shared_report_list()
}

#' Update a shared report
#'
#' @inheritParams shared-reports-parameters
#' @param name Report name
#' @param is_public Is this a public report?
#' @param fixed_date Are the dates fixed?
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

  content(response) %>%
    list() %>%
    parse_shared_report_list()
}

#' Delete a shared report
#'
#' @inheritParams shared-reports-parameters
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
