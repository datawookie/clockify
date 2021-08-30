simplify_user <- function(user, active = TRUE, show_workspace = FALSE) {
  user$memberships <- NULL
  user$settings <- NULL
  user$profilePicture <- NULL

  for (field in c("name", "activeWorkspace", "defaultWorkspace")) {
    if (is.null(user[[field]])) user[[field]] <- NA
  }

  user <- user %>%
    as_tibble() %>%
    clean_names() %>%
    rename(
      user_id = id
    )

  if (active) user <- user %>% filter(status == "ACTIVE")
  if (!show_workspace) user <- user %>% select(-ends_with("workspace"))

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
user <- function(show_workspace = FALSE) {
  user <- GET("/user")
  user %>%
    content() %>%
    simplify_user(show_workspace = show_workspace)
}

#' Get list of users in active workspace
#'
#' @param active Only include active users
#' @param show_workspace Show active and default workspace IDs
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
#' users(show_workspace = TRUE)
#' }
users <- function(active = TRUE, show_workspace = FALSE) {
  path <- sprintf("/workspaces/%s/users", workspace())
  users <- GET(path)

  users <- content(users) %>%
    map_dfr(simplify_user, active, show_workspace)

  users
}
