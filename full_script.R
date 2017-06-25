library(readr)
library(stringr)
library(magrittr)
jar <- "news-crowler/target/sourcer-0.0.1-SNAPSHOT.jar"
java_command_base <- paste("java -jar", jar)

cmd_args <- commandArgs()
cmd_args <- cmd_args[!str_detect(string = cmd_args, pattern = "^-|^/Library")]

cmd_args <- "urls"
data <- readLines(cmd_args) %>% .[4:length(.)]

#all rows are assumed to be URLs
for(url in data){
    file.create("tmp")
    write(x = url, file = "tmp")
    system(paste(java_command_base, "tmp"))
    content_csv <- read.csv(file = "tmp.csv", header = T, sep = "|", stringsAsFactors = F)
    title <- content_csv$Title

    write(x = title, file = "tmp")
    system(command = "Rscript url-finder/starterScript.R tmp")

    related_links <- paste0("tmp", title, "_output") %>% str_replace_all(pattern = " |/", replacement = "_")
    system(paste(java_command_base, related_links))

    related_content_csv <- paste0(related_links, ".csv")
    write.csv(x = content_csv, file = "tmp", sep = "|")
    # related_content <- read_delim(related_content_csv, "|", escape_double = FALSE, trim_ws = TRUE)

    system(command = paste("Rscript sentiment_correlations.R", "tmp.csv", related_content_csv))
    sentiments <- read_csv("tmp_correlations")

    system(command = paste("Rscript sentence_correlations.R", "tmp.csv", related_content_csv))
    sentences <- read_csv("tmp_sentence_correlations")

    path <- str_replace(url, pattern = ".+\\.[a-z]+/", replacement = "") %>% paste0("res_", .) %>%
      str_replace_all(pattern = "/", replacement = "_") %>% str_replace_all(pattern = "\"", replacement = "_")
    dir.create(path = path)
    file.copy(from = "tmp_correlations", to = paste0(path, "/", "related_sentiment_correlations"))
    file.copy(from = "tmp_sentence_correlations", to = paste0(path, "/", "related_sentence_correlations"))
    file.copy("tmp.csv", paste0(path, "/", "original_raw"))
    file.copy(related_content_csv, paste0(path, "/", "related_raw"))

    file.remove("tmp")
    file.remove("tmp_output")
    file.remove("tmp.csv")
    file.remove(related_links)
    file.remove(paste0(related_links, ".csv"))
    file.remove("tmp_sentence_correlations")
    file.remove("tmp_correlations")
}

