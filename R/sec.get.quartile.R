#' Get by-quartile data from the SEC market structure website.
#' 
#' As of this date, only three quarters are available, Q4 2012 
#'   to Q2 2013.
#' 
#' @export
#' @example
#'   dt <- sec.get.quartile()
#'   head(dt); tail(dt)
sec.get.quartile <- function() {

  # Download the file
  dt_url <- paste0("http://www.sec.gov/marketstructure/downloads/",
    "2013-q2/metrics_by_decile_quartile.zip")
  temp <- tempfile()
  download.file(dt_url, destfile = temp, method="curl")

  # Metrics / files to load
  files <- c("Quartile_Cancel_to_Trade_ETP", "Quartile_Hidden_Rate_ETP", 
    "Quartile_Hidden_Volume_ETP", "Quartile_Oddlot_Rate_ETP", 
    "Quartile_Oddlot_Volume_ETP", "Quartile_Trade_Volume_ETP")

  # Iterate over files
  dt <- do.call("rbind", lapply(files, function(f) { 
    
    # Unzip and get the (partial) data into a temporary file
    dtp <- read.csv(unz(temp, paste0("data/", f, ".csv")))
      
    # Lowercase column names
    colnames(dtp) <- tolower(colnames(dtp))

    # Add a file name marker
    dtp$type <- f

    dtp
  }))

  # Clean up the temp file
  file.remove(temp)

  dt
}
