#' Basic demongraphics or census data at various levels for (2009:2020).
   

{ # Parameters -------------------------------------------------------------------
  
  list__variables = lst(
    pop = "B01003_001",
    median_age = "B01002_001"
  )
  
  vec__years = 2009:2020
  
}

{ # Pulls -------------------------------------------------------------------
  df_place = etl_demographics('place', list__variables, vec__years)
  df_county = etl_demographics('county', list__variables, vec__years)
}


{ # Export ------------------------------------------------------------------
  df_demographics = list(
    df_place,
    df_county
  ) %>% 
    bind_rows()
  df_demographics %>% arrow::write_parquet("clean/df_demographics.parquet")
  cli::cli_alert_success('Demographics seeds generated!')
}
