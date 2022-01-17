FROM alpine:latest

LABEL maintainer="melsonlai"

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
      echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
      apk update && \
      apk add dante-server openfortivpn

ENV OPENFORTIVPN_CONFIG="/root/openfortivpn.config"

COPY sockd.conf /etc/sockd.conf
COPY services.d /etc/services.d
RUN chmod 511 /etc/services.d/sockd/run

ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh", "-c", "/usr/bin/openfortivpn -c ${OPENFORTIVPN_CONFIG}" ]
