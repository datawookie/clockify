#' Title
#'
#' @return
#' @export
#'
#' @examples
user <- function() {
  user <- GET("/user")
  content(user)
}
