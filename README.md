## Mục tiêu dự án

`me_dia` là project quản lý **media cá nhân dung lượng lớn** (mp3, mp4, hình ảnh…) theo cách:

- **Git/GitHub** chỉ quản lý *code, cấu hình, ghi chú* (nhẹ, portable)
- **USB / ổ ngoài** quản lý *media nặng* (dùng chung Mac & Windows)
- **R / Quarto** dùng để quét (scan), lập chỉ mục (index), báo cáo media

## Tổng kết hôm nay (đã làm xong)

### 1. Kiến trúc thư mục chuẩn

**Trong repo (Mac / Windows):**

me_dia/

├── R/

│   ├── 01_scan_media.R      # logic scan media

│   └── scan_media.R         # hàm gọi gọn scan_media()

├── config/

│   └── media.R              # xác định MEDIA_ROOT (USB hoặc env)

├── data/                    # output local (KHÔNG push)

│   └── index_media.csv

├── MEDIA -> (symlink)       # link tới USB (Mac)

├── _quarto.yml

├── media_report.qmd

├── README.md

└── .gitignore

**Trên USB (dùng chung Mac / Windows):**

ssd_1tb/MEDIA/me_dia/

├── audio/

├── video/

├── image/

├── raw/

└── export/

### 2. Nguyên tắc Git & Media

- ❌ **KHÔNG push media nặng lên GitHub**
- ✅ Git chỉ quản lý:
  - R scripts
  - Quarto / Markdown
  - config
- `data/index_media.csv` là **file local**, đã ignore trong `.gitignore`

### 3. MEDIA_ROOT portable

File `config/media.R`:

- Ưu tiên biến môi trường `MEDIA_ROOT`
- Nếu không có → dùng thư mục `MEDIA/` trong project
- Nhờ vậy:
  - Mac: dùng symlink tới `/Volumes/ssd_1tb/MEDIA/me_dia`
  - Windows: chỉ cần set `MEDIA_ROOT = E:/MEDIA/me_dia`

### 4. Pipeline scan media (đã hoàn chỉnh)

- Copy media vào USB bằng `rsync`
- Chạy **1 lệnh duy nhất trong R**:

setwd("/Users/mac/Documents/me_dia")

source("R/scan_media.R")

scan_media()

Kết quả:

- Quét toàn bộ `audio / video / image / raw / export`
- Lọc theo extension
- Tính **md5 checksum**
- Ghi `data/index_media.csv`

Ví dụ kết quả:

- `Hashing md5: video (n=10)`
- `✅ Wrote: data/index_media.csv | n=10`

### 5. Thực nghiệm thành công hôm nay

- Copy **~1.7 GB video (10 file mp4)** từ Mac → USB
- R nhận đúng Unicode (中文 / tiếng Việt)
- Index ghi đúng:
  - `rel_path`
  - `size_mb`
  - `md5`

## Ngày mai / bước tiếp theo (đề xuất)

### A. Hoàn thiện báo cáo media (Quarto)

- Cập nhật `media_report.qmd` để:
  - Đọc `data/index_media.csv`
  - Bảng video/audio/image
  - Tổng dung lượng theo category
  - Sắp xếp theo số tập (01–10)

### B. Hỗ trợ Windows

- Viết ngắn trong README:
  - Cách set `MEDIA_ROOT` trên Windows
  - Cách chạy `scan_media()` trên Windows RStudio

### C. Mở rộng (tuỳ chọn)

- Phát hiện **file trùng md5**
- Lịch sử thay đổi media (so sánh index cũ/mới)
- Tự động scan khi cắm USB

## Ghi nhớ quan trọng

- **Terminal ≠ R console**
  - Terminal: `ls`, `rsync`
  - R: `dir()`, `list.files()`
- Khi thấy kết quả lạ → `rm(list = ls())` rồi reload `scan_media()`

## Trạng thái hiện tại

✔ Project ổn định ✔ Portable Mac / Windows ✔ Media lớn quản lý an toàn ✔ Code gọn, dễ bảo trì

> Đây là mốc "xong nền móng" của `me_dia`. Các bước sau chỉ là mở rộng.

Xong rồi 👍
 Mình đã **viết lại toàn bộ README.md** cho bạn, đúng theo những gì **hôm nay đã làm** và **định hướng mai làm tiếp**, ở mức:

- Nhìn vào là **nhớ lại ngay workflow**
- Đủ rõ để **vài tháng sau mở lại không bối rối**
- Chuẩn để **dùng lâu dài, không chỉ cho hôm nay**

📌 README hiện đã có:

- Mục tiêu dự án
- Kiến trúc Git ↔ USB
- MEDIA_ROOT portable
- Pipeline `scan_media()`
- Thực nghiệm copy + scan hôm nay
- Danh sách việc làm tiếp ngày mai
- Ghi chú những lỗi “dễ dính” (Terminal vs R)

👉 **Tối nay dừng ở đây là quá hợp lý**:
 nền móng đã xong, không còn nợ kỹ thuật.

Ngày mai nếu bạn nói:

- “làm report”
- hoặc “chuẩn hóa cho Windows”
- hoặc “phát hiện file trùng md5”