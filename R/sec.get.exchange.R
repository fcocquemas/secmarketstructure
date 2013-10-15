#' Get by-exchange data from the SEC market structure website.
#' 
#' As of this date, only three quarters are available, Q4 2012 
#'   to Q2 2013.
#' 
#' @export
#' @example
#'   dt <- sec.get.security()
#'   str(dt)
sec.get.exchange <- function() {

  # Download the file
  dt_url <- paste0("http://www.sec.gov/marketstructure/downloads/",
    "2013-q2/metrics_by_exchange.zip")
  temp <- tempfile()
  download.file(dt_url, destfile = temp, method="curl")

  # Metrics / files to load
  files <- c("ETP_Cancel_to_Trade", "ETP_Hidden_Rate", "ETP_Hidden_Volume", 
    "ETP_Oddlot_Rate", "ETP_Oddlot_Volume", "ETP_Stock_Timeseries", 
    "ETP_Trade_Volume", "Stock_Cancel_to_Trade", "Stock_Hidden_Rate", 
    "Stock_Hidden_Volume", "Stock_Oddlot_Rate", "Stock_Oddlot_Volume", 
    "Stock_Trade_Volume")

  # Iterate over files
  dt <- lapply(files, function(f) { 
    
    # Unzip and get the (partial) data into a temporary file
    dtp <- read.csv(unz(temp, paste0("data/", f, ".csv")))
      
    # Lowercase column names
    colnames(dtp) <- tolower(colnames(dtp))

    dtp
  })
  
  names(dt) <- files
  
  # Clean up the temp file
  file.remove(temp)

  dt
}


