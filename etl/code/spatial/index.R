{ # Dependencies -------------------------------------------------------------------

  library(dplyr)
  library(sf)
  library(rmapshaper)
  library(tigris)
  library(geoarrow)
  library(arrow)
  library(stringr)
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



{ # Seeds -------------------------------------------------------------------

  { # State -------------------------------------------------------------------
    walk_state_fip = read.csv('https://gist.githubusercontent.com/dantonnoriega/bf1acd2290e15b91e6710b6fd3be0a53/raw/11d15233327c8080c9646c7e1f23052659db251d/us-state-ansi-fips.csv') %>% 
      as_tibble() %>% 
      mutate(state_code = str_trim(stusps),
             statefp = str_pad(st, width = 2, side = 'left', pad = '0' )) %>% 
      select(state_code, statefp)
    
    df_state = read.csv('https://raw.githubusercontent.com/cphalpert/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv') %>% 
      as_tibble() %>% 
      janitor::clean_names() %>% 
      left_join(walk_state_fip) %>% 
      select(state, statefp, state_code, region, division)
    
    df_state %>% arrow::write_parquet("../spatial/df_state.parquet")
  }
  
}

{ # Tigris Pull -----------------------------------------------------------------
  
  ## States
  tigris_states = tigris::states()
  
  ## Place
  tigris_places <- tigris_states$STUSPS[1:3] %>% 
    purrr::map_df(~tigris::places(year = 2021, state = .x))
  # tigris_places_simp =  tigris_places %>%  rmapshaper::ms_simplify(keep = 0.05)
  tigris_places %>% geoarrow::write_geoparquet('code/spatial/processed/tigris_places.parquet')
  # tigris_places_simp %>% geoarrow::write_geoparquet('code/spatial/processed/tigris_places_simp.parquet')
  
  ## County
  tigris_counties <- tigris::counties()
  tigris_counties_simp =  tigris_counties %>%  rmapshaper::ms_simplify(keep = 0.05)
  tigris_counties %>% geoarrow::write_geoparquet('code/spatial/processed/tigris_counties.parquet')
  tigris_counties_simp %>% geoarrow::write_geoparquet('code/spatial/processed/tigris_counties_simp.parquet')
  

  }