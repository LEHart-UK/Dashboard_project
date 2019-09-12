my_theme <- function() {
        theme_minimal() +
                theme(
                        title = element_text(face = "bold", size = 12), 
                        axis.title = element_text(face = "bold", size = 10), 
                        panel.grid.major = element_line(colour = "grey82")
                )
}