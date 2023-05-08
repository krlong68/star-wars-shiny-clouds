library(dplyr)
library(tm)
library(tidytext)
library(stringr)

dialogue <- read.table("data/ep4_dialogue.csv", header = TRUE, sep = ";", quote = "")

characters <- unique(dialogue$from)

characters_text <- dialogue[c("doc_id", "from", "text")]
characters_text$text <- removePunctuation(characters_text$text,
                  preserve_intra_word_contractions = TRUE,
                  preserve_intra_word_dashes = TRUE) %>%
                  stripWhitespace %>%
                  tolower

'%nin%' <- Negate('%in%')
characters_text$text <- lapply(characters_text[,"text"],
                          function(x) {
                            t <- unlist(strsplit(x, " "))
                            t <- t[t %nin% stopwords("english")]
                            t <- t[t %nin% stopwords("SMART")]
                            t <- paste(t, collapse = " ")
                          })

characters_text <- apply(characters_text, 2, as.character)

write.csv(characters_text, "data/ep4_cleaned.csv", row.names = FALSE)
