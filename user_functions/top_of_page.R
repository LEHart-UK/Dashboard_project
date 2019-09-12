# ==============================================================================
#
# Top of page
#
# ==============================================================================

# Returns the number of sessions in the chosen date range.
get_number_sessions <- google_analytics(google_analytics_id,
                date_range = c(as.character(start_date),
                        as.character(end_date)
                ),
                metrics = c("sessions")
       )


# Returns the number of goal conversions in the chosen date range.
get_number_conversions <- google_analytics(google_analytics_id,
                date_range = c(as.character(start_date),
                        as.character(end_date)
                ),
                metrics = c("goal3completions", "goal5completions")
        )

