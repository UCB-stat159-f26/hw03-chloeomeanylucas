#' @title Table of a Tennis Player's Career with Player's Age vs. Opponent's Age
#' @name getcareertable
#' @description Creates a data frame with columns of the date of the tennis match, the player's age, the opponent's age, the difference between the ages, and "W" or "L" for whether the player "won" or "lost"
#' @param name the name of the professional tennis player in the format: FirstLast
#' @return a data frame with five columns
#' @export
#' @examples
#' name = SerenaWilliams
#' getcareertable(name)
#'
#' name = "RodLaver"
#' getcareertable(name)


library(rvest)
library(tidyverse)
library(lubridate)

#argument <name> is the full name of the player in the format: FirstLast

getcareertable = function (name) {
  js_urls = getcareerdatafromweb(name)

  career_url = js_urls[str_detect(js_urls, pattern = "Career")]
  player_url = js_urls[str_detect(js_urls, pattern = paste0(name, "(?!Career)"))]

  player_data = readLines(player_url)
  career_data = readLines(career_url)


  #Dates-----------------------------------------------------------------------
  #extracts the first occurrence of a number 8 digits long, which corresponds to
  #the date of the tennis match
  date_of_match = str_extract(career_data, pattern = "\\d{8}")

  #removes NA values
  date_of_match = date_of_match[!is.na(date_of_match)]


  #Player's Birthday--------------------------------------------------------------
  #This extracts the player's birthday. It is a character vector of NA values and
  #one character value that corresponds to the player's birthday.
  player_bday = str_extract(player_data, pattern = "(?<=dob=)[:digit:]{8}")

  #removes the NA values that come from str_extract()
  player_bday = player_bday[!is.na(player_bday)]

  #Male or Female Player--------------------------------------------------------
  #this checks if the player is a man by checking if the player's career data has
  #ages instead of birthdays for their opponents
  if (length(str_view(career_data, pattern = "[:digit:]{2}\\.[:digit:]+")) == 0){
    #output of getmensoppsages() is a list
    opp_ages = getmensoppsages.R(name)$OppAges
    unincluded_index = getmensoppsages.R(name)$Indices
    if (length(unincluded_index) != 0){ #making sure unincluded_index is NOT empty
      date_of_match = date_of_match[-unincluded_index] #Removing the dates that correspond to the opponents with missing birthdays
    }
  } else {
    #output of getwomensoppsbdays() is a list
    opp_bdays = getwomensoppsbdays(name)$OppBdays
    unincluded_index = getwomensoppsbdays(name)$Indices
    if (length(unincluded_index) != 0){ #making sure unincluded_index is NOT empty
     date_of_match = date_of_match[-unincluded_index] #Removing the dates that correspond to the opponents with missing birthdays
    }
    opp_age_intervals = interval(ymd(opps_bdays), ymd(date_of_match))
    opp_ages = time_length(opp_age_intervals, "year")
  }
  #in the above if-else statement, the variable unincluded_index is tracked so that I can
  #remove the opponents that did not have an age or birthday in the data in further
  #calculations. Please refer to the README.md for more explanation.


  #Player Age and Difference of Ages----------------------------------------------------
  #interval() from the package lubridate returns an array of UTC formatted intervals
  #where one value looks like: YYYY-MM-DD UTC--YYYY-MM-DD UTC
  #they are "doubles"
  player_age_intervals = interval(ymd(player_bday), ymd(date_of_match))

  #time_length() calculates the length of time between a player's birthday and
  #the match date in units of "years"
  player_ages = time_length(player_age_intervals, "year")

  #difference in ages relative to player's age on the date of the match
  age_diff = player_ages - opp_ages


  #Outcomes-----------------------------------------------------------------------
  #In order to find if the player won or not, str_extract detects the first occurrence of
  #a W or L wrapped in quotation marks. A "W" for "won" and "L" for "lost."
  outcomes = str_extract(career_data, pattern = '(?<=\")(W|L)(?=\")')

  #removes NA values
  outcomes = outcomes[!is.na(outcomes)]

  #removing outcome(s) that correspond to the index of the opponent(s) with a missing birthday or age
  if (length(unincluded_index) != 0){ #making sure unincluded_index is NOT empty
    outcomes = outcomes[-unincluded_index]
  }


  #Crafting a Table of the Player's Career--------------------------------------
  career_table = data.frame(
    "Date" = date_of_match,
    "Player_Age" = player_ages,
    "Opponent_Age" = opp_ages,
    "Age_Difference" = age_diff,
    "Player_Outcome" = outcomes
  )

  career_table

}
