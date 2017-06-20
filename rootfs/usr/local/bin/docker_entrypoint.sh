#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Make sure volumes are mounted correctly
if [ ! -d /var/lib/subsonic ]; then
  printf "\nERROR: volume /var/lib/subsonic not mounted.\n" >&2
  exit 1
fi

# Create symlink for transcoding
if [ ! -e /var/lib/subsonic/transcode/ffmpeg ]; then
  ln -s /usr/bin/ffmpeg /var/lib/subsonic/transcode/
fi

# Fix user and group ownerships
chown -R subsonic:subsonic /music /playlists /podcasts
chown -R subsonic:subsonic /var/lib/subsonic

# Change workdir
cd /usr/lib/subsonic

# Start subsonic in console mode
exec gosu subsonic \
  /usr/bin/java \
    -Dsubsonic.home=/var/lib/subsonic \
    -Dsubsonic.host=0.0.0.0 \
    "$@" \
    -Dsubsonic.contextPath=/ \
    -Dsubsonic.defaultMusicFolder=/music \
    -Dsubsonic.defaultPlaylistFolder=/playlists \
    -Dsubsonic.defaultPodcastFolder=/podcasts \
    -Djava.awt.headless=true \
    -jar /usr/lib/subsonic/subsonic-booter-jar-with-dependencies.jar
