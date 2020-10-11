FROM centos:8
MAINTAINER Zsolt Zimmermann 

ARG HOME=/home/weewx
ARG WEEWX_VERSION="4.1.1-1.el8"
ARG INTERCEPTOR_VERSION="master"
ARG FORECAST_VERSION="3.3.2"
ARG IDOKEP_VERSION="0.5"
ARG MQTT_VERSION="0.19"
ARG BELCHER_VERSION="1.2"
ENV TZ=Europe/Budapest
ENV LANG="hu_HU.UTF-8"
ENV LC_ALL="hu_HU.UTF-8"

ADD supervisord.conf /etc/supervisord.conf
ADD rsyslog.conf /etc/rsyslog.conf
ADD http://weewx.com/downloads/released_versions/weewx-${WEEWX_VERSION}.noarch.rpm /tmp/weewx-${WEEWX_VERSION}.noarch.rpm
ADD https://github.com/matthewwall/weewx-interceptor/archive/${INTERCEPTOR_VERSION}.tar.gz /tmp/extensions/weewx-interceptor.tar.gz
ADD http://lancet.mit.edu/mwall/projects/weather/releases/weewx-forecast-${FORECAST_VERSION}.tgz /tmp/extensions/weewx-forecast.tgz
ADD http://lancet.mit.edu/mwall/projects/weather/releases/weewx-mqtt-${MQTT_VERSION}.tgz /tmp/extensions/weewx-mqtt.tgz
ADD https://github.com/cinadr/weewx-idokep/archive/${IDOKEP_VERSION}.tar.gz /tmp/extensions/idokep.tar.gz
ADD https://github.com/poblabs/weewx-belchertown/releases/download/weewx-belchertown-${BELCHER_VERSION}/weewx-belchertown-release-${BELCHER_VERSION}.tar.gz /tmp/extensions/weewx-belchertown.tar.gz

RUN dnf -y install epel-release;\
    dnf -y update;\
    dnf -y install glibc-locale-source glibc-all-langpacks langpacks-hu tzdata initscripts rsyslog supervisor python3-devel python3-pip python3-configobj python3-pillow python3-cheetah python3-imaging python3-setuptools python3-ephem python3-paho-mqtt python3-simplejson;\
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone;\
    localedef -c -i hu_HU -f UTF-8 hu_HU.UTF-8;\
    rsyslogd;\
    dnf -y install /tmp/weewx-${WEEWX_VERSION}.noarch.rpm;\
    dnf clean all;\
    rm -rf /var/cache/dnf;\    
    mkdir -p /tmp/extensions /etc/weewx/config;\
    find /tmp/extensions/ -name '*.*' -exec wee_extension --install={} \; ;\
    2to3 -w /usr/share/weewx/user/mqtt.py;\
    2to3 -w /usr/share/weewx/user/forecast.py;\
    mv /etc/weewx/weewx.conf /etc/weewx/config/weewx.conf;\
    ln -s /etc/weewx/config/weewx.conf /etc/weewx/weewx.conf

VOLUME [ "/etc/weewx/config/" ]
VOLUME [ "/var/www/weewx/" ]
VOLUME [ "/var/lib/weewx/" ]
CMD ["/usr/bin/supervisord"]