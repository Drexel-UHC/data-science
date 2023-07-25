#' Unprocessed imports from Census 


{ # Place ------------------------------------------------------------
  
  ## Raw
  sf_place_raw = etl$xwalk_state$state_abbr %>% purrr::map_df( ~ tigris::places(year = year_tmp, state = .x))
  df_place_raw = sf_place_raw %>% as.data.frame() %>% select(-geometry) %>% as_tibble()
  
  ## Simplified 
  sf_place_simp =  etl$xwalk_state$state_abbr %>% 
    purrr::map_df( ~ tigris::places(year = year_tmp, state = .x) %>%  
                     rmapshaper::ms_simplify(keep = 0.05))

  
  ## Exports
  sf_place_raw %>% geoarrow::write_geoparquet("code/spatial/processed/sf_place_raw.parquet")
  sf_place_simp %>% geoarrow::write_geoparquet("code/spatial/processed/sf_place_simp.parquet")
  df_place_raw %>% arrow::write_parquet("code/spatial/processed/df_place_raw.parquet")
  cli::cli_alert_success("Census Place imports done!")
}


{ # County ------------------------------------------------------------
  
  ## Raw
  sf_county_raw = tigris::counties()
  df_county_raw = sf_county_raw %>% as.data.frame() %>% select(-geometry) %>% as_tibble()
  
  ## Simplified 
  sf_county_simp =  sf_county_raw %>%  rmapshaper::ms_simplify(keep = 0.05)
  
  ## Exports
  sf_county_raw %>% geoarrow::write_geoparquet("code/spatial/processed/sf_county_raw.parquet")
  sf_county_simp %>% geoarrow::write_geoparquet("code/spatial/processed/sf_county_simp.parquet")
  df_county_raw %>% arrow::write_parquet("code/spatial/processed/df_county_raw.parquet")
  
  cli::cli_alert_success("County imports done!")
  
} 
{ # EDA ---------------------------------------------------------------------
  
  tigris_places %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()  
  
}