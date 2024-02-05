REPORT_SUMMARY_COLS <- c("user_name", "duration", "amount", "amounts", "projects")
REPORT_DETAILED_COLS <- c(
  "id",
  "description",
  "user_id",
  "start",
  "end",
  "duration",
  "billable",
  "project_id",
  "task_id",
  "type",
  "tag_ids",
  "approval_request_id",
  "is_locked",
  "amount",
  "rate",
  "user_name",
  "user_email",
  "project_name",
  "client_name",
  "client_id"
)
REPORT_WEEKLY_COLS <- c("user_name", "duration", "amount", "projects")

test_that("summary report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  report <- reports_summary(TIME_START, TIME_END)

  expect_equal(report$duration, DURATION_TOTAL)
  expect_identical(names(report), REPORT_SUMMARY_COLS)
})

test_that("detailed report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  report <- reports_detailed(TIME_START, TIME_END)

  expect_equal(report %>% pull(duration) %>% sum(), DURATION_TOTAL)
  expect_identical(sort(names(report)), sort(REPORT_DETAILED_COLS))
})

test_that("weekly report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  report <- reports_weekly(WEEK_START, WEEK_END)

  expect_equal(report$duration, DURATION_TOTAL)
  expect_identical(names(report), REPORT_WEEKLY_COLS)
})
