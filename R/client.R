#' Title
#'
#' @param workspace_id
#'
#' @return
#' @export
#'
#' @examples
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
