USERS_COLS_CONCISE <- c("user_id", "user_name", "status")
USERS_COLS <- c("user_id", "email", "user_name", "active_workspace", "default_workspace", "status")

test_that("get active users", {
  users <- users(active = TRUE)
  expect_identical(names(users), USERS_COLS_CONCISE)
})

test_that("get all users", {
  users <- users(active = FALSE)
  expect_identical(names(users), USERS_COLS_CONCISE)
})

test_that("extended output", {
  users <- users(concise = FALSE)
  expect_identical(names(users), USERS_COLS)
})
