library(tidyverse)
library(rvest)

# we've tagged the texts manually (added a new column "Relevant" with Yes/No answers)
# let's read the data and take the texts we're interested in

raki_df <- read.csv("linki_test.csv")
raki_relevant <- raki_df %>%
  filter(Relevant == "Yes")

url <- as.character(raki_relevant$x[2])
webpage <- url %>%
  read_html(encoding = "UTF-8")
content <- webpage %>%
  html_nodes(".dC") %>%
  html_nodes("p") %>%
  html_text() %>%
  str_replace_all("\t|\n", "") %>%
  trimws(which = c("both"))
content <- content[nchar(content) > 4] # removes all entries where there are < 5 characters

comment_times <- webpage %>%
  html_nodes(".dC") %>%
  html_nodes("time") %>%
  html_attr("datetime")

about_post <- webpage %>%
  html_nodes(".bdivider") %>%
  html_text() %>%
  str_replace_all("\t", "") %>%
  str_replace_all("\n", "")

info <- c(about_post, comment_times)