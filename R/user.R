simplify_user <- function(user) {
  user$memberships <- NULL
  user$settings <- NULL
  user$profilePicture <- NULL

  user %>%
    as_tibble() %>%
    clean_names() %>%
    rename(
      user_id = id
    )
}

#' Get information for logged in user
#'
#' @return
#' @export
#'
#' @examples
user <- function() {
  user <- GET("/user") %>%
    content() %>%
    simplify_user()
}

#' Get list of users in workspace
#'
#' @return
#' @export
#'
#' @examples
users <- function() {
  path <- sprintf("/workspaces/%s/users", workspace())
  users <- GET(path)

  content(users) %>%
    map_dfr(simplify_user)
}
