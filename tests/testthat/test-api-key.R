test_that("error on empty api key", {
  expect_error(set_api_key(""), regexp = "\\(401\\) Unauthorized")
})

test_that("set api key", {
  skip_on_cran()
  set_api_key(CLOCKIFY_API_KEY)
  expect_equal(cache_get(API_KEY), CLOCKIFY_API_KEY)
})

test_that("get api key", {
  skip_on_cran()
  expect_equal(get_api_key(), CLOCKIFY_API_KEY)
})
