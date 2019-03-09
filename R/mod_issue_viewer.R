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
mod_issue_viewer_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns('viewer'))
  )
}
    
# Module Server
    
#' @rdname mod_issue_viewer
#' @import DT
#' @import projmgr
#' @import tibble
#' @import purrr
#' @import dplyr
#' @export
#' @keywords internal
    
mod_issue_viewer <- function(input, output, session){
  ns <- session$ns
  
  issue_df <- reactive({
    repo_name <- create_repo_ref(repo_owner = "chirunconf",
                                 repo_name = "chirunconf19")
    
    repo_issues <- get_issues(repo_name, state = "all") %>%
      parse_issues()
    
    keep_cols <- function(df) {
      df %>%
        as_tibble() %>%
        select(number, title, user_login, state, url,
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
    
    return(tagged_issues)
  })
  
  output$viewer <- renderUI({
    #tmp <- filter(issue_df(), repo_name == "drake")
    
    create_card <- function(df) {

      bs4Card(
        title = df$repo_name,
        status = "primary",
        solidHeader = TRUE,
        closable = FALSE,
        collapsible = TRUE,
        collapsed = FALSE,
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
    
    tagList(
      issue_df() %>%
        group_nest(repo_owner, repo_name, keep = TRUE) %>% 
        pull(data) %>%
        map(create_card)
    )
  })
}
    
## To be copied in the UI
# mod_issue_viewer_ui("issue_viewer_ui_1")
    
## To be copied in the server
# callModule(mod_issue_viewer, "issue_viewer_ui_1")
 
