# Delete lingering time entries.
#
walk(time_entries() %>% pull(time_entry_id), time_entry_delete)
