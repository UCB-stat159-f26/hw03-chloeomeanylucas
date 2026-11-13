#' @title The Birthdays of a Female Player's Opponents
#' @name getwomensoppsbdays
#' @description Retrieves the birthdays of the female player's opponents and indices of missing data to omit for future calculations
#' @param name the name of the professional tennis player in the format: FirstLast
#' @return a 2-item list containing a vector of the opponents' birthdays and a vector of the indices that were missing an opponent's birthday in the data
#' @export
#' @examples
#' name = "SerenaWilliams"
#' getwomensoppsbdays(name)

library(rvest)
library(tidyverse)
library(lubridate)

getwomensoppsbdays = function (name){
  js_urls = getcareerdatafromweb(name)

  career_url = js_urls[str_detect(js_urls, pattern = "Career")]

  career_data = readLines(career_url)

  #this includes only the date of the match and opponents' birthdays
  all_dates = str_extract_all(career_data, pattern = "\\d{8}(?!\\-)")

  opp_bdays = c()
  unincluded_index = c()
  for (i in 1:length(all_dates)){
    if (length(all_dates[[i]]) == 0){ #skips if list item in all_dates contains character(0) (empty string)
      next
    } else if (length(all_dates[[i]]) < 2){ #skips if i-th opponent's birthday is missing
      unincluded_index = append(unincluded_index, i) #but keeps track of indices to omit in future calculations
      next
    } else {
      opp_bdays = append(opp_bdays, all_dates[[i]][2]) #appends i-th opponent's birthday
    }
  }

  l = list(
    OppBdays = opp_bdays,
    Indices = unincluded_index
  )

  l
}
