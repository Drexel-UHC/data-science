#' Basic demongraphics or census data at various levels for (2009:2020).
   

{ # Parameters -------------------------------------------------------------------
  
  list__variables = lst(
    pop = "B01001_001",
    median_age = "B01002_001",
    #sex (total, female)
    sex_total = "B01001_001", 
    sex_female = "B01001_026", 
    #race/ethnicity (total,NH white, NH black, hispanic), 
    race_total = "B03002_001", 
    race_nhw = "B03002_003", 
    race_black = "B03002_012", 
    race_hisp = "B03002_004",
   
  )
  
  vec__years = 2009:2020
  
}

{ # Pulls -------------------------------------------------------------------
  df_state = etl_demographics('state', list__variables, vec__years)
  df_place = etl_demographics('place', list__variables, vec__years)
  df_county = etl_demographics('county', list__variables, vec__years)
}


{ # Export ------------------------------------------------------------------
  df_state %>% arrow::write_parquet("code/demographics/processed/df_state.parquet")
  df_place %>% arrow::write_parquet("code/demographics/processed/df_place.parquet")
  df_county %>% arrow::write_parquet("code/demographics/processed/df_county.parquet")
  
  df_demographics = list(
    df_state,
    df_place,
    df_county
  ) %>% 
    bind_rows()
  df_demographics %>% arrow::write_parquet("clean/df_demographics.parquet")
  cli::cli_alert_success('Demographics seeds generated!')
}
