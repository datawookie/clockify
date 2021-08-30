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
    "clientId",
    "description",
    "end",
    "error",
    "name",
    "project_id",
    "public",
    "start",
    "status",
    "template",
    "timeInterval",
    "time_end",
    "time_start",
    "user_id",
    "workspace_id",
    "workspaceId"
  )
)
