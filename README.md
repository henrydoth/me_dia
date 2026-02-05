# me_dia - Cross-Platform Media Manager

A lightweight media file manager for organizing and tracking MP4, MP3, and picture files across Mac and Windows USB/external drives.

## Features

- 📁 Scan and index media files (MP4, MP3, JPG, PNG, etc.)
- 💾 Cross-platform support (Mac & Windows)
- 🔌 USB/External drive detection
- 📊 Generate detailed media reports with Quarto
- 🔐 MD5 hash verification for file integrity
- 📈 Track file sizes, modification times, and locations

## Supported File Types

- **Video**: mp4, mkv, mov, avi
- **Audio**: mp3, wav, flac
- **Images**: jpg, jpeg, png, heic, tif, tiff
- **Documents**: pdf, docx, xlsx, pptx, zip, rar, 7z, raw, txt

## Installation

### Prerequisites

1. **R** (version 4.0+)
   - Mac: `brew install r`
   - Windows: Download from [CRAN](https://cran.r-project.org/)

2. **Quarto** (for reports)
   - Download from [quarto.org](https://quarto.org/)

3. **R Packages**:
   ```r
   install.packages(c("yaml", "digest"))
   ```

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/henrydoth/me_dia.git
   cd me_dia
   ```

2. Create your local configuration:
   ```bash
   # Copy the example config
   cp config/media_root.example.yml config/media_root.yml
   ```

3. Edit `config/media_root.yml` with your USB/external drive path:
   
   **Windows example:**
   ```yaml
   media_root: "E:/MEDIA"
   # or
   media_root: "D:/MyUSB/MEDIA"
   ```
   
   **Mac example:**
   ```yaml
   media_root: "/Volumes/MyUSB/MEDIA"
   # or
   media_root: "/Volumes/External/MEDIA"
   ```

## Folder Structure on USB Drive

Organize your media files on the USB drive as follows:

```
MEDIA/
├── mp_4/           # Video files
│   ├── vacation_2024.mp4
│   └── family/
│       └── birthday.mov
├── mp_3/           # Audio files
│   ├── music/
│   │   └── song.mp3
│   └── podcast.wav
├── pic_ture/       # Picture files
│   ├── photos/
│   │   └── sunset.jpg
│   └── screenshots/
│       └── screen.png
└── r_m_d/          # Documents & others
    ├── docs/
    │   └── report.pdf
    └── archive.zip
```

## Usage

### 1. Scan Media Files

Connect your USB drive and run the scan script:

```r
# From R console or RStudio
source("R/01_scan_media.R")
```

This will:
- Scan all supported files in your MEDIA_ROOT
- Calculate MD5 hashes for integrity verification
- Create `data/index_media.csv` with file metadata

### 2. View Media Reports

Generate HTML reports:

```bash
quarto render
# Or in RStudio: Build > Render Website
```

Open `output/quarto/index.html` in your browser to view:
- Total indexed files
- File counts by category
- Storage usage statistics

## Cross-Platform Notes

### Windows
- Use drive letters: `E:/`, `D:/`, etc.
- Forward slashes (`/`) or double backslashes (`\\`) work
- USB drives typically appear as `E:`, `F:`, etc.

### Mac
- USB drives mount under `/Volumes/`
- Use: `/Volumes/[DriveName]/MEDIA`
- Check mounted drives: `ls /Volumes/`

### Path Portability
- Paths in `index_media.csv` are stored as relative paths
- This allows the index to work when the USB drive has different mount points
- Absolute paths are also stored for convenience

## Workflow: Moving Between Mac and Windows

1. **On first computer** (Windows or Mac):
   - Configure `config/media_root.yml`
   - Run `source("R/01_scan_media.R")`
   - Files are indexed with relative paths

2. **On second computer**:
   - Connect the same USB drive
   - Update `config/media_root.yml` with new mount point
   - Run scan again to update absolute paths
   - The relative paths remain consistent

## Troubleshooting

### "media_root is invalid or not found"
- Check if USB drive is connected
- Verify the path in `config/media_root.yml`
- Mac: Run `ls /Volumes/` to see mounted drives
- Windows: Check "This PC" for drive letters

### "No files found"
- Ensure folders `mp_4`, `mp_3`, `pic_ture`, `r_m_d` exist on USB
- Check that files have supported extensions
- Verify folder names match exactly (case-sensitive on Mac)

### "Missing config/media_root.yml"
- Copy from example: `cp config/media_root.example.yml config/media_root.yml`
- Edit with your USB path

## License

MIT License - Feel free to use and modify
