#' @title Career Data from Tennis Abstract
#' @name getcareerdatafromweb
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

getcareerdatafromweb = function (name) {
  url = paste0("https://www.tennisabstract.com/cgi-bin/wplayer-classic.cgi?p=", name, "&f=ACareerqq")

  html_webpage = rvest::read_html(url)

  #searching for the "src" url in <script></script>
  js_urls = html_webpage %>%
    rvest::html_elements("script[src]") %>%
    rvest::html_attr("src")

  career_url = js_urls[stringr::str_detect(js_urls, pattern = "Career")]
  player_url = js_urls[stringr::str_detect(js_urls, pattern = paste0(name, "(?!Career)"))]

  #requesting response from server, making sure error does not stop call to server
  #uses httr2 package
  server_response <- httr2::request(career_url) %>%
    httr2::req_error(is_error = function(resp) FALSE) %>%
    httr2::req_perform()

  #checking if URL exists. If the server throws a 404 error, then the webpage could not be found
  if (httr2::resp_status(server_response) == 404) {
    stop("Player or player data does not exist on Tennis Abstract. Make sure that the player's name is formatted as FirstLast in quotation marks")
  }

  career_data = readLines(career_url)
  player_data = readLines(player_url)

  l = list(C = career_data, P = player_data)

  l

}
