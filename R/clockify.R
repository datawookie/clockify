#' @import httr
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import janitor
#' @import logger
#' @import anytime
#' @import lubridate
#' @import tibble
#' @importFrom stats setNames
NULL

BASE_PATH <- "https://api.clockify.me/api/v1"
REPORTS_BASE_PATH <- "https://reports.api.clockify.me/v1"

globalVariables(
  c(
    ".",
    "address",
    "archived",
    "assignee_id",
    "assignee_ids",
    "billable",
    "clientId",
    "client_id",
    "client_name",
    "description",
    "end",
    "error",
    "memberships",
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
    "user_name",
    "workspace_id",
    "workspaceId"
  )
)
