FROM centos:latest
MAINTAINER Zsolt Zimmermann 

ARG HOME=/home/weewx
ARG WEEWX_VERSION="3.9.2-1"
ARG INTERCEPTOR_VERSION="0.40"
ARG FORECAST_VERSION="3.2.19"
ARG IDOKEP_VERSION="0.1"
ENV TZ=Europe/Budapest

RUN sed -i -e '/override_install_langs/s/^/#/g' /etc/yum.conf;\    
    yum clean metadata;\
    yum -y reinstall glibc-common glibc-headers;\
    mkdir -p /tmp/extensions;\
    mkdir -p /etc/init.d
ENV LANG="hu_HU.UTF-8"

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;\
    yum -y update;\
    yum -y install python-configobj python-cheetah python-imaging python-setuptools pyephem wget;\
    yum -y groupinstall "Fonts";\
    easy_install pyserial pyusb;\ 
    rpm --import http://weewx.com/keys.html;\    
    wget -O /tmp/weewx-${WEEWX_VERSION}.rhel.noarch.rpm http://weewx.com/downloads/weewx-${WEEWX_VERSION}.rhel.noarch.rpm;\
    wget -O /tmp/extensions/weewx-interceptor.tar.gz https://github.com/matthewwall/weewx-interceptor/archive/v${INTERCEPTOR_VERSION}.tar.gz;\
    wget -O /tmp/extensions/weewx-forecast.tgz http://lancet.mit.edu/mwall/projects/weather/releases/weewx-forecast-${FORECAST_VERSION}.tgz;\
    wget -O /tmp/extensions/idokep.tar.gz  https://github.com/lorantkurthy/weewx-idokep/archive/${IDOKEP_VERSION}.tar.gz;\
    yum -y install /tmp/weewx-${WEEWX_VERSION}.rhel.noarch.rpm;\
    yum clean all;\
    rm -rf /var/cache/yum;\
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone;\
    find /tmp/extensions/ -name '*.*' -exec wee_extension --install={} \; ;\
    sed -i -e '63s/get_dict/get_site_dict/' /usr/share/weewx/user/idokep.py;\
    sed -i -e "0,/'WS23XX'/{s/'WS23XX'/engine.stn_info.hardware/}" /usr/share/weewx/user/idokep.py;\
    sed -i -e "/site_dict.setdefault('database_dict'/c\ \tsite_dict['manager_dict'] = weewx.manager.get_manager_dict(\n\t\tconfig_dict['DataBindings'], config_dict['Databases'], 'wx_binding')" /usr/share/weewx/user/idokep.py;\
    sed -i -e "s/database_dict/manager_dict/g" /usr/share/weewx/user/idokep.py

VOLUME [ "/etc/weewx" ]
VOLUME [ "/var/www/weewx" ]
VOLUME [ "/var/lib/weewx/" ]

CMD [ "/etc/init.d/weewx start" ]