# Shared report tests - uses your own workspace dynamically

SHARED_REPORT_LIST_COLS <- c(
  "shared_report_id", "workspace_id", "user_id", "report_author", "name",
  "link", "visible_to_users", "visible_to_user_groups", "fixed_date", "type",
  "filter", "is_public"
)

# A shared report doesn't need any time entries, so just use the past week.
WEEK_END <- Sys.Date() + 1
WEEK_START <- WEEK_END - 7

test_that("no shared reports (or some exist)", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  reports <- shared_reports()

  expect_identical(names(reports), SHARED_REPORT_LIST_COLS)
  # Accept any number of shared reports, including zero
  expect_gte(nrow(reports), 0)
})

test_that("create shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  SHARED_REPORT_NAME <<- random_string()

  report <- shared_report_create(SHARED_REPORT_NAME, WEEK_START, WEEK_END)

  expect_equal(report$name, SHARED_REPORT_NAME)
  expect_identical(names(report), SHARED_REPORT_LIST_COLS)

  SHARED_REPORT_ID <<- report$shared_report_id
})

test_that("get shared reports", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  reports <- shared_reports()

  expect_identical(names(reports), SHARED_REPORT_LIST_COLS)
  # The report created above should be listed.
  if (!is.na(SHARED_REPORT_ID)) {
    expect_true(SHARED_REPORT_ID %in% reports$shared_report_id)
  }
})

test_that("get shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(SHARED_REPORT_ID), message = "Shared report not created yet")

  report <- shared_report(SHARED_REPORT_ID)

  # The API may return other columns too (for example, `donutChart`).
  expect_true(all(c("totals", "groups", "filters") %in% names(report)))
})

test_that("update shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(SHARED_REPORT_ID), message = "Shared report not found, skipping")

  SHARED_REPORT_NAME <<- random_string()

  report <- shared_report_update(SHARED_REPORT_ID, name = SHARED_REPORT_NAME)

  expect_equal(SHARED_REPORT_NAME, report$name)
})

test_that("delete shared report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(SHARED_REPORT_ID), message = "No shared report to delete")

  expect_true(shared_report_delete(SHARED_REPORT_ID))

  reports <- shared_reports()
  expect_false(SHARED_REPORT_ID %in% reports$shared_report_id)
})
