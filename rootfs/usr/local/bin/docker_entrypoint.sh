#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Start sonarr in console mode
exec gosu sonarr \
    mono --debug NzbDrone.exe -nobrowser -data=/var/lib/sonarr
