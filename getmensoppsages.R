library(rvest)
library(tidyverse)


getmensoppsages = function (name){
  js_urls = getcareerdatafromweb(name)

  career_url = js_urls[str_detect(js_urls, pattern = "Career")]

  data = readLines(career_url)

  #extracts patterns that look like: ##.#######...
  opp_ages = str_extract(data, pattern = "[:digit:]{2}\\.[:digit:]+")

  #removes NA values
  opp_ages = opp_ages[!is.na(opp_ages)]

  opp_ages
}
