#' Get hazard data from the SEC market structure website.
#'
#' By default, tries to retrieve all available dates (which is
#'   around 15 MB for hazard, survivor, and CDF).
#' 
#' As of this date, only three quarters are available, Q4 2012 
#'   to Q2 2013.
#' 
#' @param year.quarter character vector of the year-quarter to
#'   retrieve, NULL for all. Examples could be "2013.Q1" or
#'   c("2012.Q4", "2013.Q2").
#' @export
#' @example
#'   dt <- sec.get.hazard()
#'   head(dt); tail(dt)
sec.get.hazard <- function(year.quarter = NULL) {
  # If no year.quarter, retrieve all dates (hardcoded for now)
  if(is.null(year.quarter)) 
    year.quarter <- c("2012.Q4", "2013.Q1", "2013.Q2")

  # Iterate over quarters
  dt <- do.call("rbind", lapply(year.quarter, function(yq) { 
    
    # Separate year and quarter
    yq <- unlist(strsplit(tolower(yq), split="\\."))

    # Get the (partial) data
    dtp_url <- paste0("http://www.sec.gov/marketstructure/downloads/",
      yq[1], "-", yq[2], "/hazsur_", yq[1], "_", yq[2], ".zip")
    temp <- tempfile()
    download.file(dtp_url, destfile = temp, method="curl")
    
    # Files to read
    files <- apply(expand.grid(
      c("large_", "mid_", "small_"), c("e_", "s_"), 
      c("cancelhaz1", "cancelhaz2", "tradehaz1", "tradehaz2"), 
      stringsAsFactors = FALSE), 1, function(x) { paste(x, collapse = "") })

    # Read the files into one data.frame
    dtp <- do.call("rbind", lapply(files, function(f) {
      dtpp <- read.csv(unz(temp, paste0("data/", f, ".csv")), header = FALSE)

      # Add column names
      colnames(dtpp) <- c("time_ms", "hazard")
      
      # Add a file name marker
      dtpp$type <- f
      
      dtpp
    }))

    # Clean up the temp file
    file.remove(temp)

    # Add a year and quarter marker
    dtp$year <- yq[1]
    dtp$quarter <- yq[2]

    dtp
  }))
}