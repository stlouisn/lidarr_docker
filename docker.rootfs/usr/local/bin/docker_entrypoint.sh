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

# Copy default subsonic.properties file
if [ ! -e /var/lib/subsonic/subsonic.properties ]; then
    cp /etc/subsonic/subsonic.properties /var/lib/subsonic/.
fi

# Create symlinks for transcoding
if [ ! -e /var/lib/subsonic/transcode/ffmpeg ]; then
    mkdir -p /var/lib/subsonic/transcode
    ln -s /usr/bin/ffmpeg /var/lib/subsonic/transcode/ffmpeg
fi
if [ ! -e /var/lib/subsonic/transcode/lame ]; then
    mkdir -p /var/lib/subsonic/transcode
    ln -s /usr/bin/lame /var/lib/subsonic/transcode/lame
fi
if [ ! -e /var/lib/subsonic/transcode/flac ]; then
    mkdir -p /var/lib/subsonic/transcode
    ln -s /usr/bin/flac /var/lib/subsonic/transcode/flac
fi
if [ ! -e /var/lib/subsonic/transcode/xmp ]; then
    mkdir -p /var/lib/subsonic/transcode
    ln -s /usr/bin/xmp /var/lib/subsonic/transcode/xmp
fi

# Fix user and group ownerships
MOUNT_MODE=`mount | grep "/music" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R subsonic:subsonic /music
fi
MOUNT_MODE=`mount | grep "/playlists" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R subsonic:subsonic /playlists
fi
MOUNT_MODE=`mount | grep "/podcasts" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R subsonic:subsonic /podcasts
fi
chown -R subsonic:subsonic /var/lib/subsonic

# Change workdir
cd /usr/lib/subsonic

# Start subsonic in console mode
exec gosu subsonic \
    /usr/bin/java \
        -Dsubsonic.contextPath=/ \
        -Dsubsonic.defaultMusicFolder=/music \
        -Dsubsonic.defaultPlaylistFolder=/playlists \
        -Dsubsonic.defaultPodcastFolder=/podcasts \
        -Dsubsonic.home=/var/lib/subsonic \
        -Dsubsonic.host=0.0.0.0 \
        -Dsubsonic.httpsPort=4443 \
        -Dsubsonic.port=4040 \
        -Xmx512m \
        -Djava.awt.headless=true \
        -jar /usr/lib/subsonic/subsonic-booter-jar-with-dependencies.jar