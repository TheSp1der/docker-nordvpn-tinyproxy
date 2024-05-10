FROM registry.c.test-chamber-13.lan/dockerhub/library/alpine:latest

RUN apk add --no-cache openvpn tinyproxy iputils bind-tools curl bash jq file

COPY openvpn/* /etc/openvpn/
COPY scripts/ /usr/local/bin/

WORKDIR /root

ENTRYPOINT ["/bin/bash", "-c", "healthcheck.sh -s; startup.sh" ]