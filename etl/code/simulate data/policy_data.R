{ # Setup -------------------------------------------------------------------

  ## import
  df_covid_policy_raw = fread("code/simulate data/raw policy/county_cases2.csv") %>% as_tibble()
  df_psl_raw = fread("code/simulate data/raw policy/psl_1.csv") %>% as_tibble()
  df_medicaid_raw = fread("code/simulate data/raw policy/medicaid_expanse_state.csv") %>% as_tibble()

  
}

{ #  County level ETL -----------------------------------------------
  
  { # Indoor Dining -----------------------------------------------------------
    df_covid_policy_raw2 = df_covid_policy_raw %>% 
      mutate(geo = 'county',
             geo_id = str_pad(FIPS, width = 5, side = 'left', pad = '0')    ) %>% 
      select(geo,
             geo_id,
             mask_start,
             stay_start) %>% 
      distinct() %>% 
      pivot_longer(cols = c('mask_start','stay_start')) %>% 
      mutate(name = name %>% str_remove('_start') %>% paste('covid',.))
    
    df_covid_policy = df_covid_policy_raw2 %>% 
      rowwise() %>% 
      mutate(
        policy_end_date = '',
        policy_description = '',
        policy_uuid = UUIDgenerate(),
        policy_details= '',
        policy_exists = '1'
        
      ) %>% 
      select(
        geo,
        geo_id ,
        policy_uuid,
        policy_name = name,
        policy_description,
        policy_details,
        policy_exists,
        policy_start_dat= value,
        policy_end_date
      )%>%
      mutate(across(everything(), as.character))
    
      
    
  }
}
{ #  State level ETL -----------------------------------------------
  

  { #  Paid Sick Leave -----------------------------------------------
    
    df_psl = df_psl_raw %>% 
      rowwise() %>% 
      mutate(geo = 'state',
             policy_start_date = '',
             policy_end_date = '',
             policy_uuid = UUIDgenerate()
      ) %>% 
      select(
        geo,
        geo_id = state_fips,
        policy_uuid,
        policy_name = topic,
        policy_description = policy_details,
        policy_details = comments,
        policy_exists = value_num,
        policy_start_date,
        policy_end_date
      )%>%
      mutate(across(everything(), as.character))
    
    
  }
  
  
  { #  Medicaid -----------------------------------------------
    
    df_medicaid = df_medicaid_raw %>% 
      rowwise() %>% 
      mutate(geo = 'state',
             policy_end_date = '',
             policy_start_date = date_effective %>% as.character(),
             policy_uuid = UUIDgenerate()
      ) %>% 
      select(
        geo,
        geo_id = state_fips,
        policy_uuid,
        policy_name = topic,
        policy_description = policy_details,
        policy_details = comments,
        policy_exists = policy_value,
        policy_start_date,
        policy_end_date
      )  %>%
      mutate(across(everything(), as.character))
    
  }
  
}

{ # Export ------------------------------------------------------------------

  df_policy = lst(
    df_covid_policy,
    df_psl,
    df_medicaid
  ) %>% 
    bind_rows()
  
  df_policy %>% write_parquet("clean/df_dummy_policy.parquet")
}
