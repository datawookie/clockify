test_that("remove NULL from list", {
  expect_identical(
    list_remove_empty(list(1, NULL, 3)),
    list(1, 3)
  )
  expect_identical(
    list_remove_empty(list(1, list(1, NULL, 3), 3)),
    list(1, list(1, 3), 3)
  )
})

test_that("ensure columns adds missing columns", {
  df <- tibble(id = c("a", "b"), amount = c(1, 2))

  result <- ensure_columns(df, amount = NA_real_, rate = NA_real_)

  expect_identical(names(result), c("id", "amount", "rate"))
  expect_identical(result$amount, c(1, 2))
  expect_identical(result$rate, c(NA_real_, NA_real_))
})

test_that("ensure columns leaves complete data frame unchanged", {
  df <- tibble(id = "a", amount = 1, rate = 2)

  expect_identical(ensure_columns(df, amount = NA_real_, rate = NA_real_), df)
})

test_that("ensure columns works on empty data frame", {
  result <- ensure_columns(tibble(id = character()), amount = NA_real_)

  expect_identical(nrow(result), 0L)
  expect_type(result$amount, "double")
})
