#' Helper function for parsing projects
#'
#' @noRd
#'
parse_projects <- function(projects, concise = TRUE) {
  projects <- tibble(projects) %>%
    unnest_wider(projects) %>%
    # TODO: There are a lot more fields which can be included here.
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
      select(-workspace_id, -public, -template)
  } else {
    projects
  }
}

#' Get projects
#'
#' Wraps \code{GET /workspaces/{workspaceId}/projects}.
#'
#' @param concise Generate concise output
#'
#' @return A data frame with one record per project
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' projects()
#' }
projects <- function(concise = TRUE) {
  path <- sprintf("/workspaces/%s/projects", workspace())

  paginate(path) %>%
    parse_projects(concise = concise)
}

#' Get project
#'
#' Wraps \code{GET /workspaces/{workspaceId}/projects/{projectId}}.
#'
#' @param project_id Project ID
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' project("612b16c0bc325f120a1e5099")
#' }
project <- function(project_id, concise = TRUE) {
  path <- sprintf("/workspaces/%s/projects/%s", workspace(), project_id)

  clockify:::GET(path) %>%
    content() %>% list() %>%
    parse_projects(concise = concise)
}
