test_that("set api key", {
  clockify::set_api_key(CLOCKIFY_API_KEY)
  expect_equal(cache_get(API_KEY), CLOCKIFY_API_KEY)
})

test_that("get api key", {
  expect_equal(clockify::get_api_key(), CLOCKIFY_API_KEY)
})
