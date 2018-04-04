# scraping-wykop
a collection of scripts for scraping wykop.pl, a Polish website similar to reddit, hackernews, etc

### backstory
I created those scripts for a friend who needs some data for her MA thesis (good luck!). 

### use and setup
To install the libraries used in the projects run
`install.packages(c("rvest", "plyr", "tidyverse"))`

The workflow is:
1. set a keyword in get_search_results.R
2. run `get_search_results.R`
3. browse the csv with the generated links to add a column "Relevant" with Yes/No answers (or remove any potentially unnecessary entries and comment out/remove the filter lines (12-13 in `get_posts_and_comments.R`)
4. provide get_posts_and_comments.R with the name of your csv file. It expects to find 2 columns: `x` (links) and `Relevant` (can be easily removed).
5. run `get_posts_and_comments.R`
6. from then on, you can analyse your results in RStudio or export them to a csv file with `write.csv(all_posts_and_comments, file = "yourfilename.csv")`

### what's next
I'll probably be refactoring the code and fixing any potential issues sometime soon once I get feedback from my friend. Later I plan on using the data marked by her to run my own analysis so it's still wip.