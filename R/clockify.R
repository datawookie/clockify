#' @import httr
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import janitor
#' @import logger
#' @import anytime
#' @import lubridate
NULL

BASE_PATH = "https://api.clockify.me/api/v1"

globalVariables(
  c(
    "billable",
    "description",
    "error",
    "project_id",
    "timeInterval",
    "time_end",
    "time_start",
    "workspace_id",
    "name",
    "clientId",
    "workspaceId",
    "public",
    "template",
    "status"
  )
)
