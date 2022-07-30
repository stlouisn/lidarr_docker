#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R lidarr:lidarr /config

# Delete PID if it exists
if
    [ -e "/config/lidarr.pid" ]
then
    rm -f /config/lidarr.pid
fi

#=========================================================================================

# Start lidarr in console mode
exec gosu lidarr \
    /Lidarr/Lidarr -nobrowser -data=/config
