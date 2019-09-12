# ==============================================================================
#
# Tab 1b - Sessions and Conversions by Device Type
#
# ==============================================================================

# Plotting the devices used from all sessions
get_all_sessions <- function(device_data) {      

        ggplot(device_data) +
                geom_col(aes(x = deviceCategory, 
                        y = sessions, 
                        fill = deviceCategory)
                ) +
                scale_fill_manual(values =  c("#6baed6", "#3182bd", "#08519c"),
                        name = "Device\nCategory"
                ) +
                my_theme() +
                labs(
                        title = "Sessions by Device Used",
                        x = "\nType of Device",
                        y = "Number of sessions\n"
                )
}

# Plotting the devices used to book events
get_device_plot <- function(goal_data) {

        goal_data <- goal_data %>%
                gather(goal, num_device, "goal3Completions":"goal5Completions")
        
        ggplot(goal_data) +
                geom_bar(aes(x = deviceCategory, y = num_device, fill = goal),
                         stat = "identity", position = "dodge") +
                scale_fill_manual(values = c("#6baed6", "#3182bd", "#08519c"),
                        name = "Goal"
                ) +
                labs(
                        title = "Type of device used to book event", 
                        x = "\nType of Device", 
                        y = "Num. Events Booked\n"
                ) +
                my_theme()
        
}