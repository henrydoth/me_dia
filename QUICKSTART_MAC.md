# Quick Start Guide for Mac Users

## Hướng dẫn nhanh cho người dùng Mac / Quick Start for Mac

### Yêu cầu / Requirements
- macOS (đã test trên Apple Silicon M1/M2)
- R version 4.0+ (bạn đã có R 4.4.3 ✓)
- Quarto (tùy chọn, cho báo cáo)

### Cài đặt / Setup

1. **Cài đặt các gói R cần thiết / Install required R packages:**
   ```r
   # Mở R hoặc RStudio
   source("R/00_setup.R")
   ```

2. **Tìm đường dẫn USB của bạn / Find your USB path:**
   ```r
   source("R/utils_detect_usb.R")
   show_drives()
   ```
   
   Thường sẽ là: `/Volumes/[Tên USB]/MEDIA`
   Usually: `/Volumes/[USB Name]/MEDIA`

3. **Cấu hình đường dẫn / Configure path:**
   ```bash
   # Copy file cấu hình mẫu
   cp config/media_root.example.yml config/media_root.yml
   
   # Sửa file với đường dẫn USB của bạn
   # Edit with your USB path
   nano config/media_root.yml
   ```
   
   Ví dụ / Example:
   ```yaml
   media_root: "/Volumes/MyUSB/MEDIA"
   ```

4. **Tạo cấu trúc thư mục trên USB / Create folder structure on USB:**
   ```bash
   # Trên USB drive của bạn, tạo:
   # On your USB drive, create:
   mkdir -p /Volumes/MyUSB/MEDIA/{mp_4,mp_3,pic_ture,r_m_d}
   ```
   
   Hoặc tạo thủ công trong Finder:
   - MEDIA/mp_4/     (video files)
   - MEDIA/mp_3/     (audio files)
   - MEDIA/pic_ture/ (hình ảnh / images)
   - MEDIA/r_m_d/    (tài liệu / documents)

5. **Quét file media / Scan media files:**
   ```r
   source("R/01_scan_media.R")
   ```

### Xem danh sách volumes hiện có / Check available volumes

Trong Terminal:
```bash
ls -l /Volumes/
```

Hoặc trong R:
```r
list.files("/Volumes/", full.names = TRUE)
```

### Các loại file được hỗ trợ / Supported file types

- **Video (mp_4/)**: .mp4, .mkv, .mov, .avi
- **Audio (mp_3/)**: .mp3, .wav, .flac
- **Hình ảnh (pic_ture/)**: .jpg, .jpeg, .png, .heic, .tif, .tiff
- **Tài liệu (r_m_d/)**: .pdf, .docx, .xlsx, .pptx, .zip, .rar, .7z, .txt

### Lưu ý quan trọng cho Mac / Important Mac notes

1. **Đường dẫn phân biệt chữ hoa/thường** / Paths are case-sensitive
   - Phải ghi đúng: `mp_4`, `mp_3`, `pic_ture`, `r_m_d`
   - Must match exactly: `mp_4`, `mp_3`, `pic_ture`, `r_m_d`

2. **Tên volume USB** / USB volume name
   - Sử dụng tên chính xác như trong Finder
   - Use exact name as shown in Finder
   - Kiểm tra: `ls /Volumes/`

3. **Eject an toàn** / Safe eject
   - Luôn eject từ Finder trước khi rút USB
   - Always eject from Finder before removing USB

### Sử dụng giữa Mac và Windows / Using between Mac and Windows

File index (`data/index_media.csv`) lưu cả đường dẫn tương đối và tuyệt đối:
The index file stores both relative and absolute paths:

**Trên Mac:**
```yaml
media_root: "/Volumes/MyUSB/MEDIA"
```

**Trên Windows:**
```yaml
media_root: "E:/MEDIA"
```

Đường dẫn tương đối (như `mp_4/video.mp4`) hoạt động trên cả hai hệ thống!
Relative paths work on both systems!

### Tạo báo cáo / Generate reports

```bash
quarto render
```

Mở file: `output/quarto/index.html`

### Khắc phục sự cố / Troubleshooting

**Lỗi: "media_root is invalid or not found"**
- Kiểm tra USB đã kết nối chưa / Check USB is connected
- Chạy: `ls /Volumes/` để xem các volume
- Đảm bảo đường dẫn trong `config/media_root.yml` đúng

**Lỗi: "No files found"**
- Kiểm tra các thư mục tồn tại: mp_4/, mp_3/, pic_ture/, r_m_d/
- Đảm bảo tên thư mục chính xác (phân biệt chữ hoa/thường)
- Kiểm tra file có đuôi đúng không

### Hỗ trợ / Support

Xem thêm tài liệu chi tiết:
- README.md
- cross_platform_guide.qmd
