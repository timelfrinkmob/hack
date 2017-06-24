library(readr)
library(stringr)
library(magrittr)
jar <- "news-crowler/target/sourcer-0.0.1-SNAPSHOT.jar"
java_command_base <- paste("java -jar", jar)

cmd_args <- commandArgs()
cmd_args <- cmd_args[!str_detect(string = cmd_args, pattern = "^-|^/Library")]

cmd_args <- "full_script_test"
data <- readLines(cmd_args)

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
    AKLJ <- read_delim(related_content_csv, "|", escape_double = FALSE, trim_ws = TRUE)
}

