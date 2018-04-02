#subpages for a page -- works both for search results and comments under individual posts
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

# all comments for a single page
GetCommentsFromSinglePage <- function(this_url) {
  webpage <- this_url %>%
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
                            function(x) ! (any(grepl("źródło: ", x))), 
                            USE.NAMES = FALSE)
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
                                  function(x) ! (any(grepl("Zobacz więcej", x))), 
                                  USE.NAMES = FALSE)
                           == TRUE]
  
  info <- c(about_post, comment_times)
  web_addresses <- rep(this_url, length(info))
  page_content_df <- data.frame(content = content, info = info, web_addresses = web_addresses)
  
  return(page_content_df)
}