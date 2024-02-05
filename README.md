{clockify}
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# clockify <img src="man/figures/clockify-hex.png" align="right" alt="" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/clockify)](https://cran.r-project.org/package=clockify)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/datawookie/clockify.svg)](https://app.codecov.io/github/datawookie/clockify)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)<!-- badges: end -->

An R wrapper around the [Clockify API](https://docs.clockify.me/).

The documentation for `{clockify}` is hosted at
<https://datawookie.github.io/clockify/>.

## API Key

You’re going to need to have an API key from your Clockify account. If
you don’t yet have an account, create one. Then retrieve the API key
from the [account settings](https://clockify.me/user/settings).

## Get Started

The first thing you’ll need to do is set up your API key. I store mine
in an environment variable called `CLOCKIFY_API_KEY`.

<!-- Use API key from demo account. -->

``` r
CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
```

Now load the `{clockify}` package and specify the API key.

``` r
library(clockify)

set_api_key(CLOCKIFY_API_KEY)
```

Let’s turn on some logging so we can see what’s happening behind the
scenes.

``` r
library(logger)

log_threshold(INFO)
```

## Workspaces

Retrieve a list of available workspaces.

``` r
workspaces()
```

    # A tibble: 3 × 3
      workspace_id             name               memberships      
      <chr>                    <chr>              <list>           
    1 5ef46294df73063139f60bfc Fathom Data        <tibble [22 × 6]>
    2 61343c45ab05e02be2c8c1fd Personal           <tibble [2 × 4]> 
    3 630c61ba9c3a3c3112812332 {clockify} sandbox <tibble [5 × 6]> 

Select a specific workspace.

``` r
workspace("630c61ba9c3a3c3112812332")
```

    [1] "630c61ba9c3a3c3112812332"

## Users

Retrieve information on your user profile.

``` r
user()
```

    # A tibble: 1 × 3
      user_id                  user_name      status
      <chr>                    <chr>          <chr> 
    1 5f227e0cd7176a0e6e754409 Andrew Collier ACTIVE

Get a list of users.

``` r
users()
```

    # A tibble: 5 × 3
      user_id                  user_name      status                    
      <chr>                    <chr>          <chr>                     
    1 5f227e0cd7176a0e6e754409 Andrew Collier ACTIVE                    
    2 630f17f04a05b20faf7e0afc Bob Smith      ACTIVE                    
    3 630f16ab90cfd878937a7997 <NA>           NOT_REGISTERED            
    4 630f1cb9cb18da61cfd58659 Carol Brown    PENDING_EMAIL_VERIFICATION
    5 630f15d3b59c366b0e3ae2e6 Alice Jones    ACTIVE                    

## Clients

Get a list of clients.

``` r
clients()
```

    # A tibble: 1 × 3
      client_id                workspace_id             client_name
      <chr>                    <chr>                    <chr>      
    1 63a55695db26c25e9d4e2d02 630c61ba9c3a3c3112812332 RStudio    

## Projects

Get a list of projects.

``` r
projects()
```

    # A tibble: 3 × 5
      project_id               project_name client_id              billable archived
      <chr>                    <chr>        <chr>                  <lgl>    <lgl>   
    1 632a94f8d801fa1178d366b8 test         <NA>                   TRUE     FALSE   
    2 630ce53290cfd8789366fd49 {clockify}   63a55695db26c25e9d4e2… TRUE     FALSE   
    3 630ce53cb59c366b0e27743f {emayili}    63a55695db26c25e9d4e2… TRUE     FALSE   

## Time Entries

### Retrieve Time Entries

Retrieve the time entries for the authenticated user.

``` r
time_entries()
```

Retrieve time entries for another user specified by their user ID.

``` r
time_entries(user_id = "630f15d3b59c366b0e3ae2e6")
```

### Insert Time Entry

``` r
prepare_cran_entry <- time_entry_create(
  project_id = "630ce53290cfd8789366fd49",
  start = "2021-08-30 08:00:00",
  end = "2021-08-30 10:30:00",
  description = "Prepare for CRAN submission"
)
```

Check on the ID for this new time entry.

``` r
prepare_cran_entry$time_entry_id
```

    [1] "64f21f2ad397e5503bef3bb4"

Confirm that it has been inserted.

``` r
time_entries(concise = FALSE) %>%
  select(time_entry_id, description, time_start, time_end)
```

    # A tibble: 1 × 4
      time_entry_id            description   time_start          time_end           
      <chr>                    <chr>         <dttm>              <dttm>             
    1 64f21f2ad397e5503bef3bb4 Prepare for … 2021-08-30 08:00:00 2021-08-30 10:30:00

### Delete Time Entry

``` r
time_entry_delete(prepare_cran_entry$time_entry_id)
```

    [1] TRUE

Confirm that it has been deleted.

``` r
time_entries(concise = FALSE) %>%
  select(time_entry_id, description, time_start, time_end)
```

    # A tibble: 0 × 4
    # ℹ 4 variables: time_entry_id <chr>, description <chr>, time_start <dttm>,
    #   time_end <dttm>

## Endpoints

<!-- This list generated by api-get-endpoints.R. -->

Endpoints which have currently been implemented in this package.
Endpoints which are only available on a paid plan are indicated with a
💰.

- [x] GET /workspaces/{workspaceId}/clients
- [x] POST /workspaces/{workspaceId}/clients
- [x] PUT /workspaces/{workspaceId}/clients/{clientId}
- [x] DELETE /workspaces/{workspaceId}/clients/{clientId}
- [x] GET /workspaces/{workspaceId}/projects
- [x] GET /workspaces/{workspaceId}/projects/{projectId}
- [x] POST /workspaces/{workspaceId}/projects
- [x] PUT /workspaces/{workspaceId}/projects/{projectId}
- [x] PUT
  /workspaces/{workspaceId}/projects/{projectId}/users/{userId}/hourly-rate
- [x] PUT
  /workspaces/{workspaceId}/projects/{projectId}/users/{userId}/cost-rate
- [x] PATCH /workspaces/{workspaceId}/projects/{projectId}/estimate
- [x] PATCH /workspaces/{workspaceId}/projects/{projectId}/memberships
- [x] PATCH /workspaces/{workspaceId}/projects/{projectId}/template
- [x] DELETE /workspaces/{workspaceId}/projects/{id}
- [x] GET /workspaces/{workspaceId}/tags
- [x] GET /workspaces/{workspaceId}/tags/{tagId}
- [x] POST /workspaces/{workspaceId}/tags
- [x] PUT /workspaces/{workspaceId}/tags/{tagId}
- [x] DELETE /workspaces/{workspaceId}/tags/{tagId}
- [x] GET /workspaces/{workspaceId}/projects/{projectId}/tasks
- [x] GET /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
- [x] POST /workspaces/{workspaceId}/projects/{projectId}/tasks
- [x] PUT /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
- [x] PUT
  /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/hourly-rate
- [x] PUT
  /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/cost-rate
- [x] DELETE
  /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
- [x] GET /workspaces/{workspaceId}/user/{userId}/time-entries
- [x] GET /workspaces/{workspaceId}/time-entries/{id}
- [x] POST /workspaces/{workspaceId}/time-entries
- [x] POST /workspaces/{workspaceId}/user/{userId}/time-entries 💰
- [x] PATCH /workspaces/{workspaceId}/user/{userId}/time-entries 💰
- [x] PUT /workspaces/{workspaceId}/time-entries/{id}
- [x] PATCH /workspaces/{workspaceId}/time-entries/invoiced
- [x] DELETE /workspaces/{workspaceId}/time-entries/{id}
- [x] GET /user
- [x] GET /workspaces/{workspaceId}/users
- [x] POST /workspaces/{workspaceId}/users 💰
- [x] PUT /workspaces/{workspaceId}/users/{userId}
- [x] PUT /workspaces/{workspaceId}/users/{userId}/hourly-rate
- [x] PUT /workspaces/{workspaceId}/users/{userId}/cost-rate
- [x] POST /workspaces/{workspaceId}/users/{userId}/roles
- [x] DELETE /workspaces/{workspaceId}/users/{userId}/roles
- [x] DELETE /workspaces/{workspaceId}/users/{userId}
- [x] GET /workspaces/{workspaceId}/user-groups
- [x] POST /workspaces/{workspaceId}/user-groups
- [x] PUT /workspaces/{workspaceId}/user-groups/{userGroupId}
- [x] DELETE /workspaces/{workspaceId}/user-groups/{userGroupId}
- [x] POST /workspaces/{workspaceId}/user-groups/{userGroupId}/users
- [x] DELETE
  /workspaces/{workspaceId}/user-groups/{userGroupId}/users/{userId}
- [x] GET /workspaces
- [x] GET /workspaces/{workspaceId}/custom-fields
- [x] GET /workspaces/{workspaceId}/projects/{projectid}/custom-fields
- [x] PATCH
  /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
- [x] DELETE
  /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
- [x] POST /workspaces/{workspaceId}/reports/summary
- [x] POST /workspaces/{workspaceId}/reports/detailed
- [x] POST /workspaces/{workspaceId}/reports/weekly
- [x] GET /workspaces/{workspaceId}/shared-reports
- [x] GET /shared-reports/{sharedReportId}
- [x] POST /workspaces/{workspaceId}/shared-reports
- [x] PUT /workspaces/{workspaceId}/shared-reports/{sharedReportId}
- [x] DELETE /workspaces/{workspaceId}/shared-reports/{sharedReportId}
