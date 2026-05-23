#!/usr/bin/env bash

# define color variables
RED="\e[31m"
YELLOW="\e[33m"
PURP="\e[35m"

ENDC="\e[0m"

# define script path and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# define paths
WEB_SOURCE="$PROJECT_ROOT/web"
NGX_SOURCE="$PROJECT_ROOT/nginx/goathub"

WEB_DEST="/var/www/goathub"
NGX_DEST="/etc/nginx/sites-available/goathub"
NGX_ENABLED="/etc/nginx/sites-enabled/goathub"

echo -e "${purp} ==== Verifying Existence of Source Files ==== ${ENDC}"

# check web source exists
if [ ! -d "$WEB_SOURCE" ]; then
  echo "[Err]: Web source not found. Deployment not initialized."
  echo "(missing/damaged path $WEB_SOURCE)"
  exit 1
else
  echo "Web page source found"
fi

# check nginx source exists
if [ ! -f "$NGX_SOURCE" ]; then
  echo "[Err]: Nginx config not found. Deployment not initialized."
  echo "(missing/damaged path $NGX_SOURCE)"
  exit 1
else
  echo "Nginx config source found"
fi


echo " ==== Copying web source files to live directory ==== "

# create live web dir
if [ ! -d "$WEB_DEST" ]; then
  echo "Destination folder $WEB_DEST not found, creating."
  sudo mkdir -p "$WEB_DEST"
else 
  echo "Destination folder alreadyy exists, skipping creation."
fi

# copy web files
sudo rsync -av "$WEB_SOURCE"/ "$WEB_DEST"/

# copy nginx config
echo " ==== Copying nginx source files to live directory ===="
sudo rsync -av "$NGX_SOURCE" "$NGX_DEST"

# verify symlink
if [ ! -L "$NGX_ENABLED" ]; then
  echo "Symlink not found, creating."
  sudo ln -s "$NGX_DEST" "$NGX_ENABLED"
else
  echo "Symlink already exists, skipping creation."
fi

# test nginx
echo "Testing nginx config..."

if sudo nginx -t; then
  echo "Config is valid, reloading."
  sudo systemctl reload nginx
else
  echo "[Err]: Config test failed, check $NGX_SOURCE or $NGX_DEST."
  exit 1
fi

echo " ==== goathub patch successful, no errors, no goats harmed ===="
exit 0
