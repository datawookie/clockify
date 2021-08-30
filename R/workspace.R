#' Get a list of workspaces
#'
#' @return A data frame with one record per workspace.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' \dontrun{
#' workspaces()
#' }
workspaces <- function() {
  workspaces <- GET("/workspaces")
  content(workspaces) %>%
    map_df(function(workspace) {
      with(
        workspace,
        tibble(
          workspace_id = id,
          name
        )
      )
    })
}

#' Get or set active workspace ID
#'
#' @param workspace_id A workspace ID
#'
#' @return The ID of the active workspace.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' \dontrun{
#' workspace("612b15a5f4c3bf0462192677")
#' }
workspace <- function(workspace_id = NULL) {
  if (!is.null(workspace_id)) {
    log_debug("Set active workspace -> {workspace_id}.")
    cache_set("workspace_id", workspace_id)
  }

  workspace_id <- cache_get("workspace_id")
  if (is.null(workspace_id)) stop("Workspace ID has not been set.")

  workspace_id
}
