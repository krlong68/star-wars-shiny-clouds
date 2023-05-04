library(tm)
library(wordcloud)

args = commandArgs(trailingOnly = TRUE)
set.seed(68)

dialogue <- read.table("data/ep1_cleaned.csv", header = TRUE, sep = ",")

characters <- unique(dialogue$from)
character <- args[1]

char_text <- dialogue[dialogue$from == character, "text"]

char_docs <- VCorpus(VectorSource(char_text))

tdm <- TermDocumentMatrix(char_docs) 
matrix <- as.matrix(tdm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

wordcloud(words = df$word,
          freq = df$freq,
          min.freq = 1,
          max.words = 200,
          random.order = FALSE,
          rot.per = 0,
          scale = c(3, .5),
          colors = brewer.pal(8, "Dark2"))