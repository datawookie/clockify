# Test API Key with actual API calls
# Note: Tests use dynamic workspace/project IDs from setup-files.R

test_that("error on empty api key", {
  THRESHOLD <- log_threshold()
  log_threshold(FATAL)
  expect_error(set_api_key("")$error, "401")
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

  # Insert time entries for reports using dynamic project IDs.
  #
  workspace(clockify::workspace())
  #
  # Get existing projects from workspace (use first one(s))
  projects <- clockify::projects(concise = FALSE)
  if (nrow(projects) == 0) {
    warning("No projects found. Tests may fail if they depend on existing projects.")
    return()
  }

  # Use first 1-2 projects for creating time entries
  project_ids <- projects$project_id[1:min(2, nrow(projects))]

  for (i in seq_along(project_ids)) {
    TIME_END <- TIME_CURRENT - random_integer(86400)
    TIME_START <- TIME_END - random_integer(3600 * 6)

    time_entry_create(
      USER_ID_AUTHENTICATED,
      project_id = project_ids[i],
      start = TIME_START,
      end = TIME_END,
      description = sprintf("Test entry %d", i)
    )
  }
})

test_that("get api key", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_equal(get_api_key(), CLOCKIFY_API_KEY)
})
