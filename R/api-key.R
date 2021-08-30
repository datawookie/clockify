API_KEY = "api_key"

#' Set API key
#'
#' @param api_key A Clockify API key
#'
#' @return The API key.
#' @export
#'
#' @examples
#' CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
#' set_api_key(CLOCKIFY_API_KEY)
set_api_key <- function(api_key) {
  log_debug("Setting API key: {api_key}.")
  assign(API_KEY, api_key, envir = cache)

  # Get user associated with this API key and set default workspace.
  api_key_user <- user(show_workspace = TRUE)
  api_key_default_workspace <- api_key_user$default_workspace
  log_debug("Setting default workspace.")
  workspace(api_key_default_workspace)

  invisible(api_key)
}

#' Get API key
#'
#' @return The API key.
#' @export
#'
#' @examples
#' get_api_key()
get_api_key <- function() {
  api_key <- get(API_KEY, envir = cache)
  if (is.null(api_key)) stop("API key has not been set.")
  api_key
}
