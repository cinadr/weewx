FROM centos:latest
MAINTAINER Zsolt Zimmermann <cina@cina.hu>

ENV container docker

ARG VER="3.8.0-1"
ARG HOME=/home/weewx

RUN yum -y update; yum clean all;\ 
    yum -y install python-configobj python-cheetah python-imaging python-setuptools;\
    easy_install pyserial pyusb;\ 
    rpm --import http://weewx.com/keys.html;\
    curl http://weewx.com/downloads/weewx-${VER}.rhel.noarch.rpm -o weewx-${VER}.rhel.noarch.rpm;\
    yum -y install weewx-${VER}.rhel.noarch.rpm;\
    systemctl enable weewx;\
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;\
    mkdir -p ${HOME}/extensions
COPY ./extensions/* ${HOME}/extensions/
RUN find ${HOME}/extensions/ -name '*.*' -exec wee_extension --install={} \;

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ "/etc/weewx" ]
VOLUME [ "/var/www/weewx" ]
CMD ["/usr/sbin/init"]