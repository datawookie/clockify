#' Helper function for parsing tags
#'
#' @noRd
#'
parse_tags <- function(tags) {
  tibble(tags) %>%
    unnest_wider(tags) %>%
    select(tag_id = id, workspaceId, everything()) %>%
    clean_names()
}

#' Get tags
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' tags()
#' }
tags <- function() {
  path <- sprintf("/workspaces/%s/tags", workspace())

  paginate(path) %>%
    parse_tags()
}

#' Get tag
#'
#' @param tag_id Tag ID
#'
#' @return A data frame with one record per tag
#' @export
#'
#' @examples
#' \dontrun{
#' tag("5f2d9bc659badb2a849c027e")
#' }
tag <- function(tag_id) {
  result <- GET(
    sprintf("/workspaces/%s/tags/%s", workspace(), tag_id)
  )

  content(result) %>%
    list() %>%
    parse_tags()
}

#' Create tag
#'
#' @param name Tag name
#'
#' @export
#'
#' @examples
#' \dontrun{
#' tag_create("Size: S")
#' tag_create("Size: M")
#' tag_create("Size: L")
#' tag_create("Size: XL")
#' }
tag_create <- function(name) {
  body <- list(
    name = name
  )

  result <- POST(
    sprintf("/workspaces/%s/tags", workspace()),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tags()
}

#' Update tag
#'
#' @param tag_id Tag ID
#' @param name Tag name
#' @param archived Whether or not item is archived
#'
#' @export
#'
#' @examples
#' \dontrun{
#' tag_update("5f2d9bc659badb2a849c027e", "Size: Large")
#' tag_update("5f2d9bc659badb2a849c027e", archived = TRUE)
#' tag_update("5f2d9bc659badb2a849c027e", "Size: L", FALSE)
#' }
tag_update <- function(tag_id, name = NULL, archived = NULL) {
  body <- list(
    name = name,
    archived = archived
  ) %>%
    list_remove_empty()

  result <- PUT(
    sprintf("/workspaces/%s/tags/%s", workspace(), tag_id),
    body = body
  )

  content(result) %>%
    list() %>%
    parse_tags()
}

#' Delete tag
#'
#' @param tag_id Tag ID
#'
#' @export
#'
#' @examples
#' \dontrun{
#' tag_delete("5f2d9bc659badb2a849c027e")
#' }
tag_delete <- function(tag_id) {
  result <- DELETE(
    sprintf("/workspaces/%s/tags/%s", workspace(), tag_id)
  )
  status_code(result) == 200
}
