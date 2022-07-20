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

test_that("extended output", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  users <- users(concise = FALSE)
  expect_identical(names(users), USERS_COLS)
})
