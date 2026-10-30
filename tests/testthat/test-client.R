# Client tests - creates (and then deletes) its own client

CLIENTS_COLS_CONCISE <- c("client_id", "workspace_id", "client_name")
CLIENTS_COLS <- c("client_id", "workspace_id", "client_name", "archived", "address")

test_that("get clients", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)

  # Accept any number of clients, including zero.
  clients <- clients()
  expect_identical(names(clients), CLIENTS_COLS_CONCISE)
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

  CLIENT_NAME_PSF <<- sprintf("Test Client %s", random_string())

  psf <- client_create(CLIENT_NAME_PSF)

  expect_identical(names(psf), CLIENTS_COLS_CONCISE)
  expect_equal(psf$client_name, CLIENT_NAME_PSF)
  expect_true(psf$client_id %in% clients()$client_id)

  CLIENT_ID_PSF <<- psf$client_id
})

test_that("update client", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(CLIENT_ID_PSF), message = "Client ID not found, skipping")

  name <- sprintf("Updated %s", CLIENT_NAME_PSF)
  psf <- client_update(CLIENT_ID_PSF, name = name)

  expect_equal(psf$client_name, name)
})

test_that("delete client", {
  skip_on_cran()
  skip_if(NO_API_KEY_IN_ENVIRONMENT)
  skip_if(is.na(CLIENT_ID_PSF), message = "Client ID not found, skipping")

  # A client must be archived before it can be deleted.
  expect_true(client_delete(CLIENT_ID_PSF, archive = TRUE))
  expect_false(CLIENT_ID_PSF %in% clients()$client_id)
})
