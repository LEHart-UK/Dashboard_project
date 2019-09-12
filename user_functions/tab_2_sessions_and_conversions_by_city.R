# ==============================================================================
#
# Tab 2 - Session Sources and Conversion by City
#
# ==============================================================================

# PLOT FUNCTION: Number of Sessions by Channel
# Call using:
# session_channel(channel_group_df)
session_channel <- function(channel_group_df){
        
        ggplot(channel_group_df) +
                aes(x = channel_group_df$channelGrouping, 
                        y = channel_group_df$sessions, fill = channelGrouping
                ) +
                geom_col() +
                labs(
                        x = "\nChannel",
                        y = "Sessions\n",
                        title = "Sessions by Channel\n",
                        fill = "Channel"
                ) +
                my_theme() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                scale_fill_brewer(palette = "Blues")
}

# PLOT FUNCTION: nummber of sessions by Social Network
# Call Using:
# session_social(social_group_df)
session_social <- function(social_group_df){
        
        ##removing the row which is (not set)
        social_group_df<- dplyr::filter(social_group_df, 
                                        socialNetwork != "(not set)")
                                        
        ggplot(social_group_df) +
                aes(x = social_group_df$socialNetwork, 
                        y = social_group_df$sessions, fill = socialNetwork
                ) +
                geom_col() +
                labs(
                        x = "\nSocial Network",
                        y = "Sessions\n",
                        title = "Breakdown of Social Channel by Social Network\n",
                        fill = "Social Network"
                ) + 
                my_theme() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                scale_fill_brewer(palette = "Blues")
        
}

# Create a new data.frame containing only the information I need to use 
filter_social <- function(social_group_df){
        
        social_group_df2 <- social_group_df %>% dplyr::select(socialNetwork,
                goal3ConversionRate, goal5ConversionRate
        )
        
        # Gather the goal3ConversionRate and goal5ConversionRate data into a new
        # column to use fill + location
        gathered_social<-gather(social_group_df2, key = "location",
                value = conversion, -socialNetwork
        )
        
        return(gathered_social)
}

# PLOT FUNCTION: comparison of goal conversion for Edinburgh and Glasgow by
# Social Network
# Call Using: social_conversion_comparison(gathered_social)
social_conversion_comparison <- function(social_group_df){
        
        gathered_social <- filter_social(social_group_df)
        
        ggplot(gathered_social, aes(socialNetwork, conversion, fill=location)) +
                geom_bar(stat = "identity",position="dodge") +
                labs(
                        x = "\nSocial Network",
                        y = "Conversion \n",
                        title = "Info Session Conversion Comparison by Social
                                Network\n"
                ) +
                my_theme() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                scale_fill_manual(name = "Location", 
                        values = c("#6baed6", "#08306b"), 
                        labels = c("Glasgow", "Edinburgh")
                )
}

#
filter_channel <- function(channel_group_df){
        # Create new data.frame which contains only the columns I need to work
        # with
        channel_group_df2 <- channel_group_df %>%
                dplyr::select(channelGrouping, goal3ConversionRate, goal5ConversionRate)
        
        # Gather the goal3ConversionRate and goal5ConversionRate data into a
        # new column to use fill + location
        gathered_channel<- gather(channel_group_df2, key="location",
                value = conversion, -channelGrouping
        )
        
        return(gathered_channel)
        
}

# PLOT FUNCTION: comparison of goal conversion for Edinburgh and Glasgow by 
# Channel
# CALL USING: channel_conversion_comparison(gathered_channel)
channel_conversion_comparison <- function(channel_group_df){
        
        gathered_channel <- filter_channel(channel_group_df)
        
        ggplot(gathered_channel, aes(channelGrouping, conversion, fill=location)) +
                geom_bar(stat = "identity",position="dodge") +
                labs(
                        x = "\nChannel",
                        y = "Conversion \n",
                        title = "Info Session Conversion Comparison by Channel\n"
                ) +
                my_theme() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                scale_fill_manual(name = "Location", 
                        values = c("#6baed6", "#08306b"), 
                        labels = c("Glasgow", "Edinburgh")
                )
}