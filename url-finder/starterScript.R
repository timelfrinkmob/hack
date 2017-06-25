library(XML)
library(RCurl)
library(stringr)

args <- commandArgs()
args <- args[!str_detect(string = args, pattern = "^-|^/Library")]

# args <- "~/Documents/Mobiquity/Rest/FakeNews/url-finder/test_input"

stopifnot(length(args) == 1, file.exists(args))
titles <- readLines(con = args)
folder <- str_replace(string = args, pattern = "/[^/]+$",replacement = "/")

getGoogleLinks <- function(google.url) {
    doc <- getURL(google.url, httpheader = c("User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"))
    Sys.sleep(5+rnorm(1,0,4) + runif(min = 0, max = 2, n = 1))
    html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function
                          (...){})
    nodes <- getNodeSet(html, "//h3[@class='r']//a")
    return(sapply(nodes, function(x) x <- xmlAttrs(x)[["href"]]))
}

for(title in titles){
    headline <- URLencode(title)
    base <- "https://www.google.nl/search?q="
    url <- paste0(base, headline)

    links <- list()
    for ( i in  0 : 4 ) {
        results <- getGoogleLinks(paste0(url, "&start=",i*10))
        links <- c(links, results)
    }

    links <- unlist(links)
    title <- str_replace_all(string = title, pattern = " |/", replacement = "_")
    write(links, file = paste0(folder, title, "_output"))
}