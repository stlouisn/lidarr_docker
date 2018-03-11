#!/bin/bash

# Fix user and group ownerships
chown -R sonarr:sonarr /config || ( echo -e "\nError: volume '/config' not mounted correctly.\n"; exit 1 ) || exit 1

# Delete pid if it exists
[[ -e /var/lib/sonarr/nzbdrone.pid ]] && rm -f /var/lib/sonarr/nzbdrone.pid

# Start sonarr in console mode
exec gosu sonarr \
    /usr/bin/mono --debug \
    /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/config
