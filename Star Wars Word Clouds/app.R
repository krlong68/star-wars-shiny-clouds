library(shiny)
library(tm)
library(wordcloud)

# UI
ui <- fluidPage(
  titlePanel("Star Wars Word Clouds"),

  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "movie",
                  label = "Choose a Movie",
                  choices = c("Episode I - The Phantom Menace",
                              "Episode II - Attack of the Clones",
                              "Episode III - Revenge of the Sith",
                              "Episode IV - A New Hope"
                              #"Episode V - The Empire Strikes Back",
                              #"Episode VI - Return of the Jedi"
                              )
                  ),
      uiOutput("characters")
      ),
    mainPanel(
      imageOutput("char_image", width = "64px", height = "64px"),
      plotOutput("wordcloud", width = "600px", height = "600px"),
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      )
    )
  )
)
  

# Server
server <- function(input, output) {
  set.seed(68)
  data_dir <- "data/"
  movies <- read.table("data/movies.csv", header = TRUE, sep = ",")
  
  output$characters = renderUI({
    req(input$movie)
    
    movie <- input$movie
    movie_id <- movies[movies$title == movie,1]
    filename <- paste0(data_dir, movie_id, "_chars.csv")
    
    char_file <- read.csv(filename, header = TRUE, sep = ",")
    characters <- char_file$styled
    
    selectInput(inputId = "character",
                label = "Choose a Character",
                choices = characters
    )
  })
  
  getImage <- reactive({
    #req(input$movie)
    req(input$character)
    
    print("getting movie")
    movie <- input$movie
    print(movie)
    movie_id <- movies[movies$title == movie,1]
    print(movie_id)
    
    print("getting character image filename")
    styled_character <- input$character
    print(styled_character)
    chars_filename <- paste0(data_dir, movie_id, "_chars.csv")
    print(chars_filename)
    char_file <- read.csv(chars_filename, header = TRUE, sep = ",")
    char_image_path <- char_file[char_file$styled == styled_character,3]
    print(char_image_path)
    
    image_file <- paste0(data_dir, movie_id, "_images/", char_image_path, ".jpeg")
    print(image_file)
    
    return(image_file)
  })
  
  output$char_image <- renderImage({
    #req(input$movie)
    req(input$character)
    
    image_file <- getImage()
    
    list(src = image_file)
  }, deleteFile = FALSE)
  
  getWords <- reactive({
    #req(input$movie)
    req(input$character)
    
    movie <- input$movie
    print(movie)
    
    styled_character <- input$character
    print(styled_character)
    
    movie_id <- movies[movies$title == movie,1]
    
    dialogue_filename <- paste0(data_dir, movie_id, "_cleaned.csv")
    chars_filename <- paste0(data_dir, movie_id, "_chars.csv")
    
    char_file <- read.csv(chars_filename, header = TRUE, sep = ",")
    dialogue <- read.table(dialogue_filename, header = TRUE, sep = ",")
    
    character <- char_file[char_file$styled == styled_character,1]
    print(character)
    
    char_text <- dialogue[dialogue$from == character, "text"]
    char_docs <- VCorpus(VectorSource(char_text))
    #print(char_text)
    
    tdm <- TermDocumentMatrix(char_docs) 
    matrix <- as.matrix(tdm) 
    words <- sort(rowSums(matrix), decreasing=TRUE) 
    df <- data.frame(word = names(words),freq=words)
    
    return(df)
  })
  
  output$wordcloud <- renderPlot({
    #req(input$movie)
    req(input$character)
    
    df <- getWords()
    wordcloud(words = df$word,
              freq = df$freq,
              min.freq = 1,
              max.words = 200,
              random.order = FALSE,
              rot.per = 0,
              scale = c(3, .5),
              colors = brewer.pal(8, "Dark2"))
  })
  
}


# Run
shinyApp(ui = ui, server = server)
