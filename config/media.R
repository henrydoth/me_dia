# config/media.R
# -------------------------------------------------
# USB-based MEDIA root, cross-platform friendly.
# - Prefer environment variable MEDIA_ROOT if set.
# - Otherwise use symlink folder "MEDIA" in project root.

media_root <- Sys.getenv(
  "MEDIA_ROOT",
  unset = normalizePath("MEDIA", mustWork = FALSE)
)

if (!dir.exists(media_root)) {
  stop("MEDIA root not found: ", media_root)
}

message("MEDIA root: ", media_root)
