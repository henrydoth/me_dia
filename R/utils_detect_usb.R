# R/utils_detect_usb.R
# Utility functions to detect USB drives on Mac and Windows

#' Detect operating system
#' @return Character: "windows", "mac", or "unix"
get_os <- function() {
  if (.Platform$OS.type == "windows") {
    return("windows")
  } else if (Sys.info()["sysname"] == "Darwin") {
    return("mac")
  } else {
    return("unix")
  }
}

#' List available drives/volumes
#' @return Character vector of available paths
list_drives <- function() {
  os <- get_os()
  
  if (os == "windows") {
    # Windows: List available drive letters
    drives <- c()
    for (letter in LETTERS) {
      drive_path <- paste0(letter, ":/")
      if (dir.exists(drive_path)) {
        drives <- c(drives, drive_path)
      }
    }
    return(drives)
    
  } else if (os == "mac") {
    # Mac: List volumes
    vol_dir <- "/Volumes"
    if (dir.exists(vol_dir)) {
      vols <- list.files(vol_dir, full.names = TRUE)
      return(vols)
    }
    return(character(0))
    
  } else {
    # Linux/Unix: Common mount points
    paths <- c("/mnt", "/media")
    existing <- paths[sapply(paths, dir.exists)]
    if (length(existing) > 0) {
      all_mounts <- unlist(lapply(existing, function(p) {
        list.files(p, full.names = TRUE)
      }))
      return(all_mounts)
    }
    return(character(0))
  }
}

#' Find USB drives with MEDIA folder structure
#' @return Data frame with path, folders_found, and status
find_media_usb <- function() {
  drives <- list_drives()
  if (length(drives) == 0) {
    message('No drives/volumes found')
    return(NULL)
  }
  
  required_folders <- c('mp_4', 'mp_3', 'pic_ture', 'r_m_d')
  results <- list()
  
  for (drive in drives) {
    # Check if MEDIA folder exists
    media_path <- file.path(drive, 'MEDIA')
    if (dir.exists(media_path)) {
      folders_exist <- sapply(required_folders, function(f) {
        dir.exists(file.path(media_path, f))
      })
      results[[length(results) + 1]] <- list(
        path = media_path,
        has_mp_4 = folders_exist['mp_4'],
        has_mp_3 = folders_exist['mp_3'],
        has_pic_ture = folders_exist['pic_ture'],
        has_r_m_d = folders_exist['r_m_d'],
        all_folders = all(folders_exist)
      )
    }
  }
  
  if (length(results) == 0) {
    message('No MEDIA folders found on available drives')
    return(NULL)
  }
  
  do.call(rbind, lapply(results, as.data.frame))
}

#' Print current drives/volumes
show_drives <- function() {
  os <- get_os()
  message('Operating System: ', toupper(os), '\n')
  
  drives <- list_drives()
  if (length(drives) == 0) {
    message('No drives/volumes detected')
    return(invisible(NULL))
  }
  
  message('Available drives/volumes:')
  for (d in drives) {
    # Check if it's likely a USB (heuristic)
    is_likely_usb <- if (os == "mac") {
      !grepl("Macintosh HD", d, ignore.case = TRUE)
    } else if (os == "windows") {
      # On Windows, C: is usually system drive
      !grepl("^C:", d, ignore.case = TRUE)
    } else {
      TRUE
    }
    
    usb_marker <- if (is_likely_usb) ' 💾' else ''
    message('  ', d, usb_marker)
  }
  
  message('\nLooking for MEDIA folders...')
  media_drives <- find_media_usb()
  if (!is.null(media_drives)) {
    message('\nFound MEDIA folders:')
    for (i in seq_len(nrow(media_drives))) {
      row <- media_drives[i, ]
      status <- if (row$all_folders) '✅ Complete' else '⚠️  Incomplete'
      message('  ', status, ' ', row$path)
      if (!row$all_folders) {
        missing <- c(
          if (!row$has_mp_4) 'mp_4/' else NULL,
          if (!row$has_mp_3) 'mp_3/' else NULL,
          if (!row$has_pic_ture) 'pic_ture/' else NULL,
          if (!row$has_r_m_d) 'r_m_d/' else NULL
        )
        message('    Missing: ', paste(missing, collapse = ', '))
      }
    }
  }
  
  invisible(drives)
}

# If run directly, show drives
if (!interactive()) {
  show_drives()
}
