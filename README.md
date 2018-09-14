WEEWX Docker container based on centos:latest with extensions

Modify /etc/weewx/weewx.conf file to keep installed extensions working.

VOLUMES:
HTML export is in /var/www/weewx. 
SDB database is in /var/lib/weewx/.
CONFIG files are in /etc/weewx/

Extensions installed:
- interceptor 
- forercast
- idokep