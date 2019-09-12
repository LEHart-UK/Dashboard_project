# ==============================================================================
#
# Tab 4 - Top 20 Sessions and Exits
#
# ==============================================================================

# Pulls a list of pages that have the most views within the defined date range
# in descending order from googe analytics, and then plots the top 20 as a
# flipped bar chart.
create_plot_most_views <- function(most_page_view) {
        

        # Plots flipped bar chart
        ggplot(most_page_view) +
                aes(x = reorder(pagePath, pageviews),
                    y = pageviews,
                    fill = pageviews
                ) +
                geom_bar(stat = "identity") +
                coord_flip() +
                my_theme() +
                scale_fill_gradient(low = "#deebf7",
                        high = "#08306b",
                        name = "Number of\nPageviews"
                ) +
                labs(
                        title = "Top 20 Most Visted Pages\n",
                        x = "Page URL\n",
                        y = "\nNumber of exits"
                )
}

# Pulls a list of pages that have the most exits within the defined date range
# in descending order from googe analytics, and then plots the top 20 as a
# flipped bar chart.
create_plot_most_exits <- function(most_exit_page) {

        # Plots flipped bar chart
        ggplot(most_exit_page) +
                aes(x = reorder(pagePath, exits), y = exits, fill = exits) +
                geom_bar(stat = "identity") +
                coord_flip()  +
                my_theme() +
                scale_fill_gradient(low = "#deebf7",
                        high = "#08306b",
                        name = "Number of\nExits"
                ) +
                labs(
                        title = "Top 20 Pages by Exit\n",
                        x = "Page URL\n",
                        y = "\nNumber of Views"
                )
}