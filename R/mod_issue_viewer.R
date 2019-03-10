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
mod_issue_viewer_ui <- function(id) {
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
#' @import stringr
#' @export
#' @keywords internal

mod_issue_viewer <- function(input, output, session, issue_type, collapsed = TRUE){
  ns <- session$ns
  
  issue_df <- reactive({
    get_repos_issues("data-raw/repositories.csv", issue_type)
  })
  
  output$viewer <- renderUI({
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
      bs4AccordionItem(
        id = ns(stringr::str_extract(url, "([^/]+$)")),
        title = title,
        status = "primary",
        enurl(url, url)
      )
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

