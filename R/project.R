#' Get projects
#'
#' @param concise Generate concise output
#'
#' @return A data frame with one record per project
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' projects()
projects <- function(concise = TRUE) {
  path <- sprintf("/workspaces/%s/projects", workspace())

  projects <- paginate(path)

  projects <- tibble(projects) %>%
    unnest_wider(projects) %>%
    select(
      project_id = id,
      project_name = name,
      clientId,
      workspaceId,
      billable,
      public,
      template
    ) %>%
    clean_names()

  if (concise) {
    projects %>%
      select(-public, -template)
  } else {
    projects
  }
}
