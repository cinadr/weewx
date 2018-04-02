WEEWX Docker container based on centos:latest with extensions

Howto install extensions

Put your extensions in tgz compressed format into extensions folder prior to build.
All these tgz files will be installed with <wee_extension --install> during build.

Modify /etc/weewx/weewx.conf file to keep installed extensions working.

VOLUMES:
HTML export is in /var/www/weewx. 
SDB database is in /var/lib/weewx/.
CONFIG files are in /etc/weewx/

Default extensions:
- observerip
- forercast
- idokep
