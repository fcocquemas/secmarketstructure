#' Get data from the SEC market structure website.
#'
#' By default, tries to retrieve all available dates (which is
#'   around 30MB per quarter for individual securities, 15 MB
#'   for hazards, 11 MB for conditional frequency distribution).
#' 
#' As of this date, only three quarters are available, Q4 2012 
#'   to Q2 2013.
#' 
#' @param by.type character vector, one of "security", "exchange", 
#'   "decile", "quartile", "condfreq", "hazard" or "survival".
#'   Defaults to "security".
#' @param year.quarter character vector of the year-quarter to
#'   retrieve, NULL for all. Examples could be "2013.Q1" or
#'   c("2012.Q4", "2013.Q2").
#' @export
#' @example
#'   dt <- sec.get("hazard")
#'   head(dt); tail(dt)
sec.get <- function(by.type = "security", year.quarter = NULL) {

  dt <- switch(by.type,
    security = sec.get.security(year.quarter),
    exchange = sec.get.exchange(),
    decile = sec.get.decile(),
    quartile = sec.get.quartile(),
    condfreq = sec.get.condfreq(year.quarter),
    hazard = sec.get.hazard(year.quarter),
    survival = sec.get.survival(year.quarter)
    )

  dt
}

