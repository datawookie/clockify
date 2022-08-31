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
