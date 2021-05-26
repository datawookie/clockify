#' Title
#'
#' @return
#' @export
#'
#' @examples
clients <- function() {
  path <- sprintf("/workspaces/%s/clients", workspace())
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
