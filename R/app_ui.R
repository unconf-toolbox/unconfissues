#' @import shiny
#' @import bs4Dash
#' @import emo
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
        "The Unconf Issue Explorer!",
        skin = "light",
        status = "success",
        controlbarIcon = "plus",
        leftUi = NULL,
        rightUi = NULL
      ),
      
      # left sidebar
      sidebar = bs4DashSidebar(
        skin = 'light',
        status = 'info',
        brandColor = 'info',
        title = "Unconf Issue Explorer",
        url = "https://github.com/chirunconf",
        src = "https://raw.githubusercontent.com/chirunconf/chirunconf.github.io/master/img/logo.png",
        elevation = 4,
        opacity = 0.8,
        
        # left sidebar menu
        bs4SidebarMenu(
          bs4SidebarMenuItem(
            "Viewer",
            tabName = "viewer",
            icon = 'table'
          )
        )
      ),
      
      controlbar = bs4DashControlbar(
        title = "Add a repository",
        skin = "light",
        textInput(
          inputId = "new_repo_owner",
          label = "Repository owner"
        ),
        textInput(
          inputId = "new_repo_name",
          label = "Repository name"
        ),
        textInput(
          inputId = "new_repo_label",
          label = "Label used"
        ),
        actionButton(
          inputId = "add_repo",
          label = "Add repo!"
        )
      ),
      
      # main body
      body = bs4DashBody(
        shinyjs::useShinyjs(),
        shinyWidgets::chooseSliderSkin("HTML5"),
        
        # Tab content
        bs4TabItems(
          
          # viewer tab
          bs4TabItem(
            tabName = "viewer",
            fluidRow(
              col_12(
                bs4Alert(
                  title = "Welcome to the Unconf Issue Explorer!",
                  width = 12,
                  status = "success",
                  closable = TRUE,
                  paste("You can view the issues associated with a different GitHub repository by clicking the",  emo::ji("heavy_plus_sign"), "in the upper right corner and entering the repository details.")
                )
              )
            ),
            fluidRow(
              col_6(
                align = "center",
                h3("Open Issues"),
                mod_issue_viewer_ui("issue_viewer_open")
              ),
              col_6(
                align = "center",
                h3("Closed Issues"),
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
