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


#arg1 <- "~/Desktop/ruben/test.csv"
#arg2 <- "~/Desktop/ruben/compare.csv"

arg1 <- args[1]
arg2 <- args[2]


# 2 strings 2 csv files
original_text <- read.csv(arg1, header=T, sep="|", stringsAsFactors = F) %>% as.data.frame()

compare_text <- read.csv(arg2, header=T, sep="|", stringsAsFactors = F) %>% as.data.frame()




original <- as.matrix(original_text$Content)
articles <- as.matrix(compare_text$Content)

docs <- rbind(original,articles)
docs <- VCorpus(VectorSource(docs))
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs,removePunctuation)
docs <- tm_map(docs, stemDocument)
docs <- tm_map(docs, removeWords, stopwords("english"))
dtm <-  DocumentTermMatrix(docs)
library(tidytext)
tidy_dtm <- tidy(dtm)
tidy_dtm$document <- as.numeric(as.character(tidy_dtm$document))

tidy_dtm <- tidyr::spread(tidy_dtm,document,count)
tidy_dtm[is.na(tidy_dtm)] <- 0


library(lsa)
require(quanteda)
cosine = c()
cor = c()
for(i in c(1:(ncol(tidy_dtm)-1))) {
  cosine <- c(cosine,(lsa::cosine(as.vector(t(tidy_dtm[,2])),as.vector(t(tidy_dtm[,1+i])))))
  cor <- c(cor,(cor(as.vector(t(tidy_dtm[,2])),as.vector(t(tidy_dtm[,1+i])))))
}

tot <- cbind(cosine,cor)
rownames(tot) <- c(1:nrow(tot))



old_file_name <- str_replace_all(arg1, pattern = ".+/", replacement = "") %>% str_replace_all(pattern = "\\.[^\\.]+$", replacement = "")
new_file_name <- paste(old_file_name, "_sentence_correlations")%>% str_replace_all(pattern = " ", replacement = "")
write.csv(tot, file =new_file_name)
