# Libraries
library(rvest)
library(dplyr)
library(stringr)
library(xml2)

# Initialize an empty data frame
Articles <- data.frame(stringsAsFactors = FALSE)

# Function to get correspondence authors
get_correspondence_auth <- function(article_link) {
  article_page <- read_html(article_link)
  correspondance_auth <- article_page %>% html_nodes("#corresponding-author-list a") %>%
    html_text() %>% paste(collapse = ",")
  return(correspondance_auth)
}

# Function to get keywords 
get_keywords <- function(article_link) {
  article_page <- read_html(article_link)
  keywords <- article_page %>% html_nodes(".c-article-subject-list__subject") %>% 
    html_text() %>% paste(collapse = ",")
  return(keywords)
}

# Function to get author emails
get_author_email <- function(article_link) {
  article_page <- read_html(article_link)
  anchor_elements <- article_page %>% html_nodes("#corresponding-author-list a[href]")
  
  if (length(anchor_elements) > 0) {
    urls <- html_attr(anchor_elements, "href")
    mailto_strings <- urls[grepl("mailto:", urls)]
    
    if (length(mailto_strings) >= 2) {
      mailto_strings <- mailto_strings[1:(length(mailto_strings) - 2)]
      mailto_strings <- paste(mailto_strings, collapse = ",")
      auth_mails <- gsub('mailto:', '', mailto_strings, fixed = TRUE)
      return(auth_mails)
    }
  }
  
  # Return NA if not enough valid email found
  return(NA)
}


# For loop to iterate through multiple pages 
for (page_result in seq(from = 1, to = 12)) {
  link = paste0("https://immunityageing.biomedcentral.com/articles?searchType=journalSearch&sort=PubDate&page=", page_result, "")
  page = read_html(link)
  
  # Extracting Title, Authors, Publish_date, Abstract, Keywords, Correspondence author, Author emails
  Title <- page %>% html_nodes(".c-listing__title a") %>% html_text()
  article_links <- page %>% html_nodes(".c-listing__title a") %>% 
    html_attr("href") %>% paste("https://immunityageing.biomedcentral.com", ., sep = "")
  Authors <- page %>% html_nodes(".c-listing__authors-list") %>% html_text()
  Publish_Date <- page %>% html_nodes(".c-listing__metadata span+ span") %>% html_text()
  Abstract <- page %>% html_nodes(".c-listing__title+ p") %>% html_text()
  
  Keywords <- sapply(article_links, FUN = get_keywords, USE.NAMES = FALSE)
  
  Correspondence_author <- sapply(article_links, FUN = get_correspondence_auth, USE.NAMES = FALSE)
  
  Author_Emails <- sapply(article_links, FUN = get_author_email, USE.NAMES = FALSE)
  
  # Making sure the max length of vectors will be the length 
  length(Abstract) <- length(Title)
  
  # Creating a data frame with all the attributes
  df <- data.frame(Title = Title, Authors = Authors, Publish_Date = Publish_Date, Abstract = Abstract,
                   Correspondence_author = Correspondence_author, Author_Emails = Author_Emails, Keywords = Keywords,
                   stringsAsFactors = FALSE)
  
  # Append the data frame to the main data frame 'Articles'
  Articles <- bind_rows(Articles, df)
  print(paste("Page:", page_result))  
}


#-------------------------------------------------------------------------------

# Make a copy of the original dataframe
clean_articles <- Articles

# Replace empty values with NA in the entire data frame
clean_articles[clean_articles == ""] <- NA

# Drop rows with NA values
clean_articles <- drop_na(clean_articles)

# Remove duplicate rows
clean_articles <- unique(clean_articles)

# Remove "Published on: " from Publish_Date column
clean_articles$Publish_Date <- sub("Published on: ", "", clean_articles$Publish_Date)

# Change Publish_Date into correct format
clean_articles$Publish_Date <- format(as.Date(clean_articles$Publish_Date, format = "%d %B %Y"), "%m-%d-%Y")

# Filter out rows where the Authors or Abstract column is empty
clean_articles <- clean_articles %>%
  filter(!is.na(Authors) & Authors != "", !is.na(Abstract))

# Remove leading and trailing white spaces from all character columns
clean_articles <- as.data.frame(lapply(clean_articles, function(x) if(is.character(x)) trimws(x) else x))

# Put a space between comma-separated values
clean_articles$Author_Emails <- gsub(",", ", ", clean_articles$Author_Emails)
clean_articles$Correspondence_author <- gsub(",", ", ", clean_articles$Correspondence_author)
clean_articles$Keywords <- gsub(",", ", ", clean_articles$Keywords)

# View the preprocessed data
View(clean_articles)


#-------------------------------------------------------------------------------


library(ggplot2)

# Convert Publish_Date to Date format with specific format
clean_articles$Publish_Date <- as.Date(clean_articles$Publish_Date, format = "%m-%d-%Y", na.rm = TRUE)

# Extract year from Publish_Date
clean_articles$Year <- format(clean_articles$Publish_Date, "%Y")

# Create the bar plot by year
ggplot(clean_articles, aes(x = Year)) +
  geom_bar(fill = "red", alpha = 0.5) +
  labs(title = "Published Articles Distribution by Year", x = "Year", y = "Number of Articles") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Writing the dataframe to a CSV file
write.csv(clean_articles, "Articles.csv", row.names = FALSE)
