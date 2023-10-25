{ # Setup ------------------------------------------------------------
  
  { # External dependencies ---------------------------------------------------
    library(data.table)     ## Import/Export
    library(arrow)
    library(jsonlite)
    library(dplyr)          ## Functional programming
    library(stringr)
    library(purrr)
    library(sf)             ## Spatial
    library(rmapshaper)
    library(tigris)
    library(geoarrow)
    library(leaflet)
    library(geojsonio)
    library(tidycensus)     ## Others
    library(cli)
  }
   
  { ## Internal dependencies ---------------------------------------------------
    list.files(path = 'R/', all.files = T,
               recursive = T, full.names = T, 
               pattern = '.R') %>%
      c("R/source_parent.R",.) %>% 
      purrr::walk(~source(.x))
  }
  
  { ## Imports -----------------------------------------------------------------
    etl = get_etl_objects()
    cli::cli_alert_success("ETL workbench set up done!")
  }
  
}

{ # Seeds -------------------------------------------------------------------
  "code/demographics/demographics.R"
  "code/crosswalks/crosswalks.R"
  "code/spatial/spatial.R"
  "code/simulate data/health_outcomes.R"
  "code/simulate data/policy_data.R"
}


{ # Marts -------------------------------------------------------------------

  
}
