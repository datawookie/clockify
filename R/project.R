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
      template,
      memberships
    ) %>%
    clean_names()

  if (concise) {
    projects %>%
      select(-workspace_id, -public, -template, -memberships)
  } else {
    projects %>%
      mutate(
        memberships = map(memberships, simplify_membership)
      )
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
#' @param concise Generate concise output
#'
#' @return A data frame with one record per project
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

  GET(path) %>%
    content() %>% list() %>%
    parse_projects(concise = concise)
}

#' Create project
#'
#' Wraps `POST /workspaces/{workspaceId}/projects`.
#'
#' @param name Project name
#' @param client_id Client ID
#'
#' @export
#'
#' @examples
#' \dontrun{
#' }
project_create <- function(
    name,
    client_id = NULL
) {
  path <- sprintf("/workspaces/%s/projects", workspace())

  body <- list(
    name = name,
    client_id = client_id
  ) %>%
    clockify:::list_remove_empty()

  response <- clockify:::POST(
    path,
    body = body
  )

  content(response) %>%
    list() %>%
    parse_projects()
}

#' Delete project
#'
#' Wraps `DELETE /workspaces/{workspaceId}/projects/{id}`.
#'
#' An active project cannot be deleted. Archive the project first.
#'
#' @param project_id Project ID
#'
#' @export
#'
#' @examples
#' \dontrun{
#' }
project_delete <- function(project_id) {
  result <- clockify:::DELETE(
    sprintf("/workspaces/%s/projects/%s", workspace(), project_id)
  )
  status_code(result) == 200
}

#' Update project
#'
#' Wraps `PUT /workspaces/{workspaceId}/projects/{projectId}`.
#'
#' @param project_id Project ID
#' @param name Project name
#' @param client_id Client ID
#' @param archived Whether or not item is archived
#'
#' @export
#'
#' @examples
#' \dontrun{
#' }
project_update <- function(
    project_id,
    name = NULL,
    client_id = NULL,
    archived = NULL
) {
  body <- list(
    name = name,
    client_id = client_id,
    archived = archived
  ) %>%
    clockify:::list_remove_empty()

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/projects/%s", workspace(), project_id),
    body = body
  )
  status_code(result) == 200
}

#' Update user billable rate on project
#'
#' Wraps `PUT /workspaces/{workspaceId}/projects/{projectId}/users/{userId}/hourly-rate`.
#'
#' @param project_id Project ID
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
project_update_user_billable_rate <- function(project_id, user_id, rate, since = NULL) {
  body <- list(
    amount = rate * 100,
    since = since
  )

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/projects/%s/users/%s/hourly-rate", workspace(), project_id, user_id),
    body = body
  )

  content(response) %>%
    list() %>%
    parse_projects()
}

#' Update user cost rate on project
#'
#' Wraps `PUT /workspaces/{workspaceId}/projects/{projectId}/users/{userId}/cost-rate`.
#'
#' @param project_id Project ID
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
project_update_user_cost_rate <- function(project_id, user_id, rate, since = NULL) {
  body <- list(
    amount = rate * 100,
    since = since
  )

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/projects/%s/users/%s/cost-rate", workspace(), project_id, user_id),
    body = body
  )

  content(response) %>%
    list() %>%
    parse_projects()
}

# - [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/estimate
# - [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/memberships
# - [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/template
