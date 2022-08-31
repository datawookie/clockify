simplify_user <- function(user, active = NULL, concise = TRUE) {
  user$memberships <- list(simplify_membership(user$memberships))
  user$settings <- NULL
  user$profilePicture <- NULL
  user$customFields <- NULL

  for (field in c("name", "activeWorkspace", "defaultWorkspace")) {
    if (is.null(user[[field]])) user[[field]] <- NA_character_
  }

  user <- user %>%
    as_tibble() %>%
    clean_names() %>%
    rename(
      user_id = id,
      user_name = name
    )

  if (!is.null(active) && active) user <- user %>% filter(status == "ACTIVE")
  if (concise) {
    user <- user %>% select(user_id, user_name, status)
  }

  user
}

#' Unpack membership data
#'
#' The `target_id` and `membership_type` columns need to be consider together.
#' For example, if `membership_type` is `WORKSPACE` then the value in the
#' `target_id` column is a workspace ID. If, however, `membership_type` is
#' `PROJECT` then the value in the `target_id` column is a project ID.
#'
#' @noRd
simplify_membership <- function(membership) {
  membership <- list_null_to_na(membership) %>%
    map_dfr(as_tibble) %>%
    clean_names()

  if ("target_id" %in% names(membership)) {
    membership <- membership %>%
      rename(project_id = target_id)
  }

  membership
}

#' Get ID for authenticated user.
#' @noRd
user_get_id <- function() {
  user(concise = FALSE)$user_id
}

#' Get information for authenticated user
#'
#' @inheritParams users
#'
#' @return A data frame with details of user profile.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' user()
#' }
user <- function(concise = TRUE) {
  user <- GET("/user")
  user %>%
    content() %>%
    simplify_user(concise = concise)
}

#' Get list of users in active workspace
#'
#' @param active Only include active users
#' @param concise Generate concise output
#'
#' @return A data frame with one record per user.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' # Show only active users.
#' users()
#' # Show all users.
#' users(active = FALSE)
#' # Show active & default workspace for each user.
#' users(concise = FALSE)
#' }
users <- function(active = NULL, concise = TRUE) {
  users <- GET(sprintf("/workspaces/%s/users", workspace()))

  content(users) %>%
    map_dfr(simplify_user, active, concise)
}

#' Create a user
#'
#' @export
user_create <- function(email, send_email = TRUE) {
  warning("Creating users is a paid feature.", call. = FALSE, immediate. = TRUE)

  body <- list(
    email = email
  )
  query <- list(
    sendEmail = ifelse(send_email, "true", "false")
  )

  result <- POST(
    sprintf("/workspaces/%s/users", workspace()),
    body = body,
    query = query
  )

  status_code(result) %in% c(200, 201)
}

#' Update status
#'
#' @param user_id User ID
#' @param active A Boolean indicating whether or not user is active.
#'
#' @export
user_update_status <- function(user_id, active) {
  body <- list(
    membershipStatus = ifelse(active, "ACTIVE", "INACTIVE")
  )

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/users/%s", workspace(), user_id),
    body = body
  )

  content(result) %>% simplify_workspace()
}

#' Update billable rate
#'
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
user_update_billable_rate <- function(user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = clockify:::time_format(since)
  )

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/users/%s/hourly-rate", workspace(), user_id),
    body = body
  )

  status_code(result) %in% c(200, 201)
}

#' Update cost rate
#'
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
user_update_cost_rate <- function(user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = clockify:::time_format(since)
  )

  result <- clockify:::PUT(
    sprintf("/workspaces/%s/users/%s/cost-rate", workspace(), user_id),
    body = body
  )

  status_code(result) %in% c(200, 201)
}

check_valid_role <- function(role) {
  if (!(role %in% c("TEAM_MANAGER", "PROJECT_MANAGER", "WORKSPACE_ADMIN"))) {
    stop("Invalid role.")
  }
}

#' Update user roles
#'
#' @name user-update-role
#'
#' @param user_id User ID
#' @param role One of `"TEAM_MANAGER"`, `"PROJECT_MANAGER"` or
#'   `"WORKSPACE_ADMIN"`.
#' @param entity_id Depending on `role`, this is a user ID (for
#'   `"TEAM_MANAGER"`), a project ID (for `"PROJECT_MANAGER"`) or a workspace ID
#'   (for `"WORKSPACE_ADMIN"`).
#'
#' @export
user_update_role <- function(user_id, role, entity_id) {
  check_valid_role(role)

  body <- list(
    role = role,
    entity_id = entity_id
  )

  result <- clockify:::POST(
    sprintf("/workspaces/%s/users/%s/roles", workspace(), user_id),
    body = body
  )

  status_code(result) %in% c(200, 201)
}

#' Delete user roles
#'
#' @inheritParams user-update-role
#'
#' @export
user_delete_role <- function(user_id, role, entity_id) {
  check_valid_role(role)

  body <- list(
    role = role,
    entity_id = entity_id
  )

  result <- clockify:::DELETE(
    sprintf("/workspaces/%s/users/%s/roles", workspace(), user_id),
    body = body
  )

  status_code(result) %in% c(200, 201)
}

#' Delete user
#'
#' @param user_id User ID
#'
#' @export
user_delete <- function(user_id) {
  result <- clockify:::DELETE(
    sprintf("/workspaces/%s/users/%s", workspace(), user_id)
  )

  status_code(result) %in% c(200, 201)
}
