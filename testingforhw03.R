library(rvest)
library(tidyverse)

name = "MirraAndreeva"

url = paste0("https://www.tennisabstract.com/cgi-bin/wplayer-classic.cgi?p=", name, "&f=ACareerqq")

html_webpage = read_html(url)

#searching for the "src" url in <script></script>
js_urls = html_webpage %>%
  html_elements("script[src]") %>%
  html_attr("src")

career_url = js_urls[str_detect(js_urls, pattern = "Career")]

#I can get the ...<FirstLast>.js and the ...<FirstLast>Career.js from same webpage
player_url = js_urls[str_detect(js_urls, pattern = paste0(name, "(?!Career)"))]

player_data = readLines(player_url)
career_data = readLines(career_url)
head(career_data)
player_data
career_data[28]

#okay so this extracts the birthday
birthday = str_extract(player_data, pattern = "(?<=dob=)[:digit:]{8}")

#removes the NA values that come from str_extract()
birthday = birthday[!is.na(birthday)]


date_of_match = str_extract(career_data, pattern = "\\d{8}")

#removes NA values
date_of_match = date_of_match[!is.na(date_of_match)]


#this includes only the date of the match and opponents' birth year
all_dates = str_extract_all(career_data, pattern = "\\d{8}(?!\\-)")

#unlists and removes NA values
all_dates = all_dates[!is.na(all_dates)]

#this retrieves every even number of the array of dates
#An even number corresponds to opponents' dates of birth and odd numbers correspond to date of match
#!!!!Will also need to make sure that it's like seq(2, length(data)/2, by = 2)

#!!!major problem: some of the opponents' birth years are missing...

opponent_birth_years = all_dates[seq(2, length(all_dates)/2, by = 2)]
all_dates

#setting a variable for Serena's birth year
#!!!!!!!!NEED TO EDIT THIS
#!!!will replace with an auxiliary function that gets the player's birthday
player_birth_year = as.character(19810926)

#recall that all of these variables are ordered by the opponent's name, for example,
#the first value of date_of_match and first value of opponent_birth_years is for
#opponent Anne Miller

#interval() from the package lubridate returns an array of UTC formatted intervals
#where one value looks like: YYYY-MM-DD UTC--YYYY-MM-DD UTC
#these are "doubles"
opp_age_intervals = interval(ymd(opponent_birth_years), ymd(date_of_match))
player_age_intervals = interval(ymd(player_birth_year), ymd(date_of_match))

#time_length() calculates the length of time between a player's birth year and
#the match date in units of "years"
opp_ages = time_length(opp_age_intervals, "year")
player_ages = time_length(player_age_intervals, "year")

#difference in ages relative to Serena's age on the date of the match
age_diff = player_ages - opp_ages

#In order to find if Serena won or not, str_extract_all detects any letter with quotation marks
#in front of it that does not have a letter following it
#I need to check for all the instances, G, W, L, I, etc. because the second occurrence of
#the pattern determines whether Serena has won the match or not.
#I remove the 1039th row because it is NA
all_outcomes = str_extract_all(career_data, pattern = '(?<=\")(G|W|L|I|O|D|P|PM|F|T2|T1|T3|T4)(?![:alpha:])')[-1039]

#new pattern: '(?<=\")([:upper:]{1,2}|[:upper:][:digit:])(?![:alpha:])'

print(str_view(career_data, pattern = '(?<=\")([:upper:]{1,2}|[:upper:][:digit:])(?![:alpha:])'), n = 100)

#extracting the second value of each value in the list. This value corresponds with
#either "W" or "L" to indicate Serena "won" or "lost"
serena_outcomes = c()
for (i in 1:length(all_outcomes)){
  serena_outcomes = append(serena_outcomes, all_outcomes[[i]][2])
}
