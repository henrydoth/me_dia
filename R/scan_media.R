# R/scan_media.R
scan_media <- function() {
  # always reload MEDIA root (avoid stale session)
  source("config/media.R", local = .GlobalEnv)
  source("R/01_scan_media.R", local = .GlobalEnv)
  invisible(TRUE)
}
