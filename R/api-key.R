API_KEY <- "api_key"

#' Set API key
#'
#' @param api_key A Clockify API key
#'
#' @return The API key.
#' @export
#'
#' @examples
#' \dontrun{
#' CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
#' set_api_key(CLOCKIFY_API_KEY)
#' }
set_api_key <- function(api_key) {
  cache_set(API_KEY, api_key)

  # Get user associated with this API key and set default workspace.
  user <- user(concise = FALSE)
  default_workspace <- user$default_workspace
  log_debug("Setting default workspace.")
  workspace(default_workspace)

  invisible(api_key)
}

#' Get API key
#'
#' @return The API key.
#' @export
#'
#' @examples
#' \dontrun{
#' CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
#' set_api_key(CLOCKIFY_API_KEY)
#' get_api_key()
#' }
get_api_key <- function() {
  api_key <- cache_get(API_KEY)
  if (is.null(api_key)) stop("API key has not been set.")
  api_key
}
