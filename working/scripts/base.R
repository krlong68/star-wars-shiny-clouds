library(dplyr)
library(wordcloud)
library(tm)
library(tidytext)
library(stringr)


set.seed(68)
original_SMART <- stopwords("SMART")
custom_SMART <- setdiff(original_SMART, c("b", "c", "d", "e", "f", "g", "h", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "w", "x", "y", "z"))

ep1 <- read.table("data/ep1_dialogue.csv", header = TRUE, sep = ";", quote = "")

characters <- unique(ep1$from)
character <- "QUI-GON"

character_text <- ep1[ep1$from == character, "text"]
character_text <- removePunctuation(character_text,
                                    preserve_intra_word_contractions = TRUE,
                                    preserve_intra_word_dashes = TRUE)

docs <- VCorpus(VectorSource(character_text))

docs <- docs %>%
  #tm_map(removeNumbers) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, custom_SMART)

dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

wordcloud(words = df$word,
          freq = df$freq,
          min.freq = 1,
          max.words=200,
          random.order=FALSE,
          rot.per=0,
          scale = c(2, .5),
          colors=brewer.pal(8, "Dark2"))
