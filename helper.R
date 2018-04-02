#subpages for a page -- work both for search results and comments under individual posts
GetNumberOfSubPages <- function (this_url) {
  webpage <- read_html(this_url)
  page_numbers <- webpage %>%
    html_nodes(".pager") %>%
    html_nodes(".button")
  max_page_char <- page_numbers[length(page_numbers)-1] %>%
    html_text()
  max_page <- as.numeric(max_page_char)
  return(max_page)
}

# all links for a single page
GetLinksFromSinglePage <- function(this_url) {
  webpage <- read_html(this_url)
  this_site_links <- webpage %>%
    html_nodes("a") %>%
    html_attr("href")
  return(this_site_links)
}