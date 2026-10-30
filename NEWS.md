# {clockify} (development version)

* Handle the Free plan no longer including billable rates (since June 2026).
  * `reports_detailed()` always returns `amount` and `rate` columns, which are
    `NA` on the Free plan.
  * `reports_summary()` returns `NA` for `amount` and an empty `amounts` on the
    Free plan. Previously it returned no rows.
  * `reports_weekly()` returns the API's `amount` of 0 on the Free plan.
* `reports_summary()` and `reports_weekly()` gain `user_id` and `project_id`
  columns.
* `reports_summary()` entries no longer have an `id` column. Entries are
  grouped by description, so there's no time entry ID. This also fixes each
  entry being repeated three times.
* `workspaces()` only returns its documented columns, so new API fields (like
  `cakeOrganizationId`) don't change the output.
* Fix the user group functions, which returned no rows because of a new
  `teamManagers` field in the API.
* `clients()` and `tags()` return a data frame with the usual columns when
  there are none. Previously `clients()` had no columns and `tags()` failed.
* `time_entries()` keeps the list of tags for each entry in a `tag_ids` column.

# {clockify} 0.1.3

* Update GitHub Actions.
* Test for updating shared report working (API fixed).

# {clockify} 0.1.2

* Improve test coverage.

# {clockify} 0.1.1

* Improved test coverage.
* Add pre-commit hooks.
* Rate no longer scaled by 100.

# {clockify} 0.1.0

* Add `user_group_create()`.
* Add `user_group_update()`.
* Add `user_group_delete()`.
* Add `user_group_user_add()`.
* Add `user_group_user_delete()`.

# {clockify} 0.0.19

* Add `user_update_cost_rate()`.
* Add `user_update_role`.
* Add `user_delete_role`.
* Add `user_delete`.

# {clockify} 0.0.18

* Add `task_create()`.
* Add `task_update()`.
* Add `task_update_billable_rate()`.
* Add `task_update_cost_rate()`.
* Add `task_delete()`.

# {clockify} 0.0.17

* Add `tag()`.
* Add `tag_create()`.
* Add `tag_update()`.
* Add `tag_delete()`.

# {clockify} 0.0.16

* Add `project_create()`.
* Add `project_delete()`.
* Add `project_update()`.
* Add `project_update_template()`.
* Add `project_update_user_billable_rate()`.
* Add `project_update_user_cost_rate()`.
* Add `project_update_estimate_time()` & `project_update_estimate_budget()`.
* Add `project_update_memberships()`.
* On `NULL` argument to `time_format()` return `NULL`.

# {clockify} 0.0.15

* Result from `clients()` is paginated (so goes beyond 50 items).

# {clockify} 0.0.14

* Add minimal support for shared report endpoints.

# {clockify} 0.0.13

* Add endpoints for reports.

# {clockify} 0.0.12

* Add endpoints for dealing with custom fields.

# {clockify} 0.0.11

* Add the ability to filter time entries by `description`, `project`, `task`, or `tag`.

# {clockify} 0.0.10

* Hide `time_format` function in the documentation
* Hide `time_parse` function in the documentation

# {clockify} 0.0.9

* Add tests.
* Use NA_character_ in simplify_user().

# {clockify} 0.0.8

* Add `time_entry_delete()`.
* Improve styling of code blocks in `README`.
* Add code coverage checks.
* Add `concise` argument to various functions.
* Add GitHub Actions.
* Started test suite.
* Return empty tibble (with correct columns) if no time entries.

# {clockify} 0.0.7

# {clockify} 0.0.6

# {clockify} 0.0.5

# {clockify} 0.0.4

# {clockify} 0.0.3

# {clockify} 0.0.2

# {clockify} 0.0.1
