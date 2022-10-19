#' Get custom fields
#'
#' Custom fields are only listed for specific projects if the default values for
#' those fields have been modified for those projects.
#'
#' Custom fields are only available on the Pro and Enterprise plans.
#'
#' @param project_id Project ID
#'
#' @export
custom_fields <- function(project_id = NULL) {
  path <- sprintf("/workspaces/%s/", workspace())
  if (!is.null(project_id)) {
    path <- paste0(path, sprintf("projects/%s/", project_id))
  }
  path <- paste0(path, "custom-fields")

  response <- GET(path)

  tibble(fields = content(response)) %>%
    unnest_wider(fields) %>%
    clean_names() %>%
    rename(custom_field_id = id)
}

#' Update a custom field on a project
#'
#' @param project_id Project ID
#' @param custom_field_id Custom field ID
#' @param default_value A default value for the field
#' @param status Status
#'
#' @export
custom_field_update <- function(project_id,
                                custom_field_id,
                                default_value = NULL,
                                status = NULL) {
  path <- sprintf("/workspaces/%s/projects/%s/custom-fields/%s", workspace(), project_id, custom_field_id)

  body <- list(
    defaultValue = default_value,
    status = status
  )

  response <- PATCH(
    path,
    body = body
  )

  tibble(fields = list(content(response))) %>%
    unnest_wider(fields) %>%
    clean_names()
}

#' Remove a custom field from a project
#'
#' @param project_id Project ID
#' @param custom_field_id Custom field ID
#'
#' @export
custom_field_delete <- function(project_id,
                                custom_field_id) {
  path <- sprintf("/workspaces/%s/projects/%s/custom-fields/%s", workspace(), project_id, custom_field_id)

  response <- DELETE(path)

  tibble(fields = list(content(response))) %>%
    unnest_wider(fields) %>%
    clean_names()
}
