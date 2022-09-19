test_that("create task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tasks <- task_create(PROJECT_ID_CLOCKIFY, TASK_NAME)

  expect_true(TASK_NAME %in% (tasks %>% pull(name)))
})

test_that("get tasks", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tasks <- tasks(PROJECT_ID_CLOCKIFY)

  TASK_ID <<- tasks %>%
    filter(name == TASK_NAME) %>%
    pull(task_id)

  expect_identical(names(tasks), c("task_id", "name", "project_id", "status", "billable", "assignee_id"))
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

  task <- task_update(PROJECT_ID_CLOCKIFY, TASK_ID, name = TASK_NAME_UPDATED, billable = FALSE)

  expect_equal(task %>% pull(name), TASK_NAME_UPDATED)
})

test_that("delete task", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  task_delete(PROJECT_ID_CLOCKIFY, TASK_ID)

  expect_false(TASK_ID %in% (tasks(PROJECT_ID_CLOCKIFY) %>% pull(task_id)))
})
