library(rvest)
library(tidyverse)


getmensoppsages = function (name){
  js_urls = getcareerdatafromweb(name)

  career_url = js_urls[str_detect(js_urls, pattern = "Career")]

  career_data = readLines(career_url)

  #extracts the ages of the opponents as a list. If there is no match, an item will be
  #coded as character(0) (empty string)
  all_opp_ages = str_extract_all(career_data, pattern = "[:digit:]{2}\\.[:digit:]+")

  opp_ages = c()
  unincluded_index = c()
  for (i in 1:length(all_opp_ages)){
    if (length(all_opp_ages[[i]]) == 0){ #skips if list item in all_opp_ages contains character(0) (empty string)
      unincluded_index = append(unincluded_index, i) #but keeps track of indices to omit from future calculations
      next
    } else {
      opp_ages = append(opp_ages, all_opp_ages[[i]]) #appends i-th opponent's birthday
    }
  }

  l = list(
    OppAges = opp_ages, #a vector
    Indices = unincluded_index #a vector
  )

  l
}
