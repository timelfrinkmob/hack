library(magrittr)
library(XML)
library(RCurl)


getGoogleLinks <- function(google.url) {
  doc <- getURL(google.url, httpheader = c("User-Agent" = "R
                                           (2.10.0)"))
  Sys.sleep(5+rnorm(1,0,2))
  html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function
                        (...){})
  nodes <- getNodeSet(html, "//h3[@class='r']//a")
  #return(sapply(nodes, function(x) x <- xmlAttrs(x)[["href"]]))
  return(doc)
}

links <- list()
for ( i in  1 : 2 ) {
  results <- getGoogleLinks(paste0("https://www.google.nl/search?q=BREAKING!+NYPD+Ready+To+Make+Arrests+In+Weiner+Case%E2%80%A6Hillary+Visited+Pedophile+Island+At+Least+6+Times%E2%80%A6Money+Laundering%2C+Underage+Sex%2C+Pay-for-Play%2CProof+of+Inappropriate+Handling+Classified+Information+%C2%BB+100percentfedUp.com&oq=BREAKING!+NYPD+Ready+To+Make+Arrests+In+Weiner+Case%E2%80%A6Hillary+Visited+Pedophile+Island+At+Least+6+Times%E2%80%A6Money+Laundering%2C+Underage+Sex%2C+Pay-for-Play%2CProof+of+Inappropriate+Handling+Classified+Information+%C2%BB+100percentfedUp.com&aqs=chrome..69i57.216j0j7&sourceid=chrome&ie=UTF-8","&start=",i*10))
  
  links <- c(results,links)
  
}

links[[1]] %>% htmlTreeParse(useInternalNodes = TRUE, error=function
                             (...){})

