#' @import shiny
app_server <- function(input, output,session) {
  # List the first level callModules here
  
  callModule(mod_issue_viewer, "issue_viewer_ui_1")
}
