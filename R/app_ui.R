#' @import shiny
#' @import bs4Dash
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    # from inst/app/www
    golem_add_external_resources(),
    golem::js(),
    golem::favicon(),
    
    # List the first level UI elements here 
    bs4DashPage(
      title = "Unconf Issue Explorer",
      sidebar_collapsed = TRUE,
      
      # navigation bar
      navbar = bs4DashNavbar(
        skin = "light",
        status = "success",
        leftUi = NULL,
        rightUi = NULL
      ),
      
      # left sidebar
      sidebar = bs4DashSidebar(
        skin = 'light',
        status = 'info',
        brandColor = 'info',
        elevation = 4,
        opacity = 0.8,
        
        # left sidebar menu
        bs4SidebarMenu(
          bs4SidebarMenuItem(
            "Welcome",
            tabName = "welcome",
            icon = 'info'
          ),
          bs4SidebarMenuItem(
            "Viewer",
            tabName = "viewer",
            icon = 'table'
          )
        )
      ),
      
      # main body
      body = bs4DashBody(
        shinyjs::useShinyjs(),
        shinyWidgets::chooseSliderSkin("HTML5"),
        
        # Tab content
        bs4TabItems(
          
          # welcome tab
          bs4TabItem(
            tabName = "welcome",
            bs4Jumbotron(
              title = "The Unconf Issue Explorer!",
              lead = "Add more exciting content here",
              status = 'success'
            )
          ),
          
          # viewer tab
          bs4TabItem(
            tabName = "viewer",
            fluidRow(
              col_6(
                mod_issue_viewer_ui("issue_viewer_open")
              ),
              col_6(
                mod_issue_viewer_ui("issue_viewer_closed")
              )
            )
          )
        )
      )
    )
  )
}

golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'unconfissues')
  )
 
  tagList(
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
