WEEWX 4.1.1 Docker container based on centos:8 with extensions

VOLUMES:
HTML export is in /var/www/weewx
SDB database is in /var/lib/weewx/
CONFIG files are in /etc/weewx/config
SKIN files are in /etc/weewx/skins

Extensions installed:
- driver: interceptor 
- forercast 
- idokep 0.5
- skin: Belchertown 1.2