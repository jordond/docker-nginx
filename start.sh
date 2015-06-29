#!/bin/bash
# Commands to setup and launch nginx
# permissions logic taken from https://github.com/timhaak/docker-plex/blob/master/start.sh

GROUP=httptmp

mkdir -p /data/sites-{enabled,available}
mkdir -p /data/{secure,conf.d,logs,www}

if [ ! -f /data/nginx.conf ]; then
  cp /etc/nginx/nginx.conf /data/nginx.conf
fi

# set permissions to data dir owner
TARGET_GID=$(stat -c "%g" /data)
EXISTS=$(cat /etc/group | grep ${TARGET_GID} | wc -l)

# Create new group using target GID and add http user
if [ $EXISTS = "0" ]; then
  groupadd --gid ${TARGET_GID} ${GROUP}
else
  # GID exists, find group name and add
  GROUP=$(getent group $TARGET_GID | cut -d: -f1)
  usermod -a -G ${GROUP} http
fi
usermod -a -G ${GROUP} http

chgrp -R ${GROUP} /data
chmod -R g+wX /data

# run nginx with config file from /data
exec /usr/sbin/nginx -c /data/nginx.conf