#' Get clients
#'
#' @return A data frame with one record per client.
#' @export
#'
#' @examples
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' clients()
clients <- function(concise = TRUE) {
  path <- sprintf("/workspaces/%s/clients", workspace())
  clients <- GET(path) %>%
    content() %>%
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

  if (concise) {
    clients <- clients %>% select(client_id, client_name, workspace_id)
  }

  clients
}
