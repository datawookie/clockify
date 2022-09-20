PROJECTS_COLS_CONCISE <- c("project_id", "project_name", "client_id", "billable")
PROJECTS_COLS <- c(
  "project_id", "project_name", "client_id", "workspace_id", "billable", "public", "template", "memberships"
)

test_that("get projects", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_identical(names(projects(concise = TRUE)), PROJECTS_COLS_CONCISE)
  expect_identical(names(projects(concise = FALSE)), PROJECTS_COLS)
})
