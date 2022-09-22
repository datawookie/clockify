USER_GROUP_COLS <- c("group_id", "name", "workspace_id", "user_id")

test_that("no user groups", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  groups <- user_groups()

  expect_equal(nrow(groups), 0)
  expect_identical(names(groups), USER_GROUP_COLS)
})

test_that("create user group", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  GROUP_NAME <- random_string()

  group <- user_group_create(GROUP_NAME)
  expect_equal(group$name, GROUP_NAME)

  USER_GROUP_ID <<- group$group_id
})

test_that("update user group", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  GROUP_NAME <- random_string()

  group <- user_group_update(USER_GROUP_ID, GROUP_NAME)
  expect_equal(group$name, GROUP_NAME)
})

test_that("get user groups", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  groups <- user_groups()

  expect_true(USER_GROUP_ID %in% groups$group_id)
  expect_identical(names(groups), USER_GROUP_COLS)
})

test_that("add user to user group", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  group <- user_group_user_add(USER_GROUP_ID, USER_ID_AUTHENTICATED)
  expect_true(USER_ID_AUTHENTICATED %in% (group %>% unnest(cols = user_id) %>% pull(user_id)))
})

test_that("remove user from user group", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  group <- user_group_user_remove(USER_GROUP_ID, USER_ID_AUTHENTICATED)
  expect_false(USER_ID_AUTHENTICATED %in% (group %>% unnest(cols = user_id) %>% pull(user_id)))
})

test_that("delete user group", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  user_group_delete(USER_GROUP_ID)
  expect_false(USER_GROUP_ID %in% user_groups()$group_id)
})
