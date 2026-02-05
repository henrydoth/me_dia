# R/00_setup.R
# Initial setup script for me_dia project
# Run this once to configure the project

message('=== me_dia Setup ===\n')

# Check required packages
check_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message('📦 Installing package: ', pkg)
    install.packages(pkg)
  } else {
    message('✅ Package already installed: ', pkg)
  }
}

message('Checking R packages...')
check_package('yaml')
check_package('digest')

# Check for config file
cfg_path <- 'config/media_root.yml'
if (!file.exists(cfg_path)) {
  message('\n📝 Creating config/media_root.yml...')
  file.copy('config/media_root.example.yml', cfg_path)
  message('✅ Created config/media_root.yml')
  message('')
  message('⚠️  IMPORTANT: Edit config/media_root.yml with your USB drive path!')
  message('')
  
  # Detect OS and give appropriate instructions
  if (.Platform$OS.type == "windows") {
    message('Windows: Set media_root to your USB drive, e.g.:')
    message('  media_root: "E:/MEDIA"')
    message('  media_root: "D:/MyUSB/MEDIA"')
  } else if (Sys.info()["sysname"] == "Darwin") {
    message('Mac: Set media_root to your USB mount point, e.g.:')
    message('  media_root: "/Volumes/MyUSB/MEDIA"')
    message('  media_root: "/Volumes/External/MEDIA"')
    message('')
    message('Available volumes:')
    vols <- list.files('/Volumes/', full.names = TRUE)
    for (v in vols) message('  ', v)
  }
} else {
  message('✅ config/media_root.yml already exists')
}

# Create data directory
if (!dir.exists('data')) {
  dir.create('data', recursive = TRUE)
  message('✅ Created data/ directory')
}

message('\n=== Setup Complete! ===')
message('\nNext steps:')
message('  1. Edit config/media_root.yml with your USB drive path')
message('  2. Ensure your USB has folders: mp_4/, mp_3/, pic_ture/, r_m_d/')
message('  3. Run: source("R/01_scan_media.R") to scan your media')
message('  4. Run: quarto render to generate reports')
message('')
