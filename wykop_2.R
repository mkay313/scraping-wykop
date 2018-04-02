library(tidyverse)
library(rvest)

CSV_DATA = "linki_test.csv"

# we've tagged the texts manually (added a new column "Relevant" with Yes/No answers)
# let's read the data and take the texts we're interested in

current_df <- read.csv(CSV_DATA)
current_df <- current_df %>%
  filter(Relevant == "Yes")
length_of_current_df = nrow(current_df)
results <- vector(mode="list", length=length_of_current_df)

for (i in 1:length_of_current_df) {
  print(i)
  url <-
    paste(c(as.character(current_df$x[i]), "strona/1"), collapse = "")
  webpage <- url %>%
    read_html(encoding = "UTF-8")
  content <- webpage %>%
    html_nodes(".dC") %>%
    html_nodes("p") %>%
    html_text() %>%
    str_replace_all("\t|\n|pokaż komentarz|. . . kliknij, aby rozwinąć obrazek . . .", "") %>%
    trimws(which = c("both"))
  
  content <-
    content[nchar(content) > 4] # removes all entries where there are < 5 characters

  # below is pure magic: we remove all "źródło: " entries since they are part of the same comment
  # otherwise the timestamps wouldn't work
  content <- content[sapply(content,
                            function(x)
                              ! (any(grepl("źródło: ", x))), USE.NAMES = FALSE)
                     == TRUE]
  
  comment_times <- webpage %>%
    html_nodes(".dC") %>%
    html_nodes("time") %>%
    html_attr("datetime")
  
  about_post <- webpage %>%
    html_nodes(".bdivider") %>%
    html_text() %>%
    str_replace_all("\t", "") %>%
    str_replace_all("\n", "")
  
  # similar magic for comment times to remove all "Powiązane" entries
  
  about_post <- about_post[sapply(about_post,
                                  function(x)
                                    ! (any(grepl("Zobacz więcej", x))), USE.NAMES = FALSE)
                           == TRUE]
  
  info <- c(about_post, comment_times)
  page_content_df <- data.frame(content = content, info = info)
  results[[i]] <- page_content_df
}