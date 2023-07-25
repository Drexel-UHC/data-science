#' Some of our functions rely on other functions. This is a function
#' to help source those dependencies. 
#' 
#'    @param function_name: a string containing the function name
#' function_name = 'get_denormalized_table'
#' function_name = 'etl_export_step1'



source_parent = function(function_name){
  
  function_file = paste0(function_name,'.R')
  etl_functions = list.files('R/_renovate/')
  R_path = ifelse(function_file %in% etl_functions,'R/_renovate/','R/') 
  
  source(paste0(R_path,function_file))
}