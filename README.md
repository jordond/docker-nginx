Nginx
======

A dockerfile for a custom run of nginx.

**Pull image**

```
docker pull jordond/nginx
```

**Running container**

```
docker run -d -p 80:80 -p 443:443 --name=<container name> -v <path for nginx data>:/data jordond/nginx
```
Please replace all user variables in the above command defined by <> with the correct values.  Start the container once, to create the `nginx.conf` in the data directory.

**Exposes**
1. Port 80 for http traffic
1. Port 443 for https traffic
1. `/data` for nginx directories

**Adding virtual hosts**
1. Create and store the host .conf's in the `sites-available` folder.
1. For sites you want active COPY don't symlink the confs to `sites-enabled`.
1. Store `.htpasswd` or SSL certs in `secure`
1. Websites folders are stored in `www`
1. Restart the container for config to load.

**Access Nginx http**

```
http://<host ip>:80
```

**Access Nginx https**

```
https://<host ip>:443
```
