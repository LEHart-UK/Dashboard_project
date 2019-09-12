# ==============================================================================
#
# Tab 3 - Map of sessions
#
# ==============================================================================

# Pulls the latitude and longitude of all sessions on the website within the
# defined data range then plots them on leaflet map.
create_map <- function(Cities) {
        
        # Create a dataset from google analytics.

        
        # Repeat each row for the number of times in the sessions variable.
        # This is so when leaflet creates the groupings on the map, the
        # numbers that appear correspond with the number of sessions rather than
        # the number of rows in the dataset.
        Cities_expanded <- Cities[rep(row.names(Cities), Cities$sessions), ]
        
        # Create leaflet
        leaflet(Cities_expanded) %>%
                addTiles() %>%
                addMarkers(clusterOptions = markerClusterOptions(),
                           lat = as.numeric(Cities_expanded$latitude),
                           lng = as.numeric(Cities_expanded$longitude),
                           popup = Cities_expanded$city
                )
}