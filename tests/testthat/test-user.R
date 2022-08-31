USERS_COLS_CONCISE <- c("user_id", "user_name", "status")
USERS_COLS <- c("user_id", "email", "user_name", "memberships", "active_workspace", "default_workspace", "status")

test_that("get active users", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  users <- users(active = TRUE)
  expect_identical(names(users), USERS_COLS_CONCISE)
})

test_that("get all users", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  users <- users(active = FALSE)
  expect_identical(names(users), USERS_COLS_CONCISE)
})

test_that("ID for authenticated user", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_equal(user_get_id(), USER_ID_AUTHENTICATED)
})

test_that("extended output", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  users <- users(concise = FALSE)
  expect_identical(names(users), USERS_COLS)
})

test_that("NA for missing username", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_true(
    users() %>% filter(user_id == USER_ID_MISSING_NAME) %>% pull(user_name) %>% is.na()
  )
})
