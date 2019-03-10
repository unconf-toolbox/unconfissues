# Module UI
  
#' @title   mod_issue_viewer_ui and mod_issue_viewer_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_issue_viewer
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @import DT
#' @import shinycustomloader
mod_issue_viewer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns('viewer')) %>% withLoader(type = "html", loader = "dnaspin")
  )
}
    
# Module Server
    
#' @rdname mod_issue_viewer
#' @import DT
#' @import projmgr
#' @import tibble
#' @import purrr
#' @import dplyr
#' @import stringr
#' @export
#' @keywords internal
    
mod_issue_viewer <- function(input, output, session, issue_type, collapsed = TRUE){
  ns <- session$ns
  
  issue_df <- reactive({
    repo_name <- create_repo_ref(repo_owner = "chirunconf",
                                 repo_name = "chirunconf19")
    
    repo_issues <- get_issues(repo_name, state = "all") %>%
      parse_issues()
    
    keep_issues_and_cols <- function(df) {
      df %>%
        as_tibble() %>%
        filter(str_detect(url, "issues")) %>%
        select(number, title, user_login, state, url,
               created_at, closed_at, body, labels_name)
    }
    
    repo_issues <- repo_issues %>%
      keep_issues_and_cols() %>%
      mutate(repo_owner = repo_name[["repo_owner"]],
             repo_name = repo_name[["repo_name"]])
    
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
        keep_issues_and_cols() %>%
        mutate(repo_owner = repo_owner,
               repo_name = repo_name,
               label = label)
    }
    
    tagged_issues <- repos_with_tags %>%
      purrr::pmap_dfr(get_tagged_issues) 
    
    repo_and_tagged_issues <- repo_issues %>%
      bind_rows(tagged_issues) %>%
      filter(state == issue_type)
    
    return(repo_and_tagged_issues)
  })
  
  output$viewer <- renderUI({
    #tmp <- filter(issue_df(), repo_name == "drake")
    req(issue_df())
    create_card <- function(df) {

      bs4Card(
        title = df$repo_name,
        status = "primary",
        solidHeader = TRUE,
        closable = FALSE,
        collapsible = TRUE,
        collapsed = collapsed,
        width = 12,
        map2(df$title, df$url, ~create_accordion(.x, .y))
      )
    }
    
    create_accordion <- function(title, url) {
      
      #tagList(
        bs4AccordionItem(
          id = ns(stringr::str_extract(url, "([^/]+$)")),
          title = title,
          status = "primary",
          enurl(url, url)
          #rep_br(2),
          #body
        )
      #)
    }
    
    if (nrow(issue_df()) < 1) {
      res <- tagList(
        bs4Alert(
          title = "No closed issues yet!",
          "Let's keep checking!",
          width = 12,
          closable = FALSE
        )
      )
    } else {
      res <- tagList(
        issue_df() %>%
          group_nest(repo_owner, repo_name, keep = TRUE) %>% 
          pull(data) %>%
          map(create_card)
      )
    }
  })
}
    
## To be copied in the UI
# mod_issue_viewer_ui("issue_viewer_ui_1")
    
## To be copied in the server
# callModule(mod_issue_viewer, "issue_viewer_ui_1")
 
