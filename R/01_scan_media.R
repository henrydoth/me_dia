# R/01_scan_media.R
# Cross-platform media scanner for Mac and Windows USB/external drives
# Scans MEDIA_ROOT and writes data/index_media.csv

suppressWarnings(suppressMessages({
  if (!requireNamespace('yaml', quietly = TRUE)) stop('Please install.packages("yaml")')
  if (!requireNamespace('digest', quietly = TRUE)) stop('Please install.packages("digest")')
}))

# Detect operating system
get_os <- function() {
  if (.Platform$OS.type == "windows") {
    return("windows")
  } else if (Sys.info()["sysname"] == "Darwin") {
    return("mac")
  } else {
    return("unix")
  }
}

OS <- get_os()
message('Detected OS: ', toupper(OS))

cfg_path <- file.path('config', 'media_root.yml')
if (!file.exists(cfg_path)) {
  stop(
    'Missing config/media_root.yml (local configuration file)\n',
    'Create it by copying the example:\n',
    '  cp config/media_root.example.yml config/media_root.yml\n\n',
    'Then edit it with your USB drive path:\n',
    if (OS == "windows") '  Windows: media_root: "E:/MEDIA"\n' else '  Mac: media_root: "/Volumes/MyUSB/MEDIA"\n'
  )
}

cfg <- yaml::read_yaml(cfg_path)
MEDIA_ROOT <- cfg$media_root

# Validate media_root configuration
if (is.null(MEDIA_ROOT) || MEDIA_ROOT == "CHANGE_ME") {
  stop(
    'Please configure media_root in config/media_root.yml\n',
    if (OS == "windows") {
      '  Windows example: media_root: "E:/MEDIA"\n'
    } else if (OS == "mac") {
      '  Mac example: media_root: "/Volumes/MyUSB/MEDIA"\n'
    } else {
      '  Example: media_root: "/mnt/usb/MEDIA"\n'
    },
    '\nAvailable drives/volumes:\n',
    if (OS == "windows") {
      paste0('  ', paste(list.files('/', pattern = '^[A-Z]:$', full.names = TRUE), collapse = ', '))
    } else if (OS == "mac") {
      paste0('  ', paste(list.files('/Volumes/', full.names = TRUE), collapse = '\n  '))
    } else {
      '  Check /mnt or /media directories'
    }
  )
}

if (!dir.exists(MEDIA_ROOT)) {
  stop(
    'media_root path not found: ', MEDIA_ROOT, '\n',
    'Please verify:\n',
    '  1. USB/External drive is connected\n',
    '  2. Path in config/media_root.yml is correct\n',
    if (OS == "windows") {
      '  3. Check available drives in File Explorer (E:, F:, etc.)\n'
    } else if (OS == "mac") {
      '  4. Run: ls /Volumes/ to see mounted drives\n'
    }
  )
}

message('✅ Media root found: ', MEDIA_ROOT)

MEDIA_DIRS <- c('mp_4','mp_3','pic_ture','r_m_d')
ext_map <- list(
  mp_4     = c('mp4','mkv','mov','avi'),
  mp_3     = c('mp3','wav','flac'),
  pic_ture = c('jpg','jpeg','png','heic','tif','tiff'),
  r_m_d    = c('pdf','docx','xlsx','pptx','zip','rar','7z','raw','txt')
)

message('Required folder structure in MEDIA_ROOT:')
for (d in MEDIA_DIRS) {
  path <- file.path(MEDIA_ROOT, d)
  status <- if (dir.exists(path)) '✓' else '✗ MISSING'
  message('  ', status, ' ', d, '/')
}

get_ext <- function(x) tolower(sub('.*\\.', '', x))

md5_file <- function(path) digest::digest(file = path, algo = 'md5')

scan_one <- function(subdir) {
  root <- file.path(MEDIA_ROOT, subdir)
  if (!dir.exists(root)) {
    message('[skip] missing folder: ', root)
    return(NULL)
  }
  files <- list.files(root, recursive = TRUE, full.names = TRUE, include.dirs = FALSE)
  if (length(files) == 0) return(NULL)

  ext <- get_ext(files)
  keep <- ext %in% ext_map[[subdir]]
  files <- files[keep]
  ext <- ext[keep]
  if (length(files) == 0) return(NULL)

  info <- file.info(files)

  # normalize paths for portability
  abs_path <- gsub('\\\\', '/', normalizePath(files, winslash = '/'))
  base_root <- gsub('\\\\', '/', normalizePath(MEDIA_ROOT, winslash = '/'))
  rel_path <- sub(paste0('^', base_root, '/?'), '', abs_path)

  df <- data.frame(
    category = subdir,
    rel_path = rel_path,
    abs_path = abs_path,
    ext      = ext,
    size     = as.numeric(info$size),
    size_mb  = round(as.numeric(info$size) / 1024^2, 2),
    mtime    = as.character(info$mtime),
    stringsAsFactors = FALSE
  )

  message('Hashing md5: ', subdir, ' (n=', nrow(df), ') ...')
  df$md5 <- vapply(df$abs_path, md5_file, character(1))
  df
}

df <- do.call(rbind, lapply(MEDIA_DIRS, scan_one))
if (is.null(df) || nrow(df) == 0) {
  stop(
    'No media files found!\n',
    'Please check:\n',
    '  1. Required folders exist in MEDIA_ROOT: mp_4/, mp_3/, pic_ture/, r_m_d/\n',
    '  2. Files have supported extensions\n',
    '  3. Current MEDIA_ROOT: ', MEDIA_ROOT, '\n'
  )
}

# Create data directory if it doesn't exist
if (!dir.exists('data')) {
  dir.create('data', recursive = TRUE)
  message('Created data/ directory')
}

out <- file.path('data', 'index_media.csv')
write.csv(df, out, row.names = FALSE, fileEncoding = 'UTF-8')
message('✅ Index complete!')
message('   Written to: ', out)
message('   Total files: ', nrow(df))
message('   Total size: ', round(sum(df$size) / 1024^3, 2), ' GB')
message('')
message('File breakdown:')
tbl <- table(df$category)
for (cat in names(tbl)) {
  message('  ', cat, ': ', tbl[cat], ' files')
}
