FROM melsonlai/docker-openvpn-client-socks:latest

LABEL maintainer="melsonlai"

RUN apk add bash jq

COPY main.sh /root/
RUN chmod 511 /root/main.sh

ENTRYPOINT [ "/init" ]
CMD [ "/root/main.sh" ]

