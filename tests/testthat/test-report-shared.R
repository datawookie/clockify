SHARED_REPORT_COLS <- c(
  "shared_report_id", "workspace_id", "user_id", "name", "visible_to_user_groups", "visible_to_users", "fixed_date",
  "type", "filter", "is_public"
)

entries <- time_entries(concise = FALSE)

DURATION_TOTAL <<- entries %>%
  pull(duration) %>%
  sum()

TIME_START <<- min(entries$time_start)
TIME_END <<- max(entries$time_end)

WEEK_END <<- ceiling_date(TIME_END, unit = "day") %>% as.Date() + 1
WEEK_START <<- WEEK_END - 7

test_that("create shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  SHARED_REPORT_NAME <- random_string()

  report <- shared_report_create(SHARED_REPORT_NAME, WEEK_START, WEEK_END)
  expect_equal(report$name, SHARED_REPORT_NAME)
  expect_identical(names(report), SHARED_REPORT_COLS)

  SHARED_REPORT_ID <<- report$shared_report_id
})

test_that("get shared reports", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  reports <- shared_reports()
  print(reports)

  expect_identical(names(reports), SHARED_REPORT_COLS)
  expect_true(SHARED_REPORT_ID %in% reports$shared_report_id)
})

test_that("delete shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  shared_report_delete(SHARED_REPORT_ID)

  reports <- shared_reports()

  expect_false(SHARED_REPORT_ID %in% reports$shared_report_id)
})

#' #' Get all shared reports
#' #'
#' #' @export
#' shared_reports <- function() {
#'   path <- sprintf("/workspaces/%s/shared-reports", workspace())
#'
#'   query <- list(
#'     page = 1,
#'     pageSize = 50
#'   )
#'
#'   reports <- list()
#'
#'   while (TRUE) {
#'     response <- GET(
#'       path,
#'       query = query
#'     ) %>% content()
#'
#'     if (!length(response$reports)) break
#'
#'     reports <- c(reports, response$reports)
#'
#'     query$page <- query$page + 1
#'   }
#'
#'   tibble(reports = reports) %>%
#'     unnest_wider(reports) %>%
#'     clean_names() %>%
#'     select(
#'       shared_report_id = id,
#'       everything()
#'     )
#' }
#'
#' #' Get a specific shared report
#' #'
#' #' @inheritParams shared-reports-parameters
#' #'
#' #' @export
#' #'
#' #' @examples
#' #' \dontrun{
#' #' # Get all shared reports.
#' #' shared_reports()
#' #' # Get specific shared report by shared report ID.
#' #' shared_report("6307f29f1bbd1d34e56b9eb7")
#' #' }
#' shared_report <- function(shared_report_id) {
#'   path <- sprintf("/shared-reports/%s", shared_report_id)
#'
#'   report <- GET(
#'     path
#'   ) %>% content()
#'
#'   tibble(group = report$groupOne) %>%
#'     unnest_wider(group) %>%
#'     clean_names() %>%
#'     select(id, name, client_name, duration, amount, amounts, children) %>%
#'     mutate(
#'       children = map(
#'         children,
#'         function(children) {
#'           map_dfr(children, identity) %>%
#'             mutate(
#'               amounts = map(amounts, ~ map_dfr(., identity))
#'             ) %>%
#'             clean_names() %>%
#'             select(id, name, duration, amount, amounts)
#'         }
#'       )
#'     )
#' }
#'
#'
#' #' Update a shared report
#' #'
#' #' @export
#' #'
#' #' @examples
#' #' \dontrun{
#' #' shared_report_update("6307f29f1bbd1d34e56b9eb7", name = "Test Report")
#' #' }
#' shared_report_update <- function(shared_report_id, name = NULL, is_public = NULL, fixed_date = NULL) {
#'   path <- sprintf("/workspaces/%s/shared-reports/%s", workspace(), shared_report_id)
#'
#'   if (!is.null(is_public)) is_public <- as.logical(is_public)
#'   if (!is.null(fixed_date)) fixed_date <- as.logical(fixed_date)
#'
#'   body <- list(
#'     name = name,
#'     isPublic = is_public,
#'     fixedDate = fixed_date,
#'     visibleToUsers = c(),
#'     visibleToUserGroups = c()
#'   )
#'
#'   response <- PUT(
#'     path,
#'     body = body
#'   )
#'
#'   status_code(response) == 200
#' }
