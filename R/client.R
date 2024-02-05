#' Parameters for client functions
#'
#' @name client-parameters
#'
#' @param client_id Client ID
#' @param concise Generate concise output
NULL

parse_client <- function(client, concise = TRUE) {
  client <- client %$%
    tibble(
      client_id = id,
      client_name = name,
      workspaceId,
      archived,
      address = ifelse(is.null(address) || address == "", NA, address)
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
#' @inheritParams client-parameters
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

  paginate(path) %>%
    map_df(parse_client, concise = concise)
}

#' Get client
#'
#' @inheritParams client-parameters
#'
#' @return A data frame with one record per client
#' @export
#'
#' @examples
#' \dontrun{
#' client("63a5493591ed63165538976d")
#' }
client <- function(client_id, concise = TRUE) {
  path <- sprintf("/workspaces/%s/clients/%s", workspace(), client_id)

  GET(path) %>%
    content() %>%
    parse_client(concise = concise)
}

#' Add a new client to workspace
#'
#' @inheritParams users
#'
#' @param name Client name
#' @inheritParams client-parameters
#'
#' @return A data frame with one row per record.
#' @export
#'
#' @examples
#' \dontrun{
#' client_create("RStudio")
#' }
client_create <- function(name, concise = TRUE) {
  path <- sprintf("/workspaces/%s/clients", workspace())

  body <- list("name" = name)

  POST(path, body = body) %>%
    content() %>%
    parse_client(concise = concise)
}

#' Update a client
#'
#' @inheritParams client-parameters
#' @param name Client name
#' @param note Note about client
#' @param archived Whether or not client is archived
#'
#' @return A data frame with one record for the updated client.
#' @export
client_update <- function(client_id,
                          name = NULL,
                          note = NULL,
                          archived = NULL) {
  log_debug("Update client.")
  path <- sprintf("/workspaces/%s/clients/%s", workspace(), client_id)

  if (is.null(name)) {
    log_debug("Client name not supplied.")
    name <- client(client_id)$client_name
  }

  body <- list(
    name = name,
    note = note,
    archived = as.logical(archived)
  ) %>%
    list_remove_empty()

  PUT(path, body = body) %>%
    content() %>%
    parse_client()
}

#' Delete a client from workspace
#'
#' A client must first be archived before it can be deleted.
#'
#' @param client_id Client ID
#' @param archive Archive client before deleting.
#'
#' @return A Boolean: \code{TRUE} on success or \code{FALSE} on failure.
#' @export
client_delete <- function(client_id, archive = FALSE) {
  log_debug("Delete client.")

  if (archive) {
    client_update(client_id, archived = TRUE)
  }
  path <- sprintf("/workspaces/%s/clients/%s", workspace(), client_id)
  result <- DELETE(path)
  status_code(result) == 200
}
