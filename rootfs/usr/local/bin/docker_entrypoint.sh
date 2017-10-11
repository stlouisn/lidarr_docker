#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Delete pid if it exists
[[ -e /var/lib/sonarr/nzbdrone.pid ]] && rm -f /var/lib/sonarr/nzbdrone.pid

# Fix user and group ownerships
#umask 022
chown -R 10000:10000 /var/lib/sonarr || exit 1

# Start sonarr in console mode
exec gosu sonarr \
    /usr/bin/mono --debug \
    /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/var/lib/sonarr
