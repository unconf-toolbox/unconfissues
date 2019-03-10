#' @import shiny
#' @import shinyjs
app_server <- function(input, output, session) {
  # List the first level callModules here
  
  repos_df <- reactiveVal(
    repositories
  )
  
  observeEvent(
    eventExpr = input$add_repo, {
      repos_with_new_df <- add_repo(
        repos_df(),
        input$new_repo_owner,
        input$new_repo_name,
        input$new_repo_label
      )
      
      repos_df(repos_with_new_df)
      
      reset("new_repo_owner")
      reset("new_repo_name")
      reset("new_repo_label")
    }
  )
  
  callModule(mod_issue_viewer, "issue_viewer_open", repos_df = repos_df, issue_type = "open", collapsed = TRUE)
  
  callModule(mod_issue_viewer, "issue_viewer_closed", repos_df = repos_df, issue_type = "closed", collapsed = FALSE)
}
