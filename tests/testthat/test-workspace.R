WORKSPACE_COLS <- c("workspace_id", "name", "memberships")

test_that("get workspaces", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  workspaces <- workspaces()
  expect_identical(names(workspaces), WORKSPACE_COLS)
})

test_that("set default workspace for authenticated user", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Delete cached workspace (set when authenticated).
  rm("workspace_id", envir = clockify:::cache)

  workspace <- workspace()
  expect_false(workspace == "")
})

test_that("choose workspace", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  workspace <- workspace(CLOCKIFY_WORKSPACE)
  expect_identical(workspace, CLOCKIFY_WORKSPACE)
})

test_that("get cached workspace", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  workspace <- workspace()
  expect_identical(workspace, CLOCKIFY_WORKSPACE)
})

# test_that("get all users", {
#   skip_on_cran()
#   skip_if(NO_API_KEY_IN_ENVIRONMENT)
#
#   users <- users(active = FALSE)
#   expect_identical(names(users), USERS_COLS_CONCISE)
# })
#
# test_that("extended output", {
#   skip_on_cran()
#   skip_if(NO_API_KEY_IN_ENVIRONMENT)
#
#   users <- users(concise = FALSE)
#   expect_identical(names(users), USERS_COLS)
# })
