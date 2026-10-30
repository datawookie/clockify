# Report tests using mocked API responses - no API key needed.
#
# The responses are based on what the API returns for a Free-plan workspace
# (since June 2026), where billable rate fields are missing or empty.

# Return each response in turn from successive API calls.
local_fake_responses <- function(..., .env = parent.frame()) {
  responses <- list(...)
  i <- 0
  local_mocked_bindings(
    workspace = function(...) "w1",
    POST = function(...) NULL,
    content = function(...) {
      i <<- i + 1
      responses[[i]]
    },
    .package = "clockify",
    .env = .env
  )
}

fake_summary_entry <- function(name = "entry", duration = 7200L) {
  list(
    workspaceCurrencyCode = "USD",
    duration = duration,
    `_id` = list(USER = "u1", PROJECT = "p1", TIMEENTRY = name),
    name = name,
    color = "#9575CD",
    amounts = list()
  )
}

fake_summary_response <- function(user_amount = NULL) {
  user <- list(
    duration = 7200L,
    `_id` = "u1",
    name = "Alice",
    amounts = list(),
    children = list(list(
      currency = "USD",
      duration = 7200L,
      `_id` = "p1",
      name = "test",
      clientName = "",
      amounts = list(),
      children = list(fake_summary_entry())
    ))
  )
  user$amount <- user_amount
  list(groupOne = list(user))
}

test_that("summary report on Free plan", {
  local_fake_responses(fake_summary_response())

  report <- reports_summary("2026-10-01", "2026-10-29")

  expect_identical(
    names(report),
    c("user_id", "user_name", "duration", "amount", "amounts", "projects")
  )
  expect_identical(nrow(report), 1L)
  expect_identical(report$user_id, "u1")
  expect_identical(report$amount, NA_real_)

  projects <- report$projects[[1]]
  expect_identical(nrow(projects), 1L)
  expect_identical(projects$project_id, "p1")
  expect_identical(projects$amount, NA_real_)

  entries <- projects$entries[[1]]
  expect_identical(names(entries), c("description", "duration", "amount"))
  expect_identical(nrow(entries), 1L)
  expect_identical(entries$amount, NA_real_)
})

test_that("summary report keeps amount when present", {
  # Check that `amount` isn't confused with `amounts`.
  local_fake_responses(fake_summary_response(user_amount = 12.5))

  report <- reports_summary("2026-10-01", "2026-10-29")

  expect_identical(report$amount, 12.5)
})

test_that("weekly report on Free plan", {
  local_fake_responses(list(groupOne = list(list(
    `_id` = "u1",
    duration = 7200L,
    amounts = list(),
    amount = 0,
    name = "Alice",
    children = list(list(
      duration = 7200L,
      amounts = list(),
      amount = 0,
      `_id` = "p1",
      name = "test",
      clientName = ""
    ))
  ))))

  report <- reports_weekly("2026-10-23", "2026-10-30")

  expect_identical(names(report), c("user_id", "user_name", "duration", "amount", "projects"))
  expect_identical(report$user_id, "u1")
  expect_identical(report$amount, 0)

  projects <- report$projects[[1]]
  expect_identical(projects$project_id, "p1")
  expect_identical(projects$amount, 0)
})

test_that("detailed report on Free plan", {
  entry <- list(
    `_id` = "e1",
    description = "entry",
    userId = "u1",
    timeInterval = list(
      start = "2026-10-29T08:00:00Z",
      end = "2026-10-29T10:00:00Z",
      duration = 7200L
    ),
    billable = FALSE,
    projectId = "p1",
    projectColor = "#689F38",
    userName = "Alice"
  )
  # A page of entries, then an empty page to end pagination.
  local_fake_responses(
    list(timeentries = list(entry)),
    list(timeentries = list())
  )

  report <- reports_detailed("2026-10-01", "2026-10-29")

  expect_identical(nrow(report), 1L)
  expect_identical(report$amount, NA_real_)
  expect_identical(report$rate, NA_real_)
  expect_false("project_color" %in% names(report))
})
