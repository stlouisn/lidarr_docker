FROM alpine:latest

#ARG SUBSONIC_VERSION=6.1.beta2
ARG SUBSONIC_VERSION=6.1.1

RUN \

  # Install tzdata
  apk add \
    --no-cache \
    tzdata && \

  # Install SSL
  apk add \
    --no-cache \
    ca-certificates \
    openssl && \

  # Install curl
  apk add \
    --no-cache \
    curl && \

  # Install su-exec
  apk add \
    --no-cache \
    su-exec && \

  # Install java
  apk add \
    --no-cache \
    openjdk8-jre && \

  # Create subsonic group
  addgroup -S \
    -g 10000 \
    subsonic && \

  # Create subsonic user
  adduser -S -D -H \
    -s /sbin/nologin \
    -G subsonic \
    -g subsonic \
    -u 10000 \
    subsonic && \

  # Install subsonic
  mkdir -p /usr/lib/subsonic && \
  wget -qO- \
    https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz \
    | tar zxf - -C /usr/lib/subsonic && \
  rm /usr/lib/subsonic/subsonic.sh && \
  rm /usr/lib/subsonic/subsonic.bat && \
  rm /usr/lib/subsonic/Getting\ Started.html && \
  rm /usr/lib/subsonic/README.TXT && \
  chown -R subsonic:subsonic /usr/lib/subsonic && \

  # Install ffmpeg
  apk add \
    --no-cache \
    ffmpeg \
    lame \
    flac

COPY rootfs /

RUN chmod 0744 /usr/local/bin/docker_entrypoint.sh

ENV JAVA_HOME /usr/lib/jvm/default-jvm/jre

EXPOSE 4040 4443

VOLUME \

  /var/lib/subsonic \
  /music \
  /podcasts \
  /playlists \
  /videos

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]