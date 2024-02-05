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

simplify_role <- function(user) {
  map_dfr(user, function(user) {
    user <- list_null_to_na(user)
    user$role <- as_tibble(user$role) %>%
      rename(
        role_name = name,
        entity_id = id
      )
    user$role <- list(user$role)
    as_tibble(user)
  }) %>%
    clean_names()
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
  membership <- membership %>%
    map_dfr(function(m) {
      if (is.null(m$hourlyRate)) {
      } else {
        m$hourlyRate <- list(as_tibble(m$hourlyRate))
      }
      if (is.null(m$costRate)) {
      } else {
        m$costRate <- list(as_tibble(m$costRate))
      }
      m
    }) %>%
    clean_names()

  if ("hourly_rate" %in% names(membership)) {
    membership <- membership %>%
      unnest(hourly_rate, keep_empty = TRUE) %>%
      rename(
        rate_amount = amount,
        rate_currency = currency
      )
  }

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
#' @param email Email address for user
#' @param send_email Whether to send email to user
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
#' @param active A Boolean indicating whether or not user is active. Can also specify either `"ACTIVE"` or `"INACTIVE"`.
#'
#' @export
user_update_status <- function(user_id, active) {
  body <- list(
    membershipStatus = check_active(active)
  )

  result <- PUT(
    sprintf("/workspaces/%s/users/%s", workspace(), user_id),
    body = body
  )

  content(result) %>% unpack_workspace()
}

#' Update hourly rate
#'
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
user_update_hourly_rate <- function(user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = time_format(since)
  )

  result <- PUT(
    sprintf("/workspaces/%s/users/%s/hourly-rate", workspace(), user_id),
    body = body
  )

  content(result) %>% unpack_workspace()
}

#' Update cost rate
#'
#' For this to work you need to enable expenses (under the _General_ tab in
#' _Workspace Settings_). It's only available on the PRO plan.
#'
#' @param user_id User ID
#' @param rate Rate
#' @param since New rate will be applied to all time entries after this time
#'
#' @export
user_update_cost_rate <- function(user_id, rate, since = NULL) {
  body <- list(
    amount = rate,
    since = time_format(since)
  )

  result <- PUT(
    sprintf("/workspaces/%s/users/%s/cost-rate", workspace(), user_id),
    body = body
  )

  content(result) %>% unpack_workspace()
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
    entityId = entity_id
  )

  result <- POST(
    sprintf("/workspaces/%s/users/%s/roles", workspace(), user_id),
    body = body
  )

  content(result) %>% simplify_role()
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
    entityId = entity_id
  )

  result <- DELETE(
    sprintf("/workspaces/%s/users/%s/roles", workspace(), user_id),
    body = body
  )

  status_code(result) %in% c(200, 201, 204)
}

#' Delete user
#'
#' @param user_id User ID
#'
#' @export
user_delete <- function(user_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/users/%s", workspace(), user_id)
  )

  status_code(result) %in% c(200, 201)
}
