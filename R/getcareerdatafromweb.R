#' @title Career Data from Tennis Abstract
#' @description Retrieves the .js files embedded in the Tennis Abstract summary of a professional tennis player's career
#' @param name the name of the professional tennis player in the format: FirstLast
#' @return a character vector of all .js urls
#' @export
#' @examples
#' name = "SerenaWilliams"
#' getcareerdatafromweb(name)
#'
#' name = "RodLaver"
#' getcareerdatafromweb(name)

library(rvest)
library(tidyverse)

getcareerdatafromweb = function (name) {
  url = paste0("https://www.tennisabstract.com/cgi-bin/wplayer-classic.cgi?p=", name, "&f=ACareerqq")

  html_webpage = read_html(url)

  #searching for the "src" url in <script></script>
  js_urls = html_webpage %>%
    html_elements("script[src]") %>%
    html_attr("src")

  js_urls

}
