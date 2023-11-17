# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

devtools::load_all()
options( "golem.app.prod" = TRUE)
exemploGolem::run_app() # add parameters here (if any)

# library(exemploGolem)
# run_app()

# exemploGolem::run_app()
