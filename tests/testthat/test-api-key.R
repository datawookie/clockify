test_that("error on empty api key", {
  THRESHOLD <- log_threshold()
  log_threshold(FATAL)
  expect_error(set_api_key(""), regexp = "\\(401\\) Unauthorized")
  log_threshold(THRESHOLD)
})

test_that("api key not set", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Delete cached API key.
  try(rm("api_key", envir = clockify:::cache), silent = TRUE)

  expect_error(get_api_key())
})

test_that("set api key", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  set_api_key(CLOCKIFY_API_KEY)
  expect_equal(cache_get(API_KEY), CLOCKIFY_API_KEY)

  # Insert time entries for reports.
  #
  # Insert these time entries here. Why? Because they are going to be used in the tests for reports and shared reports.
  # However, if you only create these time entries immediately before the reports then the reports don't seem to get
  # updated in time. It's a race condition of sorts.
  #
  workspace(CLOCKIFY_WORKSPACE)
  #
  for (i in 1:3) {
    for (project_id in c(PROJECT_ID_CLOCKIFY, PROJECT_ID_EMAYILI)) {
      TIME_END <- TIME_CURRENT - random_integer(86400)
      TIME_START <- TIME_END - random_integer(3600 * 6)

      time_entry_create(USER_ID_AUTHENTICATED, project_id, TIME_START, TIME_END, random_string())
    }
  }
})

test_that("get api key", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_equal(get_api_key(), CLOCKIFY_API_KEY)
})
