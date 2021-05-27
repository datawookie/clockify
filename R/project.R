#' Title
#'
#' @return
#' @export
#'
#' @examples
projects <- function() {
  path <- sprintf("/workspaces/%s/projects", workspace())
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
