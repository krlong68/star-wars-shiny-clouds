library(tools)

# create editable character sheet with suggestions
dialogue <- read.table("data/epX_cleaned.csv", header = TRUE, sep = ",")

freq_frame <- as.data.frame(sort(table(dialogue$from), decreasing = TRUE))
norm_char_frame <- as.data.frame(apply(freq_frame, 2, as.character))

base_chars <- norm_char_frame$Var1

styled_chars <- toTitleCase(tolower(base_chars))
char_images <- gsub(" ", "-", base_chars)

char_frame <- cbind(base_chars, styled_chars, char_images)
colnames(char_frame) <- c("base", "styled", "image")

write.csv(char_frame, "data/epX_chars.csv", row.names = FALSE)

