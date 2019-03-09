library(projmgr)
library(dplyr)

repo_name <- create_repo_ref(repo_owner = "chirunconf",
                             repo_name = "chirunconf19")

repo_issues <- get_issues(repo_name, state = "all") %>%
  parse_issues()

keep_cols <- function(df) {
  df %>%
    as_tibble() %>%
    select(number, title, user_login, state,
           created_at, closed_at, body, labels_name)
}

repo_issues <- repo_issues %>%
  keep_cols()

repos_with_tags <- tibble::tribble(
  ~repo_owner, ~repo_name, ~label,
  "ropensci", "drake", "Chicago R Unconference",
  "jdblischak", "workflowr", "Chicago R Unconference"
)

get_tagged_issues <- function(repo_owner, repo_name, label){
  get_issues(
    create_repo_ref(repo_owner, repo_name),
    labels = label
  ) %>%
    parse_issues() %>%
    keep_cols() %>%
    mutate(repo_owner = repo_owner,
           repo_name = repo_name,
           label = label)
}

tagged_issues <- repos_with_tags %>%
  purrr::pmap_dfr(get_tagged_issues)
