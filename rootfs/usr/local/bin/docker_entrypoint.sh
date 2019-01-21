#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R lidarr:lidarr /config

# Delete pid if it exists
[[ -e /config/lidarr.pid ]] && rm -f /config/lidarr.pid

#=========================================================================================

# Start lidarr in console mode
exec gosu lidarr \
    /usr/bin/mono --debug \
    /opt/Lidarr/Lidarr.exe -nobrowser -data=/config
