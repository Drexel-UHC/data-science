#' This script will generate the following:
#'  1. census place (> 10K or 100k?)
#'     - area in square miles (2020)
#'     - total population (1990 - 2020)
#'     - population density (2020)
#'     - region
#'  2. County (PA, DE)
#'     - boundaries
#'     - population density
#'     - median age



{ # Census Place ------------------------------------------------------------
  #'  1. census place 
  #'     - total population (1990 - 2020)
  #'     - area in square miles (2020)
  #'     - populaiton density
  #'     - region
  
  ## Population
 
  
  ## Area
  sf_place = geoarrow::read_geoparquet_sf("code/spatial/processed/tigris_places.parquet")
  df_place_area = sf_place %>% 
    as_data_frame() %>% 
    janitor::clean_names() %>% 
    mutate(area_sq_mile = aland/2589988) %>% 
    select( name, statefp, placefp, geoid, intptlat, intptlon, aland, area_sq_mile) 
    
}
