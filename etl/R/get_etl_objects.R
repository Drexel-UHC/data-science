#' Get etl objects

get_etl_objects = function(){
  
  { # Crosswalks --------------------------------------------------------------
    lst__xwalk = lst(
      xwalk_state = arrow::read_parquet("clean/xwalk_state.parquet")
    )
    
  }
  
  { # Boundaries --------------------------------------------------------------

    
  }
  
  { # Demographics ------------------------------------------------------------
   
    lst__demo = lst(
      df_demographics = arrow::read_parquet("clean/df_demographics.parquet")
    )
    
  }
  
  { # Final -------------------------------------------------------------------
   
    etl = c(
      lst__xwalk,
      lst__demo
    )
    
    return(etl)
  }
  
}