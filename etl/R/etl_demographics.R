#' this funciton will use used to pull and format cenus data for our demographics seeds
#' 
#' Examples:
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
  

  
  return(dfa)
}
