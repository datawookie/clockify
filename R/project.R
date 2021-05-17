#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
projects <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/projects", workspace_id)
  projects <- GET(path)
  content(projects) %>%
    map_df(function(project) {
      with(
        project,
        tibble(
          project_id = id,
          project_name = name,
          clientId,
          workspaceId,
          billable,
          public,
          template
        )
      )
    }) %>%
    clean_names()
}
