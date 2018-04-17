#!/bin/bash

#=========================================================================================

# Make sure volume '/var/lib/lidarr' is mounted and writeable
if [[ ! -d /var/lib/lidarr ]]; then
    echo -e "\nError: volume '/var/lib/lidarr' is not mounted.\n" >&2
    exit 1
elif [[ `mount | grep '/var/lib/lidarr' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nError: volume '/var/lib/lidarr' is readonly.\n" >&2
    exit 1
fi

# Fix user and group ownerships for '/var/lib/lidarr'
chown -R lidarr:lidarr /var/lib/lidarr

# Delete pid if it exists
[[ -e /var/lib/lidarr/lidarr.pid ]] && rm -f /var/lib/lidarr/lidarr.pid

#=========================================================================================

# Start lidarr in console mode
exec gosu lidarr \
    /usr/bin/mono --debug \
    /opt/Lidarr/Lidarr.exe -nobrowser -data=/var/lib/lidarr
