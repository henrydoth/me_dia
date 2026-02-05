# R/01_scan_media.R
# Scan MEDIA_ROOT (USB/External) and write data/index_media.csv

suppressWarnings(suppressMessages({
  if (!requireNamespace('digest', quietly = TRUE)) stop('Please install.packages("digest")')
}))

source("config/media.R")
MEDIA_ROOT <- media_root

MEDIA_DIRS <- c('video','audio','image','raw','export')
ext_map <- list(
  video  = c('mp4','mkv','mov','avi'),
  audio  = c('mp3','wav','flac'),
  image  = c('jpg','jpeg','png','heic','tif','tiff'),
  raw    = c('pdf','docx','xlsx','pptx','zip','rar','7z','raw','txt'),
  export = c('pdf','docx','xlsx','pptx','zip','rar','7z','raw','txt')
)

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
  message('⚠️ No files found yet (folders are empty). Creating empty index.')
  df <- data.frame(
    category = character(),
    rel_path = character(),
    abs_path = character(),
    ext      = character(),
    size     = double(),
    size_mb  = double(),
    mtime    = character(),
    md5      = character(),
    stringsAsFactors = FALSE
  )
}

out <- file.path('data', 'index_media.csv')
write.csv(df, out, row.names = FALSE, fileEncoding = 'UTF-8')
message('✅ Wrote: ', out, ' | n=', nrow(df))
