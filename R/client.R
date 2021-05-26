#' Client
#'
#' A wrapper function that returns client_id, client_name, workspaceId, archived and address.
#' If there is no address it returns NA.
#'
#' @param workspace_id A character vector used to identify clients in the workspace.
#'
#' @return
#' @export
#'
#' @examples clients(workspace_id = "5c0fe3290cl84304845dbf1f")
clients <- function(workspace_id) {
  path <- sprintf("/workspaces/%s/clients", workspace_id)
  clients <- GET(path)
  content(clients) %>%
    map_df(function(client) {
      with(
        client,
        tibble(
          client_id = id,
          client_name = name,
          workspaceId,
          archived,
          address = ifelse(is.null(address) || address == "", NA, address)
        )
      )
    }) %>%
    clean_names()
}
