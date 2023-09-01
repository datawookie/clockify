unpack_workspace <- function(workspace) {
  workspace$imageUrl <- NULL
  workspace$featureSubscriptionType <- NULL
  workspace$workspaceSettings <- NULL
  workspace$hourlyRate <- NULL
  workspace$costRate <- NULL

  workspace$memberships <- list(simplify_membership(workspace$memberships))

  as_tibble(workspace) %>%
    rename(workspace_id = id)
}

#' Get a list of workspaces
#'
#' @return A data frame with one record per workspace.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' workspaces()
#' }
workspaces <- function() {
  GET("/workspaces") %>%
    content() %>%
    map_df(unpack_workspace)
}

#' Get or set active workspace ID
#'
#' @param workspace_id A workspace ID
#'
#' @return The ID of the active workspace.
#' @export
#'
#' @examples
#' \dontrun{
#' # Select default workspace for authenticated user.
#' workspace()
#' # Select a specific workspace.
#' workspace("612b15a5f4c3bf0462192677")
#' }
workspace <- function(workspace_id = NULL) {
  if (!is.null(workspace_id)) {
    log_debug("Set active workspace -> {workspace_id}.")
    cache_set("workspace_id", workspace_id)
  }

  workspace_id <- cache_get("workspace_id")
  if (is.null(workspace_id)) {
    log_debug("Setting default workspace.")
    workspace(user(concise = FALSE)$default_workspace)
  } else {
    workspace_id
  }
}
