FROM debian:stable-slim as fetcher
COPY build/fetch_binaries.sh /tmp/fetch_binaries.sh

RUN apt-get update && apt-get install -y \
  curl \
  wget

RUN /tmp/fetch_binaries.sh

FROM alpine:3.21.1

RUN set -ex \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    bash \
    bind-tools \
    busybox-extras \
    conntrack-tools \
    curl \
    dhcping \
    file\
    fping \
    iftop \
    iperf \
    iperf3 \
    iproute2 \
    ipset \
    iptraf-ng \
    iputils \
    httpie \
    jq \
    libc6-compat \
    liboping \
    ltrace \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    nmap-scripts \
    openssl \
    py3-pip \
    py3-setuptools \
    scapy \
    socat \
    openssh \
    strace \
    tcpdump \
    tcpflow \
    tcptraceroute \
    tshark \
    util-linux \
    vim \
    git \
    websocat \
    swaks \
    perl-crypt-ssleay \
    perl-net-ssleay

# Installing termshark
COPY --from=fetcher /tmp/termshark /usr/local/bin/termshark

# Installing grpcurl
COPY --from=fetcher /tmp/grpcurl /usr/local/bin/grpcurl

# Installing fortio
COPY --from=fetcher /tmp/fortio /usr/local/bin/fortio

# Setting User and Home
USER root
WORKDIR /root
ENV HOSTNAME netshoot

# Fix permissions for OpenShift and tshark
RUN chmod -R g=u /root
RUN chown root:root /usr/bin/dumpcap

# Running BASH
CMD ["/bin/bash"]