# Report tests - uses your own workspace and time entries dynamically

REPORT_SUMMARY_COLS <- c("user_id", "user_name", "duration", "amount", "amounts", "projects")
REPORT_DETAILED_COLS <- c(
  "id",
  "description",
  "user_id",
  "start",
  "offStart",
  "offEnd",
  "end",
  "duration",
  "timeZone",
  "zonedStart",
  "zonedEnd",
  "billable",
  "project_id",
  "task_id",
  "tag_ids",
  "approval_request_id",
  "type",
  "is_locked",
  "currency",
  "amount",
  "rate",
  "user_name",
  "user_email",
  "project_name",
  "client_name",
  "client_id",
  # Only on paid plans.
  "cost_amount",
  "cost_rate",
  "earned_amount",
  "earned_rate"
)
REPORT_WEEKLY_COLS <- c("user_id", "user_name", "duration", "amount", "projects")

get_report_time_period <- function() {
  w <- workspaces()
  if (nrow(w) == 0) {
    stop("No workspaces found")
  }
  workspace <- w$name[1]

  entries <- time_entries(user_id = USER_ID_AUTHENTICATED, concise = FALSE)
  if (nrow(entries) == 0) {
    warning("No time entries to build report. Skip report tests.")
    return(NULL)
  }

  return(list(
    workspace = workspace,
    TIME_START = min(entries$time_start),
    TIME_END = max(entries$time_end),
    DURATION_TOTAL = sum(entries$duration),
    ENTRIES = entries
  ))
}

# NULL if there's no API key or no time entries, in which case the tests skip.
report_tests_setup <- if (!NO_API_KEY_IN_ENVIRONMENT) get_report_time_period()

TIME_START <<- report_tests_setup$TIME_START
TIME_END <<- report_tests_setup$TIME_END
DURATION_TOTAL <<- report_tests_setup$DURATION_TOTAL

test_that("summary report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.null(report_tests_setup), message = "No time entries found for reports")

  report <- reports_summary(report_tests_setup$TIME_START, report_tests_setup$TIME_END)

  if (!is.null(report_tests_setup$DURATION_TOTAL)) {
    expect_equal(report$duration, report_tests_setup$DURATION_TOTAL)
  }
  expect_identical(names(report), REPORT_SUMMARY_COLS)

  # Entry durations should add up to the user total (each entry is one row).
  entries <- report %>%
    select(projects) %>%
    unnest(projects) %>%
    select(entries) %>%
    unnest(entries)
  expect_equal(sum(entries$duration), sum(report$duration))
})

test_that("detailed report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.null(report_tests_setup), message = "No time entries found for reports")

  report <- reports_detailed(report_tests_setup$TIME_START, report_tests_setup$TIME_END)

  if (!is.null(report_tests_setup$DURATION_TOTAL)) {
    total_duration <- report %>%
      pull(duration) %>%
      sum(na.rm = TRUE)
    expect_equal(total_duration, report_tests_setup$DURATION_TOTAL)
  }
  expect_true(all(names(report) %in% REPORT_DETAILED_COLS))
  # These are omitted by the API on the Free plan, but should always be present.
  expect_true(all(c("amount", "rate") %in% names(report)))
})

test_that("weekly report", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.null(report_tests_setup), message = "No time entries found for reports")

  # Calculate weekly dates
  library(lubridate)
  week_end <- ceiling_date(report_tests_setup$TIME_END, unit = "day") %>% as.Date() + 1
  week_start <- week_end - 7

  report <- reports_weekly(week_start, week_end)

  # Only the entries that start in the week are included in the report.
  entries <- report_tests_setup$ENTRIES
  in_week <- entries$time_start >= as.POSIXct(week_start, tz = "UTC") &
    entries$time_start < as.POSIXct(week_end, tz = "UTC")
  expect_equal(sum(report$duration), sum(entries$duration[in_week]))
  expect_identical(names(report), REPORT_WEEKLY_COLS)
})
