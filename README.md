{clockify}
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# clockify <img src="man/figures/clockify-hex.png" align="right" alt="" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/clockify)](https://cran.r-project.org/package=clockify)
[![Travis-CI build
status](https://travis-ci.org/datawookie/clockify.svg?branch=master)](https://travis-ci.org/datawookie/clockify)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/datawookie/clockify.svg)](https://codecov.io/github/datawookie/clockify)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)<!-- badges: end -->

An R wrapper around the [Clockify
API](https://clockify.me/developers-api).

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
CLOCKIFY_API_KEY = Sys.getenv("CLOCKIFY_API_KEY")
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

log_threshold(DEBUG)
```

## Workspaces

Retrieve a list of available workspaces.

``` r
workspaces()
```

    2021-09-09 07:16:33 — GET /workspaces

    # A tibble: 2 × 2
      workspace_id             name       
      <chr>                    <chr>      
    1 5ef46294df73063139f60bfc Fathom Data
    2 61343c45ab05e02be2c8c1fd Personal   

Select a specific workspace.

``` r
workspace("61343c45ab05e02be2c8c1fd")
```

    2021-09-09 07:16:33 — Set active workspace -> 61343c45ab05e02be2c8c1fd.

    [1] "61343c45ab05e02be2c8c1fd"

## Users

Retrieve information on your user profile.

``` r
user()
```

    2021-09-09 07:16:33 — GET /user

    # A tibble: 1 × 3
      user_id                  user_name status
      <chr>                    <chr>     <chr> 
    1 5f227e0cd7176a0e6e754409 Andrew    ACTIVE

Get a list of users.

``` r
users()
```

    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/users

    # A tibble: 2 × 3
      user_id                  user_name status
      <chr>                    <chr>     <chr> 
    1 5f227e0cd7176a0e6e754409 Andrew    ACTIVE
    2 5ef46293df73063139f60bf5 Emma      ACTIVE

## Clients

Get a list of clients.

``` r
clients()
```

    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/clients

    # A tibble: 2 × 3
      client_id                workspace_id             client_name
      <chr>                    <chr>                    <chr>      
    1 61343c6c00dc8f48962b9be9 61343c45ab05e02be2c8c1fd Community  
    2 61343c5d00dc8f48962b9be3 61343c45ab05e02be2c8c1fd Fathom Data

## Projects

Get a list of projects.

``` r
projects()
```

    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/projects
    2021-09-09 07:16:34 — Page contains 2 results.
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/projects
    2021-09-09 07:16:34 — Page is empty.
    2021-09-09 07:16:34 — API returned 2 results.

    # A tibble: 2 × 4
      project_id               project_name client_id                billable
      <chr>                    <chr>        <chr>                    <lgl>   
    1 6134506c777d5361dcdeb3b5 {cex}        61343c5d00dc8f48962b9be3 TRUE    
    2 61343c9ba15c1d53ad33369f {clockify}   61343c5d00dc8f48962b9be3 FALSE   

## Time Entries

### Retrieve Time Entries

Retrieve the time entries for the authenticated user.

``` r
time_entries()
```

    2021-09-09 07:16:34 — GET /user
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:34 — Page contains 8 results.
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:34 — Page is empty.
    2021-09-09 07:16:34 — API returned 8 results.

    # A tibble: 8 × 4
      id                       project_id              
      <chr>                    <chr>                   
    1 61343cc1777d5361dcdea70a 61343c9ba15c1d53ad33369f
    2 61343d06777d5361dcdea729 61343c9ba15c1d53ad33369f
    3 61343d27ab05e02be2c8c266 61343c9ba15c1d53ad33369f
    4 613448d7777d5361dcdead37 61343c9ba15c1d53ad33369f
    5 61344bcad01d3b4a27a82310 61343c9ba15c1d53ad33369f
    6 6134548f00dc8f48962bace7 6134506c777d5361dcdeb3b5
    7 6134585a777d5361dcdebc5c 6134506c777d5361dcdeb3b5
    8 61345c45d01d3b4a27a833c7 6134506c777d5361dcdeb3b5
      description                                                          duration
      <chr>                                                                   <dbl>
    1 Setting up GitHub Actions                                                12  
    2 Make coffee                                                               5  
    3 Populate README.Rmd                                                      68  
    4 Add GET /workspaces/{workspaceId}/projects/{projectId}                   12.0
    5 Add GET /workspaces/{workspaceId}/projects/{projectId}/tasks             31.8
    6 Add GET https://cex.io/api/ticker/{symbol1}/{symbol2}                    16.0
    7 Add GET https://cex.io/api/tickers/{symbol1}/{symbol2}/.../{symbolN}     16.5
    8 Add GET https://cex.io/api/last_price/{symbol1}/{symbol2}                31.6

Retrieve time entries for another user specified by their user ID.

``` r
time_entries(user_id = "5ef46293df73063139f60bf5")
```

    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5ef46293df73063139f60bf5/time-entries
    2021-09-09 07:16:34 — Page contains 2 results.
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5ef46293df73063139f60bf5/time-entries
    2021-09-09 07:16:34 — Page is empty.
    2021-09-09 07:16:34 — API returned 2 results.

    # A tibble: 2 × 4
      id                       project_id               description        duration
      <chr>                    <chr>                    <chr>                 <dbl>
    1 613630ebba4b374e57155a72 61343c9ba15c1d53ad33369f Another test entry     87  
    2 613630cb89516b1767a56a08 61343c9ba15c1d53ad33369f Creating hex logo      45.4

### Insert Time Entry

``` r
prepare_cran_id <- time_entry_insert(
 project_id = "61343c9ba15c1d53ad33369f",
 start = "2021-08-30 08:00:00",
 end   = "2021-08-30 10:30:00",
 description = "Prepare for CRAN submission"
)
```

    2021-09-09 07:16:34 — Insert time entry.
    2021-09-09 07:16:34 — POST /workspaces/61343c45ab05e02be2c8c1fd/time-entries

Check on the ID for this new time entry.

``` r
prepare_cran_id
```

    [1] "6139a6c2dacb7878935d87ba"

Confirm that it has been inserted.

``` r
time_entries(concise = FALSE) %>%
  select(id, description, time_start, time_end)
```

    2021-09-09 07:16:34 — GET /user
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:34 — Page contains 9 results.
    2021-09-09 07:16:34 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:34 — Page is empty.
    2021-09-09 07:16:34 — API returned 9 results.

    # A tibble: 9 × 4
      id                      
      <chr>                   
    1 6139a6c2dacb7878935d87ba
    2 61343cc1777d5361dcdea70a
    3 61343d06777d5361dcdea729
    4 61343d27ab05e02be2c8c266
    5 613448d7777d5361dcdead37
    6 61344bcad01d3b4a27a82310
    7 6134548f00dc8f48962bace7
    8 6134585a777d5361dcdebc5c
    9 61345c45d01d3b4a27a833c7
      description                                                         
      <chr>                                                               
    1 Prepare for CRAN submission                                         
    2 Setting up GitHub Actions                                           
    3 Make coffee                                                         
    4 Populate README.Rmd                                                 
    5 Add GET /workspaces/{workspaceId}/projects/{projectId}              
    6 Add GET /workspaces/{workspaceId}/projects/{projectId}/tasks        
    7 Add GET https://cex.io/api/ticker/{symbol1}/{symbol2}               
    8 Add GET https://cex.io/api/tickers/{symbol1}/{symbol2}/.../{symbolN}
    9 Add GET https://cex.io/api/last_price/{symbol1}/{symbol2}           
      time_start          time_end           
      <dttm>              <dttm>             
    1 2021-08-30 09:00:00 2021-08-30 11:30:00
    2 2021-09-03 06:15:00 2021-09-03 06:27:00
    3 2021-09-03 06:27:00 2021-09-03 06:32:00
    4 2021-09-03 06:45:00 2021-09-03 07:53:00
    5 2021-09-05 05:34:31 2021-09-05 05:46:30
    6 2021-09-05 05:47:06 2021-09-05 06:18:56
    7 2021-09-05 06:24:30 2021-09-05 06:40:29
    8 2021-09-05 06:40:42 2021-09-05 06:57:13
    9 2021-09-05 06:57:25 2021-09-05 07:29:01

### Delete Time Entry

``` r
time_entry_delete(prepare_cran_id)
```

    2021-09-09 07:16:35 — Delete time entry.
    2021-09-09 07:16:35 — DELETE /workspaces/61343c45ab05e02be2c8c1fd/time-entries/6139a6c2dacb7878935d87ba

    [1] TRUE

Confirm that it has been deleted.

``` r
time_entries(concise = FALSE) %>%
  select(id, description, time_start, time_end)
```

    2021-09-09 07:16:35 — GET /user
    2021-09-09 07:16:35 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:35 — Page contains 8 results.
    2021-09-09 07:16:35 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-09 07:16:35 — Page is empty.
    2021-09-09 07:16:35 — API returned 8 results.

    # A tibble: 8 × 4
      id                      
      <chr>                   
    1 61343cc1777d5361dcdea70a
    2 61343d06777d5361dcdea729
    3 61343d27ab05e02be2c8c266
    4 613448d7777d5361dcdead37
    5 61344bcad01d3b4a27a82310
    6 6134548f00dc8f48962bace7
    7 6134585a777d5361dcdebc5c
    8 61345c45d01d3b4a27a833c7
      description                                                         
      <chr>                                                               
    1 Setting up GitHub Actions                                           
    2 Make coffee                                                         
    3 Populate README.Rmd                                                 
    4 Add GET /workspaces/{workspaceId}/projects/{projectId}              
    5 Add GET /workspaces/{workspaceId}/projects/{projectId}/tasks        
    6 Add GET https://cex.io/api/ticker/{symbol1}/{symbol2}               
    7 Add GET https://cex.io/api/tickers/{symbol1}/{symbol2}/.../{symbolN}
    8 Add GET https://cex.io/api/last_price/{symbol1}/{symbol2}           
      time_start          time_end           
      <dttm>              <dttm>             
    1 2021-09-03 06:15:00 2021-09-03 06:27:00
    2 2021-09-03 06:27:00 2021-09-03 06:32:00
    3 2021-09-03 06:45:00 2021-09-03 07:53:00
    4 2021-09-05 05:34:31 2021-09-05 05:46:30
    5 2021-09-05 05:47:06 2021-09-05 06:18:56
    6 2021-09-05 06:24:30 2021-09-05 06:40:29
    7 2021-09-05 06:40:42 2021-09-05 06:57:13
    8 2021-09-05 06:57:25 2021-09-05 07:29:01

## Endpoints

<!-- This list generated by api-get-endpoints.R. -->

Endpoints which have currently been implemented in this package.

-   [x] GET /workspaces/{workspaceId}/clients
-   [x] POST /workspaces/{workspaceId}/clients
-   [ ] PUT /workspaces/{workspaceId}/clients/{clientId}
-   [x] DELETE /workspaces/{workspaceId}/clients/{clientId}
-   [x] GET /workspaces/{workspaceId}/projects
-   [x] GET /workspaces/{workspaceId}/projects/{projectId}
-   [ ] POST /workspaces/{workspaceId}/projects
-   [ ] PUT /workspaces/{workspaceId}/projects/{projectId}
-   [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/estimate
-   [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/memberships
-   [ ] PATCH /workspaces/{workspaceId}/projects/{projectId}/template
-   [ ] DELETE /workspaces/{workspaceId}/projects/{id}
-   [x] GET /workspaces/{workspaceId}/tags
-   [ ] POST /workspaces/{workspaceId}/tags
-   [ ] PUT /workspaces/{workspaceId}/tags/{tagId}
-   [ ] DELETE /workspaces/{workspaceId}/tags/{tagId}
-   [x] GET /workspaces/{workspaceId}/projects/{projectId}/tasks
-   [x] GET
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [ ] POST /workspaces/{workspaceId}/projects/{projectId}/tasks
-   [ ] PUT
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [ ] DELETE
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [x] GET /workspaces/{workspaceId}/user/{userId}/time-entries
-   [x] GET /workspaces/{workspaceId}/time-entries/{id}
-   [x] POST /workspaces/{workspaceId}/time-entries
-   [ ] POST /workspaces/{workspaceId}/user/{userId}/time-entries
-   [ ] PATCH /workspaces/{workspaceId}/user/{userId}/time-entries
-   [ ] PUT /workspaces/{workspaceId}/time-entries/{id}
-   [ ] PATCH /workspaces/{workspaceId}/time-entries/invoiced
-   [x] DELETE /workspaces/{workspaceId}/time-entries/{id}
-   [x] GET /user
-   [x] GET /workspaces/{workspaceId}/users
-   [ ] POST /workspaces/{workspaceId}/users
-   [ ] PUT /workspaces/{workspaceId}/users/{userId}
-   [ ] DELETE /workspaces/{workspaceId}/users/{userId}
-   [x] GET /workspaces/{workspaceId}/user-groups
-   [ ] POST /workspaces/{workspaceId}/user-groups
-   [ ] PUT /workspaces/{workspaceId}/user-groups/{userGroupId}
-   [ ] DELETE /workspaces/{workspaceId}/user-groups/{userGroupId}
-   [ ] POST /workspaces/{workspaceId}/user-groups/{userGroupId}/users
-   [ ] DELETE
    /workspaces/{workspaceId}/user-groups/{userGroupId}/users/{userId}
-   [x] GET /workspaces
-   [ ] GET /workspaces/{workspaceId}/custom-fields (*PRO feature*)
-   [ ] GET /workspaces/{workspaceId}/projects/{projectid}/custom-fields
    (*PRO feature*)
-   [ ] PATCH
    /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
    (*PRO feature*)
-   [ ] DELETE
    /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
    (*PRO feature*)
-   [ ] POST /workspaces/{workspaceId}/reports/summary
-   [ ] POST /workspaces/{workspaceId}/reports/detailed
-   [ ] POST /workspaces/{workspaceId}/reports/weekly
-   [ ] GET /workspaces/{workspaceId}/shared-reports
-   [ ] GET /shared-reports/{sharedReportId}
-   [ ] POST /workspaces/{workspaceId}/shared-reports
-   [ ] PUT /workspaces/{workspaceId}/shared-reports/{sharedReportId}
-   [ ] DELETE /workspaces/{workspaceId}/shared-reports/{sharedReportId}
