@echo off
REM Windows setup script for me_dia
REM Double-click this file to run initial setup

echo ============================================
echo me_dia - Cross-Platform Media Manager
echo Windows Setup Script  
echo ============================================
echo.

REM Check if R is installed
where Rscript >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: R is not installed or not in PATH
    echo Please install R from: https://cran.r-project.org/
    echo.
    pause
    exit /b 1
)

echo Found R installation
echo.

REM Run R setup script
echo Running setup...
Rscript -e "source('R/00_setup.R')"

if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo Setup Complete!
    echo ============================================
    echo.
    echo Next steps:
    echo 1. Edit config/media_root.yml with your USB drive path
    echo    Example: media_root: "E:/MEDIA"
    echo 2. Create folders on USB: mp_4, mp_3, pic_ture, r_m_d
    echo 3. Run scan: Rscript -e "source('R/01_scan_media.R')"
    echo.
) else (
    echo.
    echo Setup encountered an error
    echo Please check the error messages above
    echo.
)

pause
