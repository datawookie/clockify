TASKS_COLS <- c("task_id", "name", "project_id", "status", "billable", "assignees")

test_that("no tasks", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tasks <- tasks(PROJECT_ID_CLOCKIFY)

  expect_equal(nrow(tasks), 0)
  expect_identical(names(tasks), TASKS_COLS)
})

test_that("create task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  task <- task_create(PROJECT_ID_CLOCKIFY, TASK_NAME)

  expect_equal(TASK_NAME, task$name)

  TASK_ID <<- task$task_id
})

test_that("get tasks", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tasks <- tasks(PROJECT_ID_CLOCKIFY)

  expect_identical(names(tasks), TASKS_COLS)
})

test_that("get task from ID", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  task <- task(PROJECT_ID_CLOCKIFY, TASK_ID)

  expect_equal(task %>% pull(name), TASK_NAME)
})

test_that("update task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  task <- task_update(
    PROJECT_ID_CLOCKIFY,
    TASK_ID,
    name = TASK_NAME_UPDATED,
    billable = FALSE,
    assignee_id = c(USER_ID_AUTHENTICATED, USER_ID_BOB)
  )

  expect_equal(task %>% pull(name), TASK_NAME_UPDATED)
  expect_equal(nrow(task %>% unnest(assignees)), 2)
})

test_that("delete task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  task_delete(PROJECT_ID_CLOCKIFY, TASK_ID)

  expect_false(TASK_ID %in% (tasks(PROJECT_ID_CLOCKIFY) %>% pull(task_id)))
})
