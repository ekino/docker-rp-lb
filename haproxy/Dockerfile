# --- HAPROXY ---

FROM ekino/base:latest
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HAPROXY_VERSION 1.5

# prerequisites
RUN apt-get update
RUN apt-get install -y curl supervisor openssl vim

# install haproxy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 505D97A41C61B9CD
RUN echo "deb http://ppa.launchpad.net/vbernat/haproxy-${HAPROXY_VERSION}/ubuntu trusty main" >> /etc/apt/sources.list.d/haproxy.list
RUN apt-get update -y
RUN apt-get install -y haproxy socat

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists

# configure
RUN mkdir -p /opt/haproxy.cfg.d
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD showstat.sh /showstat.sh
ADD supervisord.conf /etc/supervisor/conf.d/haproxy.conf

EXPOSE 80
EXPOSE 443

# startup
ADD haproxy.sh /start.d/10-haproxy