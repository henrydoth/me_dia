# Testing and Validation Guide

This document describes how to test the cross-platform media management functionality.

## Manual Testing Checklist

### On Mac

1. **Setup Test**
   ```bash
   chmod +x setup_mac.sh
   ./setup_mac.sh
   ```
   - [ ] Script runs without errors
   - [ ] Installs yaml and digest packages (if needed)
   - [ ] Creates config/media_root.yml from example
   - [ ] Shows available volumes
   - [ ] Displays helpful next steps

2. **USB Detection Test**
   ```r
   source("R/utils_detect_usb.R")
   show_drives()
   ```
   - [ ] Detects OS as "MAC"
   - [ ] Lists volumes under /Volumes/
   - [ ] Identifies USB drives (non-system volumes)
   - [ ] Detects MEDIA folders if they exist

3. **Configuration Test**
   - [ ] Edit config/media_root.yml with a test path
   - [ ] Path format: `/Volumes/[name]/MEDIA`
   - [ ] Config file is in .gitignore (not committed)

4. **Folder Structure Test**
   ```bash
   # Create test structure on USB or temp location
   TEST_ROOT="/tmp/test_media"
   mkdir -p $TEST_ROOT/MEDIA/{mp_4,mp_3,pic_ture,r_m_d}
   
   # Create test files
   touch $TEST_ROOT/MEDIA/mp_4/test.mp4
   touch $TEST_ROOT/MEDIA/mp_3/test.mp3
   touch $TEST_ROOT/MEDIA/pic_ture/test.jpg
   touch $TEST_ROOT/MEDIA/r_m_d/test.pdf
   ```
   
   Update config:
   ```yaml
   media_root: "/tmp/test_media/MEDIA"
   ```
   
   - [ ] Folders created successfully
   - [ ] Test files created

5. **Scan Test**
   ```r
   source("R/01_scan_media.R")
   ```
   - [ ] Detects OS correctly
   - [ ] Validates config file exists
   - [ ] Checks media_root path exists
   - [ ] Shows folder structure status
   - [ ] Scans all categories
   - [ ] Creates data/index_media.csv
   - [ ] Shows summary statistics
   - [ ] Paths are normalized (forward slashes)
   - [ ] Relative paths are correct

6. **Index File Test**
   ```r
   df <- read.csv("data/index_media.csv")
   head(df)
   ```
   - [ ] CSV is valid and readable
   - [ ] Contains expected columns: category, rel_path, abs_path, ext, size, mtime, md5
   - [ ] Relative paths don't include MEDIA_ROOT
   - [ ] Absolute paths are correct

7. **Report Generation Test**
   ```bash
   quarto render
   ```
   - [ ] index.qmd renders successfully
   - [ ] media_report.qmd renders successfully
   - [ ] cross_platform_guide.qmd renders successfully
   - [ ] Output appears in output/quarto/
   - [ ] Reports show correct statistics

### On Windows

1. **Setup Test**
   - [ ] Double-click setup_windows.bat
   - [ ] Script detects R installation
   - [ ] Installs required packages
   - [ ] Creates config file
   - [ ] Shows appropriate Windows instructions

2. **USB Detection Test**
   ```r
   source("R/utils_detect_usb.R")
   show_drives()
   ```
   - [ ] Detects OS as "WINDOWS"
   - [ ] Lists available drive letters
   - [ ] Identifies non-C: drives as potential USB
   - [ ] Finds MEDIA folders if they exist

3. **Path Format Test**
   - [ ] Config accepts drive letters: `E:/MEDIA`
   - [ ] Forward slashes work: `E:/MEDIA`
   - [ ] Double backslashes work: `E:\\MEDIA`

4. **Scan Test**
   ```r
   source("R/01_scan_media.R")
   ```
   - [ ] Works with Windows paths
   - [ ] Normalizes paths correctly
   - [ ] Creates valid CSV
   - [ ] MD5 hashing works

## Cross-Platform Portability Test

1. **Create index on Mac**
   ```r
   # On Mac with USB at /Volumes/MyUSB/MEDIA
   source("R/01_scan_media.R")
   ```
   - [ ] Creates data/index_media.csv
   - [ ] Note some rel_path values

2. **Move USB to Windows**
   - [ ] USB mounts (e.g., E:/)
   - [ ] Update config: `media_root: "E:/MEDIA"`
   
3. **Re-scan on Windows**
   ```r
   source("R/01_scan_media.R")
   ```
   - [ ] Same rel_path values as Mac
   - [ ] Different abs_path (Windows format)
   - [ ] All files still detected
   - [ ] MD5 hashes unchanged

## Edge Cases to Test

### Empty Folders
- [ ] Empty mp_4/ folder is skipped gracefully
- [ ] Helpful message when no files found

### Invalid Extensions
- [ ] .txt file in mp_4/ is ignored
- [ ] Only valid extensions are indexed

### Missing Folders
- [ ] Missing r_m_d/ is reported but doesn't crash
- [ ] Other folders are still scanned

### Invalid Config
- [ ] `media_root: "CHANGE_ME"` shows helpful error
- [ ] Non-existent path shows helpful error
- [ ] Missing config file shows how to create it

### Special Characters
- [ ] Files with spaces: "my video.mp4"
- [ ] Unicode filenames
- [ ] Nested directories work

## Documentation Tests

1. **README.md**
   - [ ] Clear installation instructions
   - [ ] Platform-specific examples
   - [ ] Troubleshooting section
   - [ ] Cross-platform workflow explained

2. **QUICKSTART_MAC.md**
   - [ ] Bilingual (English/Vietnamese)
   - [ ] Mac-specific commands
   - [ ] Lists /Volumes/ examples

3. **cross_platform_guide.qmd**
   - [ ] Comprehensive guide
   - [ ] Examples for both platforms
   - [ ] Renders to HTML properly

## Automated Checks

```bash
# File permissions
ls -la setup_mac.sh  # Should be executable

# .gitignore verification
git status  # config/media_root.yml should not appear
git status  # data/*.csv should not appear
git status  # *.mp3, *.mp4, etc. should not appear

# File structure
test -d data && echo "data/ exists"
test -f data/.gitkeep && echo ".gitkeep exists"
test -f config/media_root.example.yml && echo "example config exists"
```

## Performance Tests

For a USB with ~1000 files:
- [ ] Scan completes in reasonable time (< 5 minutes)
- [ ] MD5 hashing doesn't cause timeout
- [ ] Memory usage is acceptable
- [ ] Progress messages appear

## User Experience Tests

1. **First-time user**
   - [ ] Can follow README and get started
   - [ ] Error messages are helpful
   - [ ] Examples match their system

2. **Cross-platform user**
   - [ ] Can switch between Mac and Windows
   - [ ] Understands relative vs absolute paths
   - [ ] Can maintain same USB on both systems

## Known Limitations

Document any limitations discovered:
- Large files (>5GB) may be slow to hash
- Network drives not tested
- Case-sensitive file systems (Mac can vary)
- Windows drive letter changes require config update

## Test Results Summary

Date: ___________
Tester: ___________
Platform: [ ] Mac [ ] Windows [ ] Linux

Overall Result: [ ] PASS [ ] FAIL [ ] PARTIAL

Notes:
