#!/bin/bash
# Commands to setup and launch nginx
# permissions logic taken from https://github.com/timhaak/docker-plex/blob/master/start.sh

GROUP=httptmp

# Make the required directories in /data if they aren't already there
mkdir -p /data/sites-{enabled,available}
mkdir -p /data/{secure,conf.d,logs}
mkdir -p /data/www/default

# If the default conf doesn't exist copy it
if [ ! -f /data/nginx.conf ]; then
  cp /etc/nginx/nginx.conf /data/nginx.conf
fi
if [ ! -f /data/conf.d/errors.conf ]; then
  cp /etc/nginx/conf.d/errors.conf /data/conf.d/errors.conf
fi

if [ ! -d "/data/errors" ]; then
  mkdir -p /data/errors
  cp /root/errors/*.html /data/errors
fi
ln -sf /data/errors /etc/nginx/

ln -sf /data/www /var/

if [ ! -f /data/sites-available/default ]; then
  cp /root/default/default /data/sites-available
  cp /root/default/index.html /data/www/default/index.html
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
echo "Starting nginx..."
exec /usr/sbin/nginx -c /data/nginx.conf