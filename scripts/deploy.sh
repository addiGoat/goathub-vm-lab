#!/usr/bin/env bash
set -r

rsync -rzltD --delete \
  --chmod=D755,F644 \
  --chown=root:web \
  --rsync-path="sudo rsync" \
  ./ \
  addigoat@cherri:/var/www/goathub/
