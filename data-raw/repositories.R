library(readr)

repositories <- read_csv("data-raw/repositories.csv", na = "NA")

usethis::use_data(repositories, overwrite = TRUE)
