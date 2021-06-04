#' Title
#'
#' @return
#' @export
#'
#' @examples
projects <- function() {
  path <- sprintf("/workspaces/%s/projects", workspace())

  projects <- paginate(path)

  tibble(projects) %>%
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
}
