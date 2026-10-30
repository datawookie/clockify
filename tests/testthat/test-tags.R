# Tag tests - creates (and then deletes) its own tag

TAGS_COLS <- c("tag_id", "workspace_id", "name", "archived")

test_that("create tag", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tags <- tag_create(TAG_NAME)

  expect_true(TAG_NAME %in% (tags %>% pull(name)))
})

test_that("get tags", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  tags <- tags()

  TAG_ID <<- tags %>%
    filter(name == TAG_NAME) %>%
    pull(tag_id)

  expect_identical(names(tags), TAGS_COLS)
  expect_length(TAG_ID, 1)
})

test_that("get tag from ID", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TAG_ID), message = "Tag not created, skipping")

  tag <- tag(TAG_ID)

  expect_equal(tag %>% pull(name), TAG_NAME)
})

test_that("update tag", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TAG_ID), message = "Tag not found, skipping")

  tag <- tag_update(TAG_ID, name = TAG_NAME_UPDATED, archived = TRUE)

  expect_equal(tag %>% pull(name), TAG_NAME_UPDATED)
  expect_true(tag %>% pull(archived))
})

test_that("delete tag", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(TAG_ID), message = "Tag not found, skipping")

  expect_true(tag_delete(TAG_ID))
  expect_false(TAG_ID %in% (tags() %>% pull(tag_id)))
})
