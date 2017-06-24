library(lsa)
library(janeaustenr)
library(dplyr)
library(stringr)
library(tidyr)
library(dplyr)
library(tm)
library(tidytext)

args <- commandArgs()
args <- args[!str_detect(string = args, pattern = "^-|^/Library")]

stopifnot(length(args) == 2, file.exists(args))
print(args)

# arg1 <- "/Users/rubensikkes/sourcer/test.csv"
# arg2 <- "/Users/rubensikkes/sourcer/compare.csv"

arg1 <- args[1]
arg2 <- args[2]


# 2 strings 2 csv files
original_text <- read.csv(arg1, header=T, sep="|", stringsAsFactors = F) %>% as.data.frame()

compare_text <- read.csv(arg2, header=T, sep="|", stringsAsFactors = F) %>% as.data.frame()

transform_text <- function(test){
  # remove garbage from the bag of text
  test <- VCorpus(VectorSource(test))
  test <- tm_map(test, content_transformer(tolower))
  test <- tm_map(test, removePunctuation)
  test <- tm_map(test, removeNumbers)
  test <- tm_map(test, stemDocument)
  test <- tm_map(test, removeWords, stopwords("english"))

  dtm <- DocumentTermMatrix(test)
  word_frame <- tidy(dtm)
  colnames(word_frame)[2] <- "word"

  # get sentiments for the document matrix
  positive_neg <- get_sentiments("nrc")
  joined <- inner_join(word_frame, positive_neg, by="word")

  # count sentiment
  joined <- joined %>% group_by(sentiment) %>% summarise(total_sentiment= sum(count))
  return(joined)
}

similarities <- function(total){
  # first one is the original so only compare to that
  cols_to_compare = ncol(total)-1
  cosine_results <- c()
  pearson_results <- c()
  kendall_results <- c()
  spearman_results <-c()
  for (i in 1:cols_to_compare){
    cosine_results <- c(cosine_results, cosine(as.vector(t(total[,2])),as.vector(t(total[,i+1]))))

    pearson_results <- c(pearson_results, cor(as.vector(t(total[,2])),as.vector(t(total[,i+1]))))

    kendall_results <- c(kendall_results, cor(as.vector(t(total[,2])),as.vector(t(total[,i+1])), method ="kendall"))

    spearman_results <- c(spearman_results, cor(as.vector(t(total[,2])),as.vector(t(total[,i+1])), method ="spearman"))
  }
  similarity_matrix= cbind(cosine_results, pearson_results,kendall_results,spearman_results) %>% as.data.frame()
  return(similarity_matrix)
}


original <- original_text$Content
articles <- compare_text$Content

# start with the orignal and append the crawled websites
transformed <- transform_text(original)

for(item in articles){
  transformed <- full_join(transformed, transform_text(item), by="sentiment")
}
transformed[is.na(transformed)] <- 0

similarity_results <- similarities(transformed)
res <- apply(similarity_results, 1 , mean)
similarity_results$sentiment_avg <- res
rownames(similarity_results) <- c(1:nrow(similarity_results))

old_file_name <- str_replace_all(arg1, pattern = ".+/", replacement = "") %>% str_replace_all(pattern = "\\.[^\\.]+$", replacement = "")
new_file_name <- paste(old_file_name, "_correlations")%>% str_replace_all(pattern = " ", replacement = "")
write.csv(similarity_results, file =new_file_name)
