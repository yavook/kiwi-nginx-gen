# kiwi-nginx-gen

[![Build Status](https://github.drone.yavook.de/api/badges/yavook/kiwi-nginx-gen/status.svg)](https://github.drone.yavook.de/yavook/kiwi-nginx-gen)

> `kiwi` - simple, consistent, powerful

Utility for [`kiwi-scp`](https://github.com/yavook/kiwi-scp). Also [on Docker Hub](https://hub.docker.com/r/yavook/kiwi-nginx-gen).

## Use Case

kiwi-nginx-gen is used in the multi-container use case alongside an official `nginx` container to mimic `nginxproxy/nginx-proxy` without publishing your docker socket to the `nginx` container.

## Typical usage in `docker-compose.yml` sections:

Without TLS:

```yaml
nginx:
  image: nginx:stable-alpine
  container_name: nginx
  network_mode: host
  volumes:
    - "${KIWI_PROJECT}/nginx/conf.d:/etc/nginx/conf.d:ro"

nginx-gen:
  build: yavook/kiwi-nginx-gen
  networks:
    - kiwi_hub
  depends_on:
    - nginx
  volumes:
    - "/var/run/docker.sock:/tmp/docker.sock:ro"
    - "${KIWI_PROJECT}/nginx/conf.d:/etc/nginx/conf.d"
```

With automatic TLS by Let's Encrypt:

```yaml
nginx:
  image: nginx:stable-alpine
  container_name: nginx
  labels:
    com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy: 'true'
  network_mode: host
  volumes:
    - "${KIWI_PROJECT}/nginx/certs:/etc/nginx/certs:ro"
    - "${KIWI_PROJECT}/nginx/conf.d:/etc/nginx/conf.d:ro"

nginx-gen:
  build: yavook/kiwi-nginx-gen
  networks:
    - kiwi_hub
  depends_on:
    - nginx
  volumes:
    - "/var/run/docker.sock:/tmp/docker.sock:ro"
    - "${KIWI_PROJECT}/nginx/certs:/etc/nginx/certs:ro"
    - "${KIWI_PROJECT}/nginx/conf.d:/etc/nginx/conf.d"

letsencrypt:
  image: nginxproxy/acme-companion
  depends_on:
    - nginx-gen
  volumes:
    - "/var/run/docker.sock:/var/run/docker.sock:ro"
    - "${KIWI_PROJECT}/nginx/certs:/etc/nginx/certs"
    - "${KIWI_PROJECT}/nginx/conf.d:/etc/nginx/conf.d:ro"
    - "${KIWI_PROJECT}/nginx/acme.sh:/etc/acme.sh"
  environment:
    DEFAULT_EMAIL: "${LE_MAIL_DEFAULT}"
```
