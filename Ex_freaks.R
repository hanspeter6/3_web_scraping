link <- "http://freakonomics.com/archive/"

# read in
library(rvest)
freaks_html <- read_html(link)
freaks_html

# extract relevant text from selectorgadget css:

freaks_table<- html_nodes(x = freaks_html, css = "table")
freaks_table

title_descr <- html_table(freaks_table[[1]])
library(tidyverse)
d_frame <- title_descr %>%
        select(X2, X3)
#remove 1st row
d_frame <- d_frame[-1,]

# want to seperate title and descriptions 
library(stringr)

titles <- vector()
descriptions <- vector()
for(i in 1: nrow(d_frame)) {
        titles <- append(titles, unlist(str_split(d_frame$X2[i], '\\n'))[1])
        descriptions <- append(descriptions, unlist(str_split(d_frame$X2[i], '\\n'))[2])
}

d_frame <- data.frame(titles = titles, descriptions = descriptions, date = d_frame$X3)

# now want to add column of links

freaks_titles <- html_nodes(freaks_html, css = 'td :nth-child(1)')

links <- html_attr(freaks_titles, 'href')
links <- links[-which(is.na(links))]

d_frame_total <- data.frame(d_frame, links = links)