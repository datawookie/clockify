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

    2021-09-05 06:14:39 — GET /workspaces

    # A tibble: 2 × 2
      workspace_id             name       
      <chr>                    <chr>      
    1 5ef46294df73063139f60bfc Fathom Data
    2 61343c45ab05e02be2c8c1fd Personal   

Select a specific workspace.

``` r
workspace("61343c45ab05e02be2c8c1fd")
```

    2021-09-05 06:14:39 — Set active workspace -> 61343c45ab05e02be2c8c1fd.

    [1] "61343c45ab05e02be2c8c1fd"

## Users

Retrieve information on your user profile.

``` r
user()
```

    2021-09-05 06:14:39 — GET /user

    # A tibble: 1 × 3
      user_id                  user_name status
      <chr>                    <chr>     <chr> 
    1 5f227e0cd7176a0e6e754409 Andrew    ACTIVE

Get a list of users.

``` r
users()
```

    2021-09-05 06:14:39 — GET /workspaces/61343c45ab05e02be2c8c1fd/users

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

    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/clients

    # A tibble: 2 × 3
      client_id                client_name workspace_id            
      <chr>                    <chr>       <chr>                   
    1 61343c6c00dc8f48962b9be9 Community   61343c45ab05e02be2c8c1fd
    2 61343c5d00dc8f48962b9be3 Fathom Data 61343c45ab05e02be2c8c1fd

## Projects

Get a list of projects.

``` r
projects()
```

    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/projects
    2021-09-05 06:14:40 — Page contains 2 results.
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/projects
    2021-09-05 06:14:40 — Page is empty.
    2021-09-05 06:14:40 — API returned 2 results.

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

    2021-09-05 06:14:40 — GET /user
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:40 — Page contains 5 results.
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:40 — Page is empty.
    2021-09-05 06:14:40 — API returned 5 results.

    # A tibble: 4 × 3
      project_id              
      <chr>                   
    1 61343c9ba15c1d53ad33369f
    2 61343c9ba15c1d53ad33369f
    3 61343c9ba15c1d53ad33369f
    4 61343c9ba15c1d53ad33369f
      description                                            duration
      <chr>                                                     <dbl>
    1 Setting up GitHub Actions                                  12  
    2 Make coffee                                                 5  
    3 Populate README.Rmd                                        68  
    4 Add GET /workspaces/{workspaceId}/projects/{projectId}     12.0

Retrieve time entries for another user specified by their user ID.

``` r
time_entries(user_id = "5ef46293df73063139f60bf5")
```

    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5ef46293df73063139f60bf5/time-entries
    2021-09-05 06:14:40 — Page is empty.
    2021-09-05 06:14:40 — API returned 0 results.

    # A tibble: 0 × 9
    # … with 9 variables: id <chr>, user_id <chr>, workspace_id <chr>, project_id <chr>, billable <lgl>, description <chr>, time_start <dttm>, time_end <dttm>, duration <dbl>

### Insert Time Entry

``` r
prepare_cran_id <- time_entry_insert(
 project_id = "61343c9ba15c1d53ad33369f",
 start = "2021-08-30 08:00:00",
 end   = "2021-08-30 10:30:00",
 description = "Prepare for CRAN submission"
)
```

    2021-09-05 06:14:40 — Insert time entry.
    2021-09-05 06:14:40 — POST /workspaces/61343c45ab05e02be2c8c1fd/time-entries

Check on the ID for this new time entry.

``` r
prepare_cran_id
```

    [1] "61345240d50d07715889e4ae"

Confirm that it has been inserted.

``` r
time_entries(concise = FALSE) %>%
  select(id, description, time_start, time_end)
```

    2021-09-05 06:14:40 — GET /user
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:40 — Page contains 6 results.
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:40 — Page is empty.
    2021-09-05 06:14:40 — API returned 6 results.

    # A tibble: 5 × 4
      id                      
      <chr>                   
    1 61345240d50d07715889e4ae
    2 61343cc1777d5361dcdea70a
    3 61343d06777d5361dcdea729
    4 61343d27ab05e02be2c8c266
    5 613448d7777d5361dcdead37
      description                                            time_start         
      <chr>                                                  <dttm>             
    1 Prepare for CRAN submission                            2021-08-30 09:00:00
    2 Setting up GitHub Actions                              2021-09-03 06:15:00
    3 Make coffee                                            2021-09-03 06:27:00
    4 Populate README.Rmd                                    2021-09-03 06:45:00
    5 Add GET /workspaces/{workspaceId}/projects/{projectId} 2021-09-05 05:34:31
      time_end           
      <dttm>             
    1 2021-08-30 11:30:00
    2 2021-09-03 06:27:00
    3 2021-09-03 06:32:00
    4 2021-09-03 07:53:00
    5 2021-09-05 05:46:30

### Delete Time Entry

``` r
time_entry_delete(prepare_cran_id)
```

    2021-09-05 06:14:40 — Delete time entry.
    2021-09-05 06:14:40 — DELETE /workspaces/61343c45ab05e02be2c8c1fd/time-entries/61345240d50d07715889e4ae

    [1] TRUE

Confirm that it has been deleted.

``` r
time_entries(concise = FALSE) %>%
  select(id, description, time_start, time_end)
```

    2021-09-05 06:14:40 — GET /user
    2021-09-05 06:14:40 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:41 — Page contains 5 results.
    2021-09-05 06:14:41 — GET /workspaces/61343c45ab05e02be2c8c1fd/user/5f227e0cd7176a0e6e754409/time-entries
    2021-09-05 06:14:41 — Page is empty.
    2021-09-05 06:14:41 — API returned 5 results.

    # A tibble: 4 × 4
      id                      
      <chr>                   
    1 61343cc1777d5361dcdea70a
    2 61343d06777d5361dcdea729
    3 61343d27ab05e02be2c8c266
    4 613448d7777d5361dcdead37
      description                                            time_start         
      <chr>                                                  <dttm>             
    1 Setting up GitHub Actions                              2021-09-03 06:15:00
    2 Make coffee                                            2021-09-03 06:27:00
    3 Populate README.Rmd                                    2021-09-03 06:45:00
    4 Add GET /workspaces/{workspaceId}/projects/{projectId} 2021-09-05 05:34:31
      time_end           
      <dttm>             
    1 2021-09-03 06:27:00
    2 2021-09-03 06:32:00
    3 2021-09-03 07:53:00
    4 2021-09-05 05:46:30

## Endpoints

<!-- This list generated by api-get-endpoints.R. -->

Endpoints which have currently been implemented in this package.

-   [x] GET /workspaces/{workspaceId}/clients
-   [ ] POST /workspaces/{workspaceId}/clients
-   [ ] PUT /workspaces/{workspaceId}/clients/{clientId}
-   [ ] DELETE /workspaces/{workspaceId}/clients/{clientId}
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
-   [ ] GET /workspaces/{workspaceId}/projects/{projectId}/tasks
-   [ ] GET
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [ ] POST /workspaces/{workspaceId}/projects/{projectId}/tasks
-   [ ] PUT
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [ ] DELETE
    /workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}
-   [x] GET /workspaces/{workspaceId}/user/{userId}/time-entries
-   [ ] GET /workspaces/{workspaceId}/time-entries/{id}
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
-   [ ] GET /workspaces/{workspaceId}/custom-fields
-   [ ] GET /workspaces/{workspaceId}/projects/{projectid}/custom-fields
-   [ ] PATCH
    /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
-   [ ] DELETE
    /workspaces/{workspaceId}/projects/{projectid}/custom-fields/{customFieldId}
-   [ ] POST /workspaces/{workspaceId}/reports/summary
-   [ ] POST /workspaces/{workspaceId}/reports/detailed
-   [ ] POST /workspaces/{workspaceId}/reports/weekly
-   [ ] GET /workspaces/{workspaceId}/shared-reports
-   [ ] GET /shared-reports/{sharedReportId}
-   [ ] POST /workspaces/{workspaceId}/shared-reports
-   [ ] PUT /workspaces/{workspaceId}/shared-reports/{sharedReportId}
-   [ ] DELETE /workspaces/{workspaceId}/shared-reports/{sharedReportId}
