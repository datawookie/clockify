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
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R-CMD-check](https://github.com/datawookie/clockify/workflows/R-CMD-check/badge.svg)](https://github.com/datawookie/clockify/actions)
<!-- badges: end -->

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

    # A tibble: 2 × 2
      workspace_id             name    
      <chr>                    <chr>   
    1 612b15a5f4c3bf0462192677 Personal
    2 612b1708f4c3bf0462192861 Work    

Select a specific workspace.

``` r
workspace("612b15a5f4c3bf0462192677")
```

    DEBUG [2021-08-29 11:40:03] Set active workspace -> 612b15a5f4c3bf0462192677.

    [1] "612b15a5f4c3bf0462192677"

## Users

Retrieve information on your user profile.

``` r
user()
```

    DEBUG [2021-08-29 11:40:03] GET /user

    # A tibble: 1 × 4
      user_id                  email                      name       status
      <chr>                    <chr>                      <chr>      <chr> 
    1 612b15a4f4c3bf0462192676 andrew.b.collier@gmail.com datawookie ACTIVE

Get a list of users.

``` r
users()
```

    DEBUG [2021-08-29 11:40:03] GET /workspaces/612b15a5f4c3bf0462192677/users

    # A tibble: 2 × 4
      user_id                  email                      name       status
      <chr>                    <chr>                      <chr>      <chr> 
    1 612b15a4f4c3bf0462192676 andrew.b.collier@gmail.com datawookie ACTIVE
    2 5ef46293df73063139f60bf5 emma@fathomdata.dev        Emma       ACTIVE
