#' Get all my shared reports
#'
#' @return A data frame with one record per user group.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_key(Sys.getenv("CLOCKIFY_API_KEY"))
#'
#' shared_reports()
#' }
# shared_reports <- function() {
#   path <- sprintf("/workspaces/%s/shared-reports", workspace())
#   # GET(path) %>%
#   #   content()
#
#   reports <- paginate(path)
# }
