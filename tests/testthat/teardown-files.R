# Delete lingering time entries.
#
walk(time_entries() %>% pull(time_entry_id), time_entry_delete)

# Delete lingering user groups.
#
walk(user_groups() %>% pull(group_id), user_group_delete)
