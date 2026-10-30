if (!(testthat:::on_cran() || NO_API_KEY_IN_ENVIRONMENT)) {
  # Delete lingering time entries.
  #
  walk(time_entries() %>% pull(time_entry_id), time_entry_delete)

  # Delete lingering user groups.
  #
  walk(user_groups() %>% pull(group_id), user_group_delete)

  # Delete lingering tasks.
  #
  walk(
    projects() %>% pull(project_id),
    function(project_id) {
      tasks <- tasks(project_id)
      # A task must be DONE before it can be deleted.
      walk2(
        tasks$task_id,
        tasks$name,
        ~ task_update(project_id, .x, .y, status = "DONE")
      )
      walk(tasks$task_id, ~ task_delete(project_id, .))
    }
  )
}
