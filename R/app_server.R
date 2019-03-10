#' @import shiny
app_server <- function(input, output,session) {
  # List the first level callModules here
  
  callModule(mod_issue_viewer, "issue_viewer_open", issue_type = "open", collapsed = TRUE)
  callModule(mod_issue_viewer, "issue_viewer_closed", issue_type = "closed", collapsed = FALSE)
}
