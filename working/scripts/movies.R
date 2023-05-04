ep <- c("ep1",
         "ep2",
         "ep3",
         "ep4",
         "ep5",
         "ep6")

title <- c("Episode I - The Phantom Menace",
            "Episode II - Attack of the Clones",
            "Episode III - Revenge of the Sith",
            "Episode IV - A New Hope",
            "Episode V - The Empire Strikes Back",
            "Episode VI - Return of the Jedi")

movie_frame <- as.data.frame(cbind(ep, title))

write.csv(movie_frame, "data/movies.csv", row.names = FALSE)
