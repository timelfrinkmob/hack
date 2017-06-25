library(magrittr)
library(stringr)

folders <- list.files() %>% .[str_detect(., "res_")]

for(folder in folders){
    system(command = paste0("Rscript sentiment_correlations.R ", folder, "/original_raw ", folder, "/related_raw"))
    system(command = paste0("Rscript sentence_correlations.R ", folder, "/original_raw ", folder, "/related_raw"))

    file.copy(from = "original_raw_sentence_correlations", to = paste0(folder, "/", "related_sentiment_correlations"))
    file.copy(from = "original_raw_sentiment_correlations", to = paste0(folder, "/", "related_sentence_correlations"))
}

file.remove("original_raw_sentence_correlations")
file.remove("original_raw_sentiment_correlations")