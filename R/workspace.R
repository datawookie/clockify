#' Get a list of workspaces
#'
#' @return
#' @export
#'
#' @examples
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
workspaces <- memoise::memoise(workspaces)

#' Get or set workspace ID
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
workspace <- function(workspace_id = NULL) {
  if (!is.null(workspace_id)) {
    log_debug("Set active workspace -> {workspace_id}.")
    cache_set("workspace_id", workspace_id)
  }

  workspace_id <- cache_get("workspace_id")
  if (is.null(workspace_id)) stop("Workspace ID has not been set.")

  workspace_id
}
