# Script for data preprocessing and feature engineering 
library(readr)

# Load seperate datasets
fakeArticles <- read_csv("~/Desktop/Hackathon/fake.csv")
realArticles <- read_csv("~/Desktop/Hackathon/real.csv")

# Add label column 
fakeArticles$label <- "fake"
realArticles$label <- "real"

# Format timestamps
fakeArticles$published <- as.Date(fakeArticles$published)
realArticles$published <- as.Date(realArticles$published, format = "%d/%m/%Y")

# Fix typo's 
fakeArticles$language <- "english"

# Remove un-needed columns

# Fake
fakeArticles$uuid <- NULL
fakeArticles$ord_in_thread <- NULL
fakeArticles$crawled <- NULL
fakeArticles$type <- NULL

# Real
realArticles$X1 <- NULL
realArticles$ord_in_thread <- NULL
realArticles$crawled <- NULL
realArticles$type <- NULL

names(realArticles)[which(names(realArticles) == "tekst")] <- "text"
names(fakeArticles)[which(names(fakeArticles) == "tekst")] <- "text"

# Combine datasets
allArticles <- rbind(realArticles, fakeArticles)

# Remove columns
allArticles$shares <- NULL
allArticles$comments <- NULL
allArticles$likes <- NULL
allArticles$participants_count <- NULL
allArticles$replies_count <- NULL
allArticles$spam_score <- NULL
allArticles$thread_title <- NULL

# Remove non-english languages
allArticles <- allArticles[which(allArticles$language == "english"), ]

library(stringr)

# Feature engineering using tilte feature

# Count number of words in title
allArticles$numberWordsTitle <- str_count(allArticles$title, "\\S+")
#allArticles$numberWordsTitle[is.na(allArticles$numberWordsTitle)] <- 0

# Count number of characters in title
allArticles$numberCharsTitle <- str_count(allArticles$title)
allArticles$numberCharsTitle[is.na(allArticles$numberCharsTitle)] <- 0

# Average length of words
allArticles$averageLengthWords <- allArticles$numberCharsTitle / allArticles$numberWordsTitle

# Replace NA with 0
allArticles$numberWordsTitle[is.na(allArticles$numberWordsTitle)] <- 0
allArticles$numberCharsTitle[is.na(allArticles$numberCharsTitle)] <- 0
allArticles$averageLengthWords[is.na(allArticles$averageLengthWords)] <- 0

# Count number of words with capital letter
allArticles$numberWordsCapital <- str_count(allArticles$title, "\\b[A-Z]{2,}\\b")

# Total number of capital latter
allArticles$numberCapitalLetters <- sapply(regmatches(allArticles$title, gregexpr("[A-Z]", allArticles$title, perl=TRUE)), length)

#TODO: Total number of special characters 

## Wordcloud 
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")


create_wordcloud <- function(data) {
  # Load the data as a corpus
  docs <- Corpus(VectorSource(data))
  toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
  docs <- tm_map(docs, toSpace, "/")
  docs <- tm_map(docs, toSpace, "@")
  docs <- tm_map(docs, toSpace, "\\|")
  
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove your own stop word
  # specify your stopwords as a character vector
  docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Text stemming
  # docs <- tm_map(docs, stemDocument)
  
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  head(d, 10)
  
  set.seed(1234)
  wordcloud(words = d$word, freq = d$freq, min.freq = 1,
            max.words=1000, random.order=FALSE, rot.per=0.1, 
            colors=brewer.pal(8, "Dark2"))
  
}


create_wordcloud(allArticles$title)
par(mfrow = c(2,1))
create_wordcloud(allArticles$title[which(allArticles$label == "fake")])
create_wordcloud(allArticles$title[which(allArticles$label == "real")])


# Repeat for real and fake news seperately

# Real 

