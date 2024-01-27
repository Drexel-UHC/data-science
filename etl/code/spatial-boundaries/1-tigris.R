{ # Setup -------------------------------------------------------------------

  ## Local Objects
  place_years = c(2017, 2019, 2020)
  tract_years = c(2010)
  zcta_years = c(2010)
  county_years = c(2010)
  state_years = c(2010, 2020)
  # geo_tmp = 'zcta'
  # year_tmp = 2010
   
  get_census_boundaries = function(etl, year_tmp, geo_tmp, overwrite = F ){
     
    ## Setup
    out_file = glue::glue("clean/spatial/cartographic boundaries/{geo_tmp}_{year_tmp}")
    out_rds_file = glue::glue("{out_file}.rds") 
    is__already_written = file.exists(out_rds_file) 
    
    if (is__already_written && overwrite == F){
      cli::cli_alert_success("Census {geo_tmp} {year_tmp} already written; no overwrite!")
      return()
    }
    cli_alert("Started: Census {geo_tmp} {year_tmp}")
 
    ## Simplified boundaries
    if (geo_tmp == 'state'){
      sf_simp_raw = tigris::states(year = year_tmp) %>%  
        rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE, sys = TRUE) %>% 
        st_cast(., "MULTIPOLYGON") %>% 
        st_make_valid(.)
    } else if ( geo_tmp == 'place') {
      sf_simp_raw =  etl$xwalk_state$state_abbr %>% 
        purrr::map_df( ~ tigris::places(year = year_tmp, state = .x) %>%  
                         rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE, sys = TRUE) %>% 
                         st_cast(., "MULTIPOLYGON") %>% 
                         st_make_valid(.)) 
    } else if (geo_tmp == 'county'){
      sf_simp_raw =  etl$xwalk_state$state_abbr %>% 
        purrr::map_df( ~ tigris::counties(year = year_tmp, state = .x) %>%  
                         rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE, sys = TRUE) %>% 
                         st_cast(., "MULTIPOLYGON") %>% 
                         st_make_valid(.)) 
    } else if (geo_tmp == 'zcta'){
      sf_simp_raw =  etl$xwalk_state$state_abbr %>% 
        purrr::map_df( ~ tigris::zctas(year = year_tmp, state = .x) %>%  
                         rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE, sys = TRUE) %>% 
                         st_cast(., "MULTIPOLYGON") %>% 
                         st_make_valid(.)) 
    } else if (geo_tmp == 'tract'){
      sf_simp_raw =  etl$xwalk_state$state_abbr %>% 
        purrr::map_df( ~ tigris::tracts(year = year_tmp, state = .x) %>%  
                         rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE, sys = TRUE) %>% 
                         st_cast(., "MULTIPOLYGON") %>% 
                         st_make_valid(.)) 
    } 
    
    
    if ('GEOID10'%in%names(sf_simp_raw)) sf_simp_raw = sf_simp_raw %>% rename(GEOID = GEOID10)
    if ('GEOID20'%in%names(sf_simp_raw)) sf_simp_raw = sf_simp_raw %>% rename(GEOID = GEOID20)
    cli_alert_info('sf_simp_raw imported!')
    
    ## Subset to boundaries
    sf_simp = sf_simp_raw %>% 
      select(GEOID)
    
    ## Exports
    sf_simp_raw  %>% 
      st_cast(., "MULTIPOLYGON") %>% 
      st_make_valid(.) %>% 
      saveRDS(out_rds_file)
    cli::cli_alert_success("Census {geo_tmp} {year_tmp} imports done!")
  }
  safe_get_census_boundaries <- safely(get_census_boundaries)
}





{ # County ------------------------------------------------------------
  
  county_years %>% 
    walk(~safe_get_census_boundaries(etl, 
                                     year_tmp = .x, 
                                     geo_tmp = 'county'))
  
}

{ # ZCTA ------------------------------------------------------------
  
  zcta_years %>% 
    walk(~safe_get_census_boundaries(etl, 
                                     year_tmp = .x, 
                                     geo_tmp = 'zcta'))
  
}

{ # Tract ------------------------------------------------------------
  
  tract_years %>% 
    walk(~safe_get_census_boundaries(etl, 
                                     year_tmp = .x, 
                                     geo_tmp = 'tract'))
  
}

{ # Place ------------------------------------------------------------
  
  place_years %>% 
    walk(~safe_get_census_boundaries(etl, 
                                     year_tmp = .x, 
                                     geo_tmp = 'place'))
 
}

{ # State ------------------------------------------------------------
  
  state_years %>% 
    walk(~safe_get_census_boundaries(etl, 
                                     year_tmp = .x, 
                                     geo_tmp = 'state'))
  
}

{ # EDA ---------------------------------------------------------------------
  
  sf_tract = readRDS("clean/spatial/cartographic boundaries/tract_2010.rds")
  sf_zcta = readRDS("clean/spatial//cartographic boundaries/zcta_2010.rds")
  tigris_places %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()  
  
}