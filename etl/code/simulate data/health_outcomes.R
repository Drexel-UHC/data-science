{ # Setup -------------------------------------------------------------------
 

  
}


{ # State level -------------------------------------------------------------

  df_state_counts =  etl$df_demographics %>% 
    filter(geo == 'state') %>% 
    select(geo, geoid, year) %>% 
    mutate(dummy_hiv_case_count = rnorm(n(), mean = 500, sd = 50),
           dummy_covid_case_count = rnorm(n(), mean = 1000, sd = 50),
           dummy_covid_death_count = rnorm(n(), mean = 200, sd = 50),
           dummy_obesity_count =  rnorm(n(), mean = 1500, sd = 50),
    )%>%
    mutate(across(starts_with("dummy"), ~as.integer(round(.))))
  
  df_county_counts =  etl$df_demographics %>% 
    filter(geo == 'county') %>% 
    select(geo, geoid, year) %>% 
    mutate(dummy_hiv_case_count = rnorm(n(), mean = 50, sd = 5),
           dummy_covid_case_count = rnorm(n(), mean = 100, sd = 5),
           dummy_covid_death_count = rnorm(n(), mean = 50, sd = 5),
           dummy_obesity_count =  rnorm(n(), mean = 150, sd = 5),
    ) %>%
    mutate(across(starts_with("dummy"), ~as.integer(round(.))))
}

{ # Export ------------------------------------------------------------------

  df_dummy_health_counts = lst(
    df_county_counts,
    df_state_counts
  ) %>% 
    bind_rows()
  
  df_dummy_health_counts %>% arrow::write_parquet("clean/df_dummy_health_counts.parquet")
}