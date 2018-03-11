#!/bin/bash

# Delete pid if it exists
[[ -e /var/lib/sonarr/nzbdrone.pid ]] && rm -f /var/lib/sonarr/nzbdrone.pid

# Fix user and group ownerships
chown -R 10000:10000 /var/lib/sonarr || exit 1

# Start sonarr in console mode
exec gosu sonarr \
    /usr/bin/mono --debug \
    /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/var/lib/sonarr
