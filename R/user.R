simplify_user <- function(user, active = TRUE, concise = TRUE) {
  user$memberships <- NULL
  user$settings <- NULL
  user$profilePicture <- NULL

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

#' Get information for logged in user
#'
#' @inheritParams users
#'
#' @return A data frame with details of user profile.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' \dontrun{
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
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' # Show only active users.
#' users()
#' # Show all users.
#' users(active = FALSE)
#' # Show active & default workspace for each user.
#' users(concise = FALSE)
users <- function(active = TRUE, concise = TRUE) {
  path <- sprintf("/workspaces/%s/users", workspace())
  users <- GET(path)

  users <- content(users) %>%
    map_dfr(simplify_user, active, concise)

  users
}
