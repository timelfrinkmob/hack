library(magrittr)
library(stringr)
urls <- allArticles$site_url[allArticles$label == "real"]
write(urls,"urls.csv")

folders <- list.files() %>% .[str_detect(., "res_")]
res <- paste0(folders, "/original_raw") %>% lapply(FUN = read.csv, header = T, sep = "|", stringsAsFactors = F) %>% dplyr::bind_rows()
related_raw_merged <- paste0(folders, "/related_raw") %>% lapply(FUN = read.csv, header = T, sep = "|", stringsAsFactors = F) %>% dplyr::bind_rows()
write.csv(related_raw_merged, file = "related_raw_merged.csv")

related_raw_merged$label <- 0
related_raw_merged$idOriginalArticle <- 0

# Manually labelling article 1
#[1] "res_2017_06_22_health_ancient-egypt-mummy-dna-genome-heritage_index.html"   
related_raw_merged$idOriginalArticle[1:51] <- 1
related_raw_merged$label[c(1:3,6,13,20,22,27,31,34,36,39:41,43,46)] <- 1

# Manually labelling article 2
#[2] "res_article_us-britain-fire-arconic-idUSKBN19F05M" 
related_raw_merged$idOriginalArticle[52:88] <- 2
related_raw_merged$label[c(52:54,57,58,60,62:65,69:70,72,73)] <- 1

# Merge sentiment features
datasetFiltering <- related_raw_merged[which(related_raw_merged$idOriginalArticle %in% c(1,2)),]
related_sentiment_merged <- paste0(folders, "/related_sentiment_correlations") %>% lapply(FUN = read.csv, header = T, sep = ",", stringsAsFactors = F) %>% dplyr::bind_rows()

# Combine the datasets
datasetFinal <- cbind(datasetFiltering, related_sentiment_merged[1:88,])
datasetFinal$order[1:51] <- c(1:51)
datasetFinal$order[52:88] <- c(1:37)

#Save the data
save(datasetFinal, file="models/datasetFinal.csv")
