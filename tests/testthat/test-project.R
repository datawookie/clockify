# Project tests - uses your own workspace dynamically
#
# The project from setup (PROJECT_ID) is only read here, because other test
# files use it. These tests create, change and delete their own project.

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
  expect_true(PROJECT_ID %in% projects$project_id)
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
  skip_if(is.na(PROJECT_ID), message = "Project not found, skipping")

  project <- project(PROJECT_ID)
  expect_identical(names(project), PROJECTS_COLS_CONCISE)
  expect_identical(project$project_id, PROJECT_ID)
})

test_that("create project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  name <- sprintf("Test Project %s", random_string())
  project <- project_create(name)

  expect_identical(names(project), PROJECTS_COLS_CONCISE)
  expect_equal(project$project_name, name)

  NEW_PROJECT_ID <<- project$project_id
})

test_that("update user billable rate", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(NEW_PROJECT_ID), message = "Project not created, skipping")

  RATE <- random_integer()

  skip_if_rates_forbidden(
    project_update_billable_rate(NEW_PROJECT_ID, USER_ID_AUTHENTICATED, RATE)
  )

  expect_equal(
    project(NEW_PROJECT_ID, concise = FALSE) %>%
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
  skip_if(is.na(NEW_PROJECT_ID), message = "Project not created, skipping")

  ESTIMATE <- "PT2H45M30S"

  project_update_estimate_time(NEW_PROJECT_ID, ESTIMATE, TRUE, TRUE)

  expect_equal(
    project(NEW_PROJECT_ID, concise = FALSE) %>% unnest(time_estimate) %>% pull(estimate),
    ESTIMATE
  )
})

test_that("update project memberships", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(NEW_PROJECT_ID), message = "Project not created, skipping")

  get_members <- function(project) {
    project %>%
      select(-project_id) %>%
      unnest(memberships) %>%
      pull(user_id)
  }

  # Add another member if there is one.
  other_users <- setdiff(users(active = TRUE)$user_id, USER_ID_AUTHENTICATED)
  if (length(other_users)) {
    memberships <- project_update_memberships(
      NEW_PROJECT_ID,
      c(USER_ID_AUTHENTICATED, other_users[1])
    ) %>% get_members()
    expect_true(all(c(USER_ID_AUTHENTICATED, other_users[1]) %in% memberships))
  }

  # Leave only the authenticated user.
  memberships <- project_update_memberships(NEW_PROJECT_ID, USER_ID_AUTHENTICATED) %>%
    get_members()
  expect_true(USER_ID_AUTHENTICATED %in% memberships)
  if (length(other_users)) {
    expect_false(other_users[1] %in% memberships)
  }
})

test_that("update project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(NEW_PROJECT_ID), message = "Project not created, skipping")

  # Archive project. This is needed before it can be deleted.
  project <- project_update(NEW_PROJECT_ID, archived = TRUE)
  expect_true(project$archived)
})

test_that("delete project", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(NEW_PROJECT_ID), message = "Project not created, skipping")

  expect_true(project_delete(NEW_PROJECT_ID))
  expect_false(NEW_PROJECT_ID %in% projects()$project_id)
})
