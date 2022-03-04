FROM nginxproxy/docker-gen
LABEL maintainer="jmm@yavook.de"

LABEL com.github.jrcs.letsencrypt_nginx_proxy_companion.docker_gen="true"

ADD \
  https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/main/nginx.tmpl \
  /etc/docker-gen/templates/nginx.tmpl

CMD [ \
  "-notify-sighup", "nginx", \
  "-watch", \
  "-wait", "5s:30s", \
  "/etc/docker-gen/templates/nginx.tmpl", \
  "/etc/nginx/conf.d/default.conf" \
]
