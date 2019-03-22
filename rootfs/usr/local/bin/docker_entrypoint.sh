#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R www-data:www-data /config

# Delete pid if it exists
[[ -e /config/lidarr.pid ]] && rm -f /config/lidarr.pid

#=========================================================================================

# Start lidarr in console mode
exec gosu www-data \
    /usr/bin/mono --debug \
    /opt/Lidarr/Lidarr.exe -nobrowser -data=/config
