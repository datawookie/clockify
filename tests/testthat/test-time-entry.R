TIME_ENTRIES_COLS_CONCISE <- c("time_entry_id", "project_id", "description", "duration")
TIME_ENTRIES_COLS <- c(
  "time_entry_id", "user_id", "workspace_id", "project_id", "billable", "description", "time_start", "time_end",
  "duration"
)

test_that("no time entries", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  entries <- time_entries(user_id = USER_ID_BOB)

  expect_identical(names(entries), TIME_ENTRIES_COLS_CONCISE)
  expect_equal(nrow(entries), 0)
})

test_that("create time entry", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  TIME_END <- TIME_CURRENT - random_integer(86400)
  TIME_START <- TIME_END - random_integer(3600 * 6)
  TIME_ENTRY_DESCRIPTION <<- random_string()

  entry <- time_entry_create(USER_ID_AUTHENTICATED, PROJECT_ID_CLOCKIFY, TIME_START, TIME_END, TIME_ENTRY_DESCRIPTION)

  expect_equal(entry$user_id, USER_ID_AUTHENTICATED)
  expect_equal(entry$project_id, PROJECT_ID_CLOCKIFY)
  expect_equal(entry$description, TIME_ENTRY_DESCRIPTION)

  TIME_ENTRY_ID <<- entry$time_entry_id
})

test_that("get time entries", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  entries <- time_entries()
  expect_identical(names(entries), TIME_ENTRIES_COLS_CONCISE)

  entries <- time_entries(concise = FALSE)
  expect_identical(names(entries), TIME_ENTRIES_COLS)

  expect_true(TIME_ENTRY_ID %in% entries$time_entry_id)
})

test_that("filter time entries", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  entry <- time_entries(
    # start = TIME_START,
    # end = TIME_END,
    description = TIME_ENTRY_DESCRIPTION,
    project_id = PROJECT_ID_CLOCKIFY
  )

  expect_equal(entry$description, TIME_ENTRY_DESCRIPTION)
})

test_that("get time entry", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  entry <- time_entry(TIME_ENTRY_ID)

  expect_identical(names(entry), TIME_ENTRIES_COLS_CONCISE)
  expect_equal(entry$time_entry_id, TIME_ENTRY_ID)
})

test_that("update time entry", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  TIME_END <- TIME_CURRENT - random_integer(86400)
  TIME_START <- TIME_END - random_integer(3600 * 6)
  TIME_DESCRIPTION <- random_string()

  entry <- time_entry_set(TIME_ENTRY_ID, PROJECT_ID_EMAYILI, TIME_START, TIME_END, TIME_DESCRIPTION)

  expect_equal(entry$user_id, USER_ID_AUTHENTICATED)
  expect_equal(entry$project_id, PROJECT_ID_EMAYILI)
  expect_equal(entry$description, TIME_DESCRIPTION)
})

test_that("stop running time entry", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  TIME_END <- TIME_CURRENT - random_integer(86400)
  TIME_START <- TIME_END - random_integer(3600 * 6)
  TIME_DESCRIPTION <- random_string()

  # Start time entry.
  time_entry_create(USER_ID_AUTHENTICATED, PROJECT_ID_CLOCKIFY, TIME_START, NULL, TIME_DESCRIPTION)
  # Stop time entry.
  entry <- time_entry_stop(USER_ID_AUTHENTICATED, TIME_END)

  expect_equal(entry$user_id, USER_ID_AUTHENTICATED)
  expect_equal(entry$project_id, PROJECT_ID_CLOCKIFY)
  expect_equal(entry$description, TIME_DESCRIPTION)
  expect_equal(as.character(entry$time_start), as.character(TIME_START))
  expect_equal(as.character(entry$time_end), as.character(TIME_END))
})

test_that("delete time entry", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_true(time_entry_delete(TIME_ENTRY_ID))
  expect_false(TIME_ENTRY_ID %in% time_entries()$time_entry_id)
})
