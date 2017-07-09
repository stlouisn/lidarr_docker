FROM ubuntu:rolling

ARG SUBSONIC_VERSION

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt update && \

    # Install tzdata
    apt install -y --no-install-recommends \
        tzdata && \

    # Install SSL
    apt install -y --no-install-recommends \
        ca-certificates \
        openssl && \

    # Install gosu
    apt install -y --no-install-recommends \
        gosu && \

    # Install Java
    apt install -y --no-install-recommends \
        default-jre-headless && \

    # Create subsonic group
    groupadd \
        --system \
        --gid 10000 \
        subsonic && \

    # Create subsonic user
    useradd \
        --system \
        --no-create-home \
        --shell /sbin/nologin \
        --comment subsonic \
        --gid 10000 \
        --uid 10000 \
        subsonic && \
    
    # Install build-tools
    apt install -y --no-install-recommends \
        wget && \

    # Install subsonic
    mkdir -p /usr/lib/subsonic && \
    wget -q -O- https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz \
        | tar zxf - -C /usr/lib/subsonic && \
    rm /usr/lib/subsonic/subsonic.sh && \
    rm /usr/lib/subsonic/subsonic.bat && \
    rm /usr/lib/subsonic/Getting\ Started.html && \
    rm /usr/lib/subsonic/README.TXT && \
    chown -R subsonic:subsonic /usr/lib/subsonic && \

    # Install codecs
    apt install -y --no-install-recommends \
        ffmpeg \
        flac \
        lame \
        xmp && \

    # Remove build-tools
    apt purge -y \
        wget && \

    # Set docker_entrypoint as executable
    chmod 0744 /usr/local/bin/docker_entrypoint.sh && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java/jre \
    LC_ALL=C.UTF-8

EXPOSE 4040 \
       4443

VOLUME /music \
       /playlists \
       /podcasts \
       /var/lib/subsonic

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
