#' This script will generate the following:
#'  1. census place (> 10K or 100k?)
#'     - area in square miles (2020)
#'     - total population (1990 - 2020)
#'     - populaiton density (2020)
#'     - region
#'  2. County (PA, DE)
#'     - boundaries
#'     - populaiton density
#'     - median age
#'    

{ # Dependencies -------------------------------------------------------------------
  
  library(dplyr)
  library(sf)
  library(rmapshaper)
  library(tigris)
  library(geoarrow)
  library(arrow)
  library(leaflet)
  library(tidycensus)
  
  
}
{ # Dependencies -------------------------------------------------------------------

  library(dplyr)
  library(sf)
  library(rmapshaper)
  library(tigris)
  library(geoarrow)
  library(arrow)
  library(leaflet)
  
  'code/spatial/index.R'
  'code/spatial/place.R'
  'code/spatial/zcta.R'
  'code/spatial/zcta.R'
  'code/spatial/zcta.R'
  
  tigris_places %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()
}

{ # Census Place ------------------------------------------------------------
  #'  1. census place 
  #'     - total population (1990 - 2020)
  #'     - area in square miles (2020)
  #'     - populaiton density
  #'     - region
  
  ## Population
  df_place_pop = 2009:2020 %>% 
    purrr::map_df(
      function(year_tmp){
        tidycensus::get_acs(geography = 'place', 
                            variables = "B01003_001",
                            year = year_tmp) %>% 
          janitor::clean_names() %>% 
          mutate(year = year_tmp) %>% 
          select(geoid, year, pop = estimate)
    })
  
  ## Area
  sf_place = geoarrow::read_geoparquet_sf("code/spatial/processed/tigris_places.parquet")
  df_place_area = sf_place %>% 
    as_data_frame() %>% 
    janitor::clean_names() %>% 
    mutate(area_sq_mile = aland/2589988) %>% 
    select( name, statefp, placefp, geoid, intptlat, intptlon, aland, area_sq_mile) 
    
}
