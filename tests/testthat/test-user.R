USERS_COLS_CONCISE <- c("user_id", "user_name", "status")
USERS_COLS <- c(
  "user_id", "email", "user_name", "memberships", "active_workspace",
  "default_workspace", "status"
)

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
    users() %>%
      filter(user_id == USER_ID_MISSING_NAME) %>%
      pull(user_name) %>%
      is.na()
  )
})

test_that("update hourly rate", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  rate <- runif(1, 0, 1000) %>% ceiling()

  workspace <- user_update_hourly_rate(USER_ID_ALICE, rate, NULL)

  expect_equal(
    workspace %>%
      unnest(memberships) %>%
      filter(user_id == USER_ID_ALICE) %>%
      pull(rate_amount),
    rate
  )
})

test_that("update user status", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  workspace <- user_update_status(USER_ID_CAROL, FALSE)
  #
  expect_equal(
    workspace %>%
      unnest(cols = c(memberships)) %>%
      filter(user_id == USER_ID_CAROL) %>%
      pull(membership_status),
    "INACTIVE"
  )

  workspace <- user_update_status(USER_ID_CAROL, "ACTIVE")
  #
  expect_equal(
    workspace %>%
      unnest(cols = c(memberships)) %>%
      filter(user_id == USER_ID_CAROL) %>%
      pull(membership_status),
    "ACTIVE"
  )
})

test_that("update user role", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  role <- user_update_role(USER_ID_BOB, "WORKSPACE_ADMIN", CLOCKIFY_WORKSPACE)

  expect_equal(
    role %>% unnest(cols = c(role)) %>% pull(role_name),
    "WORKSPACE_ADMIN"
  )
})

test_that("delete user role", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_true(user_delete_role(USER_ID_BOB, "WORKSPACE_ADMIN", CLOCKIFY_WORKSPACE))
})
