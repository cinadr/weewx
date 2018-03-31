WEEWX Docker container based on centos:latest (systemd enabled)

Extensions installs:

Put your extensions in tgz compressed format into extensions format prior to build.
All these tgz files will be installed with <wee_extension --install> during build.

Modify the /etc/weewx/weewx.conf file after first start as this is modified by wee_extension.

HTML export is in /var/www/weewx. 

SDB database is in /var/lib/weewx/.
