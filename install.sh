#!/usr/bin/env bash

# This script downloads and installs TETR.IO to your ~/.local/ directory and
# places a desktop integration file in ~/.local/share/applications/.
# Sadly the old 'latest' version path doesn't work anymore so versions will be
# hardcoded. I don't want to bother with webscraping for now.

# These variables may break any time since they rely on external factors

PNG_URL="https://txt.osk.sh/branding/tetrio-color.png"
TAR_NAME="TETR.IO%20Setup.tar.gz"
VERSION="9.0.0"
SHORT_VERSION="9"
TAR_URL="https://tetr.io/about/desktop/builds/$SHORT_VERSION/$TAR_NAME"

# Fixed paths and variables

DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/"
ICON_PATH="$HOME/.local/share/icons/hicolor/213x213"
LOCAL_PATH="$HOME/.local/"
DIRNAME="tetrio-desktop-$VERSION"
TETRIO_INSTALL_LOCATION="$LOCAL_PATH$DIRNAME"

if [ ! $(which update-desktop-database) ]; then
  echo "update-desktop-database not installed. Aborting."
  echo "Maybe you don't have desktop support?"
  exit 1
fi

for cmd in "curl" "tar"; do
  if [ ! $(which $cmd) ]; then
    echo "$cmd not installed. Aborting."
    exit 1
  fi
  echo "$cmd installed"
done

if [ ! -d $DESKTOP_ENTRY_PATH ]; then
  echo "Icon path $DESKTOP_ENTRY_PATH not found"
  echo "Creating directory $DESKTOP_ENTRY_PATH"
  mkdir -p $DESKTOP_ENTRY_PATH
fi

if [ ! -d $ICON_PATH ]; then
  echo "Dektop entry path $ICON_PATH not found"
  echo "Creating directory $ICON_PATH"
  mkdir -p $ICON_PATH
fi

### TETR.IO App ###

echo "Downloading version $VERSION of TETR.IO"
curl -O "$TAR_URL" >/dev/null
tar -vxf "$TAR_NAME"
mv "$DIRNAME" "$LOCAL_PATH"

### Desktop integration ###

curl -O $PNG_URL >/dev/null
mv "tetrio-color.png" $ICON_PATH

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=TETR.IO
GenericName=Stacker
Comment=TETR.IO is a free-to-win modern yet familiar online stacker.
TryExec=$TETRIO_INSTALL_LOCATION/TETR.IO
Exec=$TETRIO_INSTALL_LOCATION/TETR.IO
Icon=$ICON_PATH/tetrio-color.png
Categories=Game;" >"$DESKTOP_ENTRY_PATH/tetrio.desktop"

update-desktop-database ~/.local/share/applications
rm "$TAR_NAME"
