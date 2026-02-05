# R/scan_media.R
scan_media <- function() {
  wd <- getwd()
  on.exit(setwd(wd), add = TRUE)
  # assume running from project root
  source("R/01_scan_media.R", local = .GlobalEnv)
  invisible(TRUE)
}
