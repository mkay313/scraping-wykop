library(plyr)
library(tidyverse)
library(rvest)
source("helper.R")

CSV_DATA = "linki_test.csv"

# we've tagged the texts manually (added a new column "Relevant" with Yes/No answers)
# let's read the data and take the texts we're interested in

current_df <- read.csv(CSV_DATA)
current_df <- current_df %>%
  filter(Relevant == "Yes")
length_of_current_df = nrow(current_df)
results <- vector(mode="list", length=length_of_current_df)

for (i in 1:length_of_current_df) {
  url <- as.character(current_df$x[i])
  max_page <- GetNumberOfSubPages(url)
  
  if (identical(max_page, numeric(0))) {
    max_page <- 1
  }
  list_of_comment_pages <- vector(mode="list", length=max_page)
  
  for (i in 1:max_page) {
    abs_url <- paste(c(url,"strona/",i), collapse = "")
    print(c("comment pages found: ", max_page))
    print(c("parsing: ", abs_url))
    page_content_df <- GetCommentsFromSinglePage(abs_url)
    list_of_comment_pages[[i]] <- page_content_df
    Sys.sleep(sample(seq(0.1, 1, 0.1), 1)) # wait a moment
  }
  
  page_content_df <- rbind.fill(list_of_comment_pages)
  
  results[[i]] <- page_content_df
  
}

all_posts_and_comments <- rbind.fill(results)