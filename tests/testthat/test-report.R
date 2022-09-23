REPORT_SUMMARY_COLS <- c("user_name", "duration", "amount", "amounts", "projects")
REPORT_DETAILED_COLS <- c(
  "id", "description", "user_id", "start", "end", "duration", "billable", "project_id", "task_id",
  "approval_request_id", "tags", "is_locked", "custom_fields", "amount", "rate", "user_name", "user_email",
  "project_name", "client_name", "client_id"
)
REPORT_WEEKLY_COLS <- c("user_name", "duration", "amount", "projects")

# Time entries for reports.
#
for (i in 1:3) {
  for (project_id in c(PROJECT_ID_CLOCKIFY, PROJECT_ID_EMAYILI)) {
    TIME_END <- TIME_CURRENT - random_integer(86400)
    TIME_START <- TIME_END - random_integer(3600 * 6)

    time_entry_create(USER_ID_AUTHENTICATED, project_id, TIME_START, TIME_END, random_string())
  }
}

entries <- time_entries(concise = FALSE)

DURATION_TOTAL <- entries %>%
  pull(duration) %>%
  sum()

TIME_START <- min(entries$time_start)
TIME_END <- max(entries$time_end)

WEEK_END <- ceiling_date(TIME_END, unit = "day") %>% as.Date() + 1
WEEK_START <- WEEK_END - 7

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
  expect_identical(names(report), REPORT_DETAILED_COLS)
})

test_that("weekly report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  report <- reports_weekly(WEEK_START, WEEK_END)

  expect_equal(report$duration, DURATION_TOTAL)
  expect_identical(names(report), REPORT_WEEKLY_COLS)
})
