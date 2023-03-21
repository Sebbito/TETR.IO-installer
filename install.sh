#!/bin/bash

PNG_URL="https://txt.osk.sh/branding/tetrio-color.png"
TAR_URL="https://tetr.io/about/desktop/builds/TETR.IO%20Setup.tar.gz"
DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/"
LOCAL_PATH="$HOME/.local/"

# download tar ball
wget "$TAR_URL"

# extract files
tar -vxf "TETR.IO Setup.tar.gz"

# grab the extracted directory name
dir_name=$(find . -name "tetrio-desktop*" -type d)
dir_name=${dir_name:2} # cut off the ./ from the start

# extract version number of tetrio
# 15 is for the strings of "tetrio-desktop"
VERSION=${dir_name:15}

# move files to destination
mv "$dir_name" "$LOCAL_PATH"
FILE_LOCATION="$LOCAL_PATH$dir_name/"

### Desktop integration ###

# download the tetrio logo to the tetrio path
ICON_PATH="$FILE_LOCATION""tetrio-color.png"
wget $PNG_URL
mv "tetrio-color.png" $ICON_PATH

# Copy the desktop file
cp ./tetrio.desktop $DESKTOP_ENTRY_PATH
ENTRY="$DESKTOP_ENTRY_PATH""tetrio.desktop"
EXECUTABLE_LOCATION="$FILE_LOCATION""tetrio-desktop"

# set attributes
sed -i "s+VERSION+$VERSION+g" $ENTRY
sed -i "s+EXEC_PATH+$EXECUTABLE_LOCATION+g" $ENTRY
sed -i "s+ICON_PATH+$ICON_PATH+g" $ENTRY

# update desktop entries
update-desktop-database ~/.local/share/applications

# remove the tarball
rm "TETR.IO Setup.tar.gz"
