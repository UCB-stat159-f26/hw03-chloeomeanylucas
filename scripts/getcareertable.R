library(rvest)
library(tidyverse)

#argument <name> is the full name of the player in the format: FirstLast

function (name) {

  data = readLines(getcareerdatafromweb(name))

}
