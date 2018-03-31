library(rvest)
library(tidyverse)

# how do we get the number of pages? here's a trick:
# the penultimate <a href> has the info about the last page
url <- "https://www.wykop.pl/szukaj/rak/?"
webpage <- read_html(url)
page_numbers <- webpage %>%
  html_nodes(".pager") %>%
  html_nodes(".button")
max_page_char <- page_numbers[length(page_numbers)-1] %>%
  html_text()
max_page <- as.numeric(max_page_char)

# we're only interested in "link" and "wpis" types of urls

link_links <- vector(mode="character", length=0)
wpis_links <- vector(mode="character", length=0)

for (i in 1:max_page) {
  v <- c("https://www.wykop.pl/szukaj/rak/strona/", i)
  url <- paste(v, collapse = "")
  rm(v)

  webpage <- read_html(url)

  site_links <- webpage %>%
    html_nodes("a") %>%
    html_attr("href")

  length_site_links <- length(site_links)

  for (i in 1:length_site_links) {
    if (grepl("https://www.wykop.pl/link", site_links[i])) {
      link_links <- c(link_links, site_links[i])
    }
    if (grepl("https://www.wykop.pl/wpis", site_links[i])) {
      wpis_links <- c(wpis_links, site_links[i])
    }
  }
}

link_links <- unique(link_links)
wpis_links <- unique(wpis_links)

# not all these links pertain to intellectual cancer so we need to remove these