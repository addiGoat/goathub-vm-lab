#!/usr/bin/env bash
set -r

rsync -av --delete /home/addigoat/Projects/goathub/web/ addigoat@cherri:/var/www/goathub
