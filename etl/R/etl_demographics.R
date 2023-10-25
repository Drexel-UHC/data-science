#' this funciton will use used to pull and format cenus data for our demographics seeds
#' 
#' Examples:
#'    geo_tmp = 'state'
#'    geo_tmp = 'place'
#'    

etl_demographics = function(geo_tmp,
                            list__variables,
                            vec__years){
  dfa = vec__years %>% 
    purrr::map_df(
      function(year_tmp){
        tidycensus::get_acs(geography = geo_tmp, 
                            variables = list__variables,
                            year = year_tmp) %>% 
          janitor::clean_names() %>% 
          select(-any_of(c('moe','name'))) %>% 
          tidyr::pivot_wider(names_from = 'variable', values_from = 'estimate') %>% 
          mutate(year = year_tmp,
                 geo = geo_tmp) %>% 
          select(geo, geoid, year, everything())
      })
  
  df_clean = dfa %>% 
    mutate( pct_hisp = race_hisp/race_total,
            pct_black = race_black/race_total,
            pct_nhwhite = race_nhw/race_total,
            pct_female = sex_female/pop,
            pct_male = (pop-sex_female)/pop) %>% 
    select(geo, geoid, year, pop, contains('pct_') )

  
  return(df_clean)
}
