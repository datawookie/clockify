#' @import httr
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import janitor
#' @import logger
#' @import anytime
#' @import lubridate
#' @import tibble
#' @import stringi
#' @importFrom stats setNames
#' @importFrom methods is
NULL

BASE_PATH <- "https://api.clockify.me/api/v1"
REPORTS_BASE_PATH <- "https://reports.api.clockify.me/v1"

globalVariables(
  c(
    "%$%",
    ".",
    "address",
    "amount",
    "archived",
    "assignee_id",
    "assignee_ids",
    "assignees",
    "billable",
    "clientId",
    "client_id",
    "client_name",
    "currency",
    "description",
    "end",
    "error",
    "fields",
    "filters",
    "fixed_date",
    "groupOne",
    "hourly_rate",
    "is_public",
    "link",
    "memberships",
    "name",
    "project_color",
    "project_id",
    "public",
    "report_author",
    "start",
    "status",
    "template",
    "target_id",
    "time_estimate",
    "time_interval",
    "timeEstimate",
    "timeInterval",
    "time_end",
    "time_entry_id",
    "time_start",
    "type",
    "user_id",
    "user_ids",
    "user_name",
    "visible_to_users",
    "visible_to_user_groups",
    "workspace_id",
    "workspaceId"
  )
)
