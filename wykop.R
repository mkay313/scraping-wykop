library(rvest)
library(tidyverse)

SEARCH_TERM <- "rihanna"

#combine the search term and other url elements
url_elements <- c("https://www.wykop.pl/szukaj/", SEARCH_TERM, "/strona/")
url <- paste(url_elements, collapse = "")

# how do we get the number of pages? here's a trick:
# the penultimate <a href> has the info about the last page
webpage <- read_html(url)
page_numbers <- webpage %>%
  html_nodes(".pager") %>%
  html_nodes(".button")
max_page_char <- page_numbers[length(page_numbers)-1] %>%
  html_text()
max_page <- as.numeric(max_page_char)
site_links <- vector(mode="character", length=0)

# all links for a single page
GetLinksFromSinglePage <- function(this_url) {
  v <- c(this_url, i)
  this_url <- paste(v, collapse = "")
  webpage <- read_html(this_url)
  this_site_links <- webpage %>%
    html_nodes("a") %>%
    html_attr("href")
  return(this_site_links)
}

# collects links for all results
# if there is only a single page then the loop only runs once
if (identical(max_page, numeric(0))) {
  max_page <- 1
}
for (i in 1:max_page) {
  site_links <- c(site_links, GetLinksFromSinglePage(url))
  Sys.sleep(sample(seq(0.1, 1, 0.1), 1)) # wait a moment
}

# get only the links for "link" and "wpis" types
link_links <- vector(mode="character", length=0)
wpis_links <- vector(mode="character", length=0)

length_site_links <- length(site_links)
for (i in 1:length_site_links) {
  if (grepl("https://www.wykop.pl/link", site_links[i])) {
    link_links <- c(link_links, site_links[i])
  }
  if (grepl("https://www.wykop.pl/wpis", site_links[i])) {
    wpis_links <- c(wpis_links, site_links[i])
  }
}

# remove duplicate links
link_links <- unique(link_links)
wpis_links <- unique(wpis_links)

# not all these links pertain to intellectual cancer so we need to remove these manually
csv_link_name <- paste(c(SEARCH_TERM, "_linki.csv"), collapse = "")
csv_wpis_name <- paste(c(SEARCH_TERM, "_wpisy.csv"), collapse = "")
write.csv(link_links, file = csv_link_name)
write.csv(wpis_links, file = csv_wpis_name)