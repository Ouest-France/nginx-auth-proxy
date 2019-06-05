FROM nginx:alpine

ENV PROXY_HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.' \
    PROXY_LISTEN_PORT=8080 \
    PROXY_FORWARD_PORT=80 \
    PROXY_FORWARD_HOST=127.0.0.1

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && apk add --no-cache confd@testing

COPY confd /etc/confd

COPY entrypoint.sh /entrypoint.sh

RUN chmod g+rwx /etc/nginx/conf.d /var/cache/nginx /var/run /var/log/nginx && chgrp -R root /var/cache/nginx && addgroup nginx root

RUN rm -f /etc/nginx/conf.d/* && chmod +x /entrypoint.sh

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]