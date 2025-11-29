FROM alpine:latest
ARG S6_OVERLAY_VERSION=3.2.1.0

LABEL maintainer="melsonlai"

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && rm /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && rm /tmp/s6-overlay-x86_64.tar.xz

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
      apk update && \
      apk add dante-server openvpn openresolv

COPY sockd.conf /etc/sockd.conf
COPY services.d /etc/services.d
RUN chmod 511 /etc/services.d/sockd/run

ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh", "-c", "cd /root/openvpn/ && exec /usr/sbin/openvpn --config *.ovpn --script-security 2 --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh" ]
