# Task tests - uses your own projects dynamically

TASKS_COLS <- c("task_id", "name", "project_id", "status", "billable", "assignees")

test_that("no tasks (or some tasks exist)", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(PROJECT_ID), message = "Project not found, skipping")

  # Projects may have zero or more tasks.
  tasks <- tasks(PROJECT_ID)
  expect_identical(names(tasks), TASKS_COLS)
})

test_that("create task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(PROJECT_ID), message = "Project not found, skipping")

  TASK_NAME <<- sprintf("Test Task - %s", random_string())

  task <- task_create(PROJECT_ID, TASK_NAME)

  expect_equal(TASK_NAME, task$name)
  TASK_ID <<- task$task_id
})

test_that("get tasks", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(PROJECT_ID), message = "Project not found, skipping")

  tasks <- tasks(PROJECT_ID)
  expect_identical(names(tasks), TASKS_COLS)
})

test_that("get task from ID", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TASK_ID), message = "Task not created, skipping")

  task <- task(PROJECT_ID, TASK_ID)

  expect_equal(task %>% pull(name), TASK_NAME)
})

test_that("update task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TASK_ID), message = "Task not found, skipping")

  TASK_NAME_UPDATED <<- random_string()

  task <- task_update(
    PROJECT_ID,
    TASK_ID,
    name = TASK_NAME_UPDATED,
    billable = FALSE,
    assignee_id = USER_ID_AUTHENTICATED,
    status = "DONE"
  )

  expect_equal(task %>% pull(name), TASK_NAME_UPDATED)
  expect_equal(task %>% pull(status), "DONE")
  expect_true(USER_ID_AUTHENTICATED %in% (task %>% unnest(assignees) %>% pull(user_id)))
})

test_that("delete task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TASK_ID), message = "Task not found, skipping")

  # Status needs to be changed to "DONE" first (done in "update task").
  task_delete(PROJECT_ID, TASK_ID)

  expect_false(TASK_ID %in% (tasks(PROJECT_ID) %>% pull(task_id)))
})
