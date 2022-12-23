CLIENTS_COLS_CONCISE <- c("client_id", "workspace_id", "client_name")
CLIENTS_COLS <- c("client_id", "workspace_id", "client_name", "archived", "address")

test_that("get clients", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  clients <- clients()

  expect_identical(names(clients), CLIENTS_COLS_CONCISE)
  expect_true(CLIENT_ID_RSTUDIO %in% clients$client_id)
})

test_that("extended output", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  clients <- clients(concise = FALSE)

  expect_identical(names(clients), CLIENTS_COLS)
})

test_that("create client", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  psf <- client_create(CLIENT_NAME_PSF)

  expect_identical(names(psf), CLIENTS_COLS_CONCISE)
  expect_equal(CLIENT_NAME_PSF, psf$client_name)

  CLIENT_ID_PSF <<- psf$client_id
})

test_that("update client", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  psf <- client_update(CLIENT_ID_PSF, name = "PSF")

  expect_equal(psf$client_name, "PSF")
})

test_that("delete client", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  expect_true(client_delete(CLIENT_ID_PSF, archive = TRUE))
})
