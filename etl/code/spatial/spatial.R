#' ETL spatial boundaries
{ # Setup -------------------------------------------------------------------
  
  ## Seed: Pull boundaries from Census
  "code/spatial/1-tigris.R"
  census = lst(
    df_place_raw = arrow::read_parquet("code/spatial/processed/df_place_raw.parquet"),
    df_county_raw = arrow::read_parquet("code/spatial/processed/df_county_raw.parquet"),
    sf_place = geoarrow::read_geoparquet_sf("code/spatial/processed/sf_place_simp.parquet"),
    sf_county = geoarrow::read_geoparquet_sf("code/spatial/processed/sf_county_simp.parquet"),
  )
  
  ## Local objects
  year_tmp = 2020
  
  ## 2020 population to calculate density
  df_pop_2020 = etl$df_demographics %>% 
    filter(year == 2020) %>% 
    select(geoid, pop)
  
}

{ # Place ------------------------------------------------------------

  ## Metadata
  df_place = census$df_place_raw %>%
    mutate(geo = 'place') %>% 
    select(geo,
           geoid = GEOID,
           state_fip = STATEFP,
           place_fip = PLACEFP,
           place_name = NAME,
           aland_m2 = ALAND,
           lat = INTPTLAT,
           lon = INTPTLON) %>% 
    left_join(df_pop_2020) %>% 
    mutate(aland_km2 = aland_m2/10^6,
           aland_mile2 =  aland_km2 / 2.58999,
           pop_dens = pop/aland_mile2) %>% 
    left_join(etl$xwalk_state %>% 
                select(state_fip, region_name, division_name))
  
  
  ## Boundaries
  sf_place =  census$sf_place %>% 
    select(geoid = GEOID) %>% 
    left_join(df_place)
 
  ## Export
  sf_place %>% geoarrow::write_geoparquet("clean/boundaries/place.parquet")
  sf_place %>% geojsonio::topojson_write(file  = "clean/boundaries/place.topojson")
  sf_place %>% geojsonio::geojson_write(file = "clean/boundaries/place.json")
  cli_alert_success("County spatial exports done")
}

{ # County ------------------------------------------------------------
  
  ## Metadata
  df_county = census$df_county_raw %>%
    mutate(geo = 'county') %>% 
    select(geo,
           geoid = GEOID,
           state_fip = STATEFP,
           county_fip = COUNTYFP,
           county_name = NAME,
           aland_m2 = ALAND,
           lat = INTPTLAT,
           lon = INTPTLON) %>% 
    left_join(df_pop_2020) %>% 
    mutate(aland_km2 = aland_m2/10^6,
           aland_mile2 =  aland_km2 / 2.58999,
           pop_dens = pop/aland_mile2) %>% 
    left_join(etl$xwalk_state %>% 
                select(state_fip, region_name, division_name))
  
  
  ## Boundaries
  sf_county =  census$sf_county %>% 
    select(geoid = GEOID) %>% 
    left_join(df_county)
  
  ## Export
  sf_county %>% geoarrow::write_geoparquet("clean/boundaries/county.parquet")
  sf_county %>% geojsonio::topojson_write(file  = "clean/boundaries/county.topojson")
  sf_county %>% geojsonio::geojson_write(file = "clean/boundaries/county.json")
  sf_county %>% sf::st_write("clean/boundaries/county.shp")
  cli_alert_success("County spatial exports done")
}



{ # EDA ---------------------------------------------------------------------
  

  sf_place %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()  
  
}