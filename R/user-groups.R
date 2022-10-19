EMPTY_USER_GROUPS <- tibble(
  group_id = character(),
  name = character(),
  workspace_id = character(),
  user_id = list()
)

simplify_group <- function(group) {
  if (length(group$userIds) == 0) {
    group$userIds <- character()
  }
  group$userIds <- tibble(user_id = group$userIds %>% unlist()) %>% list()

  group %>%
    as_tibble() %>%
    clean_names() %>%
    rename(
      group_id = id,
      user_id = user_ids
    )
}

# content(result) %>%
#   map_dfr(simplify_group) %>%
#   pull(user_id)

#' Get user groups
#'
#' @return A data frame with one record per user group.
#' @export
#'
#' @examples
#' \dontrun{
#' user_groups()
#' }
user_groups <- function() {
  result <- GET(sprintf("/workspaces/%s/user-groups", workspace()))

  groups <- content(result) %>%
    map_dfr(simplify_group)

  if (nrow(groups)) {
    groups
  } else {
    EMPTY_USER_GROUPS
  }
}

#' Create a user group
#'
#' @param name Name of user group
#'
#' @export
user_group_create <- function(name) {
  body <- list(
    name = name
  )

  result <- POST(
    sprintf("/workspaces/%s/user-groups", workspace()),
    body = body
  )

  content(result) %>% simplify_group()
}

#' Update a user group
#'
#' @param group_id User group ID
#' @param name Name of user group
#'
#' @export
user_group_update <- function(group_id, name) {
  body <- list(
    name = name
  )

  result <- PUT(
    sprintf("/workspaces/%s/user-groups/%s", workspace(), group_id),
    body = body
  )

  content(result) %>% simplify_group()
}

#' Delete a user group
#'
#' @param group_id User group ID
#'
#' @export
user_group_delete <- function(group_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/user-groups/%s", workspace(), group_id)
  )

  content(result) %>% simplify_group()
}

#' Add a user to a user group
#'
#' @param group_id User group ID
#' @param user_id User ID
#'
#' @export
user_group_user_add <- function(group_id, user_id) {
  body <- list(
    userId = user_id
  )

  result <- POST(
    sprintf("/workspaces/%s/user-groups/%s/users", workspace(), group_id),
    body = body
  )

  content(result) %>% simplify_group()
}

#' Remove a user from a user group
#'
#' @param group_id User group ID
#' @param user_id User ID
#'
#' @export
user_group_user_remove <- function(group_id, user_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/user-groups/%s/users/%s", workspace(), group_id, user_id)
  )

  content(result) %>% simplify_group()
}
