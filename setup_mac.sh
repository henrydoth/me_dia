#!/bin/bash
# Mac/Linux setup script for me_dia
# Run: chmod +x setup_mac.sh && ./setup_mac.sh

echo "============================================"
echo "me_dia - Cross-Platform Media Manager"
echo "Mac/Linux Setup Script"
echo "============================================"
echo ""

# Check if R is installed
if ! command -v Rscript &> /dev/null; then
    echo "ERROR: R is not installed"
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Install R on Mac:"
        echo "  brew install r"
        echo "  or download from: https://cran.r-project.org/"
    else
        echo "Install R on Linux:"
        echo "  Ubuntu/Debian: sudo apt-get install r-base"
        echo "  Fedora: sudo dnf install R"
    fi
    echo ""
    exit 1
fi

echo "Found R installation"
echo ""

# Run R setup script
echo "Running setup..."
Rscript -e "source('R/00_setup.R')"

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================"
    echo "Setup Complete!"
    echo "============================================"
    echo ""
    echo "Next steps:"
    echo "1. Edit config/media_root.yml with your USB drive path"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   Example: media_root: \"/Volumes/MyUSB/MEDIA\""
        echo "   Available volumes:"
        ls -1 /Volumes/ 2>/dev/null | sed 's/^/     /'
    else
        echo "   Example: media_root: \"/mnt/usb/MEDIA\""
    fi
    
    echo "2. Create folders on USB: mp_4, mp_3, pic_ture, r_m_d"
    echo "3. Run scan: Rscript -e \"source('R/01_scan_media.R')\""
    echo ""
else
    echo ""
    echo "Setup encountered an error"
    echo "Please check the error messages above"
    echo ""
    exit 1
fi
