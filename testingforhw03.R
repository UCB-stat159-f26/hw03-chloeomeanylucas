library(rvest)
library(tidyverse)

name = "EliseMertens"

url = paste0("https://www.tennisabstract.com/cgi-bin/wplayer-classic.cgi?p=", name, "&f=ACareerqq")

html_webpage = read_html(url)

#searching for the "src" url in <script></script>
js_urls = html_webpage %>%
  html_elements("script[src]") %>%
  html_attr("src")

career_url = js_urls[str_detect(js_urls, pattern = "Career")]

#I can get the ...<FirstLast>.js and the ...<FirstLast>Career.js from same webpage
player_url = js_urls[str_detect(js_urls, pattern = paste0(name, "(?!Career)"))]

data = readLines(player_url)
data

#okay so this extracts the birthday
birthday = str_extract(data, pattern = "(?<=dob=)[:digit:]{8}")

str_view(data, pattern = "WTA")

#removes the NA values that come from str_extract()
birthday = birthday[!is.na(birthday)]
