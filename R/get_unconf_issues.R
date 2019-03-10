#' Keep issues and columns
#' 
#' Only keep issues (no PRs) and relevant columns from pulled issues
#'
#' @param df 
#' @export
keep_issues_and_cols <- function(df) {
  df %>%
    dplyr::as_tibble() %>%
    dplyr::filter(stringr::str_detect(url, "issues")) %>%
    dplyr::select(number, title, user_login, state, url,
                  created_at, closed_at, body, labels_name)
}

#' Get labelled issues from a specific repository
#'
#' @param repo_owner 
#' @param repo_name 
#' @param label 
#' @param ... 
#'
#' @export
get_labelled_issues <- function(repo_owner, repo_name, label){
  projmgr::get_issues(
    projmgr::create_repo_ref(repo_owner, repo_name),
    labels = label,
    state = "all"
  ) %>%
    projmgr::parse_issues() %>%
    keep_issues_and_cols() %>%
    dplyr::mutate(repo_owner = repo_owner,
                  repo_name = repo_name,
                  label = label)
}

#' Get all unconf issues from specified repositories
#'
#' @param repositories 
#' @param issue_type
#'
#' @export
get_repos_issues <- function(repositories, issue_type){
  repositories %>% 
    purrr::pmap_dfr(get_labelled_issues) %>%
    dplyr::filter(state == issue_type)
}

#' Add repo to those tracked
#'
#' @param repo_owner 
#' @param repo_name 
#' @param label 
#'
#' @export
add_repo <- function(repos_df, repo_owner, repo_name, label){
  new_repo <- dplyr::tibble(
    repo_owner = repo_owner,
    repo_name = repo_name,
    label = label
  )
  
  repos_df %>%
    dplyr::bind_rows(new_repo)
}
