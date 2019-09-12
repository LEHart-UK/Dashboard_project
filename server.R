shinyServer(function(input, output) {
# ==============================================================================
#
# Top of page
#
# ==============================================================================
        
        # Get the number of days between the start and end dates
        span <- reactive({
                as.POSIXlt(input$date_range[2]) -
                as.POSIXlt(input$date_range[1])
        })
        
        # Create the text at the top showing the number of visitors to the
        # website in the date range specified.
        output$website_visitors <- renderText({
                validate(
                        need(input$date_range[2] >= input$date_range[1],
                        "End date is earlier than start date")
                )
                
                paste("Website visitors in the last ",
                        span(),
                        " days: "
                )
        })
        output$website_visitors_number <- renderText({
                         paste(get_number_sessions())
                
        })
        
        # Create the text at the top showing the number of conversions to the
        # website in the date range specified.
        output$conversions <- renderText({
                validate(
                        need(input$date_range[2] >= input$date_range[1],
                             "End date is earlier than start date")
                )
                
                paste("Conversions in the last ",
                      span(),
                      " days: "
                )
        })
        output$conversions_number <- renderText({
                        paste(get_number_conversions())
                
        })
        
# ==============================================================================
#
# Tab 1 - Event Goal Overview
#
# ==============================================================================
        
        output$goal_plot <- renderPlot({
                
                # Creating the plots
                if(input$time_range == "Monthly"){
                        get_goal_monthly(tab1a_goals_and_session())
                } else if (input$time_range == "Weekly") {
                        get_goal_weekly(tab1a_goals_and_session())
                } else if (input$time_range == "Daily") {
                        get_goal_daily(tab1a_goals_and_session())
                }
        })
        
        output$map_goal <- renderLeaflet({
                get_goal_map(tab1a_map_data())
        })
        
        # Plot of devices used to book events
        output$device_plot = renderPlot({
                get_device_plot(tab1b_device_completions_data())
        })
        
        # Plot of devices used for all sessions
        output$all_sessions = renderPlot({
                get_all_sessions(tab1b_device_sessions_data())
        })
        
# ==============================================================================
#
# Tab 2 - Session Sources and Conversion by City
#
# ==============================================================================
        
        # Create plot for sessions by channel
        output$session_channel <- renderPlot({
                session_channel(tab2_channel_data())
        })
        
        # Create plot for Session by Social Network
        output$session_social <- renderPlot({
                session_social(tab2_social_data())
        })
        
        # Create plot for conversion comparison by social network
        output$social_conversion_comparison <- renderPlot({
                social_conversion_comparison(tab2_social_data())
        })
         
        # Create plot for conversion comparison by channel
        output$channel_conversion_comparison <- renderPlot({
                channel_conversion_comparison(tab2_channel_data())
        })
        
# ==============================================================================
#
# Tab 3 - Map of sessions
#
# ==============================================================================
        
        # Creates the map. In order to have the map render over the full page
        # instead of the top half we have to use some javascript to dynamically
        # get the height of the window. We then render a UI output to the UI of
        # that size and the only element in that UI output is the leaflet map.
        output$map_1 <- renderUI({
                leafletOutput("full_map",
                              width = "100%",
                              height = input$GetScreenHeight
                )
        })
        
        output$full_map <- renderLeaflet({
                create_map(tab3_map_data())
        })        
        
# ==============================================================================
#
# Tab 4 - Top 20 Sessions and Exits
#
# ==============================================================================
        
        # Create the most viewed pages output.
        output$plot_5a <- renderPlot({
                create_plot_most_views(tab4_most_page_view_data())
        })
        
        # Create the most exited pages output.
        output$plot_5b <- renderPlot({
                create_plot_most_exits(tab4_most_exit_page_data())
        })



# ==============================================================================
#
# Filtering data for each graph
#
# ==============================================================================

user_start_date<- reactive({
        as.Date(input$date_range[1])
        })

user_end_date<- reactive({
        as.Date(input$date_range[2])
})

# Getting the data for the number of clicks and number of sessions
tab1a_goals_and_session <- reactive({
        overall_goals_sessions %>%
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) 
})


# Returns the number of sessions in the chosen date range.
get_number_sessions <- reactive({
        tab1a_goals_and_session() %>%
                dplyr::select(sessions) %>%
                summarise_all(sum)
})

# Returns the number of goal conversions in the chosen date range.
get_number_conversions <- reactive({
        tab1a_goals_and_session() %>%
        mutate(totalConversions = goal3Completions + goal5Completions) %>%
        dplyr::select(totalConversions) %>%
                summarise_all(sum) 
})

#for tab 1 graph want to filter when goal3 & goal5 is 0
tab1a_map_data <- reactive({
        map_data %>%
        dplyr::select(date, city, latitude, longitude, goal3Completions, goal5Completions) %>%
        dplyr::filter(goal3Completions!=0 & goal5Completions!=0) %>%
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        group_by(city, latitude, longitude) %>%
        summarise(goal3Completions = sum(goal3Completions), goal5Completions = sum(goal5Completions))
})

tab1b_device_sessions_data <- reactive({
        device_data %>%
        dplyr::select(date, deviceCategory, sessions) %>%
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        group_by(deviceCategory) %>%
        summarise(sessions = sum(sessions))
})

tab1b_device_completions_data <-reactive({
        device_data %>%
        dplyr::select(date, deviceCategory, goal3Completions, goal5Completions) %>%
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        group_by(deviceCategory) %>%
        summarise(goal3Completions = sum(goal3Completions), goal5Completions = sum(goal5Completions))
})

tab2_channel_data <- reactive({
        channel_split_data %>% 
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        dplyr::select(channelGrouping, sessions, goal3Completions, goal5Completions) %>%
        group_by(channelGrouping) %>%
        summarise(sessions=sum(sessions), goal3ConversionRate = sum(goal3Completions)/sum(sessions), goal5ConversionRate = sum(goal5Completions)/sum(sessions))
})

tab2_social_data <- reactive({
        channel_split_data %>% 
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        dplyr::select(socialNetwork, sessions, goal3Completions, goal5Completions) %>%
        group_by(socialNetwork) %>%
        summarise(sessions=sum(sessions), goal3ConversionRate = sum(goal3Completions)/sum(sessions), goal5ConversionRate = sum(goal5Completions)/sum(sessions))
})

tab3_map_data  <- reactive({
        map_data %>%
        dplyr::select(date, city, latitude, longitude, sessions) %>%
        filter(sessions != 0) %>%
       dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        group_by(city, latitude, longitude) %>%
        summarise(sessions = sum(sessions))
})

tab4_most_page_view_data <- reactive({
        top_pages %>%
        dplyr::select(date, pagePath, pageviews) %>%
        dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
        group_by(pagePath) %>%
        summarise(pageviews=sum(pageviews)) %>%
        arrange(desc(pageviews)) %>%
        top_n(20) 
})        
        
tab4_most_exit_page_data <- reactive({
                top_pages %>%
                        dplyr::select(date, pagePath, exits) %>%
                         dplyr::filter(user_start_date() <= date & user_end_date() >= date) %>%
                        group_by(pagePath) %>%
                        summarise(exits=sum(exits)) %>%
                        arrange(desc(exits)) %>%
                        top_n(20) 
})
})