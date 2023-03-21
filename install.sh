#!/bin/bash

PNG_URL="https://txt.osk.sh/branding/tetrio-color.png"
DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/"
BIN_PATH="$HOME/.local/"

help() {
    echo Please use: ./install.sh /path/to/TETR.IO\\ Setup.tar.gz
}

if [ $# == 0 ]; then
    help
    exit 1
else
    TETRIO_PATH=$1
fi

echo $TETRIO_PATH

# test to see if path is valid

# extract files and grab the extracted directory name
dir_name=`tar -vxf "$TETRIO_PATH" | head -n 1`

# extract version number of tetrio
# 15 is for the strings of "tetrio-desktop"
# -1 cuts of the "/" from the directory
VERSION=${dir_name:15: -1}

### move files to destination

mv $dir_name "$BIN_PATH"
EXEC_PATH="$BIN_PATH$dir_name"

###### Desktop integration

# download the tetrio logo to the tetrio path
ICON_PATH="$EXEC_PATH""tetrio-color.png"
curl --create-dirs --output $ICON_PATH $PNG_URL

cp ./tetrio.desktop $DESKTOP_ENTRY_PATH
ENTRY="$DESKTOP_ENTRY_PATH/tetrio.desktop"
EXEC_PATH="$EXEC_PATH""tetrio-desktop"

# set attributes
sed -i "s+VERSION+$VERSION+g" $ENTRY
sed -i "s+EXEC_PATH+$EXEC_PATH+g" $ENTRY
sed -i "s+ICON_PATH+$ICON_PATH+g" $ENTRY

# update desktop entries
update-desktop-database ~/.local/share/applications
