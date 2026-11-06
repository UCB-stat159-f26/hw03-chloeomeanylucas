library(rvest)
library(tidyverse)

#argument <name> is the full name of the player in the format: FirstLast

getcareerdatafromweb = function (name) {
  url = paste0("https://www.tennisabstract.com/cgi-bin/wplayer-classic.cgi?p=", name, "s&f=ACareerqq")

  html_webpage = read_html(url)

  #searching for the "src" url in <script></script>
  js_urls = html_webpage %>%
    html_elements("script[src]") %>%
    html_attr("src")

  career_url = js_urls[str_detect(js_urls, pattern = "Career")]

  career_url
}
