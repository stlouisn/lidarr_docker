#!/bin/bash

# Make sure volume '/var/lib/sonarr' is writeable
if [[ ! -d /var/lib/sonarr ]]; then
    echo -e "\nError: volume '/var/lib/sonarr' not mounted.\n" >&2
    exit 1
elif [[ `mount | grep '/var/lib/sonarr' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nError: volume '/var/lib/sonarr' is readonly.\n" >&2
    exit 1
fi

# Fix user and group ownerships
chown -R sonarr:sonarr /var/lib/sonarr

# Delete pid if it exists
[[ -e /var/lib/sonarr/nzbdrone.pid ]] && rm -f /var/lib/sonarr/nzbdrone.pid

# Start sonarr in console mode
exec gosu sonarr \
    /usr/bin/mono --debug \
    /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/var/lib/sonarr
