#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Copy default subsonic.properties file
#if [ ! -e /var/lib/sonarr/? ]; then
#    cp /etc/sonarr/? /var/lib/sonarr/.
#fi

# Fix user and group ownerships
#umask 022
chown -R 10000:10000 /var/lib/sonarr || exit 1

# Change workdir
#cd /opt/NzbDrone

# Start sonarr in console mode
exec gosu sonarr \
    /usr/bin/mono --debug \
    /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/var/lib/sonarr
