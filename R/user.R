simplify_user <- function(user, active = TRUE, concise = TRUE) {
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

  if (active) user <- user %>% filter(status == "ACTIVE")
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
  list_null_to_na(membership) %>%
    map_dfr(as_tibble) %>%
    clean_names()
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
users <- function(active = TRUE, concise = TRUE) {
  path <- sprintf("/workspaces/%s/users", workspace())
  users <- GET(path)

  content(users) %>%
    map_dfr(simplify_user, active, concise)
}

#' Create a user
#'
#' @export
user_create <- function(email, send_email = TRUE) {
  warning("Creating users is a paid feature.", call. = FALSE, immediate. = TRUE)

  path <- sprintf("/workspaces/%s/users", workspace())

  body <- list(
    email = email
  )
  query <- list(
    sendEmail = ifelse(send_email, "true", "false")
  )

  result <- POST(
    path,
    body = body,
    query = query
  )

  print(result)
  print(content(result))
}
