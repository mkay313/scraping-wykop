library(rvest)
library(tidyverse)
source("helper.R")

SEARCH_TERM <- "rak"

#combine the search term and other url elements
url_elements <- c("https://www.wykop.pl/szukaj/", SEARCH_TERM, "/strona/")
URL <- paste(url_elements, collapse = "")

max_page <- GetNumberOfSubPages(URL)

site_links <- vector(mode="character", length=0)

# collects links for all results
# if there is only a single page then the loop only runs once
if (identical(max_page, numeric(0))) {
  max_page <- 1
}
for (i in 1:max_page) {
  v <- c(URL, i)
  url <- paste(v, collapse = "")
  print(url)
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