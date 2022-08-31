test_that("error on empty api key", {
  expect_error(set_api_key(""), regexp = "\\(401\\) Unauthorized")
})

test_that("api key not set", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Delete cached API key.
  rm("api_key", envir = clockify:::cache)

  expect_error(get_api_key())
})

test_that("set api key", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  set_api_key(CLOCKIFY_API_KEY)
  expect_equal(cache_get(API_KEY), CLOCKIFY_API_KEY)
})

test_that("get api key", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_equal(get_api_key(), CLOCKIFY_API_KEY)
})
