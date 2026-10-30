<!-- README.md is generated from README.Rmd. Please edit that file -->

# clockify <img src="man/figures/clockify-hex.png" align="right" alt="" width="120" />

<!-- badges: start -->
<!-- badges: end -->

An R wrapper around the [Clockify API](https://docs.clockify.me/).

The documentation for `{clockify}` is hosted at <https://datawookie.github.io/clockify/>.

## Running Tests Locally (NEW - Use Your Own Workspace!)

To run tests with **your own** Clockify API key and workspace (perfect for testing breaking API changes):

```r
# 1. Set your API key
CLOCKIFY_API_KEY <- "your-api-key-here"
Sys.setenv(CLOCKIFY_API_KEY = CLOCKIFY_API_KEY)

# 2. Run tests (uses your workspace automatically)
test_check("clockify")
```

### Test Pre-requisites

Before running tests:
1. Create a Clockify account and get an API key from [account settings](https://clockify.me/)
2. Create **at least one project** in your workspace (tests need projects to work with)
3. Optionally add test collaborators if wanting to test multi-user features

### Why This Matters

Starting with version 0.1.6+, tests are **dynamic** - they automatically detect and use:
- Your workspace ID
- Your user ID  
- Your existing projects
- Your collaborators

This means you can test breaking changes to the API without needing the original author's API key or test data!

## API Key

Get an API key from your [Clockify account settings](https://clockify.me/).

## Get Started

```r
# Set up your API key
CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")

library(clockify)

set_api_key(CLOCKIFY_API_KEY)
```

Let's turn on some logging so we can see what's happening behind the scenes:

```r
library(logger)

log_threshold(INFO)
```

## Workspaces

Retrieve a list of available workspaces:

```r
workspaces()
```

## Users

Get your user profile and list users:

```r
user()
users()
```

## Clients

Get a list of clients:

```r
clients()
```

## Projects

Get a list of projects:

```r
projects()
```

## Time Entries

### Retrieve Time Entries

```r
time_entries()
```

### Create Time Entry

```r
time_entry_create(
  project_id = "your-project-id",
  start = "2021-08-30 08:00:00",
  end = "2021-08-30 10:30:00",
  description = "Description of work"
)
```

### Delete Time Entry

```r
time_entry_delete(time_entry_id)
```

## Endpoints

Endpoints which have currently been implemented in this package. Endpoints which are only available on a paid plan are indicated with a 💰.

- [x] `GET` `/workspaces/{workspaceId}/clients`
- [x] `POST` `/workspaces/{workspaceId}/clients`
- [x] `PUT` `/workspaces/{workspaceId}/clients/{clientId}`
- [x] `DELETE` `/workspaces/{workspaceId}/clients/{clientId}`
- [x] `GET` `/workspaces/{workspaceId}/projects`
- [x] `POST` `/workspaces/{workspaceId}/projects`
- [x] `GET` `/workspaces/{workspaceId}/time-entries/{id}`
- [x] `POST` `/workspaces/{workspaceId}/time-entries`
- [x] `GET` `/user`
- [x] `POST` `/workspaces/{workspaceId}/users`
- [x] `POST` `/workspaces/{workspaceId}/reports/detailed`
- [x] `POST` `/workspaces/{workspaceId}/reports/weekly`
- [x] `POST` `/workspaces/{workspaceId}/shared-reports`
<!-- More endpoints available... -->
