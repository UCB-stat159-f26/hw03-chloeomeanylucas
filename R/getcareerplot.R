#' @title Scatter plot of Player's Career And Age Difference Between Opponent
#' @name getcareerplot
#' @description Using the data frame obtained from getcareertable() function, this plots a scatter plot of all matches a player has won or lost in their career, and their age relative to their opponents each match.
#' @param table the data frame obtained from getcareertable() function
#' @param name optional parameter to include the player's name on the scatter plot title and axis. Default is "PlayerName." Name should be formatted as: FirstLast
#' @return a scatter plot of the difference of the players age relative to their opponents, color-coded by whether the player won or lost
#' @export
#' @examples
#' name = "SerenaWilliams"
#' williams_tbl = getcareertable(name)
#' getcareerplot(williams_tbl)
#'
#' name = "SerenaWilliams"
#' williams_tbl = getcareertable(name)
#' getcareerplot(williams_tbl, "SerenaWilliams")
#' getcareerplot(williams_tbl, name)
#'
#' name = "RodLaver"
#' laver_tbl =  getcareertable(name)
#' getcareerplot(laver_tbl)



library(ggplot2)
library(stringr)

getcareerplot = function (table, name = "PlayerName"){
  first_name = unlist(str_split(name, "(?<=[a-z])(?=[A-Z])"))[1]
  last_name = unlist(str_split(name, "(?<=[a-z])(?=[A-Z])"))[2]

  plot = ggplot(data = table, mapping = aes(x = Player_Age, y = Age_Difference, color = Player_Outcome))+
  geom_point(size = 0.7) +
  labs(
    title = paste0(first_name, " ", last_name,"'s Professional Matches"),
    caption = "Source: Tennis Abstract",
    x = paste0(last_name,"'s age"),
    y = ""
  ) +
  theme(
    plot.caption = element_text(hjust = 0, size = 6, color = "#83817b"),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 9),
    panel.background = element_rect(fill = "white"),
    panel.grid.minor = element_line(color = "white"),
    panel.grid.major = element_line(color = "gray", linewidth = 0.3),
    axis.ticks = element_line(color = "gray"),
    legend.position = "top",
    legend.title = element_text(size = 0),
    axis.title.x = element_text(hjust = 0, size = 8, color = "#83817b")
  ) +
  scale_x_continuous(
    position = "top",
  ) +
  scale_color_discrete(
    palette = c("#953a8c", "#4acbed"),
    labels = c("Match lost", "Match won")
  )

  plot
}
