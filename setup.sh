#!/bin/ash

cat > /etc/apk/repositories << EOF; $(echo)

http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main
http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing

EOF

apk update

apk add docker tailscale

rc-service docker start
rc-update add docker

rc-service tailscale start
rc-update add tailscale


tailscale up --advertise-tags tag:server,tag:zwave

docker network create -d bridge -o com.docker.network.bridge.host_binding_ipv4=$(tailscale ip | head -n1) tailnet

