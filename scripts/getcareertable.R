library(rvest)
library(tidyverse)
library(lubridate)

#argument <name> is the full name of the player in the format: FirstLast

function (name) {
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

  #this includes only the date of the match and opponents' birthdays
  all_dates = str_extract_all(career_data, pattern = "\\d{8}(?!\\-)")

  #!!!major problem: some of the opponents' birth years are missing...

  #I think my strategy is just going to omit the players that don't have their birthdays recorded
  #I might need to keep track of which dates I don't include because the opponent's birthday is missing
  #so then I omit these dates when calculating for the player's intervals


  #Opponents' Birthdays-----------------------------------------------------------
  opponent_bdays = c()
  unincluded_index = c()
  for (i in 1:length(all_dates)){
    if (length(all_dates[[i]]) == 0){ #skips if list item in all_dates contains character(0) (empty string)
      next
    } else if (length(all_dates[[i]]) < 2){ #skips if i-th opponent's birthday is missing
      unincluded_index = append(unincluded_index, i) #but keeps track of indices to omit in date_of_match and all_outcomes
      next
    } else {
      opponent_bdays = append(opponent_bdays, all_dates[[i]][2]) #appends i-th opponent's birthday
    }
  }

  #REMOVAL------------------------------------------------------------------------
  #Removing the dates that correspond to the opponents with missing birthdays in all_dates
  #I need date_of_match and opponent_bdays to be the same length
  date_of_match = date_of_match[-unincluded_index]


  #Player's Birthday--------------------------------------------------------------
  #This extracts the player's birthday. It is a character vector of NA values and
  #one character value that corresponds to the player's birthday.
  player_bday = str_extract(player_data, pattern = "(?<=dob=)[:digit:]{8}")

  #removes the NA values that come from str_extract()
  player_bday = player_bday[!is.na(player_bday)]


  #Ages and Difference of Ages----------------------------------------------------
  #interval() from the package lubridate returns an array of UTC formatted intervals
  #where one value looks like: YYYY-MM-DD UTC--YYYY-MM-DD UTC
  #these are "doubles"
  opp_age_intervals = interval(ymd(opponent_bdays), ymd(date_of_match))
  player_age_intervals = interval(ymd(player_bday), ymd(date_of_match))

  #time_length() calculates the length of time between a player's birthday and
  #the match date in units of "years"
  opp_ages = time_length(opp_age_intervals, "year")
  player_ages = time_length(player_age_intervals, "year")

  #difference in ages relative to player's age on the date of the match
  age_diff = player_ages - opp_ages


  #Outcomes-----------------------------------------------------------------------
  #In order to find if the player won or not, str_extract detects the first occurrence of
  #a W or L wrapped in quotation marks
  #all_outcomes = str_extract_all(career_data, pattern = '(?<=\")(G|W|L|I|O|D|P|PM|F|T2|T1|T3|T4)(?![:alpha:])')

  #!!!I can't really know if this is right for every line unless I manually check it
  outcomes = str_extract(career_data, pattern = '(?<=\")(W|L)(?=\")')

  #removes NA values
  outcomes = outcomes[!is.na(outcomes)]


  #REMOVAL------------------------------------------------------------------------
  #removing outcome(s) that corresponds to the index of the opponent(s) with a missing birthday in all_dates
  #!!!!!WARNING if i just run this one line again over and over it will continue to remove those indices
  outcomes = outcomes[-unincluded_index]

  #new pattern: '(?<=\")([:upper:]{1,2}|[:upper:][:digit:])(?![:alpha:]|[:digit:])'
  #i feel like i would have less hard of a time if this was a .csv file

  print(str_view(career_data, pattern = '(?<=\")(W|L)(?=\")'), n = 143)

  career_table = data.frame(
    "Date" = date_of_match,
    "Player_Age" = player_ages,
    "Opponent_Age" = opp_ages,
    "Age_Difference" = age_diff,
    "Player_Outcome" = outcomes
  )

  career_table

}
