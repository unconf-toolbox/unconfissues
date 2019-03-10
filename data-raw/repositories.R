library(readr)

repositories <- read_csv("data-raw/repositories.csv", 
                         na = character(),
                         col_types = list(col_character(),
                                          col_character(),
                                          col_character()))

usethis::use_data(repositories, overwrite = TRUE)
