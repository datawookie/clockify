#' Helper function for parsing projects
#'
#' @noRd
#'
parse_projects <- function(projects, concise = TRUE) {
  projects <- tibble(projects) %>%
    unnest_wider(projects)

  projects <- projects %>%
    # TODO: There are a lot more fields which can be included here.
    select(
      project_id = id,
      project_name = name,
      clientId,
      workspaceId,
      billable,
      public,
      archived,
      template,
      memberships,
      timeEstimate
    ) %>%
    clean_names() %>%
    mutate(
      client_id = ifelse(client_id == "", NA, client_id),
      time_estimate = map(time_estimate, function(estimate) {
        if (is.null(estimate$resetOption)) estimate$resetOption <- NA
        estimate %>%
          as_tibble() %>%
          clean_names()
      })
    )

  if (concise) {
    projects %>%
      select(-workspace_id, -public, -template, -memberships, -time_estimate)
  } else {
    projects %>%
      mutate(
        memberships = map(memberships, simplify_membership)
      )
  }
}

#' Get projects
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
    content() %>%
    list() %>%
    parse_projects(concise = concise)
}

#' Create project
#'
#' @param name Project name
#' @param client_id Client ID
#'
#' @export
project_create <- function(name,
                           client_id = NULL) {
  path <- sprintf("/workspaces/%s/projects", workspace())

  body <- list(
    name = name,
    clientId = client_id
  ) %>%
    list_remove_empty()

  response <- POST(
    path,
    body = body
  )

  content(response) %>%
    list() %>%
    parse_projects()
}

#' Delete project
#'
#' An active project cannot be deleted. Archive the project first.
#'
#' @param project_id Project ID
#'
#' @export
project_delete <- function(project_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/projects/%s", workspace(), project_id)
  )
  status_code(result) == 200
}

#' Update project
#'
#' Adjust the project characteristics.
#'
#' These functions enable the following functionality:
#'
#' - change the project name
#' - change the client ID associated with the project
#' - toggle whether project is archived and
#' - toggle whether project is a template (paid plan only).
#'
#' @name project-update
#' @rdname project-update
#'
#' @param project_id Project ID
#' @param name Project name
#' @param client_id Client ID
#' @param archived Whether or not project is archived
#' @param is_template Whether or not project is a template
NULL

#' @rdname project-update
#' @export
project_update <- function(project_id,
                           name = NULL,
                           client_id = NULL,
                           archived = NULL) {
  body <- list(
    name = name,
    client_id = client_id,
    archived = archived
  ) %>%
    list_remove_empty()

  response <- PUT(
    sprintf("/workspaces/%s/projects/%s", workspace(), project_id),
    body = body
  )

  content(response) %>%
    list() %>%
    parse_projects()
}

#' Only available on a paid plan.
#'
#' @rdname project-update
#' @export
project_update_template <- function(project_id, is_template = TRUE) {
  body <- list(
    isTemplate = is_template
  )

  result <- PATCH(
    sprintf("/workspaces/%s/projects/%s/template", workspace(), project_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_projects(concise = FALSE)
}

#' Update user billable rate on project
#'
#' @param project_id Project ID
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
project_update_billable_rate <- function(project_id, user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = since
  )

  result <- PUT(
    sprintf("/workspaces/%s/projects/%s/users/%s/hourly-rate", workspace(), project_id, user_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_projects()
}

#' Update user cost rate on project
#'
#' Only available on a paid plan.
#'
#' @param project_id Project ID
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
project_update_cost_rate <- function(project_id, user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = since
  )

  result <- PUT(
    sprintf("/workspaces/%s/projects/%s/users/%s/cost-rate", workspace(), project_id, user_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_projects()
}

project_update_estimate <- function(project_id,
                                    quantity = "budget",
                                    estimate = NULL,
                                    manual = TRUE,
                                    active = NULL,
                                    monthly = FALSE) {
  check_quantity(quantity) # nocov

  body <- list(
    estimate = list(
      estimate = estimate,
      type = ifelse(manual, "MANUAL", "AUTO"),
      active = active,
      resetOption = if (monthly) "MONTHLY" else NULL
    )
  ) %>% list_remove_empty()

  names(body) <- paste0(quantity, "Estimate")

  result <- PATCH(
    sprintf("/workspaces/%s/projects/%s/estimate", workspace(), project_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_projects()
}

#' Update project time & budget estimates
#'
#' @name project-update-estimate
#' @rdname project-update-estimate
#'
#' @param project_id Project ID
#' @param estimate Updated estimate
#' @param manual Is the estimate for the whole project (`TRUE`) or should task-base estimate be enabled (`FALSE`).
#' @param active Activate this estimate. Only one of either time or budget estimate may be active.
#' @param monthly Should estimate be reset monthly?
NULL

#' @rdname project-update-estimate
#' @export
#' @examples
#' \dontrun{
#' project_update_estimate_time("612b16c0bc325f120a1e5099", "PT1H0M0S", TRUE, TRUE)
#' }
project_update_estimate_time <- function(project_id, estimate = NULL, manual = TRUE, active = TRUE, monthly = FALSE) {
  if (active) {
    # Deactivate budget estimate.
    project_update_estimate(project_id, "budget", active = FALSE)
  }
  project_update_estimate(project_id, "time", estimate, manual, active)
}

#' Only available on a paid plan.
#'
#' @rdname project-update-estimate
#' @export
#' @examples
#' \dontrun{
#' project_update_estimate_budget("612b16c0bc325f120a1e5099", 1000, TRUE, TRUE)
#' }
project_update_estimate_budget <- function(project_id, estimate = NULL, manual = TRUE, active = TRUE, monthly = FALSE) {
  if (active) {
    # Deactivate time estimate.
    project_update_estimate(project_id, "time", active = FALSE)
  }
  project_update_estimate(project_id, "budget", estimate, manual, active)
}

#' Update project memberships
#'
#' @param project_id Project ID
#' @param user_id One or more user IDs
#'
#' @export
project_update_memberships <- function(project_id, user_id) {
  body <- list(
    memberships = lapply(
      user_id,
      function(user_id) {
        list(userId = user_id)
      }
    )
  )

  result <- PATCH(
    sprintf("/workspaces/%s/projects/%s/memberships", workspace(), project_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_projects(concise = FALSE)
}
