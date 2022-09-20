PROJECTS_COLS_CONCISE <- c("project_id", "project_name", "client_id", "billable", "archived")
PROJECTS_COLS <- c(
  "project_id", "project_name", "client_id", "workspace_id", "billable", "public", "archived", "template",
  "memberships", "time_estimate"
)

test_that("get projects", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  projects <- projects()

  expect_identical(names(projects), PROJECTS_COLS_CONCISE)
  expect_true(PROJECT_ID_CLOCKIFY %in% projects$project_id)
})

test_that("extended output", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  projects <- projects(concise = FALSE)

  expect_identical(names(projects), PROJECTS_COLS)
})

test_that("get project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  emayili <- project(PROJECT_ID_EMAYILI)

  expect_identical(names(emayili), PROJECTS_COLS_CONCISE)
  expect_true(PROJECT_ID_EMAYILI %in% emayili$project_id)
})

test_that("create project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  asana <- project_create("Asana", CLIENT_ID_RSTUDIO)

  expect_identical(names(asana), PROJECTS_COLS_CONCISE)
  expect_equal(CLIENT_ID_RSTUDIO, asana$client_id)

  PROJECT_ID_ASANA <<- asana$project_id
})

test_that("update user billable rate", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  RATE <- random_integer()

  project_update_billable_rate(PROJECT_ID_ASANA, USER_ID_AUTHENTICATED, RATE)

  expect_equal(
    project(PROJECT_ID_ASANA, concise = FALSE) %>%
      select(-project_id) %>%
      unnest(memberships) %>%
      filter(user_id == USER_ID_AUTHENTICATED) %>%
      pull(rate_amount),
    RATE
  )
})

test_that("update project time estimate", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  ESTIMATE <- "PT2H45M30S"

  project_update_estimate_time(PROJECT_ID_ASANA, ESTIMATE, TRUE, TRUE)

  expect_equal(
    project(PROJECT_ID_ASANA, concise = FALSE) %>% unnest(time_estimate) %>% pull(estimate),
    ESTIMATE
  )
})

test_that("update project membership", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Add member.
  memberships <- project_update_memberships(
    PROJECT_ID_EMAYILI,
    c(USER_ID_AUTHENTICATED, USER_ID_BOB)
  ) %>%
    select(-project_id) %>%
    unnest(memberships) %>%
    pull(user_id)
  expect_true(USER_ID_AUTHENTICATED %in% memberships && USER_ID_BOB %in% memberships)

  # Remove member.
  memberships <- project_update_memberships(
    PROJECT_ID_EMAYILI,
    USER_ID_AUTHENTICATED
  ) %>%
    select(-project_id) %>%
    unnest(memberships) %>%
    pull(user_id)
  expect_true(USER_ID_AUTHENTICATED %in% memberships && !(USER_ID_BOB %in% memberships))
})

test_that("update project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Archive project.
  asana <- project_update(PROJECT_ID_ASANA, archived = TRUE)
  expect_true(asana$archived)
})

test_that("delete project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_true(project_delete(PROJECT_ID_ASANA))
  expect_false(PROJECT_ID_ASANA %in% projects()$project_id)
})
