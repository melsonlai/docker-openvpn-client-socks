FROM ubuntu:latest

LABEL maintainer="melsonlai"

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN apt update -yqq \
      && apt install -yqq openfortivpn ca-certificates dante-server iproute2 \
      && apt clean -yqq

ENV OPENFORTIVPN_CONFIG="/root/openfortivpn.config"

COPY danted.conf /etc/danted.conf
COPY services.d /etc/services.d
RUN chmod 511 $(ls /etc/services.d/*/run)

ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh", "-c", "/usr/bin/openfortivpn -c ${OPENFORTIVPN_CONFIG}" ]
