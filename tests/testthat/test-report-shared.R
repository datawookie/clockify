SHARED_REPORT_LIST_COLS <- c(
  "shared_report_id", "workspace_id", "user_id", "report_author", "name",
  "link", "visible_to_users", "visible_to_user_groups", "fixed_date", "type",
  "filter", "is_public"
)

entries <- time_entries(concise = FALSE)

DURATION_TOTAL <<- entries %>%
  pull(duration) %>%
  sum()

TIME_START <<- min(entries$time_start)
TIME_END <<- max(entries$time_end)

WEEK_END <<- ceiling_date(TIME_END, unit = "day") %>% as.Date() + 1
WEEK_START <<- WEEK_END - 7

test_that("no shared reports", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  reports <- shared_reports()

  expect_identical(names(reports), SHARED_REPORT_LIST_COLS)
  expect_equal(nrow(reports), 0)
})

test_that("create shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  SHARED_REPORT_NAME <- random_string()

  report <- shared_report_create(SHARED_REPORT_NAME, WEEK_START, WEEK_END)
  expect_equal(report$name, SHARED_REPORT_NAME)
  expect_identical(
    names(report),
    c(
      "shared_report_id", "workspace_id", "user_id", "report_author", "name",
      "link", "visible_to_users", "visible_to_user_groups", "fixed_date",
      "type", "filter", "is_public"
    )
  )

  SHARED_REPORT_ID <<- report$shared_report_id
})

test_that("get shared reports", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  reports <- shared_reports()

  expect_identical(names(reports), SHARED_REPORT_LIST_COLS)
  expect_true(SHARED_REPORT_ID %in% reports$shared_report_id)
})

test_that("get shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  report <- shared_report(SHARED_REPORT_ID)

  expect_identical(names(report), c("totals", "groups", "filters"))
})

# This currently returns a 500 error. Have logged a ticket (104931).
#
test_that("update shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  SHARED_REPORT_NAME <- random_string()

  report <- shared_report_update(SHARED_REPORT_ID, name = SHARED_REPORT_NAME)

  expect_identical(SHARED_REPORT_NAME, report$name)
})

test_that("delete shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  shared_report_delete(SHARED_REPORT_ID)

  reports <- shared_reports()

  expect_false(SHARED_REPORT_ID %in% reports$shared_report_id)
})
