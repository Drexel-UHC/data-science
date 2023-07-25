#' Crosswalks   

{ # State -------------------------------------------------------------------
  walk_state_fip = read.csv('https://gist.githubusercontent.com/dantonnoriega/bf1acd2290e15b91e6710b6fd3be0a53/raw/11d15233327c8080c9646c7e1f23052659db251d/us-state-ansi-fips.csv') %>% 
    as_tibble() %>% 
    mutate(state_code = str_trim(stusps),
           statefp = str_pad(st, width = 2, side = 'left', pad = '0' )) %>% 
    select(state_code, statefp)
  
  xwalk_state = read.csv('https://raw.githubusercontent.com/cphalpert/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv') %>% 
    as_tibble() %>% 
    janitor::clean_names() %>% 
    left_join(walk_state_fip) %>% 
    select(state_name = state, 
           state_fip = statefp, 
           state_abbr = state_code, 
           region_name = region, 
           division_name = division)
  
  xwalk_state %>% arrow::write_parquet("clean/xwalk_state.parquet")
}
