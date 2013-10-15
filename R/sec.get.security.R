#' Get by-security data from the SEC market structure website.
#'
#' By default, tries to retrieve all available dates (which is
#'   around 30MB per quarter for individual securities).
#' 
#' As of this date, only three quarters are available, Q4 2012 
#'   to Q2 2013.
#' 
#' @param year.quarter character vector of the year-quarter to
#'   retrieve, NULL for all. Examples could be "2013.Q1" or
#'   c("2012.Q4", "2013.Q2").
#' @export
#' @example
#'   dt <- sec.get.security()
#'   head(dt); tail(dt)
sec.get.security <- function(year.quarter = NULL) {

  # If no year.quarter, retrieve all dates (hardcoded for now)
  if(is.null(year.quarter)) 
    year.quarter <- c("2012.Q4", "2013.Q1", "2013.Q2")

  # Iterate over quarters
  dt <- do.call("rbind", lapply(year.quarter, function(yq) { 
    
    # Separate year and quarter
    yq <- unlist(strsplit(tolower(yq), split="\\."))

    # Get the (partial) data into a temporary file
    dtp_url <- paste0("http://www.sec.gov/marketstructure/downloads/",
      yq[1], "-", yq[2], "/ma_data_", yq[1], "_", yq[2], ".csv")
    temp <- tempfile()
    download.file(dtp_url, destfile = temp, method="curl")
    
    # Read the file
    dtp <- read.csv(temp)

    # Change the column names for more consistency
    colnames(dtp) <- c("ticker", "date", "security", 
      "mcap.rank", "turn.rank", "volatility.rank", "price.rank",
      "cancels", "trades", "lit.trades", "odd.lots", "hidden",
      "trades.for.hidden", "order.vol", "trade.vol", "lit.vol",
      "odd.lot.vol", "hidden.vol", "trade.vol.for.hidden")

    # Multiply by 1000 fields expressed in '000 
    # (they have three decimals anyway...)
    dtp$order.vol <- dtp$order.vol * 1000
    dtp$trade.vol <- dtp$trade.vol * 1000
    dtp$lit.vol <- dtp$lit.vol * 1000
    dtp$odd.lot.vol <- dtp$odd.lot.vol * 1000
    dtp$hidden.vol <- dtp$hidden.vol * 1000
    dtp$trade.vol.for.hidden <- dtp$trade.vol.for.hidden * 1000

    # Clean up the temp file
    file.remove(temp)

    dtp
  }))
}


