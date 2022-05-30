WEEWX 4.8.0 Docker container based on ubuntu:latest with extensions

VOLUMES:
HTML export is in /var/www/weewx
SDB database is in /var/lib/weewx/
CONFIG files are in /etc/weewx/config
SKIN files are in /etc/weewx/skins

Extensions installed:
- driver: interceptor (latest)
- forecast (latest)
- idokep 0.5
- skin: Belchertown (latest)