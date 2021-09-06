parse_client <- function(client, concise) {
  client <- with(
    client,
    tibble(
      client_id = id,
      client_name = name,
      workspaceId,
      archived,
      address = ifelse(is.null(address) || address == "", NA, address)
    )
  ) %>%
    clean_names() %>%
    select(client_id, workspace_id, client_name, archived, address)

  if (concise) {
    client %>% select(-archived, -address)
  } else {
    client
  }
}

#' Get clients
#'
#' @inheritParams users
#'
#' @return A data frame with one record per client.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' clients()
#' }
clients <- function(concise = TRUE) {
  path <- sprintf("/workspaces/%s/clients", workspace())
  clients <- GET(path) %>%
    content() %>%
    map_df(parse_client, concise = concise)

  clients
}

#' Add a new client to workspace
#'
#' Wraps \code{POST /workspaces/{workspaceId}/clients}.
#'
#' @inheritParams users
#'
#' @param name Client name
#'
#' @return A data frame with one row per record.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' client_insert("RStudio")
#' }
client_insert <- function(name, concise = TRUE) {
  path <- sprintf("/workspaces/%s/clients", workspace())

  body <- list("name" = name)

  POST(path, body = body) %>%
    content() %>%
    parse_client(concise = concise)
}
