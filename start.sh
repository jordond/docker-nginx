#!/bin/bash
# Commands to setup and launch nginx

mkdir -p /data/sites-{enabled,available}
mkdir -p /data/{secure,conf.d,logs}

if [ ! -f /data/nginx.conf ]; then
  cp /etc/nginx/nginx.conf /data/nginx.conf
fi

# delete generated folders and files
rm -r /etc/nginx/sites-enabled \
      /etc/nginx/sites-available \
      /etc/nginx/secure \
      /etc/nginx/conf.d

# soft link /data dir to nginx root
ln -s

# run nginx with config file from /data
